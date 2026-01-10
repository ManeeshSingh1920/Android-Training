# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 Ankur, XRDA3 project

$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Define the host tools and libs that are parts of the SDK.
-include sdk/build/product_sdk.mk
-include development/build/product_sdk.mk

PRODUCT_NAME := xrda3
PRODUCT_DEVICE := xrda3
PRODUCT_BRAND := XRDA3_Cybernetics
PRODUCT_MODEL := XRDA3 Phone

