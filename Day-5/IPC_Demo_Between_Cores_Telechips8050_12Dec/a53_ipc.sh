#!/bin/sh

# Colors 
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

DEV="/dev/tcc_ipc_ap"

echo -e "${CYAN}[A53] IPC Chat Demo Start${RESET}"

# Open A53 device as fd 3
exec 3<> "$DEV" || {
    echo -e "${RED}[A53] Open failed: $DEV${RESET}"
    exit 1
}

echo -e "${GREEN}[A53] Open Success: $DEV${RESET}"


# To match log format like A72 we print similar messages
echo -e "${YELLOW}[A53] Waiting for IPC ready...${RESET}"
sleep 1
echo -e "${GREEN}[A53] IPC is READY${RESET}"

echo -e "${CYAN}[A53] Waiting for messages...${RESET}"

EOF_SHOWN=0

while true; do
    # Read message from A72
    if IFS= read -r line <&3; then
        echo -e "${GREEN}[A53] Received from A72: $line${RESET}"

        # Reply to A72
        printf "hello from A53\n" >&3
        echo -e "${CYAN}[A53] Sent reply: hello from A53${RESET}"

        EOF_SHOWN=0

    else
        if [ $EOF_SHOWN -eq 0 ]; then
            echo -e "${YELLOW}[A53] No data (EOF), waiting...${RESET}"
            EOF_SHOWN=1
        fi
        sleep 1
    fi
done

