#!/bin/sh
# Render start script for Hermes Agent (with debug output)
set -x

echo "=== render-start.sh starting ==="
echo "UID: $(id -u)  GID: $(id -g)"
echo "HERMES_HOME: ${HERMES_HOME:-unset}"
echo "PATH: $PATH"
echo "PWD: $(pwd)"

HERMES_HOME="${HERMES_HOME:-/data/.hermes}"

echo "=== Seeding config ==="
mkdir -p "$HERMES_HOME"
ls -la "$HERMES_HOME" 2>&1 || echo "cannot list HERMES_HOME"

if [ -f /opt/hermes/config.yaml ]; then
  echo "config.yaml found in /opt/hermes, copying..."
  cp /opt/hermes/config.yaml "$HERMES_HOME/config.yaml"
else
  echo "WARNING: /opt/hermes/config.yaml NOT found"
fi

echo "=== Final config.yaml content ==="
cat "$HERMES_HOME/config.yaml" 2>&1 || echo "no config.yaml"

echo "=== Checking hermes binary ==="
which hermes 2>&1 || echo "hermes not in PATH"
ls -la /opt/hermes/bin/hermes 2>&1 || echo "shim missing"
ls -la /opt/hermes/.venv/bin/hermes 2>&1 || echo "venv hermes missing"

echo "=== Checking env keys ==="
if [ -n "$DEEPSEEK_API_KEY" ]; then echo "DEEPSEEK_API_KEY set: YES"; else echo "DEEPSEEK_API_KEY set: NO"; fi
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then echo "TELEGRAM_BOT_TOKEN set: YES"; else echo "TELEGRAM_BOT_TOKEN set: NO"; fi

echo "=== Starting hermes gateway (no exec, capture exit) ==="
hermes gateway
CODE=$?
echo "=== hermes gateway EXITED with code: $CODE ==="
exit $CODE
