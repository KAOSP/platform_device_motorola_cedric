LOCAL_PATH := $(call my-dir)

# Kernel
TARGET_KERNEL_VERSION := 3.18
BOARD_KERNEL_CMDLINE += vmalloc=350M  androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_SEPARATED_DT := true
BOARD_KERNEL_LZ4C_DT := true
TARGET_CUSTOM_DTBTOOL := dtbTool_custom
BOARD_DTBTOOL_ARGS := --force-v3 --motorola 1
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET     := 0x01000000
TARGET_KERNEL_CONFIG := cedric_defconfig
TARGET_KERNEL_SOURCE := kernel/motorola/msm8937

KERNEL_TOOLCHAIN := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/aarch64/aarch64-linux-android-4.9/bin
TARGET_USE_SDCLANG := false

include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

#----------------------------------------------------------------------
# extra images
#----------------------------------------------------------------------
include device/qcom/common/generate_extra_images.mk
