"""
title: F5 AI Guardrails (Calypso) Prompt
author: O'Leary, Calalang, ChatGPT
description: Open-WebUI function to send prompts to CalypsoAI's /prompts endpoint for scanning and moderation.
version: 1.0.0
requirements: httpx
"""

from __future__ import annotations

import os
import json
from typing import Any, Dict, Iterable, Optional, AsyncIterator
from pydantic import BaseModel, Field
import httpx


def _get_by_dotpath(obj: Any, path: str, default: Any = None) -> Any:
    try:
        cur = obj
        for part in path.split("."):
            if isinstance(cur, list):
                cur = cur[int(part)]
            else:
                cur = cur.get(part)
        return cur if cur is not None else default
    except Exception:
        return default


def _coerce_content_to_text(content: Any) -> str:
    if content is None:
        return ""
    if isinstance(content, str):
        return content
    if isinstance(content, (dict, list)):
        return json.dumps(content, ensure_ascii=False)
    return str(content)


def _last_user_input(body: dict) -> str:
    messages = body.get("messages") or []
    last_user = next((m for m in reversed(messages) if m.get("role") == "user"), None)
    if not last_user:
        return ""
    return _coerce_content_to_text(last_user.get("content"))


def _parse_json_object(s: str) -> Dict[str, Any]:
    """
    Parse a JSON object string into dict. Return {} on invalid input.
    Calypso expects externalMetadata to be a dict in your tenant.
    """
    try:
        s = (s or "").strip()
        if not s:
            return {}
        obj = json.loads(s)
        return obj if isinstance(obj, dict) else {}
    except Exception:
        return {}


class Pipe:
    class Valves(BaseModel):
        # Model metadata in Open-WebUI model picker
        MODEL_ID: str = Field(default="calypso-prompts-pipe")
        MODEL_NAME: str = Field(default="CalypsoAI (Prompts)")

        # Base URL + path
        BASE_URL: str = Field(default="https://us1.calypsoai.app")
        PROMPTS_PATH: str = Field(default="/backend/v1/prompts")

        # Auth
        CALYPSO_API_KEY: str = Field(
            default=os.getenv("CALYPSO_API_KEY", ""),
            description="Bearer token for Calypso. Can also be set via env CALYPSO_API_KEY.",
        )
        API_KEY_HEADER: str = Field(default="Authorization")
        API_KEY_PREFIX: str = Field(default="Bearer ")

        # REQUIRED for your tenant
        PROJECT: str = Field(
            default="",
            description="REQUIRED: Calypso project identifier (must exist in your tenant)",
        )

        # Optional but recommended
        ENDPOINT: str = Field(
            default="open-webui", description="Calypso endpoint label"
        )
        EXTERNAL_METADATA_JSON: str = Field(
            default='{"app":"open-webui"}',
            description="JSON object string for Calypso externalMetadata (must be a dict)",
        )

        # Request mapping
        INPUT_FIELD: str = Field(default="input")
        EXTRA_BODY_JSON: str = Field(default="{}")

        # Response mapping
        RESPONSE_TEXT_DOTPATH: str = Field(default="result.response")
        FALLBACK_TEXT_DOTPATH: str = Field(default="result.providerResult.data")

        TIMEOUT_SECS: int = Field(default=120)

        # Streaming (off by default)
        STREAMING: bool = Field(default=False)
        STREAM_TEXT_PREFIX: str = Field(default="")

        # Block handling
        BLOCK_MESSAGE: str = Field(
            default="⚠️ This prompt has been blocked by F5 AI Guardrails.",
            description="Message shown to user when Calypso blocks a prompt",
        )
        FLAG_MESSAGE: str = Field(
            default="⚠️ This prompt was flagged by F5 AI Guardrails.",
            description="Message shown to user when Calypso flags a prompt (if blocking flagged is enabled)",
        )
        BLOCK_ON_FLAGGED: bool = Field(
            default=False,
            description="If true, treat flagged outcome like blocked and return FLAG_MESSAGE",
        )
        SHOW_SCANNER_DETAILS: bool = Field(
            default=False, description="Include scanner details in block/flag message"
        )

        # Debug
        DEBUG_LOG: bool = Field(default=False)

    def __init__(self):
        self.valves = self.Valves()

    def pipes(self):
        return [{"id": self.valves.MODEL_ID, "name": self.valves.MODEL_NAME}]

    async def pipe(self, body: dict, __user__: Optional[dict] = None):
        # Validate required project
        if not (self.valves.PROJECT or "").strip():
            return "Configuration error: PROJECT valve must be set to an existing Calypso project."

        url = f"{self.valves.BASE_URL.rstrip('/')}{self.valves.PROMPTS_PATH}"

        headers: Dict[str, str] = {
            "Content-Type": "application/json",
            "Accept": "application/json",
        }
        if self.valves.CALYPSO_API_KEY:
            headers[self.valves.API_KEY_HEADER] = (
                f"{self.valves.API_KEY_PREFIX}{self.valves.CALYPSO_API_KEY}"
            )

        # Only send the last user message
        input_text = _last_user_input(body)

        # Base payload
        payload: Dict[str, Any] = {
            self.valves.INPUT_FIELD: input_text,
            "project": self.valves.PROJECT,
            "endpoint": self.valves.ENDPOINT,
            "externalMetadata": _parse_json_object(self.valves.EXTERNAL_METADATA_JSON),
        }

        # Pass through common tuning params if your backend accepts them
        for k in ("temperature", "top_p", "max_tokens"):
            if k in body:
                payload[k] = body[k]

        # Merge extras
        try:
            extras = json.loads(self.valves.EXTRA_BODY_JSON or "{}")
            if isinstance(extras, dict):
                payload.update(extras)
        except Exception:
            pass

        want_stream = bool(body.get("stream")) and self.valves.STREAMING

        timeout = httpx.Timeout(self.valves.TIMEOUT_SECS)

        try:
            async with httpx.AsyncClient(timeout=timeout) as client:
                if want_stream:
                    # Stream response bytes through as they arrive
                    async with client.stream(
                        "POST", url, json=payload, headers=headers
                    ) as r:
                        if self.valves.DEBUG_LOG:
                            print(
                                {
                                    "event": "calypso_prompts_pipe_status",
                                    "status_code": r.status_code,
                                }
                            )
                        r.raise_for_status()

                        async def _aiter() -> AsyncIterator[bytes]:
                            async for line in r.aiter_lines():
                                if not line:
                                    continue
                                if self.valves.STREAM_TEXT_PREFIX and line.startswith(
                                    self.valves.STREAM_TEXT_PREFIX
                                ):
                                    line = line[len(self.valves.STREAM_TEXT_PREFIX) :]
                                yield (line + "\n").encode("utf-8")

                        return _aiter()

                # Non-streaming
                r = await client.post(url, json=payload, headers=headers)

            if self.valves.DEBUG_LOG:
                try:
                    preview = r.json()
                except Exception:
                    preview = r.text[:400]
                print(
                    {
                        "event": "calypso_prompts_pipe_response",
                        "status_code": r.status_code,
                        "preview": preview,
                    }
                )

            r.raise_for_status()
            data = r.json()

            # Outcome handling
            outcome = (_get_by_dotpath(data, "result.outcome") or "").lower()

            # Infer from scannerResults if needed
            if not outcome:
                scanner_results = (
                    _get_by_dotpath(data, "result.scannerResults", []) or []
                )
                outcomes = [
                    (sr.get("outcome") or "").lower()
                    for sr in scanner_results
                    if isinstance(sr, dict)
                ]
                if any(o in ("blocked", "block") for o in outcomes):
                    outcome = "blocked"
                elif any(o in ("failed", "fail", "flagged") for o in outcomes):
                    outcome = "flagged"
                elif outcomes and all(o in ("passed", "pass", "ok") for o in outcomes):
                    outcome = "cleared"

            if outcome == "blocked":
                return self._format_policy_message(data, blocked=True)

            if outcome == "flagged" and self.valves.BLOCK_ON_FLAGGED:
                return self._format_policy_message(data, blocked=False)

            text = _get_by_dotpath(data, self.valves.RESPONSE_TEXT_DOTPATH)
            if text is None:
                text = _get_by_dotpath(data, self.valves.FALLBACK_TEXT_DOTPATH)

            return text if text is not None else data

        except Exception as e:
            return f"Upstream /prompts error: {e}"

    def _format_policy_message(self, response_data: dict, blocked: bool) -> str:
        message = self.valves.BLOCK_MESSAGE if blocked else self.valves.FLAG_MESSAGE

        if self.valves.SHOW_SCANNER_DETAILS:
            scanner_results = (
                _get_by_dotpath(response_data, "result.scannerResults", []) or []
            )
            if scanner_results:
                message += "\n\nDetails:"
                for scanner in scanner_results:
                    if not isinstance(scanner, dict):
                        continue
                    scanner_name = _get_by_dotpath(
                        scanner, "scannerVersionMeta.name", "Unknown"
                    )
                    outcome = scanner.get("outcome") or "unknown"
                    message += f"\n- Scanner: {scanner_name} ({outcome})"

        return message
