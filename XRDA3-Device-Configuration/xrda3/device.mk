# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 Ankur, XRDA3 project
#
# If there are two PRODUCT_COPY_FILES rules for the same target file, the FIRST
# ONE WINS. In the section below, we want to override some files that are copied
# in emulator_vendor.mk so this MUST come before we inherit that file

PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/init.cutf_cvm.rc:vendor/etc/init/hw/init.cutf_cvm.rc

$(call inherit-product, device/google/cuttlefish/vsoc_x86_64/phone/aosp_cf.mk)

