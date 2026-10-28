#
#	This file is part of the AERA Recovery Project
# 	Copyright (C) 2025 The AERA Recovery Project
#
#	AERA is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	AERA is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

#set -o xtrace
FDEVICE="roadstr"

aera_get_target_device() {
	export script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
	if echo "$script_path" | grep -q "$FDEVICE"; then
		AERA_BUILD_DEVICE="$FDEVICE"
	elif echo "$0" | grep -q "$FDEVICE"; then
		AERA_BUILD_DEVICE="$FDEVICE"
	fi
}

if [ -z "$AERA_BUILD_DEVICE" ]; then
	aera_get_target_device
fi

if [ "$AERA_BUILD_DEVICE" = "$FDEVICE" ]; then
	echo "Detected build device: $AERA_BUILD_DEVICE"

# Review build flags with below links:
# https://gitlab.com/AERA/vendor/recovery/-/raw/AERA_14.1/AERA_build_vars.txt
# https://gitlab.com/AERA/bootable/Recovery/-/raw/AERA_14.1/AERA.mk

	# A/B Partition
	export AERA_VIRTUAL_AB_DEVICE=1
	export AERA_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export AERA_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

	# Compression Binaries & Tools
	export AERA_USE_BASH_SHELL=1
	export AERA_USE_NANO_EDITOR=1
	export AERA_USE_TAR_BINARY=1
	export AERA_USE_LZ4_BINARY=1
	export AERA_USE_SED_BINARY=1
	export AERA_USE_XZ_UTILS=1
	export AERA_USE_ZSTD_BINARY=1
	export AERA_DELETE_AROMAFM=1
	export AERA_ENABLE_APP_MANAGER=1
	# export AERA_REMOVE_AAPT=1
	export AERA_USE_BUSYBOX_BINARY=1
	export AERA_USE_GREP_BINARY=1

	# KernelSU / Magisk Support
	# export AERA_DELETE_MAGISK_ADDON=1
	# export AERA_USE_SPECIFIC_MAGISK_ZIP="$(echo "$script_path"/prebuilt/Magisk*.zip)"
	export AERA_MOVE_MAGISK_INSTALLER_TO_RAMDISK=1
	export AERA_ENABLE_KERNELSU_SUPPORT=1
	export AERA_ENABLE_KERNELSU_NEXT_SUPPORT=1
	export AERA_ENABLE_SUKISU_SUPPORT=1

	# AERA Settings
	export AERA_VARIANT="crypto"
	export AERA_SETTINGS_ROOT_DIRECTORY="/persist"
	export AERA_MAINTAINER_PATCH_VERSION="$(date -d "1 hour" +%Y%m%d%H%M)"
	export AERA_ALLOW_EARLY_SETTINGS_LOAD=1
	export AERA_RESET_SETTINGS="disabled"
	export AERA_NO_BLANK_DT2W=1
else
	echo "I: vendorsetup.sh skipped; device mismatch or environment issue."
fi
