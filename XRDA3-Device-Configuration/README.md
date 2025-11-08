# training_XRDA3

# XRDA3 Device Files

Device configuration files for XRDA3 phone and XRDA3 car.

This repository contains the local manifest and device-specific configuration files required to build Android 14 for XRDA3 devices.

## Usage

1. Initialize the AOSP repository:

```bash
mkdir aosp
cd aosp
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r21
repo sync -c

    Add the XRDA3 local manifest:

cd $HOME/aosp
git clone https://github.com/BuildandShip-stack/xrda3-local-manifest.git .repo/local_manifests -b android14
repo sync -c

    Build the desired device:

cd $HOME/aosp
source build/envsetup.sh
lunch xrda3-userdebug      # for XRDA3 phone
lunch xrda3car-userdebug   # for XRDA3 car
m


