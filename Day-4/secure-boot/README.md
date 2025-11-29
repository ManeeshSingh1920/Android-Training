oem@xrda3:~/Documents/Telchip_8050/mydroid/maincore/security_tools_v1.27/security_tools/module/SecureBoot$ ls
avb_root_pub_array.txt   rsa4096_prikey.pem  sign_all_fw.sh  tcSignTool_v3
avb_root_pub.bin         securebootcfg.sh    signed_output   unsigned_images
copy_unsigned_images.sh  securebootota.sh    tcSignTool



# TCC8050 Secure Boot Image Signing
unzip security_tools_v1.27.tar.xz inside the Maincore and change the dir as below ->

oem@xrda3:~/Documents/Telchip_8050/mydroid/maincore/security_tools_v1.27/security_tools/module/SecureBoot$ ls
avb_root_pub_array.txt   rsa4096_prikey.pem  sign_all_fw.sh  tcSignTool_v3
avb_root_pub.bin         securebootcfg.sh    signed_output   unsigned_images
copy_unsigned_images.sh  securebootota.sh    tcSignTool

This document provides instructions to generate secure boot keys and sign TCC8050 firmware, boot, and kernel images using the `tcSignTool_v3` tool.

---

## Directory Structure

SecureBoot/
├─ unsigned_images/ # Folder for unsigned firmware/kernel images
├─ signed_output/ # Folder for signed images (output)
├─ tcSignTool_v3 # Secure boot signing tool
├─ copy_unsigned_images.sh # Script to prepare unsigned images
├─ sign_all_fw.sh # Script to sign all images
├─ securebootcfg.sh # Optional configuration script
├─ securebootota.sh # Optional OTA signing script
├─ avb_root_pub_array.txt # AVB root public key array
├─ avb_root_pub.bin # AVB root public key binary
├─ rsa4096_prikey.pem # RSA private key for signing


---

## Prerequisites

- Linux environment with `bash`.
- Executable permission on `tcSignTool_v3`.
- Write permission in the home directory (`~/`) for keys: `root.key`, `master.key`, `image.key`.

---

## Step 1: Prepare Unsigned Images and make it signed

Before signing, copy all required unsigned images into the `unsigned_images/` folder using the provided script:

```bash
./copy_unsigned_images.sh


This script will:

Copy all necessary images into unsigned_images/.

Generate Secure Boot keys (root.key, master.key, image.key) if missing.

Prepare the environment for signing.

after copy all the files it will generate the signed images folder also  "signed_output" as shown above in SecureBoot folder.
Note: Run this script from inside SecureBoot/.
