# Security Policy

This repository builds a bootable SystemRescue image with SSH, the pi coding agent and ZeroTier baked in, and that image is distributed on a USB stick. Anyone who holds the stick gets the credentials the build put into it, so a built image is a credential-bearing artifact. Treat one as compromised the moment it leaves the machine that built it, and rotate every credential it carries. Reports about this repository are welcome.

## Reporting a vulnerability

Report privately through GitHub: open the **Security** tab of this repository, then **Report a vulnerability**. The report stays private and only the maintainer sees it.

Do not open a normal issue for anything sensitive. A credential, an authentication bypass or a problem with how the build assembles the image goes through private reporting, not the public tracker.

## Scope

In scope, this repository's own code and the image it produces:

- `build.sh`, including how `.env` values are injected and how external files are fetched during a build.
- Everything under `autorun/`: `autorun/autorun0`, `autorun/setup.sh` and `autorun/grub-params`.
- Credential handling around `.env`: what `.env.example` asks for, what ends up inside the image, and what is reachable from a booted stick. The built image carries the root password, the ZeroTier network ID and the OpenRouter key from `.env`, so treat any image produced by this build as a secret. `.env.example` ships `rescue123` as a placeholder root password, and a build that leaves the placeholder in place produces an image whose root password is public. Replace it before building.
- The integrity of the ISO the build produces: the autorun scripts it adds, the kernel parameters it sets, and anything else that changes what runs on boot.

## Out of scope

These are upstream projects. Report to their own trackers:

- SystemRescue itself, including `sysrescue-customize`: https://gitlab.com/systemrescue/systemrescue-sources
- ZeroTier One: https://github.com/zerotier/ZeroTierOne
- The pi coding agent, installed in `autorun/setup.sh` as `@earendil-works/pi-coding-agent`: https://github.com/earendil-works/pi
- OpenRouter, the API provider the agent is pointed at: https://openrouter.ai

A defect in how this repository fetches, configures or wires one of those up is in scope here. A defect inside the upstream project is not.

## What to include in a report

- The exact build command you ran, including any arguments passed to `build.sh`.
- The commit you built from.
- The SHA256 of the image you built: `sha256sum systemrescue-custom-amd64.iso`.
- The reproduction, step by step.
- For a credential issue, describe how the value is reached. Do not paste a live OpenRouter key, root password or other secret.

## Supported versions

Only the current `main` branch is supported, and a fix there does not reach an image that was already built. Rebuild to pick one up, and read a distributed image as still carrying the credentials it was built with.
