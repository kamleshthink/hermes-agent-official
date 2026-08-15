#!/bin/sh
# Simple entrypoint for Render — bypasses s6-overlay (which fails on Render)
# and runs `hermes gateway` directly.
set -e

# Set up PATH: include s6 helpers (s6-setuidgid) + hermes bin + venv bin
export PATH="/command:/package/admin/s6/command:/opt/hermes/bin:/opt/hermes/.venv/bin:${PATH}"

HERMES_HOME="${HERMES_HOME:-/data/.hermes}"
export HERMES_HOME

echo "[render-entrypoint] Starting. HERMES_HOME=$HERMES_HOME"
echo "[render-entrypoint] UID=$(id -u) GID=$(id -g)"

# Seed config.yaml (DeepSeek) into HERMES_HOME
mkdir -p "$HERMES_HOME"
if [ -f /opt/hermes/config.yaml ] && [ ! -f "$HERMES_HOME/config.yaml" ]; then
  echo "[render-entrypoint] Seeding DeepSeek config"
  cp /opt/hermes/config.yaml "$HERMES_HOME/config.yaml"
fi
chown -R hermes:hermes "$HERMES_HOME" 2>/dev/null || true

# Activate venv (so `hermes` resolves) and run the gateway
echo "[render-entrypoint] Launching hermes gateway..."
if [ -x /command/s6-setuidgid ]; then
  exec /command/s6-setuidgid hermes /opt/hermes/.venv/bin/hermes gateway
else
  exec /opt/hermes/.venv/bin/hermes gateway
fi
