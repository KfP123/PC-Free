#!/usr/bin/env bash
# Starts the Windows container. Called by postStartCommand on every Codespace start.
set -euo pipefail
cd "$(dirname "$0")/.."

# Wait for the Docker daemon (docker-in-docker starts in parallel with this script).
for _ in $(seq 1 60); do
  docker info >/dev/null 2>&1 && break
  sleep 2
done

# /tmp sits on the Codespace's large temporary disk; /workspaces is too small for Windows.
mkdir -p /tmp/windows-storage shared

# Give Windows all but 2 GB of the machine's RAM, and every CPU core.
total_gb=$(( $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1024 / 1024 ))
export RAM_SIZE="$(( total_gb > 6 ? total_gb - 2 : 4 ))G"
export CPU_CORES="$(nproc)"

docker compose -f windows10.yml up -d

echo "Windows is starting. Open the 'Windows desktop' port (8006) from the Ports tab."
echo "The first boot of each session installs Windows automatically and takes about 10-15 minutes."
