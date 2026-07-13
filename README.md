# Rescue ISO

Custom SystemRescue ISO with SSH + Pi agent + ZeroTier.

## Build

```bash
cp .env.example .env   # edit values
./build.sh             # build ISO
```

Copy to Ventoy USB and boot. No boot params needed — `nofirewall` and `cow_spacesize=2G` are baked in.

## Connect

- SSH: `ssh root@<ip>` (password set in `.env`)
- ZeroTier: approve device in web UI, SSH to ZT IP
- Pi agent: `pi` (OpenRouter free auto-configured)

## Files

| File | Purpose |
|------|---------|
| `.env.example` | Template — copy to `.env` and fill in |
| `.env` | API key + ZeroTier network ID (gitignored) |
| `autorun/autorun0` | Auto-config script |
| `build.sh` | Build ISO |
| `test-qemu.sh` | Test in QEMU |
