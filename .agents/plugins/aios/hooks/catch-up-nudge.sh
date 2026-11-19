#!/bin/bash
# Antigravity SessionStart hook: tells the agent to run the catching-up skill
# when the last catch-up is missing or more than 4 hours old, or to offer
# resuming /onboard when setup was interrupted.
# Reads Antigravity hook JSON from stdin and writes injectSteps JSON to stdout.

set -euo pipefail

PAYLOAD="$(cat || true)"

ROOT="$(python3 -c '
import json, os, sys
raw = sys.stdin.read().strip()
if raw:
    try:
        data = json.loads(raw)
        cwd = data.get("cwd") or (data.get("workspacePaths") or [None])[0]
        if cwd:
            print(cwd)
            sys.exit(0)
    except Exception:
        pass
print(os.getcwd())
' <<< "$PAYLOAD")"

emit_message() {
  python3 -c '
import json, sys
msg = sys.argv[1]
print(json.dumps({
    "injectSteps": [
        {
            "systemMessage": {
                "systemMessage": msg
            }
        }
    ]
}))
' "$1"
}

# Only run inside an AIOS workspace that has GEMINI.md.
if [ ! -f "$ROOT/GEMINI.md" ]; then
  echo '{}'
  exit 0
fi

STATE="$ROOT/.agents/state/last-catch-up"
MAX_AGE=$((4 * 60 * 60))

# Onboarding not finished (GEMINI.md still has placeholders): offer to resume it instead.
if grep -q "{{" "$ROOT/GEMINI.md" 2>/dev/null; then
  if [ -f "$ROOT/context/about-me.md" ] || [ -f "$ROOT/context/voice.md" ] || ! grep -q "Not started yet" "$ROOT/context/intake.md" 2>/dev/null; then
    emit_message "Onboarding isn't finished (GEMINI.md still has {{placeholders}}). Before the user's request, offer once to resume /onboard where it left off."
  else
    echo '{}'
  fi
  exit 0
fi

if [ -f "$STATE" ]; then
  last=$(stat -c %Y "$STATE" 2>/dev/null || stat -f %m "$STATE" 2>/dev/null || echo 0)
  age=$(( $(date +%s) - last ))
  if [ "$age" -lt "$MAX_AGE" ]; then
    echo '{}'
    exit 0
  fi
  emit_message "Last catch-up: $(cat "$STATE"). Run the catching-up skill first, then handle the user's request."
else
  emit_message "Last catch-up: never. Run the catching-up skill first, then handle the user's request."
fi
