#!/bin/bash
# Build custom SystemRescue ISO with autorun + Pi agent
# Usage: ./build.sh [source.iso] [output.iso]
# Edit .env to change config before building

set -e

SRC="${1:-systemrescue-13.01-amd64.iso}"
DEST="${2:-systemrescue-custom-amd64.iso}"

# Load config
if [ -f .env ]; then
  source .env
fi

# Inject placeholders into autorun scripts
inject() {
  sed \
    -e "s|__OPENROUTER_API_KEY__|${OPENROUTER_API_KEY:-}|g" \
    -e "s|__ZEROTIER_NETWORK_ID__|${ZEROTIER_NETWORK_ID:-}|g" \
    -e "s|__ROOT_PASSWORD__|${ROOT_PASSWORD:-rescue123}|g"
}

inject < autorun/autorun0 > .autorun_built
inject < autorun/setup.sh > .setup_built

if command -v xorriso &>/dev/null; then
  # Local build
  WORKDIR="$(pwd)/work"
  RECIPE="$(pwd)/recipe"
  CUSTOMIZE="$(pwd)/sysrescue-customize"

  if [ ! -f "$CUSTOMIZE" ]; then
    curl -sL -o "$CUSTOMIZE" 'https://gitlab.com/systemrescue/systemrescue-sources/-/raw/main/airootfs/usr/share/sysrescue/bin/sysrescue-customize?inline=false'
    chmod +x "$CUSTOMIZE"
  fi

  mkdir -p "$RECIPE/iso_add/autorun"
  cp .autorun_built "$RECIPE/iso_add/autorun/autorun0"
  cp .setup_built "$RECIPE/iso_add/autorun/setup.sh"
  chmod +x "$RECIPE/iso_add/autorun/"*

  "$CUSTOMIZE" --auto --source="$SRC" --dest="$DEST" --recipe-dir="$RECIPE" --work-dir="$WORKDIR" --overwrite
else
  # Docker build
  echo "Using Docker for build..."
  docker run --rm -v "$(pwd):/work" alpine sh -c '
    apk add xorriso squashfs-tools curl bash patch rsync >/dev/null 2>&1
    cd /work
    curl -sL -o /usr/local/bin/sysrescue-customize "https://gitlab.com/systemrescue/systemrescue-sources/-/raw/main/airootfs/usr/share/sysrescue/bin/sysrescue-customize?inline=false"
    chmod +x /usr/local/bin/sysrescue-customize
    mkdir -p /tmp/recipe/iso_add/autorun
    cp /work/.autorun_built /tmp/recipe/iso_add/autorun/autorun0
    cp /work/.setup_built /tmp/recipe/iso_add/autorun/setup.sh
    chmod +x /tmp/recipe/iso_add/autorun/*
    sysrescue-customize --auto --source=/work/'"$SRC"' --dest=/work/'"$DEST"' --recipe-dir=/tmp/recipe --work-dir=/tmp/work --overwrite
  '
fi

rm -f .autorun_built .setup_built
rm -rf recipe work 2>/dev/null || true

echo "=== Done: $DEST ==="
echo "Write to USB: dd if=$DEST of=/dev/sdX bs=4M status=progress"
echo "Or copy to Ventoy USB"
