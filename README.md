# Rescue ISO

Custom SystemRescue ISO with SSH + Pi agent + ZeroTier.

## Build

```bash
cp .env.example .env   # fill in values
./build.sh             # build ISO (uses Docker)
```

Copy to Ventoy USB and boot. No boot params needed.

## Connect

- SSH: `ssh root@<ip>` (password set in `.env`)
- ZeroTier: approve device in web UI, SSH to ZT IP
- Pi agent: `pi` (OpenRouter free auto-configured)

## Files

| File | Purpose |
|------|---------|
| `.env.example` | Template — copy to `.env` and fill in |
| `autorun/autorun0` | Entrypoint — quick setup, launches setup.sh in bg |
| `autorun/setup.sh` | Background — Node.js, Pi agent, ZeroTier, tools |
| `autorun/grub-params` | Idempotent script — bakes kernel params into GRUB |
| `build.sh` | Build ISO (Docker or local) |
| `test-qemu.sh` | Test in QEMU |
