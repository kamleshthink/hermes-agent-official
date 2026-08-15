#!/bin/sh
# Render start script for Hermes Agent
# Seeds the DeepSeek config into HERMES_HOME, then starts the gateway.
set -e

HERMES_HOME="${HERMES_HOME:-/data/.hermes}"

# Ensure HERMES_HOME exists and seed config if missing
mkdir -p "$HERMES_HOME"
if [ ! -f "$HERMES_HOME/config.yaml" ] && [ -f /opt/hermes/config.yaml ]; then
  echo "[render-start] Seeding DeepSeek config into $HERMES_HOME"
  cp /opt/hermes/config.yaml "$HERMES_HOME/config.yaml"
fi
chown -R hermes:hermes "$HERMES_HOME" 2>/dev/null || true

echo "[render-start] Starting Hermes gateway..."
exec hermes gateway
