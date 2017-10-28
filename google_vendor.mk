include vendor/google/core/definitions.mk
include vendor/google/config.mk
include vendor/google/gapps.mk

DEVICE_PACKAGE_OVERLAYS += \
    $(GAPPS_DEVICE_FILES_PATH)/overlay/pico

GAPPS_PRODUCT_PACKAGES += \
    GoogleBackupTransport \
    GoogleOneTimeInitializer \
    GooglePartnerSetup \
    PrebuiltGmsCore \
    GoogleServicesFramework \
    GoogleLoginService \
    Phonesky \
    GoogleCalendarSyncAdapter

ifneq ($(filter $(call get-allowed-api-levels),23),)
GAPPS_PRODUCT_PACKAGES += \
    GoogleTTS \
    GooglePackageInstaller
endif

ifneq ($(filter $(call get-allowed-api-levels),25),)
GAPPS_PRODUCT_PACKAGES += \
    Turbo
endif

ifneq ($(filter $(call get-allowed-api-levels),26),)
GAPPS_PRODUCT_PACKAGES += \
    AndroidPlatformServices
endif

ifneq ($(filter $(TARGET_GAPPS_VARIANT),nano),) # require at least nano
GAPPS_PRODUCT_PACKAGES += \
    FaceLock \
    Velvet

ifneq ($(filter $(TARGET_GAPPS_VARIANT),micro),) # require at least micro
GAPPS_PRODUCT_PACKAGES += \
    Maps \
    PrebuiltGmail \
    YouTube

ifeq ($(filter $(call get-allowed-api-levels),23),)
GAPPS_PRODUCT_PACKAGES += \
    GoogleTTS
endif

ifneq ($(filter $(TARGET_GAPPS_VARIANT),mini),) # require at least mini
GAPPS_PRODUCT_PACKAGES += \
    PlusOne \
    PrebuiltExchange3Google \
    Hangouts

ifneq ($(filter $(TARGET_GAPPS_VARIANT),full),) # require at least full

GAPPS_FORCE_BROWSER_OVERRIDES := true
GAPPS_PRODUCT_PACKAGES += \
    CloudPrint2 \
    EditorsDocs \
    Drive \
    Newsstand \
    PrebuiltNewsWeather \
    EditorsSheets \
    EditorsSlides \
    talkback

ifneq ($(filter $(TARGET_GAPPS_VARIANT),stock),) # require at least stock

GAPPS_FORCE_WEBVIEW_OVERRIDES := true
GAPPS_PRODUCT_PACKAGES += \
    GoogleCamera \
    GoogleVrCore

ifneq ($(filter $(call get-allowed-api-levels),24),)
GAPPS_PRODUCT_PACKAGES += \
    GooglePrintRecommendationService \
    GoogleExtServices \
    GoogleExtShared
endif

ifneq ($(filter $(TARGET_GAPPS_VARIANT),super),)

GAPPS_PRODUCT_PACKAGES += \
    Wallet \
    DMAgent \
    GoogleEarth \
    GCS \
    Street \
    TranslatePrebuilt

endif # end super
endif # end stock
endif # end full
endif # end mini
endif # end micro
endif # end nano

# This needs to be at the end of standard files, but before the GAPPS_FORCE_* options,
# since those also affect DEVICE_PACKAGE_OVERLAYS. We don't want to exclude a package
# that also has an overlay, since that will make us use the overlay but not have the
# package. This can cause issues.
PRODUCT_PACKAGES += $(filter-out $(GAPPS_EXCLUDED_PACKAGES),$(GAPPS_PRODUCT_PACKAGES))

ifeq ($(GAPPS_FORCE_WEBVIEW_OVERRIDES),true)
ifneq ($(filter-out $(call get-allowed-api-levels),24),)
DEVICE_PACKAGE_OVERLAYS += \
    $(GAPPS_DEVICE_FILES_PATH)/overlay/webview/21
else
DEVICE_PACKAGE_OVERLAYS += \
    $(GAPPS_DEVICE_FILES_PATH)/overlay/webview/24
endif
PRODUCT_PACKAGES += \
    WebViewGoogle
endif
