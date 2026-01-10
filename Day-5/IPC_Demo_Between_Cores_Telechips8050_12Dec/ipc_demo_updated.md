======================================================================================================================================================================================================

# IPC Demo Setup and Modification Guide.

======================================================================================================================================================================================================


										1-  file structure



This guide explains how to set up and modify the IPC demo in the **Maincore_A72_IPC** project.

## Prerequisites

IPC_Demo_Between_Cores_Telechips8050_12Dec/
│ └── ipc_demo_updated.md # This README file
│ └── ipc_a72_demo.sh  # Script for Maincore IPC 
  └── a53_ipc.sh       # Script for Subcore IPC





======================================================================================================================================================================================================


										2- Using script Maincore
										

We have the script in "Maincore_A72_IPC" Directory we have a script inside this folder "ipc_a72_demo.sh"
Note- if adb not working in UFS or SNOR+USF mode then access the maincore terminal (ttyUSB0 from left side, first port )and run the 
below command to enable the adb and whiloe accesing the adb shell loginnas sudo mode using below command 
# su
# setprop sys.usb.config adb

push this file using adb 

# adb push ipc_a72_demo.sh /data/local/tmp/

make it executable and run the script.

# adb shell chmod a+x /data/local/tmp/ipc_a72_demo.sh

# lshal 

# ps -A | grep vehicle                                                                                                                                                 
vehicle_network 275    1  133360   5984 binder_ioctl_write_read 0 S android.hardware.automotive.vehicle@2.0-service

# lshal | grep vehicle                                                                                                                                                  
DM,FC N android.hardware.automotive.vehicle@2.0::IVehicle/default                     0/3        275    632 183


# ./ipc_a72_demo.sh

car_tcc8050_arm64:/data/local/tmp # ./ipc_a72_demo.sh
[A72-SCRIPT] Preparing environment...
[A72-SCRIPT] Disabling SELinux...
[A72-SCRIPT] Stopping vehicle HAL...
[A72-SCRIPT] Starting IPC test...
[A72-SCRIPT] Device opened: /dev/tcc_ipc_ap
[A72-SCRIPT] Type message to send to A53 (Ctrl+C to exit)
[A72-SCRIPT] > 

after ruunning the script if you wanted to cross verify wheater the vehicle services running or not press ctrl+c to kill the script using below command.
130|car_tcc8050_arm64:/data/local/tmp # lshal | grep vehicle
1|car_tcc8050_arm64:/data/local/tmp # ps -A | grep vehicle 

Note- some time vehicle hal service not stoped using the script ,because of this our demo will not work hence we need to manually stop the services using below command
# stop vendor.vehicle-hal-2.0


# adb shell
# car_tcc8050_arm64:/ $ su
# car_tcc8050_arm64:/ # lshal | grep vehicle
DM,FC N android.hardware.automotive.vehicle@2.0::IVehicle/default                     0/2        277    637 183
# car_tcc8050_arm64:/ # stop vendor.vehicle-hal-2.0
# car_tcc8050_arm64:/ # lshal | grep vehicle                                                          





======================================================================================================================================================================================================



										3.for Subcore Ipc Script
										
										
										
										
										
#A53 IPC Chat Script – Setup & Usage Documentation

1-access the subcore linux terminal
acces ttyUSB0 on port 2 from left side.

2-vi command to create a script 
creat the file inside the /tmp folder 
# cd /
# root@telechips-tcc8050-sub:/# ls
bin         etc         lost+found  opt         sbin        usr
boot        home        media       proc        sys         var
dev         lib         mnt         run         tmp
# root@telechips-tcc8050-sub:/# cd tmp/
# root@telechips-tcc8050-sub:/tmp# ls


# vi a53_ipc.sh

3-copy and paste the below content inside vi terminal 
OR 
copy the content using cat commands as shown in the last of this doc...


===================================================================================================

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

===================================================================================================

4-Make the Script Executable
#chmod a+x a53_ipc.sh

5-Important: Resolve “Device or resource busy” Error
If you run the script and see:
/dev/tcc_ipc_ap: Device or resource busy
[A53] Failed to open /dev/tcc_ipc_ap


This means another process is already using /dev/tcc_ipc_ap.

To find it:
#ps -ef | grep ipc

In our This process is holding the device, so kill it: 

root       274     1  0 00:00 ?        00:00:02 /usr/bin/TCMicomManager -d 1 -D /dev/tcc_ipc_micom -A /dev/tcc_ipc_ap


kill the process 
# kill 274

6-Run the Demo
If everything is correct, you will see:
# ./a53_ipc.sh
after running this script you will get the below logs 
[A53] IPC Chat Demo Start
[A53] Open Success: /dev/tcc_ipc_ap
[A53] Waiting for IPC ready...
[A53] IPC is READY
[A53] Waiting for messages...
[A53] No data (EOF), waiting...





#The script is now fully active and waiting for messages from the A72 core.


===================================================================================================
# copy daata using cat command 


cat <<'EOF' > a53_ipc.sh
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
EOF



										
									 
