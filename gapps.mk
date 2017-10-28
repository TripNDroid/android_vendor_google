# Base setup
PRODUCT_COPY_FILES += $(call gapps-copy-to-system,all,etc)
PRODUCT_COPY_FILES += $(call gapps-copy-to-system,all,framework)

# Vendor Google
ifneq ($(CALLED_FROM_SETUP),true)
BUILD_VENDORIMAGE := $(shell CALLED_FROM_SETUP=true BUILD_SYSTEM=build/core \
      command make --no-print-directory -f build/core/config.mk dumpvar-BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE)
endif

# Pico and higher
ifneq ($(filter $(TARGET_GAPPS_VARIANT),pico),)
# vendor/pittpatt seems to be removed on N+ (so only copy it to older than N)
ifeq ($(filter $(call get-allowed-api-levels),24),)
  PITTPATT_COPY_FILES := $(call gapps-copy-to-system,all,vendor/pittpatt)
# if we are building a vendor image, then we cannot copy to system/vendor, so update our copy statements.
ifdef BUILD_VENDORIMAGE
  PITTPATT_COPY_FILES := $(subst :system/vendor/pittpatt,:vendor/pittpatt,$(PITTPATT_COPY_FILES))
endif
  PRODUCT_COPY_FILES += $(PITTPATT_COPY_FILES)
endif
  PRODUCT_COPY_FILES += $(call gapps-copy-to-system,all,usr/srec)
endif