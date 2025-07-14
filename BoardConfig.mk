#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 The TWRP Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/samsung/a12s

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH                := arm64
TARGET_ARCH_VARIANT        := armv8-a
TARGET_CPU_ABI             := arm64-v8a
TARGET_CPU_ABI2            := 
TARGET_CPU_VARIANT         := generic
TARGET_CPU_VARIANT_RUNTIME := generic

TARGET_2ND_ARCH                := arm
TARGET_2ND_ARCH_VARIANT        := armv7-a-neon
TARGET_2ND_CPU_ABI             := armeabi-v7a
TARGET_2ND_CPU_ABI2            := armeabi
TARGET_2ND_CPU_VARIANT         := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a15

TARGET_USES_64_BIT_BINDER   := true
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_BOARD_SUFFIX := _64

TARGET_CPU_SMP    := true
ENABLE_CPUSETS    := true
ENABLE_SCHEDBOOST := true

# Bootloader
BOARD_VENDOR                 := samsung
TARGET_SOC                   := universal3830
TARGET_BOOTLOADER_BOARD_NAME := exynos850
TARGET_NO_BOOTLOADER         := true
TARGET_NO_RADIOIMAGE         := true
TARGET_USES_UEFI             := false
TARGET_SCREEN_DENSITY        := 300

# Kernel
BOARD_BOOT_HEADER_VERSION    := 2
BOARD_KERNEL_BASE            := 0x10000000
BOARD_KERNEL_IMAGE_NAME      := Image
BOARD_KERNEL_PAGESIZE        := 4096
BOARD_RAMDISK_OFFSET         := 0x11000000
BOARD_KERNEL_TAGS_OFFSET     := 0x00001000

BOARD_KERNEL_CMDLINE += bootconfig
BOARD_BOOTCONFIG += \
	androidboot.hardware=exynos850 \
	androidboot.selinux=permissive \
	loop.max_part=35 \
	androidboot.usbcontroller=13600000.dwc3 \
	androidboot.usbconfigfs=true

# Compile kernel and DTBs
TARGET_KERNEL_CONFIG         := a12s_defconfig
TARGET_KERNEL_SOURCE         := kernel/samsung/a12s
TARGET_KERNEL_HEADER_ARCH    := arm64
TARGET_KERNEL_ARCH           := arm64
	
# Kernel - prebuilt
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
    TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/zImage
    TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
    BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
    BOARD_INCLUDE_DTB_IN_BOOTIMG := true
    BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
    BOARD_KERNEL_SEPARATED_DTBO := true
endif

# MKBOOTARGS
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --board $(TARGET_BOOTLOADER_BOARD_NAME)

BOARD_CUSTOM_BOOTIMG_MK      := $(DEVICE_PATH)/prebuilt/mkboot/bootimg.mk

# Partitions
BOARD_FLASH_BLOCK_SIZE                 := $(shell echo $$(($(BOARD_KERNEL_PAGESIZE) * 64)))
BOARD_BOOTIMAGE_PARTITION_SIZE         := 46137344
BOARD_RECOVERYIMAGE_PARTITION_SIZE     := 55574528
BOARD_SYSTEMIMAGE_PARTITION_SIZE       := 5368709120
BOARD_VENDORIMAGE_PARTITION_SIZE       := 1073741824
BOARD_SYSTEMIMAGE_PARTITION_TYPE       := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE     := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE   := f2fs

# Rsync error fix or Fixing trying to copy non-existance files
TARGET_COPY_OUT_VENDOR := vendor

# Recovery
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_USERIMAGES_USE_EXT4  := true
TARGET_USERIMAGES_USE_F2FS  := true

# Samsung Dynamic Partition
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 9122611200
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    vendor \
    product \
    odm \
    system_ext 

# Dynamic partitions
#PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Platform
TARGET_BOARD_PLATFORM := universal3830

# Android Verified Boo
BOARD_AVB_ENABLE                 := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH      := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM     := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX          := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_BUILD_DISABLED_VBMETAIMAGE           := true

# Crypto
PLATFORM_SECURITY_PATCH   := 2099-12-31
VENDOR_SECURITY_PATCH     := 2099-12-31
PLATFORM_VERSION          := $(shell tail -n1 cts/tests/tests/os/assets/platform_versions.txt)
TW_INCLUDE_CRYPTO         := false
TW_INCLUDE_CRYPTO_FBE     := false
TW_INCLUDE_FBE_METADATA_DECRYPT := false

# Device Partitons
BOARD_USES_METADATA_PARTITION   := true
BOARD_USES_VENDOR_DLKMIMAGE     := true
BOARD_USES_SYSTEM_DLKMIMAGE     := true

# TWRP
TW_DEVICE_VERSION     := LTS
TW_THEME              := portrait_hdpi
TW_MTP_DEVICE         := "Galaxy MTP"

# Screen
TARGET_RECOVERY_PIXEL_FORMAT  := ABGR_8888
TW_BRIGHTNESS_PATH            := /system/backlight/brightness
TW_SECONDARY_BRIGHTNESS_PATH  := /sys/devices/platform/panel_drv@0/backlight/panel/brightness
TW_MAX_BRIGHTNESS             := 306
TW_DEFAULT_BRIGHTNESS         := 153
TARGET_SCREEN_WIDTH           := 720
TARGET_SCREEN_HEIGHT          := 1600
TW_NO_SCREEN_TIMEOUT          := true

# TWRP Settings
TARGET_SYSTEM_PROP                := $(DEVICE_PATH)/system.prop
TW_EXCLUDE_DEFAULT_USB_INIT   := true
TW_NO_SCREEN_TIMEOUT          := true
TW_NO_REBOOT_BOOTLOADER       := true
TW_HAS_DOWNLOAD_MODE          := true
TW_SCREEN_BLANK_ON_BOOT       := true
TW_INCLUDE_FASTBOOTD          := true
BOARD_CHARGER_SHOW_PERCENTAGE := true
RECOVERY_SDCARD_ON_DATA       := true
BOARD_HAS_NO_REAL_SDCARD      := true
TW_NO_LEGACY_PROPS            := true

# TWRP Utils
TW_ENABLE_ALL_PARTITION_TOOLS := true
TW_USE_TOOLBOX                := true
TW_USE_NEW_MINADBD            := true
TW_INCLUDE_REPACKTOOLS        := true
TW_EXTRA_LANGUAGES            := true
TW_INCLUDE_PYTHON             := true
TW_INCLUDE_FB2PNG             := true
TW_INCLUDE_LIBRESETPROP       := true
TW_INCLUDE_RESETPROP          := true
TW_INCLUDE_RESETPROP_BINARY   := true
TW_USE_MODEL_HARDWARE_ID_FOR_DEVICE_ID   := true

# TWRP Fuse and Formating
TARGET_USES_MKE2FS          := true
TW_INCLUDE_FUSE_EXFAT       := true
TW_INCLUDE_FUSE_NTFS        := true
TW_INCLUDE_NTFS_3G          := true

# Making the recovery.img smaller with LZMA
BOARD_RAMDISK_USE_LZMA := true
LZMA_RAMDISK_TARGETS   := recovery

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Exclude from backup
TW_BACKUP_EXCLUSIONS += \
	/data/fonts \
	/data/system/package_cache \
	/data/dalvik-cache \
	/data/cache \
	/data/resource-cache \
	/data/system/graphicsstats \
	/data/local \
	/data/gsi \
	/data/adb

#SHRP
SHRP_PATH                      := device/samsung/a12s
SHRP_MAINTAINER                := TheDarkDeath788
SHRP_DEVICE_CODE               := a12s
SHRP_REC_TYPE                  := Treble
SHRP_DEVICE_TYPE               := A_Only
SHRP_DARK                      := true
SHRP_EXPRESS                   := true
SHRP_STATUSBAR_RIGHT_PADDING   := 40
SHRP_STATUSBAR_LEFT_PADDING    := 40
SHRP_EXTERNAL                  := /external_sd
SHRP_INTERNAL                  := /sdcard
SHRP_OTG                       := /usb_otg
SHRP_REC                       := /dev/block/by-name/recovery

#PBRP
PB_TORCH_PATH                  := "/system/flashlight/"
