# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 Ankur, XRDA3 project

$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_NAME := xrda3car
PRODUCT_DEVICE := xrda3car
PRODUCT_BRAND := XRDA3_Cybernetics
PRODUCT_MODEL := XRDA3 Car

# Allow our custom simple HAL AIDL NDK library and service files in system image
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/lib64/vendor.xrda3.simple_hal_interface-ndk.so \
    system/bin/vendor.xrda3.simple-hal-service \
    system/etc/init/simple-hal-xrda3.rc

