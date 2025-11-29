#!/bin/bash
# Script to generate keys and sign TCC8050 images (MCERT, HSM, boot firmware, kernels)
# Input files are expected in 'unsigned_images/'
# Signed outputs are stored in 'signed_output/'

# ---------- Color definitions ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ---------- Tool and keys ----------
SEC_TOOL=./tcSignTool_v3
KEY_ROOT=~/root.key
KEY_MASTER=~/master.key
KEY_IMAGE=~/image.key
INPUT_DIR=./unsigned_images
OUTPUT_DIR=./signed_output

# ---------- Encryption and RBID settings ----------
HSM_ENCRYPTION=0     # 0 = not encrypted, 1 = encrypted
HSM_RBID=0           # RBID for HSM
BOOT_ENCRYPTION=0    # 0 = not encrypted, 1 = encrypted
BOOT_RBID=0          # RBID for boot/firmware images

# ---------- Step 0: Print working directory ----------
echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}Script running from: $(pwd)${NC}"
echo -e "${CYAN}Unsigned images folder: $INPUT_DIR${NC}"
echo -e "${CYAN}Signed images will be saved to: $OUTPUT_DIR${NC}"
echo -e "${CYAN}=========================================${NC}"

# ---------- Step 1: Generate Secure Boot Keys ----------
echo -e "${CYAN}Step 1: Generating Secure Boot keys (if missing)...${NC}"

[ ! -f "$KEY_ROOT" ] && echo -e "${GREEN}Generating root key -> $KEY_ROOT${NC}" && $SEC_TOOL genkey ecdsa "$KEY_ROOT" 2
[ ! -f "$KEY_MASTER" ] && echo -e "${GREEN}Generating master key -> $KEY_MASTER${NC}" && $SEC_TOOL genkey ecdsa "$KEY_MASTER" 1
[ ! -f "$KEY_IMAGE" ] && echo -e "${GREEN}Generating image key -> $KEY_IMAGE${NC}" && $SEC_TOOL genkey ecdsa "$KEY_IMAGE" 1

echo -e "${CYAN}Secure Boot keys ready.${NC}"

# ---------- Step 2: Prepare output folder ----------
mkdir -p "$OUTPUT_DIR"

# ---------- Step 3: Generate MCERT ----------
echo -e "${CYAN}Step 2: Generating MCERT image...${NC}"
MCERT_OUT="$OUTPUT_DIR/mcert.bin.signed"
echo -e "Output file: $MCERT_OUT"
$SEC_TOOL mcert "$MCERT_OUT" "$KEY_ROOT" "$KEY_MASTER"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}MCERT successfully generated -> $MCERT_OUT${NC}"
else
    echo -e "${RED}Failed to generate MCERT${NC}"
fi
echo -e "${CYAN}-----------------------------------------${NC}"

# ---------- Step 4: Sign HSM firmware ----------
HSM_FILE=hsm.cs.bin
echo -e "${CYAN}Step 3: Signing HSM firmware...${NC}"
if [ -f "$INPUT_DIR/$HSM_FILE" ]; then
    HSM_OUT="$OUTPUT_DIR/$HSM_FILE.signed"
    echo -e "Input : $INPUT_DIR/$HSM_FILE"
    echo -e "Output: $HSM_OUT"
    $SEC_TOOL hsmfw "$INPUT_DIR/$HSM_FILE" "$HSM_OUT" "$KEY_ROOT" "$HSM_ENCRYPTION" "$HSM_RBID"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}HSM firmware signed -> $HSM_OUT${NC}"
    else
        echo -e "${RED}Error signing HSM firmware${NC}"
    fi
else
    echo -e "${YELLOW}Warning: $INPUT_DIR/$HSM_FILE not found. You can manually search for this image or it might have a different name.${NC}"
fi
echo -e "${CYAN}-----------------------------------------${NC}"

# ---------- Step 5: Sign Boot/Kernels/Firmware ----------
echo -e "${CYAN}Step 4: Signing Boot/Kernels/Firmware images...${NC}"

FILES=(
    ca53_bl1.rom
    ca53_bl2.rom
    ca53_bl3.rom
    ca72_bl1.rom
    ca72_bl2.rom
    ca72_bl3.rom
    scfw.rom
    optee.rom
    r5_bl1-snor.rom
    r5_fw_TCC8050.rom
    r5_sub_fw.rom
    dram_params.bin
    fwdn.rom
    boot.img    # CA72 Kernel
    tc-boot-tcc8050-sub.img     # CA53 Kernel
)

success_count=0
fail_count=0

for file in "${FILES[@]}"; do
    INPUT_PATH="$INPUT_DIR/$file"
    OUTPUT_PATH="$OUTPUT_DIR/$file.signed"
    echo -e "${CYAN}Processing: $file${NC}"

    if [ -f "$INPUT_PATH" ]; then
        echo -e "Input : $INPUT_PATH"
        echo -e "Output: $OUTPUT_PATH"
        $SEC_TOOL secfw "$INPUT_PATH" "$OUTPUT_PATH" "$KEY_MASTER" "$KEY_IMAGE" "$BOOT_ENCRYPTION" "$BOOT_RBID"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Successfully signed $file -> $OUTPUT_PATH${NC}"
            ((success_count++))
        else
            echo -e "${RED}Error signing $file${NC}"
            ((fail_count++))
        fi
    else
        echo -e "${YELLOW}Warning: $INPUT_PATH not found. You can manually search for this image or it might have a different name.${NC}"
        ((fail_count++))
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
done

# ---------- Step 6: Summary ----------
echo -e "${CYAN}=========================================${NC}"
echo -e "${GREEN}Total files successfully signed: $success_count${NC}"
echo -e "${RED}Total files failed or missing: $fail_count${NC}"
echo -e "${CYAN}Check signed images in $OUTPUT_DIR/${NC}"
echo -e "${CYAN}=========================================${NC}"

