LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED

CURRENT_PATH := $(GAPPS_DEVICE_FILES_PATH)/modules/$(LOCAL_MODULE)

# Override packages from GAPPS_LOCAL_OVERRIDES_PACKAGES only when required.
# If a package should NOT in any case be installed, add it directly to LOCAL_OVERRIDES_PACKAGES instead.
ifneq ($(GAPPS_LOCAL_OVERRIDES_PACKAGES),)
  ifeq ($(filter $(GAPPS_BYPASS_PACKAGE_OVERRIDES),$(LOCAL_MODULE)),)
    ifeq ($(GAPPS_FORCE_PACKAGE_OVERRIDES),true)
      LOCAL_OVERRIDES_PACKAGES += $(GAPPS_LOCAL_OVERRIDES_PACKAGES)
    else ifeq ($(GAPPS_LOCAL_OVERRIDES_MIN_VARIANT),)
      LOCAL_OVERRIDES_PACKAGES += $(GAPPS_LOCAL_OVERRIDES_PACKAGES)
    else ifneq ($(filter $(TARGET_GAPPS_VARIANT),$(GAPPS_LOCAL_OVERRIDES_MIN_VARIANT)),)
      LOCAL_OVERRIDES_PACKAGES += $(GAPPS_LOCAL_OVERRIDES_PACKAGES)
    else ifneq ($(filter $(GAPPS_PACKAGE_OVERRIDES),$(LOCAL_MODULE)),)
      LOCAL_OVERRIDES_PACKAGES += $(GAPPS_LOCAL_OVERRIDES_PACKAGES)
    endif
  endif
endif

LOCAL_SRC_FILES := $(call find-apk-for-pkg,all,$(LOCAL_PACKAGE_NAME))

ifdef LOCAL_SRC_FILES
  LOCAL_PREBUILT_JNI_LIBS := $(call find-libs-in-apk,$(TARGET_ARCH),$(LOCAL_SRC_FILES))
else
  LOCAL_SRC_FILES := $(call find-apk-for-pkg,$(TARGET_ARCH),$(LOCAL_PACKAGE_NAME))
  ifdef LOCAL_SRC_FILES
    ifeq ($(filter $(call get-allowed-api-levels), 21),)
      # only kitkat
      ifneq ($(call find-libs-in-apk,$(TARGET_ARCH),$(LOCAL_SRC_FILES)),)
        LOCAL_SHARED_LIBRARIES := $(notdir $(basename $(shell zipinfo -1 "$(LOCAL_SRC_FILES)" "$(call get-lib-search-path, $(TARGET_ARCH))" -x lib/*/crazy/* 2>/dev/null)))
      endif
    else
      LOCAL_PREBUILT_JNI_LIBS_$(TARGET_ARCH) := $(call find-libs-in-apk,$(TARGET_ARCH),$(LOCAL_SRC_FILES))
    endif
  else
    ifdef TARGET_2ND_ARCH
      LOCAL_SRC_FILES := $(call find-apk-for-pkg,$(TARGET_2ND_ARCH),$(LOCAL_PACKAGE_NAME))
      ifdef LOCAL_SRC_FILES
        LOCAL_PREBUILT_JNI_LIBS_$(TARGET_2ND_ARCH) := $(call find-libs-in-apk,$(TARGET_2ND_ARCH),$(LOCAL_SRC_FILES))
      endif
    endif
  endif
endif

include $(BUILD_PREBUILT)

