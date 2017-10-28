# Gapps build system
GAPPS_BUILD_SYSTEM_PATH := vendor/google/core
GAPPS_SOURCES_PATH := vendor/google/sources
GAPPS_DEVICE_FILES_PATH := vendor/google
GAPPS_CLEAR_VARS := $(GAPPS_BUILD_SYSTEM_PATH)/clear_vars.mk

BUILD_GAPPS_PREBUILT_APK := $(GAPPS_BUILD_SYSTEM_PATH)/prebuilt_apk.mk
BUILD_GAPPS_PREBUILT_SHARED_LIBRARY := $(GAPPS_BUILD_SYSTEM_PATH)/prebuilt_shared_library.mk

# check that we reside under the expected path, otherwise the
# variables defined above are invalid
ifeq ($(wildcard $(GAPPS_DEVICE_FILES_PATH)/config.mk),)
  $(error Please update your manifest to use the path "$(GAPPS_DEVICE_FILES_PATH)" for the "aosp_build" project)
endif

ifeq ($(GAPPS_VARIANT),)
  $(error GAPPS_VARIANT must be configured)
endif

# Device should define their GAPPS_VARIANT in device/manufacturer/product/BoardConfig.mk
GAPPS_VARIANT_EVAL := $(call get-gapps-variant,$(GAPPS_VARIANT))

ifeq ($(GAPPS_VARIANT_EVAL),)
  $(error GAPPS_VARIANT $(GAPPS_VARIANT) was not found. Use of one of pico,nano,micro,mini,full,stock,super)
endif

TARGET_GAPPS_VARIANT := $(GAPPS_VARIANT_EVAL)

ifeq ($(GAPPS_FORCE_MATCHING_DPI),)
  GAPPS_FORCE_MATCHING_DPI := false
endif

ifeq ($(GAPPS_FORCE_MATCHING_DPI),false)
  GAPPS_AAPT_PATH := $(shell find prebuilts/sdk/tools/$(HOST_OS) -executable -name aapt | head -n 1)
  # Check if aapt is present in prebuilts or if it is installed.
  ifeq ($(wildcard $(GAPPS_AAPT_PATH)),)
    GAPPS_TEST_AAPT := $(shell command -v aapt)
    ifeq ($(GAPPS_TEST_AAPT),)
      $(error aapt is not available. Please install it first ("sudo apt-get install aapt") or define GAPPS_FORCE_MATCHING_DPI := true)
    else
      GAPPS_AAPT_PATH := aapt
    endif
  endif
endif

