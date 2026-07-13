#!/bin/bash
# Background setup (runs after boot, detached)
sleep 5
for i in $(seq 1 30); do
  ip route | grep -q default && break
  sleep 1
done

# Node.js v22.19.0
curl -sL --connect-timeout 10 https://nodejs.org/dist/v22.19.0/node-v22.19.0-linux-x64.tar.gz | tar xz -C /usr/local --strip-components=1

# Pi agent
npm install -g @earendil-works/pi-coding-agent 2>/dev/null

# Pi config
KEY="__OPENROUTER_API_KEY__"
if [ -n "$KEY" ]; then
  mkdir -p /root/.pi/agent
  cat > /root/.pi/agent/config.json <<EOF
{
  "provider": "openrouter",
  "model": "openrouter/anthropic/claude-sonnet-4",
  "OPENROUTER_API_KEY": "$KEY"
}
EOF
fi

# Tools
rm -f /var/lib/pacman/db.lck
pacman -Sy --noconfirm 2>/dev/null
pacman -S --noconfirm fd ripgrep zerotier-one 2>/dev/null || true

# ZeroTier
ZTID="__ZEROTIER_NETWORK_ID__"
if [ -n "$ZTID" ]; then
  systemctl start zerotier-one 2>/dev/null || true
  sleep 2
  zerotier-cli join "$ZTID" 2>/dev/null || true
fi
