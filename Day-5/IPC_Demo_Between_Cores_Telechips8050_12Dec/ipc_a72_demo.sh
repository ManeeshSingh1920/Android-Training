#!/system/bin/sh

# ANSI color codes
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

DEV="/dev/tcc_ipc_ap"

echo -e "${YELLOW}[A72-SCRIPT] Preparing environment...${RESET}"

# Disable SELinux
if command -v setenforce >/dev/null 2>&1; then
    echo -e "${YELLOW}[A72-SCRIPT] Disabling SELinux...${RESET}"
    setenforce 0
fi

# Stop vehicle HAL
if command -v stop >/dev/null 2>&1; then
    echo -e "${YELLOW}[A72-SCRIPT] Stopping vehicle HAL...${RESET}"
    stop vendor.vehicle-hal-2.0
fi

echo -e "${YELLOW}[A72-SCRIPT] Starting IPC test...${RESET}"

# Function to clean up on exit
cleanup() {
    echo -e "${YELLOW}[A72-SCRIPT] Exiting... closing device.${RESET}"
    exec 3>&- 3<&-  # Close file descriptor
    kill "$READER_PID" 2>/dev/null
    exit 0
}

trap cleanup INT TERM

# Try to open device for read/write
exec 3<> "$DEV" || {
    echo -e "${RED}[A72-SCRIPT] ERROR: Cannot open $DEV (busy?)${RESET}"
    exit 1
}

echo -e "${GREEN}[A72-SCRIPT] Device opened: $DEV${RESET}"
echo -e "${YELLOW}[A72-SCRIPT] Type message to send to A53 (Ctrl+C to exit)${RESET}"

# Background reader
(
    while true; do
        if IFS= read -r line <&3; then
            echo -e "${GREEN}[A72-SCRIPT] Received from A53: $line${RESET}"
        else
            sleep 1
        fi
    done
) &

READER_PID=$!

# Main sending loop
while true; do
    printf "${YELLOW}[A72-SCRIPT] > ${RESET}"
    read user_input

    [ -z "$user_input" ] && continue

    # Quit command
    if [ "$user_input" = "quit" ]; then
        cleanup
    fi

    # Send to A53 (append newline)
    printf "%s\n" "$user_input" >&3
done
