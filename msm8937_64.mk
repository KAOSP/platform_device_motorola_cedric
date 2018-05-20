ifeq ($(PRODUCT_NAME),)
include standalone.mk
endif

TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false

ifeq ($(TARGET_USES_AOSP),true)
TARGET_DISABLE_DASH := true
endif

# Disable QTIC until it's brought up in split system/vendor
# configuration to avoid compilation breakage.
ifeq ($(ENABLE_VENDOR_IMAGE), true)
#TARGET_USES_QTIC := false
endif

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

-include $(QCPATH)/common/config/qtic-config.mk

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

PRODUCT_COPY_FILES += device/qcom/msm8937_64/whitelistedapps.xml:system/etc/whitelistedapps.xml \
                      device/qcom/msm8937_64/gamedwhitelist.xml:system/etc/gamedwhitelist.xml

# video seccomp policy files ok
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.vidc.disable.split.mode=1

$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_BOOT_JARS += tcmiface

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
#PRODUCT_BOOT_JARS += com.qti.dpmframework
#PRODUCT_BOOT_JARS += dpmapi
#PRODUCT_BOOT_JARS += com.qti.location.sdk
#Android oem shutdown hook
PRODUCT_BOOT_JARS += oem-services
endif

ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
endif #BOARD_HAVE_QCOM_FM

# When can normal compile this module, need module owner enable below commands
# font rendering engine feature switch
#-include $(QCPATH)/common/config/rendering-engine.mk
#ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
#    MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
#endif

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

#Android EGL implementation ok
PRODUCT_PACKAGES += libGLES_android

# MIDI feature ok
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

#FEATURE_OPENGLES_EXTENSION_PACK support string config file ok
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

#ANT+ stack ok
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app

# Display/Graphics ok
 PRODUCT_PACKAGES += \
     android.hardware.graphics.allocator@2.0-impl \
     android.hardware.graphics.allocator@2.0-service \
     android.hardware.graphics.mapper@2.0-impl \
     android.hardware.graphics.composer@2.1-impl \
     android.hardware.graphics.composer@2.1-service \
     android.hardware.memtrack@1.0-impl \
     android.hardware.memtrack@1.0-service \
     android.hardware.configstore@1.0-service

PRODUCT_PACKAGES += wcnss_service

# FBE support ok
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# MSM IRQ Balancer configuration file ok
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

#for wlan ok
PRODUCT_PACKAGES += \
    wificond \
    wifilogd

# Feature definition files for msm8937 ok
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

PRODUCT_PACKAGES += telephony-ext
PRODUCT_BOOT_JARS += telephony-ext

# Defined the locales ok
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN

# When can normal compile this module, need module owner enable below commands
# Add the overlay path
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
#        $(QCPATH)/qrdplus/globalization/multi-language/res-overlay \
#        $(PRODUCT_PACKAGE_OVERLAYS)
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
        $(PRODUCT_PACKAGE_OVERLAYS)

#Healthd packages ok
PRODUCT_PACKAGES += android.hardware.health@1.0-impl \
                   android.hardware.health@1.0-convert \
                   android.hardware.health@1.0-service \
                   libhealthd.msm

#for android_filesystem_config.h ok
PRODUCT_PACKAGES += \
    fs_config_files

ifeq ($(VERITY_ENABLED),true)
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system
ifeq ($(ENABLE_VENDOR_IMAGE), true)
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/bootdevice/by-name/vendor
endif
endif

# Enable logdumpd omly when asked to ok
ifeq ($(ENABLE_LOGDUMPD),true)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= ro.logdumpd.enabled=0
endif

# Vibrator ok
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service

# Power ok
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

#Enable Lights Impl HAL Compilation ok 
PRODUCT_PACKAGES += android.hardware.light@2.0-impl

#Thermal ok
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

TARGET_SUPPORT_SOTER := true

#set KMGK_USE_QTI_SERVICE to true to enable QTI KEYMASTER and GATEKEEPER HIDLs
ifeq ($(ENABLE_VENDOR_IMAGE), true)
KMGK_USE_QTI_SERVICE := true
endif

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs ok
ifneq ($(KMGK_USE_QTI_SERVICE), true)
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service
endif

ifeq ($(ENABLE_VENDOR_IMAGE), true)
	PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/vendor/lib64/libril-qc-qmi-1.so 
else
	PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/system/vendor/lib64/libril-qc-qmi-1.so
endif

ifeq ($(TARGET_HAS_LOW_RAM), true)
PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=ssss
endif

ifeq ($(ENABLE_AB),true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
                   update_engine_client \
                   update_verifier \
                   bootctrl.msm8937 \
                   brillo_update_payload \
                   android.hardware.boot@1.0-impl \
                   android.hardware.boot@1.0-service
#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif
