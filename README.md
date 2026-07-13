# Rescue ISO

Custom SystemRescue ISO with SSH + Pi agent + ZeroTier.

## Build

```bash
./build.sh
```

## Config

Edit `.env` → `./build.sh` → copy ISO to Ventoy USB.

## Boot params

Add at boot prompt: `nofirewall cow_spacesize=2G`

## Connect

- SSH: `ssh root@<ip>` pw `rescue123`
- ZeroTier: approve device in web UI, SSH to ZT IP
- Pi agent: `pi` (OpenRouter auto-configured)

## Files

| File | Purpose |
|------|---------|
| `.env` | API key + ZeroTier network ID |
| `autorun/autorun0` | Auto-config script |
| `build.sh` | Build ISO |
| `test-qemu.sh` | Test in QEMU |
