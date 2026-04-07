"""
title: F5 AI Guardrails (Calypso) Prompt
author: Claude
description: Sends user prompts to CalypsoAI for inline scanning and moderation before a response is generated. Blocked or flagged prompts are intercepted and return a policy message instead of reaching the model.
version: 2.0.0
requirements: httpx
"""

from __future__ import annotations

import os
import json
from typing import Any, Dict, Optional
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
    # Hardcoded defaults (not exposed as valves)
    _MODEL_ID = "calypso-prompts-pipe"
    _MODEL_NAME = "F5 AI Guardrails Inline"
    _PROMPTS_PATH = "/backend/v1/prompts"
    _API_KEY_HEADER = "Authorization"
    _API_KEY_PREFIX = "Bearer "
    _ENDPOINT = "open-webui"
    _EXTERNAL_METADATA = {"app": "open-webui"}
    _INPUT_FIELD = "input"
    _RESPONSE_TEXT_DOTPATH = "result.response"
    _FALLBACK_TEXT_DOTPATH = "result.providerResult.data"
    _TIMEOUT_SECS = 120
    _BLOCK_MESSAGE = "⚠️ This prompt has been blocked by F5 AI Guardrails."
    _FLAG_MESSAGE = "⚠️ This prompt was flagged by F5 AI Guardrails."

    class Valves(BaseModel):
        BASE_URL: str = Field(
            default="https://us1.calypsoai.app",
            description="Calypso base URL. Change to your local instance URL if self-hosting (e.g. http://calypso.internal).",
        )
        CALYPSO_API_KEY: str = Field(
            default=os.getenv("CALYPSO_API_KEY", ""),
            description="Bearer token for Calypso. Can also be set via env CALYPSO_API_KEY.",
        )
        PROJECT: str = Field(
            default="",
            description="REQUIRED: Calypso project identifier (must exist in your tenant)",
        )

    def __init__(self):
        self.valves = self.Valves()

    def pipes(self):
        return [{"id": self._MODEL_ID, "name": self._MODEL_NAME}]

    async def pipe(self, body: dict, __user__: Optional[dict] = None):
        # Validate required project
        if not (self.valves.PROJECT or "").strip():
            return "Configuration error: PROJECT valve must be set to an existing Calypso project."

        url = f"{self.valves.BASE_URL.rstrip('/')}{self._PROMPTS_PATH}"

        headers: Dict[str, str] = {
            "Content-Type": "application/json",
            "Accept": "application/json",
        }
        if self.valves.CALYPSO_API_KEY:
            headers[self._API_KEY_HEADER] = f"{self._API_KEY_PREFIX}{self.valves.CALYPSO_API_KEY}"

        input_text = _last_user_input(body)

        payload: Dict[str, Any] = {
            self._INPUT_FIELD: input_text,
            "project": self.valves.PROJECT,
            "endpoint": self._ENDPOINT,
            "externalMetadata": self._EXTERNAL_METADATA,
        }

        payload.update({k: body[k] for k in ("temperature", "top_p", "max_tokens") if k in body})

        timeout = httpx.Timeout(self._TIMEOUT_SECS)

        _BLOCKED = frozenset({"blocked", "block"})
        _FLAGGED = frozenset({"failed", "fail", "flagged"})
        _CLEARED = frozenset({"passed", "pass", "ok"})

        try:
            async with httpx.AsyncClient(timeout=timeout, verify=False) as client:
                r = await client.post(url, json=payload, headers=headers)

            r.raise_for_status()
            data = r.json()

            outcome = (_get_by_dotpath(data, "result.outcome") or "").lower()

            if not outcome:
                scanner_results = _get_by_dotpath(data, "result.scannerResults", []) or []
                outcomes = [
                    (sr.get("outcome") or "").lower()
                    for sr in scanner_results
                    if isinstance(sr, dict)
                ]
                if any(o in _BLOCKED for o in outcomes):
                    outcome = "blocked"
                elif any(o in _FLAGGED for o in outcomes):
                    outcome = "flagged"
                elif outcomes and all(o in _CLEARED for o in outcomes):
                    outcome = "cleared"

            if outcome == "blocked":
                return self._BLOCK_MESSAGE

            if outcome == "flagged":
                return self._FLAG_MESSAGE

            text = _get_by_dotpath(data, self._RESPONSE_TEXT_DOTPATH)
            if text is None:
                text = _get_by_dotpath(data, self._FALLBACK_TEXT_DOTPATH)

            return text if text is not None else data

        except Exception as e:
            return f"Upstream /prompts error: {e}"
