#!/bin/sh
# Simple entrypoint for Render — bypasses s6-overlay.
# Heavy debug output so the exact failure is visible in Render logs.
set -x

export PATH="/command:/package/admin/s6/command:/opt/hermes/bin:/opt/hermes/.venv/bin:${PATH}"
HERMES_HOME="${HERMES_HOME:-/data/.hermes}"
export HERMES_HOME
export HOME=/opt/data

echo "=== ENTRYPOINT START uid=$(id -u) gid=$(id -g) ==="
echo "HERMES_HOME=$HERMES_HOME"
echo "PWD=$(pwd)"

echo "=== mkdir HERMES_HOME ==="
mkdir -p "$HERMES_HOME" 2>&1 || echo "MKDIR FAILED"

echo "=== seed config ==="
if [ -f /opt/hermes/config.yaml ]; then
  cp /opt/hermes/config.yaml "$HERMES_HOME/config.yaml" && echo "CONFIG SEEDED"
else
  echo "NO /opt/hermes/config.yaml"
fi
cat "$HERMES_HOME/config.yaml" 2>&1 || echo "NO CONFIG"

chown -R hermes:hermes "$HERMES_HOME" 2>/dev/null || true

echo "=== check hermes binary ==="
ls -la /opt/hermes/.venv/bin/hermes 2>&1 || echo "VENV HERMES MISSING"
ls -la /command/s6-setuidgid 2>&1 || echo "S6-SETUIDGID MISSING"

echo "=== run gateway ==="
if [ -x /command/s6-setuidgid ]; then
  /command/s6-setuidgid hermes /opt/hermes/.venv/bin/hermes gateway 2>&1
else
  /opt/hermes/.venv/bin/hermes gateway 2>&1
fi
CODE=$?
echo "=== GATEWAY EXITED code=$CODE ==="
sleep 8
exit $CODE
