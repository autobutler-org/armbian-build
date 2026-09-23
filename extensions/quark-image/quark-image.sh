#!/usr/bin/env bash

enable_extension "appliance-image"

function extension_prepare_config__400_quark_image_defaults() {
	: "${QUARK_IMAGE_ENABLE_SSH:=no}"
	: "${QUARK_IMAGE_LOGIN_PASSWORD:=}"
	: "${QUARK_IMAGE_LOGIN_USER:=quark}"
	: "${QUARK_IMAGE_HOSTNAME:=quark}"
	# A tagged build embeds that tag's binary: the Quark release workflow passes
	# the tag as IMAGE_VERSION. Without one, the latest release.
	if [[ -n "${IMAGE_VERSION}" ]]; then
		: "${QUARK_IMAGE_BINARY_URL:=https://github.com/autobutler-org/quark/releases/download/${IMAGE_VERSION}/quark_Linux_arm64.tar.gz}"
	else
		: "${QUARK_IMAGE_BINARY_URL:=https://github.com/autobutler-org/quark/releases/latest/download/quark_Linux_arm64.tar.gz}"
	fi

	declare -g APPLIANCE_IMAGE_SERVICE_NAME="quark"
	declare -g APPLIANCE_IMAGE_HOSTNAME="${QUARK_IMAGE_HOSTNAME}"
	declare -g APPLIANCE_IMAGE_SERVICE_USER="quark"
	declare -g APPLIANCE_IMAGE_SERVICE_GROUP="quark"
	declare -g APPLIANCE_IMAGE_LOGIN_USER="${QUARK_IMAGE_LOGIN_USER}"
	declare -g APPLIANCE_IMAGE_LOGIN_PASSWORD="${QUARK_IMAGE_LOGIN_PASSWORD}"
	declare -g APPLIANCE_IMAGE_CREATE_LOGIN_USER="yes"
	declare -g APPLIANCE_IMAGE_BINARY_URL="${QUARK_IMAGE_BINARY_URL}"
	declare -g APPLIANCE_IMAGE_BINARY_URL_EXTRACT_MODE="targz"
	declare -g APPLIANCE_IMAGE_BINARY_ARCHIVE_MEMBER="quark"
	# Where the download lands; `quark install` moves it into /opt/quark/bin and
	# leaves this path as a symlink.
	declare -g APPLIANCE_IMAGE_BINARY_INSTALL_PATH="/usr/local/bin/quark"
	declare -g APPLIANCE_IMAGE_WORKING_DIR="/var/lib/quark"
	declare -g APPLIANCE_IMAGE_DATA_DIR="/var/lib/quark/data"
	# dcraw and exiftool: photoutil reads a RAW photo's embedded preview with them.
	# openssh-server is always installed but left off: an admin turns SSH access
	# on and off from Quark's settings, which starts sshd and opens 22/tcp.
	declare -g APPLIANCE_IMAGE_PACKAGES="avahi-daemon dcraw ffmpeg libimage-exiftool-perl openssh-server ufw udisks2"
	# The unit `quark install` writes has no QUARK_INSECURE, so `quark serve`
	# serves TLS on HTTPS_PORT=443 and nothing listens on 80.
	declare -g APPLIANCE_IMAGE_AVAHI_SERVICE_NAME="Quark on %h"
	declare -g APPLIANCE_IMAGE_AVAHI_SERVICE_TYPE="_https._tcp"
	declare -g APPLIANCE_IMAGE_AVAHI_SERVICE_PORT="443"
	declare -g APPLIANCE_IMAGE_OPEN_PORTS="443/tcp"
	# A dev build with SSH on from the first boot needs the port open too.
	if [[ "${QUARK_IMAGE_ENABLE_SSH}" == "yes" ]]; then
		APPLIANCE_IMAGE_OPEN_PORTS+=" 22/tcp"
	fi
	declare -g APPLIANCE_IMAGE_ENABLE_SSH="${QUARK_IMAGE_ENABLE_SSH}"
}

# The binary layout, sudoers rule, systemd unit, SSH access helper and sshd
# drop-in come from `quark install` itself, so the image cannot drift from a
# host install. It runs after appliance-image has created the accounts, and its
# unit replaces the one appliance-image wrote at the same path.
function post_customize_image__600_quark_image_install() {
	display_alert "Extension: ${EXTENSION}" "running quark install in the image" "info"
	chroot_sdcard "/usr/local/bin/quark install"
}
