LOCAL_PATH := $(call my-dir)

include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

#----------------------------------------------------------------------
# extra images
#----------------------------------------------------------------------
include device/qcom/common/generate_extra_images.mk
