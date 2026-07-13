#!/bin/bash
# Test custom SystemRescue ISO in QEMU/KVM
# Usage: ./test-qemu.sh [iso]

set -e

ISO="${1:-systemrescue-custom-amd64.iso}"
DIR="$(dirname "$0")"

# Check for qemu
QEMU=""
for cmd in qemu-system-x86_64 qemu-kvm; do
  if command -v $cmd &>/dev/null; then
    QEMU=$cmd
    break
  fi
done

if [ -z "$QEMU" ]; then
  echo "No QEMU found. Install: sudo pacman -S qemu-desktop"
  exit 1
fi

# Create test disk
DISK="$DIR/test-disk.qcow2"
if [ ! -f "$DISK" ]; then
  qemu-img create -f qcow2 "$DISK" 8G
fi

KVM=""
if [ -c /dev/kvm ]; then
  KVM="-accel kvm"
fi

echo "Starting QEMU..."
echo "SSH: ssh root@localhost -p 2222 (password: rescue123)"

$QEMU $KVM \
  -m 2048 \
  -kernel "$DIR/boot/vmlinuz" \
  -initrd "$DIR/boot/initrd.img" \
  -append "archisobasedir=sysresccd archisolabel=RESCUE1301 iomem=relaxed console=ttyS0,115200 rootpass=rescue123 net.ifnames=0 nofirewall cow_spacesize=2G" \
  -drive file="$DISK",format=qcow2,if=virtio \
  -drive file="$DIR/$ISO",format=raw,media=cdrom,index=1 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device e1000,netdev=net0 \
  -serial telnet:localhost:3333,server,nowait \
  -display none
