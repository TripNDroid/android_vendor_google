LOCAL_PATH := .
include $(CLEAR_VARS)
include $(GAPPS_CLEAR_VARS)
LOCAL_MODULE := GoogleExtServices
LOCAL_PACKAGE_NAME := com.google.android.ext.services
LOCAL_PRIVILEGED_MODULE := true

GAPPS_LOCAL_OVERRIDES_MIN_VARIANT :=
GAPPS_LOCAL_OVERRIDES_PACKAGES := ExtServices

include $(BUILD_GAPPS_PREBUILT_APK)