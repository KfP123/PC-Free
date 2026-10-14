#!/usr/bin/env bash
# Starts EXE Runner inside a GitHub Codespace. Called by postStartCommand.
# The port is private to your GitHub account, so no extra password is set.
set -euo pipefail
cd "$(dirname "$0")"

# Wait for the Docker daemon (it starts in parallel with this script).
for _ in $(seq 1 60); do
  docker info >/dev/null 2>&1 && break
  sleep 2
done

# Your uploads and installed programs live here, inside /workspaces, so they
# survive the Codespace stopping.
mkdir -p data

echo "Building EXE Runner (a few minutes the first time, seconds after that)..."
docker build -q -t exe-runner .

docker rm -f exe-runner >/dev/null 2>&1 || true
docker run -d --name exe-runner --restart unless-stopped --shm-size=1g \
  -e PUID="$(id -u)" -e PGID="$(id -g)" -e TZ=Etc/UTC \
  -e SELKIES_USE_CSS_SCALING=true -e SELKIES_ENCODER=jpeg -e DISABLE_IPV6=true \
  -v "$PWD/data:/config" -p 3000:3000 exe-runner >/dev/null

echo "EXE Runner is starting. Open the 'EXE Runner' port (3000) from the Ports tab."
