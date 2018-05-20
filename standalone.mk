#----------------------------------------------------------------------
# Compile (L)ittle (K)ernel bootloader and the nandwrite utility
#----------------------------------------------------------------------
ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)

# Compile
include bootable/bootloader/lk/AndroidBoot.mk

$(INSTALLED_BOOTLOADER_MODULE): $(TARGET_EMMC_BOOTLOADER) | $(ACP)
	$(transform-prebuilt-to-target)
$(BUILT_TARGET_FILES_PACKAGE): $(INSTALLED_BOOTLOADER_MODULE)

droidcore: $(INSTALLED_BOOTLOADER_MODULE)
endif

#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
ifeq ($(KERNEL_DEFCONFIG),)
    ifneq ($(wildcard kernel/msm-3.18),)
        ifeq ($(TARGET_BUILD_VARIANT),user)
          KERNEL_DEFCONFIG := msm8937-perf_defconfig
        else
          KERNEL_DEFCONFIG := msm8937_defconfig
        endif
    else ifneq ($(wildcard kernel/msm-4.9),)
        ifeq ($(TARGET_BUILD_VARIANT),user)
          KERNEL_DEFCONFIG := msm8937-perf_defconfig
        else
          KERNEL_DEFCONFIG := msm8937_defconfig
        endif
    endif
endif

ifeq ($(TARGET_KERNEL_SOURCE),)
     TARGET_KERNEL_SOURCE := kernel
endif

#----------------------------------------------------------------------
# Copy additional target-specific files
#----------------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE       := vold.fstab
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.target.rc
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.carrier.rc
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := fstab.qcom
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)
ifeq ($(ENABLE_AB), true)
  LOCAL_SRC_FILES    := fstab_AB_variant.qti
else
  LOCAL_SRC_FILES    := fstab_non_AB_variant.qti
endif
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := gpio-keys.kl
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := synaptics_rmi4_i2c.kl
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := synaptics_dsx.kl
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := ft5x06_ts.kl
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := qpnp_pon.kl
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
include $(CLEAR_VARS)
LOCAL_MODULE       := wpa_supplicant_overlay.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR)/etc/wifi
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := p2p_supplicant_overlay.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR)/etc/wifi
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := hostapd_default.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/hostapd
LOCAL_SRC_FILES    := hostapd.conf
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := hostapd.accept
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/hostapd
LOCAL_SRC_FILES    := hostapd.accept
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := hostapd.deny
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/hostapd
LOCAL_SRC_FILES    := hostapd.deny
include $(BUILD_PREBUILT)

#Create symbolic links
$(shell mkdir -p $(TARGET_OUT_VENDOR)/firmware/wlan/prima; \
        ln -sf /persist/WCNSS_qcom_wlan_nv.bin \
	$(TARGET_OUT_VENDOR)/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin; \
        ln -sf /persist/WCNSS_wlan_dictionary.dat \
	$(TARGET_OUT_VENDOR)/firmware/wlan/prima/WCNSS_wlan_dictionary.dat; \
        ln -sf /data/misc/wifi/WCNSS_qcom_cfg.ini \
	$(TARGET_OUT_VENDOR)/firmware/wlan/prima/WCNSS_qcom_cfg.ini)
endif

#Create dsp directory
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib/dsp)

#----------------------------------------------------------------------
# Radio image
#----------------------------------------------------------------------
ifeq ($(ADD_RADIO_FILES), true)
radio_dir := $(LOCAL_PATH)/radio
RADIO_FILES := $(shell cd $(radio_dir) ; ls)
$(foreach f, $(RADIO_FILES), \
	$(call add-radio-file,radio/$(f)))
endif

### end of AndroidBoard.mk ###

PRODUCT_NAME := msm8937_64
PRODUCT_DEVICE := msm8937_64
PRODUCT_BRAND := Android
PRODUCT_MODEL := msm8937 for arm64


ifneq ($(wildcard kernel/msm-3.18),)
    TARGET_KERNEL_VERSION := 3.18
    $(warning "Build with 3.18 kernel.")
else ifneq ($(wildcard kernel/msm-4.9),)
    TARGET_KERNEL_VERSION := 4.9
    $(warning "Build with 4.9 kernel")
else
    $(warning "Unknown kernel")
endif

# Display/Graphics
 PRODUCT_PACKAGES += \
     android.hardware.light@2.0-impl \
     android.hardware.light@2.0-service

# Powerhint configuration file
PRODUCT_COPY_FILES += \
     device/qcom/msm8937_64/powerhint.xml:system/etc/powerhint.xml

# Sensor HAL conf file
 PRODUCT_COPY_FILES += \
     device/qcom/msm8937_64/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

VERITY_ENABLED := true

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

PRODUCT_PACKAGES += \
    libandroid_net \
    libandroid_net_32

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/msm8937_64/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# heap configs
	PRODUCT_PROPERTY_OVERRIDES += \
           dalvik.vm.heapminfree=4m \
           dalvik.vm.heapstartsize=16m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

DEVICE_MANIFEST_FILE := device/qcom/msm8937_64/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8937/msm8937.mk

# media_profiles and media_codecs xmls for msm8937
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/msm8937_64/media/media_profiles_8937.xml:system/etc/media_profiles.xml \
                      device/qcom/msm8937_64/media/media_profiles_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
                      device/qcom/msm8937_64/media/media_profiles_8956.xml:system/etc/media_profiles_8956.xml \
                      device/qcom/msm8937_64/media/media_profiles_8956.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_8956.xml \
                      device/qcom/msm8937_64/media/media_codecs_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
                      device/qcom/msm8937_64/media/media_codecs_8956.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_8956.xml \
                      device/qcom/msm8937_64/media/media_codecs_performance_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
                      device/qcom/msm8937_64/media/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml
endif

BOARD_HAVE_QCOM_FM := true

TARGET_USES_NQ_NFC := true

ENABLE_AB ?= false

DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8937_64/overlay
# Default vendor configuration.
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE :=true
endif

#wlan driver
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8937_64/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/qcom/msm8937_64/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

# Enable logdumpd service only for non-perf bootimage
ifeq ($(findstring perf,$(KERNEL_DEFCONFIG)),)
    ifeq ($(TARGET_BUILD_VARIANT),user)
		ENABLE_LOGDUMPD := true
    endif
else
	ENABLE_LOGDUMPD := true
endif

