"""
title: F5 AI Guardrails (Calypso) Policy Gateway
author: Calalang, ChatGPT
description: Open-WebUI function to send prompts to CalypsoAI's /scans endpoint for scanning and moderation.
version: 1.0.0
requirements: httpx
"""

import json
import httpx
from typing import Optional, Dict, Any, List, Tuple
from pydantic import BaseModel, Field


class PolicyBlockedError(Exception):
    pass


class Filter:
    class Valves(BaseModel):
        CALYPSO_API_KEY: str = Field(
            default="", description="Calypso Bearer token", repr=False
        )
        CALYPSO_API_URL: str = Field(
            default="https://us1.calypsoai.app/backend/v1/scans"
        )

        PROJECT: str = Field(
            default="", description="REQUIRED: Calypso project identifier (must exist)"
        )
        ENDPOINT: str = Field(
            default="open-webui", description="Calypso endpoint label"
        )

        EXTERNAL_METADATA_JSON: str = Field(
            default='{"app":"open-webui"}',
            description="JSON object string for externalMetadata (must be a dict)",
        )

        MESSAGE_FLAGGED: str = Field(
            default="This message was flagged by F5 AI Guardrails"
        )
        MESSAGE_BLOCKED: str = Field(
            default="This message was blocked by F5 AI Guardrails"
        )
        MESSAGE_SEVERITY: str = Field(
            default="This message was blocked by F5 AI Guardrails"
        )

        FAIL_MODE_INLET: str = Field(
            default="closed", description="closed|open on Calypso errors"
        )
        FAIL_MODE_OUTLET: str = Field(
            default="open", description="closed|open on Calypso errors"
        )

        BLOCK_ON_SEVERITY: str = Field(default="high", description="low|medium|high")

        REQUEST_TIMEOUT_SECONDS: float = Field(default=5.0)
        MIN_CONTENT_LENGTH: int = Field(default=5)

        DEBUG_LOG_CALYPSO_FIELDS: bool = Field(default=True)

    def __init__(self):
        self.valves = self.Valves()

    def _severity_blocks(self, severity: str) -> bool:
        rank = {"low": 1, "medium": 2, "high": 3}
        threshold = rank.get(self.valves.BLOCK_ON_SEVERITY, 3)
        return rank.get(severity, 1) >= threshold

    def _parse_external_metadata(self) -> Dict[str, Any]:
        raw = (self.valves.EXTERNAL_METADATA_JSON or "").strip()
        if not raw:
            return {}
        try:
            parsed = json.loads(raw)
            return parsed if isinstance(parsed, dict) else {}
        except Exception:
            return {}

    def _last_user_message(self, body: dict) -> str:
        messages = body.get("messages", []) or []
        for msg in reversed(messages):
            if msg.get("role") == "user":
                return (msg.get("content") or "").strip()
        return ""

    def _replace_assistant_output(self, body: dict, message: str) -> dict:
        choices = body.get("choices", []) or []
        if not choices:
            body["choices"] = [
                {
                    "message": {"role": "assistant", "content": message},
                    "finish_reason": "stop",
                }
            ]
            return body

        msg = choices[0].get("message", {}) or {}
        msg["role"] = "assistant"
        msg["content"] = message
        msg.pop("tool_calls", None)

        choices[0]["message"] = msg
        choices[0]["finish_reason"] = "stop"
        body["choices"] = choices
        return body

    # -------------------------
    # Calypso result interpretation (schema-aware)
    # -------------------------
    def _interpret_result(self, data: Dict[str, Any]) -> Tuple[str, str, List[str]]:
        """
        Returns (status, severity, failed_scanners)

        Your tenant returns: { id, result: { scannerResults: [...] }, redactedInput }
        Where each scannerResults item has outcome: passed|failed|blocked (etc.)
        """
        severity = data.get("severity") or "low"
        severity = severity.lower() if isinstance(severity, str) else "low"

        result = data.get("result") or {}
        failed_scanners: List[str] = []

        scanner_results = []
        if isinstance(result, dict):
            scanner_results = (
                result.get("scannerResults") or result.get("scanner_results") or []
            )

        outcomes: List[str] = []
        if isinstance(scanner_results, list):
            for sr in scanner_results:
                if not isinstance(sr, dict):
                    continue
                outcome = (sr.get("outcome") or "").strip().lower()
                if outcome:
                    outcomes.append(outcome)

                # Capture identifiers for logging/debug/ops (not shown to user)
                if outcome in ("failed", "block", "blocked"):
                    sid = sr.get("scannerId") or sr.get("scanner_id") or "unknown"
                    failed_scanners.append(str(sid))

        # If we have outcomes, trust them fully (no heuristic guessing)
        if outcomes:
            if any(o in ("blocked", "block") for o in outcomes):
                return "Blocked", severity, failed_scanners
            if any(o in ("failed", "fail", "flagged") for o in outcomes):
                return "Flagged", severity, failed_scanners
            # If every scanner passed, it's cleared
            if all(o in ("passed", "pass", "ok") for o in outcomes):
                return "Cleared", severity, []
            # Unknown outcome values -> be conservative but not overly so:
            # treat unknowns as Flagged only if they are not "passed"
            if any(o not in ("passed", "pass", "ok") for o in outcomes):
                return "Flagged", severity, failed_scanners
            return "Cleared", severity, []

        # If no outcomes present, fall back to explicit top-level fields only (no guessing)
        for key in ("decision", "status", "outcome", "result"):
            v = data.get(key)
            if isinstance(v, str):
                s = v.strip().lower()
                if s in ("blocked", "block"):
                    return "Blocked", severity, []
                if s in ("flagged", "failed", "fail"):
                    return "Flagged", severity, []
                if s in ("cleared", "passed", "ok", "allow", "allowed"):
                    return "Cleared", severity, []

        # Default safe behavior: if Calypso doesn't give a decision, treat as Cleared
        return "Cleared", severity, []

    def _normalize(self, data: Dict[str, Any]) -> Dict[str, Any]:
        status, severity, failed_scanners = self._interpret_result(data)

        if self.valves.DEBUG_LOG_CALYPSO_FIELDS:
            try:
                result_preview = json.dumps(data.get("result"))[:600]
            except Exception:
                result_preview = str(data.get("result"))[:600]

            print(
                {
                    "event": "calypso_debug",
                    "top_level_keys": list(data.keys()),
                    "status": status,
                    "severity": severity,
                    "failed_scanners": failed_scanners[:10],
                    "result_preview": result_preview,
                }
            )

        return {
            "status": status,
            "severity": severity,
            "failed_scanners": failed_scanners,
        }

    async def _scan(self, content: str) -> Dict[str, Any]:
        if not self.valves.CALYPSO_API_KEY:
            raise PolicyBlockedError("Calypso API key not configured")
        if not (self.valves.PROJECT or "").strip():
            raise PolicyBlockedError(
                "Calypso PROJECT valve must be set to an existing project"
            )

        payload = {
            "input": content,
            "project": self.valves.PROJECT,
            "endpoint": self.valves.ENDPOINT,
            "externalMetadata": self._parse_external_metadata(),
            "verbose": False,
            "disabled": [],
            "forceEnabled": [],
        }

        async with httpx.AsyncClient(
            timeout=httpx.Timeout(self.valves.REQUEST_TIMEOUT_SECONDS)
        ) as client:
            r = await client.post(
                self.valves.CALYPSO_API_URL,
                headers={
                    "Authorization": f"Bearer {self.valves.CALYPSO_API_KEY}",
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                },
                json=payload,
            )

        if 400 <= r.status_code < 500:
            try:
                detail = r.json()
            except Exception:
                detail = r.text
            print(
                {"event": "calypso_4xx", "status_code": r.status_code, "detail": detail}
            )
            r.raise_for_status()

        r.raise_for_status()
        return r.json()

    # -------------------------
    # INLET
    # -------------------------
    async def inlet(
        self, body: dict, __event_emitter__=None, __user__: Optional[dict] = None
    ) -> dict:
        prompt = self._last_user_message(body)
        if not prompt or len(prompt) < self.valves.MIN_CONTENT_LENGTH:
            return body

        try:
            data = await self._scan(prompt)
            norm = self._normalize(data)

            print(
                {
                    "event": "calypso_inlet",
                    "status": norm["status"],
                    "severity": norm["severity"],
                }
            )

            if norm["status"] == "Blocked":
                raise PolicyBlockedError(self.valves.MESSAGE_BLOCKED)

            if norm["status"] == "Flagged":
                raise PolicyBlockedError(self.valves.MESSAGE_FLAGGED)

            if self._severity_blocks(norm["severity"]):
                raise PolicyBlockedError(self.valves.MESSAGE_SEVERITY)

            return body

        except Exception as e:
            print(
                {
                    "event": "calypso_inlet_error",
                    "error": str(e),
                    "mode": self.valves.FAIL_MODE_INLET,
                }
            )
            if self.valves.FAIL_MODE_INLET == "open":
                return body
            raise

    # -------------------------
    # OUTLET
    # -------------------------
    async def outlet(
        self, body: dict, __event_emitter__=None, __user__: Optional[dict] = None
    ) -> dict:
        try:
            choices = body.get("choices", []) or []
            if not choices:
                return body

            msg = choices[0].get("message", {}) or {}
            text = (msg.get("content") or "").strip()

            if not text or len(text) < self.valves.MIN_CONTENT_LENGTH:
                return body

            data = await self._scan(text)
            norm = self._normalize(data)

            print(
                {
                    "event": "calypso_outlet",
                    "status": norm["status"],
                    "severity": norm["severity"],
                }
            )

            if norm["status"] == "Blocked":
                return self._replace_assistant_output(body, self.valves.MESSAGE_BLOCKED)

            if norm["status"] == "Flagged":
                return self._replace_assistant_output(body, self.valves.MESSAGE_FLAGGED)

            if self._severity_blocks(norm["severity"]):
                return self._replace_assistant_output(
                    body, self.valves.MESSAGE_SEVERITY
                )

            return body

        except Exception as e:
            print(
                {
                    "event": "calypso_outlet_error",
                    "error": str(e),
                    "mode": self.valves.FAIL_MODE_OUTLET,
                }
            )
            if self.valves.FAIL_MODE_OUTLET == "open":
                return body
            raise
