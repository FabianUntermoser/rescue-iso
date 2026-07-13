# Rescue ISO

Custom SystemRescue ISO with SSH + Pi agent + ZeroTier.

## Build

```bash
./build.sh
```

## Config

```bash
cp .env.example .env   # edit values
./build.sh             # build ISO
```

Copy to Ventoy USB and boot.

## Boot params

Add at boot prompt: `nofirewall cow_spacesize=2G`

## Connect

- SSH: `ssh root@<ip>` (password set in `.env`)
- ZeroTier: approve device in web UI, SSH to ZT IP
- Pi agent: `pi` (OpenRouter auto-configured)

## Files

| File | Purpose |
|------|---------|
| `.env.example` | Template — copy to `.env` and fill in |
| `.env` | API key + ZeroTier network ID (gitignored) |
| `autorun/autorun0` | Auto-config script |
| `build.sh` | Build ISO |
| `test-qemu.sh` | Test in QEMU |
