# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 Ankur, XRDA3 project
#
# Add PRODUCT_COPY_FILES for xrda3car that override the default here ...

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.cutf_cvm.rc:vendor/etc/init/hw/init.cutf_cvm.rc

# xrda3car is based on aosp_cf_x86_64_only auto-userdebug
$(call inherit-product, device/google/cuttlefish/vsoc_x86_64_only/auto/aosp_cf.mk)

# Add all other customization for xrda3car here ...

# ---------------------------------------------------------
# Simple AIDL HAL + service + manager + apps + lights HAL
# ---------------------------------------------------------
PRODUCT_PACKAGES += \
    vendor.xrda3.simple_hal_interface-ndk \
    vendor.xrda3.simple-hal-service \
    com.example.simplemanager \
    simple-service \
    simple-manager-app \
    android.hardware.lights-service.xrda3

