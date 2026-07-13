#!/bin/bash
# Test custom SystemRescue ISO in VirtualBox
# Usage: ./test-vbox.sh [iso]

set -e

ISO="${1:-systemrescue-custom-amd64.iso}"
VM_NAME="rescue-test"

# Check if VBoxManage works
if ! VBoxManage --version &>/dev/null; then
  echo "VBoxManage not available. Try:"
  echo "  sudo modprobe vboxdrv"
  echo "  or use QEMU: ./test-qemu.sh"
  exit 1
fi

# Create VM if not exists
if ! VBoxManage showvminfo "$VM_NAME" &>/dev/null; then
  VBoxManage createvm --name "$VM_NAME" --ostype "Linux_64" --register
  VBoxManage modifyvm "$VM_NAME" --memory 2048 --vram 16
  VBoxManage modifyvm "$VM_NAME" --nic1 hostonly --hostonlyadapter1 "vboxnet0"
  VBoxManage modifyvm "$VM_NAME" --nic2 nat
  VBoxManage storagectl "$VM_NAME" --name "IDE" --add ide --controller PIIX4
  echo "VM created"
fi

# Attach ISO
VBoxManage storageattach "$VM_NAME" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "$(pwd)/$ISO"

# Add a small disk for testing
VBoxManage createmedium disk --filename "$(pwd)/test-disk.vdi" --size 8192 --format VDI 2>/dev/null || true
VBoxManage storageattach "$VM_NAME" --storagectl "IDE" --port 1 --device 0 --type hdd --medium "$(pwd)/test-disk.vdi" 2>/dev/null || true

echo "Starting VM..."
echo "After boot: ssh root@<vm-ip> (password: rescue123)"
VBoxManage startvm "$VM_NAME"
