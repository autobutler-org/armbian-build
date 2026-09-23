# Quark Image Extension

This extension provisions a Quark appliance image from a GitHub release.

It builds on `appliance-image` and preconfigures:

- `quark_Linux_arm64.tar.gz` from the release tagged `IMAGE_VERSION`, or the latest release when `IMAGE_VERSION` is unset
- service account and login account `quark`
- data directory `/var/lib/quark/data`
- HTTPS on port 443, the only port the firewall opens
- `openssh-server`, installed but off: sshd is disabled and port 22 stays closed until an admin turns SSH access on
  in Quark's settings
- avahi service `_https._tcp` for `quark.local`
- avahi service `_quark._tcp` on 443, named "Quark on <hostname>", for the Quark app to browse. Its TXT record
  `version` is the Quark version the image was built with, read from the embedded binary; it is not rewritten when
  Quark updates itself
- `ffmpeg` and `ffprobe`, which Quark shells out to for video thumbnails and transcoding
- `dcraw` and `exiftool`, which Quark uses to read RAW photo previews

The rest is done by running `quark install` inside the image, exactly as on any other host: the binary in
`/opt/quark/bin` (symlinked from `/usr/local/bin/quark`) so the service can update itself, the systemd service
`quark.service`, the sudoers rules for managed mounts and SSH access, the root-owned SSH access helper in
`/usr/local/libexec/quark`, and the sshd drop-in that refuses root and lets only `quark` sign in.

Enable it with:

```sh
ENABLE_EXTENSIONS="quark-image"
```

Optional settings:

- `QUARK_IMAGE_BINARY_URL`, to embed a binary from somewhere other than GitHub Releases
- `QUARK_IMAGE_LOGIN_PASSWORD`
- `QUARK_IMAGE_LOGIN_USER`
- `QUARK_IMAGE_HOSTNAME`
- `QUARK_IMAGE_ENABLE_SSH=yes`, for development builds: sshd starts on first boot and the firewall opens `22/tcp`.
  Settings can still turn it off.
