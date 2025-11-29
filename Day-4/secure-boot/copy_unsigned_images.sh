#!/bin/bash
# Script to copy required unsigned images to unsigned_images folder and then sign them

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Print current working directory
echo -e "${CYAN}==========================================${NC}"
echo -e "${BLUE}Current working directory:${NC}"
pwd
echo -e "${CYAN}==========================================${NC}"

# Set the maincore root directory
MAINCORE_DIR="/home/oem/Documents/Telchip_8050/mydroid/maincore"
# Destination folder in current directory
DEST_DIR="./unsigned_images"

# Create destination folder if it doesn't exist
mkdir -p "$DEST_DIR"

echo -e "${CYAN}Copying required unsigned images to $DEST_DIR...${NC}"
echo -e "${CYAN}===================================================${NC}"

# Initialize counters
success_count=0
fail_count=0

# Define files relative to maincore directory
declare -A FILES_TO_COPY=(
    ["ca53_bl1.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/ufs/ca53_bl1.rom"
    ["ca53_bl2.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/ufs/ca53_bl2.rom"
    ["ca53_bl3.rom"]="bootable/bootloader/u-boot/ca53_bl3.rom"
    ["ca72_bl1.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/ufs/ca72_bl1.rom"
    ["ca72_bl2.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/ufs/ca72_bl2.rom"
    ["ca72_bl3.rom"]="bootable/bootloader/u-boot/ca72_bl3.rom"
    ["scfw.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/scfw.rom"
    ["optee.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/optee.rom"
    ["r5_bl1-snor.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/r5_bl1-snor.rom"
    ["r5_fw_TCC8050.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/r5_fw_TCC8050.rom"
    ["r5_sub_fw.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/r5_sub_fw.rom"
    ["dram_params.bin"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/dram_params.bin"
    ["fwdn.rom"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/fwdn.rom"
    ["hsm.cs.bin"]="bootable/bootloader/u-boot/boot-firmware/prebuilt/hsm.cs.bin"
    ["tc-boot-tcc8050-sub.img"]="out/target/product/car_tcc8050_arm64/tc-boot-tcc8050-sub.img"
    ["tc-boot-tcc8050-main.img"]="out/target/product/car_tcc8050_arm64/boot.img"
)

# Copy each file
for file in "${!FILES_TO_COPY[@]}"; do
    SRC="$MAINCORE_DIR/${FILES_TO_COPY[$file]}"
    if [ -f "$SRC" ]; then
        echo -e "${GREEN}Copying ${BOLD}$SRC${NC} -> $DEST_DIR/${NC}"
        cp -u "$SRC" "$DEST_DIR/"
        ((success_count++))
    else
        echo -e "${YELLOW}Warning: ${BOLD}$SRC${NC} not found! You can manually search for this image or it might have a different name."
        ((fail_count++))
    fi
done

echo -e "${CYAN}===================================================${NC}"
echo -e "${GREEN}Success: $success_count files copied.${NC}"
echo -e "${RED}Failed: $fail_count files not found.${NC}"

# ---------- Run the signing script ----------
echo -e "${CYAN}==========================================${NC}"
echo -e "${BLUE}Running signing script: sign_all_fw.sh${NC}"
echo -e "${CYAN}==========================================${NC}"

# sleep for 1 sec 
sleep 1

# Check if signing script exists
if [ -f "./sign_all_fw.sh" ]; then
    bash ./sign_all_fw.sh
else
    echo -e "${RED}Error: sign_all_fw.sh not found in current directory!${NC}"
fi

