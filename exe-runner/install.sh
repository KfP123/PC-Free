#!/usr/bin/env bash
# Installs EXE Runner on a fresh Ubuntu server (made for Oracle Cloud's free
# Ampere A1 machine). Run as root, with EXE_RUNNER_PASSWORD set. Safe to re-run:
# it updates to the latest version and keeps your files.
set -euo pipefail

: "${EXE_RUNNER_PASSWORD:?Set EXE_RUNNER_PASSWORD before running this script}"
EXE_RUNNER_USER="${EXE_RUNNER_USER:-me}"
REPO_URL="${REPO_URL:-https://github.com/KfP123/PC-Free.git}"
DIR=/opt/pc-free
export DEBIAN_FRONTEND=noninteractive

case "$EXE_RUNNER_PASSWORD" in
  *"'"*) echo "The password can't contain a single quote (')." >&2; exit 1 ;;
esac

echo "==> Installing Docker and git"
apt-get update -q
apt-get install -y -q git curl
command -v docker >/dev/null || curl -fsSL https://get.docker.com | sh

echo "==> Opening ports 80 and 443 in the server's firewall"
# Oracle's Ubuntu images reject everything except SSH by default.
for port in 80 443; do
  iptables -C INPUT -p tcp --dport "$port" -j ACCEPT 2>/dev/null \
    || iptables -I INPUT 1 -p tcp --dport "$port" -j ACCEPT
done
command -v netfilter-persistent >/dev/null && netfilter-persistent save || true

echo "==> Getting the latest EXE Runner"
if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull -q --ff-only
else
  git clone -q --depth 1 "$REPO_URL" "$DIR"
fi
cd "$DIR/exe-runner"

umask 077
cat > /etc/exe-runner.env <<ENV
EXE_RUNNER_USER='$EXE_RUNNER_USER'
EXE_RUNNER_PASSWORD='$EXE_RUNNER_PASSWORD'
ENV
umask 022

cat > /etc/systemd/system/exe-runner.service <<UNIT
[Unit]
Description=EXE Runner
After=docker.service network-online.target
Wants=network-online.target
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=$DIR/exe-runner/start.sh

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable exe-runner.service

echo "==> Building and starting (the first build takes 5-10 minutes)"
./start.sh
echo "Log in with user '$EXE_RUNNER_USER' and the password you chose."
