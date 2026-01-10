# TCC8050_Android_10_HIDL


======================================
	Required Files 

android.hardware.echo@1.0.so
android.hardware.echo@1.0-service
HidlTestApp.apk

======================================

These are the requied files for the HIDL Demo test Application.

1- Push the android.hardware.echo@1.0.so in below location

# adb push android.hardware.echo@1.0.so /data/local/tmp/

2- Push the service file in below location 

# adb push android.hardware.echo@1.0-service /data/local/tmp/


3-after pushing above two binary files install the HidlTestApp apk 

# adb install -r HidlTestApp.apk 


4- change the permisson of the files which we have pushed before 
# adb shell
# su
# cd /data/local/tmp/
# chmod 644 android.hardware.echo@1.0.so
# chmod 755 android.hardware.echo@1.0-service

and set the path

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/local/tmp

5-Before running and doing any thing first set the selinux in permissive mode to check the current selinux mode run the below command.

# getenforce                                                         
  Enforcing

if it will show the  Enforcing the make it permissive mode 

# setenforce 0                                                   
# getenforce
  Permissive

Now it is in permissive mode. 

6- Now Check Our HIDL Demo 

a) In app drawer if you find the "HIDL Echo Tester" launch this application if not use the below command to launch the Application.
# am start -S -n com.telechips.hidltest/.MainActivity

b) Run the service in background using below command 
Go to the service directory first 
# cd /data/local/tmp
# ./android.hardware.echo@1.0-service & 


Now our demo is ready to use.

Note- You will see in the the application side it will change the String from "checking service status" to "HIDL Echo Service CONNECTED" if connected status not shows then first check the selinux mode it should be permissive mode.




