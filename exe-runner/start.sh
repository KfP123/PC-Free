#!/usr/bin/env bash
# Starts EXE Runner. Runs at every boot (exe-runner.service), so the HTTPS
# address follows the server's public IP if it ever changes.
set -euo pipefail
cd "$(dirname "$0")"
source /etc/exe-runner.env

# Pick up any updates to EXE Runner.
git -C .. pull -q --ff-only || true

ip="$(curl -fsS --retry 10 --retry-delay 3 --retry-all-errors https://api.ipify.org)"
# A free HTTPS address: sslip.io turns 1-2-3-4.sslip.io into 1.2.3.4.
host="${ip//./-}.sslip.io"
cat > .env <<ENV
EXE_RUNNER_USER='$EXE_RUNNER_USER'
EXE_RUNNER_PASSWORD='$EXE_RUNNER_PASSWORD'
EXE_RUNNER_HOST='$host'
ENV
chmod 600 .env

docker compose up -d --build
echo "EXE Runner: https://$host"
