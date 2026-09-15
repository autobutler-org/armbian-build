# Quark Image Extension

This extension provisions a Quark appliance image from a GitHub release.

It builds on `appliance-image` and preconfigures:

- `quark_Linux_arm64.tar.gz` from the release tagged `IMAGE_VERSION`, or the latest release when `IMAGE_VERSION` is unset
- install path `/usr/local/bin/quark`
- systemd service `quark.service`
- service account and login account `quark`
- data directory `/var/lib/quark/data`
- HTTP on port 80
- avahi service for `quark.local`
- `ffmpeg` and `ffprobe`, which Quark shells out to for video thumbnails and transcoding
- `dcraw` and `exiftool`, which Quark uses to read RAW photo previews
- sudoers rule needed for managed mount operations

Enable it with:

```sh
ENABLE_EXTENSIONS="quark-image"
```

Optional settings:

- `QUARK_IMAGE_LOGIN_PASSWORD`
- `QUARK_IMAGE_LOGIN_USER`
- `QUARK_IMAGE_HOSTNAME`
- `QUARK_IMAGE_PORT`
- `QUARK_IMAGE_ENABLE_SSH=yes`
