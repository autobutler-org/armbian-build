# Quark Image Extension

This extension provisions an Quark appliance image from the latest GitHub release.

It builds on `appliance-image` and preconfigures:

- latest `quark_Linux_arm64.tar.gz` from GitHub Releases
- install path `/usr/local/bin/quark`
- systemd service `quark.service`
- service account and login account `quark`
- data directory `/var/lib/quark/data`
- mounts directory `/var/lib/quark/mounts`
- HTTP on port 80
- avahi service for `quark.local`
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
