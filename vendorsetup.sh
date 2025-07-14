# Apply Changes to soure code
set -x
#cd bootable/recovery
#patch -p1 < ../../device/samsung/a12s/colour_fix.diff || true
#cd ../../

# Magisk Downloader
USER='topjohnwu'
REPO='Magisk'
PATTERN="$USER/$REPO/releases/download/[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+\.apk"
URL_BASE="https://github.com/$USER/$REPO/releases"
URL_LATEST="$URL_BASE/latest"

echo 'Searching for latest Magisk...'
REDIRECT_URL="$(curl "$URL_LATEST" -S -L -I -o /dev/null -w '%{url_effective}')" || {
    echo "Failed to open $URL_LATEST"
    exit $?
}

# Extract tag
VERSION_TAG="${REDIRECT_URL/$URL_BASE\/tag\/}"
URL="https://github.com/$USER/$REPO/releases/expanded_assets/$VERSION_TAG"

echo 'Searching for Magisk download link...'
HTML="$(curl -S -L "$URL")" || {
    echo "Failed to download $URL"
    exit $?
}

FILE_LINK="$(echo "$HTML" | grep -Eo "$PATTERN" | head -n 1)"
DOWNLOAD_LINK="https://github.com/$FILE_LINK"
FILE_NAME="/tmp/$(basename "${FILE_LINK/apk/zip}")"

echo "Downloading Magisk from $DOWNLOAD_LINK"
RESPONSE_CODE="$(curl -S -L "$DOWNLOAD_LINK" -w '%{http_code}' -o "$FILE_NAME")"; CODE=$?

if [ $CODE -gt 0 ] || [ $RESPONSE_CODE -ge 400 ]; then
    echo "Failed to download $DOWNLOAD_LINK"
    exit $CODE
fi
echo "Latest Magisk has been saved to: $FILE_NAME"

export FOX_USE_SPECIFIC_MAGISK_ZIP="$FILE_NAME"

# MKBOOTIMG
chmod a+x device/samsung/a12s/prebuilt/mkboot/mkbootimg

# Device variables
FDEVICE1="a12s"
CURR_DEVICE="a12s"

# Color codes for terminal output
RED_BACK="\e[101m"
RED="\e[91m"
RESET="\e[0m"
GREEN="\e[92m"

# Important build settings
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"

# General configurations
echo "General Configurations"
export OF_MAINTAINER="TheDarkDeath788"
SRC="device/samsung/a12s/source_changes/maintainer/processed_image1.png"
DST="bootable/recovery/gui/theme/portrait_hdpi/images/Default/About/maintainer.png"
rm -rf "$DST"
cp -v "$SRC" "$DST" | true
set +x

export FOX_BUILD_TYPE="Stable"
export FOX_VERSION="R12.1_12"
export FOX_VARIANT="ω | Omega"

# Binary and tool settings
#export FOX_CUSTOM_BINS_TO_SDCARD=2
export FOX_USE_BASH_SHELL=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_SED_BINARY=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_UNZIP_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_ZSTD_BINARY=1

# Target device configurations
export FOX_TARGET_DEVICES="a12s"
export TARGET_DEVICE_ALT="a12sub, SM-A127M, SM-A127F"
export FOX_BUILD_DEVICE="a12s, a12sub, SM-A127M, SM-A127F"

# Function to export build variables
export_build_vars() {
    echo -e "${GREEN}Exporting build vars from the a12s tree${RESET}"
    # Important build flags
    export FOX_VANILLA_BUILD=1
    export FOX_DELETE_AROMAFM=0
    export OF_WIPE_METADATA_AFTER_DATAFORMAT=1
    export FOX_DELETE_INITD_ADDON=1  # Note: This can cause bootloops
    export FOX_ENABLE_APP_MANAGER=1
    export OF_USE_SAMSUNG_HAPTICS=1
    export OF_USE_TWRP_SAR_DETECT=1
    export FOX_USE_BUSYBOX_BINARY=1
    export OF_QUICK_BACKUP_LIST="/super;/boot;/vbmeta;/dtbo;/efs;/sec_efs"
    export FOX_REPLACE_TOOLBOX_GETPROP=1
    export OF_USE_SYSTEM_FINGERPRINT=1

    # Security configurations
    export OF_ADVANCED_SECURITY=1

    # Screen Settings
    export OF_STATUS_INDENT_RIGHT=42
    export OF_STATUS_INDENT_LEFT=42
    export OF_STATUS_H=88
    export OF_SCREEN_H=2400
    export OF_OPTIONS_LIST_NUM=10
    export OF_CLOCK_POS=1
    
    # Tools and utilities configurations
    # export FOX_COMPRESS_EXECUTABLES=1
    # export OF_USE_LZ4_COMPRESSION=1
    export OF_USE_LZMA_COMPRESSION=1
    export OF_ENABLE_FS_COMPRESSION=1
    export FOX_RECOVERY_BOOT_PARTITION="/dev/block/mmcblk0p18"
    export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/mmcblk0p19"
    export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/dm-1"
    export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/dm-0"

    # Maximum permissible splash image size (in KB); do not increase!
    export OF_SPLASH_MAX_SIZE=128

    # Specific features configurations
    export OF_NO_TREBLE_COMPATIBILITY_CHECK=0
    export OF_FORCE_DATA_FORMAT_F2FS=1
    export OF_DEFAULT_TIMEZONE="GRNLNDST3"
    #export OF_ENABLE_ALL_PARTITION_TOOLS=1
    export OF_ENABLE_LPTOOLS=1
    export FOX_NO_SAMSUNG_SPECIAL=0
    export OF_PATCH_AVB20=1
    export OF_SUPPORT_VBMETA_AVB2_PATCHING=1
    export OF_NO_SPLASH_CHANGE=0

    # Flashlight paths configurations
    export OF_FL_PATH1="/system/flashlight"
    export OF_FL_PATH2=""
    export OF_FLASHLIGHT_ENABLE=1

    # Log build variables if log file is specified
    if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
        export | grep "FOX" >> $FOX_BUILD_LOG_FILE
        export | grep "OF_" >> $FOX_BUILD_LOG_FILE
        export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
        export | grep "TW_" >> $FOX_BUILD_LOG_FILE
    fi
}

# Function to prompt setting CURR_DEVICE variable
set_env_var() {
    echo -e "${RED_BACK}Environment Variable CURR_DEVICE not set... Aborting${RESET}"
    echo "Set to the codename of the device you're building for"
    echo -e "${GREEN}Example:${RESET}"
    echo " export CURR_DEVICE=a12s"
    exit 1
}

# Function to handle mismatched CURR_DEVICE variable
var_not_eq() {
    echo -e "${RED_BACK}CURR_DEVICE not equal to a12s${RESET}"
    echo -e "${RED_BACK}CURR_DEVICE = $CURR_DEVICE${RESET}"
    echo -e "${RED}If this is a mistake, then export CURR_DEVICE to the correct codename${RESET}"
    echo -e "${RED}Skipping a12s specific build vars...${RESET}"
}

# Main logic to export build vars based on the current device
case "$CURR_DEVICE" in
    "$FDEVICE1")
        export_build_vars
        ;;
    "")
        set_env_var
        ;;
    *)
        var_not_eq
        ;;
esac

# Trying to fix PBRP torch
sudo mkdir /system
sudo mkdir /system/flashlight
sudo touch /system/flashlight/brightness
sudo su -c "echo 1 > /system/flashlight/brightness"
