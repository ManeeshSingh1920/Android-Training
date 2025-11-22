# Android_14_Demos 

Open this README file in VS Code; otherwise, it will look messy in the text editor. 


==================================================================================================================================================================
																		Demo 1

																The Android Framework



																Part 1-Create a binder interface


					
1. Note ->If you do not have the vendor folder inside aosp folder then create a vendor folder and inside vendor folder create a xrda3 folder in which we put all our demos

 
2. Inside the Demos folder we have the  "simple-manager" folder copy and paste inside the vendor/xrda3 folder and build it:

3. 
# mmm vendor/xrda3/simple-manager

after the build Check that the permissions file is installed in:

[100% 2242/2242] Install: out/target/product/xrda3car/system_ext/framework/com.example.simplemanager.jar

#### build completed successfully (02:04 (mm:ss)) ####


4. 
Note ->Check that the extension library is installed in:
$OUT/system_ext/framework/com.example.simplemanager.jar


Check that the permissions file is installed in:
$OUT/system_ext/etc/permissions/com.example.simplemanager.xml



															Part 2-Implement the service




5. Inside the Demos folder we have the  "simple-service" folder	copy and paste inside the vendor/xrda3 folder and build it

6. 
# mmm vendor/xrda3/simple-service

build log =>

[100% 210/210] Install: out/target/product/xrda3car/system_ext/app/simple-service/simple-service.apk

#### build completed successfully (01:56 (mm:ss)) ####

xrda3@xrda3:~/aosp_14_training$



7. 
after the build check for the Check that the simple-service app is installed in:
$OUT/system_ext/app/simple-service/simple-service.apk




8. 
Final Step =>


Add both the manager and service to your device configuration: look at the Android.bp
files for simple-manager and simple-service. Add these packages to to your device.mk file like below.


device/xrda3/xrda3car/device.mk 

open and add the below content:

(To include simple service and manager in the target images, add this to your device.mk)

	PRODUCT_PACKAGES += \
						simple-service \
						com.example.simplemanager


9. 
after adding the above Build Android:
# m -j24


																Part 3-Testing
																
Note=> We need the device to be running with SELinux in permissive mode in order to start
simpleservice.											

10. 																
# launch_cvd -start_webrtc -guest_enforce_security=false	

11. 
In an ADB shell, check the SELinux mode:

# getenforce    // it will show Permissive
Permissive

12. 			
After booting, you can see that the Simple service app is running, with UID system:
				
# ps -A | grep simple
system        2702   370   13899172  91560 do_epoll_wait       0 S com.example.simpleservice

				
13. 				
Now list the services and check that verify that "simpleservice" is registered:

# service list | grep simple                                                                                                                                                           
251	simpleservice: [com.example.simplemanager.ISimpleManager]
xrda3car:/ # 


14. 
# logcat -s SimpleService
--------- beginning of main
11-14 12:02:37.517  2702  2702 D SimpleService: Registered service



	You can call the two interfaces using service call. Interface 1 adds two 32-bit integers:

15. 
# service call simpleservice 1 i32 3 i32 6
Result: Parcel(	00000000 00000009   '........')
xrda3car:/ # logcat -s SimpleService                                                                                                                                                                      
--------- beginning of main
11-14 12:02:37.517  2702  2702 D SimpleService: Registered service
11-14 12:09:52.666  2702  2736 D SimpleService: addInts


16. 
And above result, the answer is 9. Note that although the command-line integers are in decimal, the contents
of the returned parcel are in hex, so adding 64 and 128 looks like this:

# service call simpleservice 1 i32 64 i32 128
Result: Parcel(	00000000 000000c0   '........')
xrda3car:/ # logcat -s SimpleService                                                                                                                                                                      
--------- beginning of main
11-14 12:02:37.517  2702  2702 D SimpleService: Registered service
11-14 12:09:52.666  2702  2736 D SimpleService: addInts
11-14 12:13:20.094  2702  2736 D SimpleService: addInts


 i. because in hex, 0x40 + 0x80 = 0xc0

	Likewise, you can test that the second interface echos a string

17. 	
# service call simpleservice 2 s16 "Hello world"
Result: Parcel(	
0x00000000: 00000000 0000000b 00650048 006c006c '........H.e.l.l.'
0x00000010: 0020006f 006f0077 006c0072 00000064 'o. .w.o.r.l.d...')
xrda3car:/ # logcat -s SimpleService                                                                                                                                                                      
--------- beginning of main
11-14 12:02:37.517  2702  2702 D SimpleService: Registered service
11-14 12:09:52.666  2702  2736 D SimpleService: addInts
11-14 12:13:20.094  2702  2736 D SimpleService: addInts
11-14 12:15:42.680  2702  2736 D SimpleService: echoString

	Note=> that the 8-bit ASCII string is converted to 16-bit Unicode




														Part 4-Policy for simpleservice

18. 
To make simpleservice work with SELinux in enforcing mode you need extra sepolicy.

Copy these two directories:
					
					1- sepolicy
					2- sepolicy-private
And paste inside the:
	
					device/xrda3/xrda3car
# ls -l 
-rw-rw-r-- 1 xrda3 xrda3  185 Nov  5 16:49 AndroidProducts.mk
-rw-rw-r-- 1 xrda3 xrda3  288 Nov 19 13:14 BoardConfig.mk
-rw-rw-r-- 1 xrda3 xrda3  620 Nov 18 16:31 device.mk
-rw-rw-r-- 1 xrda3 xrda3   49 Nov  5 16:49 init.cutf_cvm.rc
drwxrwxr-x 2 xrda3 xrda3 4096 Nov 10 18:19 sepolicy                   //	sepolicy for simpleservice
drwxrwxr-x 2 xrda3 xrda3 4096 Nov 10 18:19 sepolicy-private			 //		sepolicy for simpleservice
-rw-rw-r-- 1 xrda3 xrda3  246 Nov  5 16:49 xrda3car.mk
-rw-rw-r-- 1 xrda3 xrda3  977 Nov 14 12:15 xrda3car.patch

#

19. 
open BoardConfig.mk file and add below line:
# gedit device/xrda3/xrda3car/BoardConfig.mk

	SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/xrda3/xrda3car/sepolicy-private
	SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/xrda3/xrda3car/sepolicy


20. 
Now build and test. You should find that simpleservice runs even when in enforcing mode
#getenforce                                                                                                                                                                                  
Enforcing
	
Notice that simpleservice is running in the domain simpleservice_app:

 # ps -AZ | grep simpleservice
u:r:simpleservice_app:s0       system        2756   369   13786160  91856 do_epoll_wait       0 S com.example.simpleservice


==================================================================================================================================================================

																		Demo 2


															Android applications and activities

NOTE - We will Create an application that will call the simple-manager platform library


	1-Applications started at boot time

21. 
Find persistent applications:

# adb shell dumpsys package packages > packages.txt


Looking through the file(packages.txt) for applications with the PERSISTENT flag, you should find these

 ___________________________________________________________________________________
| Package/Component                  | Description                                  |
| ---------------------------------- | -------------------------------------------- |
| com.android.networkstack           | Network stack                                |
| android                            | The framework (not an app)                   |
| com.android.car                    | Car service (automotive only)                |
| com.android.ons                    | Opportunistic Network Service                |
| com.android.se                     | Secure element                               |
| com.android.cellbroadcastservice   | Receives network wide broadcasts             |
| com.android.service.ims            | IP multimedia and voice service              |
| com.android.networkstack.tethering | Tethering                                    |
| com.android.phone                  | The phone app                                |
| com.android.systemui               | System UI - notification and navigation bars |
| com.example.simpleservice	      | Your simple system service					|
-------------------------------------------------------------------------------------


22. 
	2- Create and Build the sample application



Inside the Demos folder we have the  "simple-manager-app" folder
copy and paste inside the vendor/xrda3 folder and build it:


23. 
Then, edit [ device/xrda3/xrda3car/device.mk ] and add this.
		 
		 PRODUCT_PACKAGES += simple-manager-app


24. 
Then build xrda3

# m -j24


25. 
After the build apk file is installed into the target filesystem /system_ext/app:

# ls out/target/product/xrda3car/system_ext/app/simple-manager-app
oat  simple-manager-app.apk



26. 
	Note that the application is installed in "/system_ext/app/simple-manager-app/simple-manager-app.apk" and is available in the
	application drawer of the launcher
	if not found simply run the below command and it will launch the application (simple-manager-app.apk)
# am start -S -n com.example.simplemanagerapp/.SimpleManagerActivity


27. 
after testing you can stop/close the application using GUI or  using below command also

# am force-stop com.example.simplemanagerapp








==================================================================================================================================================================

																	  Demo -3
																	  
																	AIDL for HAL

NOTE -  We will implement a lights HAL using a stable AIDL interface


28. 
Inside the Demos folder we have the  "light-hal-aidl" folder
copy and paste inside the vendor/xrda3 folder and build it:



29. 
Then, edit [ device/xrda3/xrda3car/device.mk ] and add this.

PRODUCT_PACKAGES += android.hardware.lights-service.xrda3

🔧 SELinux file_contexts Update for Light HAL Service


=======================================================================================
create  file_contexts file in below location and add the content if already present no need to do anything
Add sepolicy to device/xrda3/xrda3car/sepolicy/file_contexts

/vendor/bin/hw/android.hardware.lights-service.xrda3    u:object_r:hal_light_default_exec:s0
============================================================================================


30. 
Build the HAL

xrda3@xrda3:~/aosp_14_training$ mmm vendor/xrda3/light-hal-aidl
============================================
PLATFORM_VERSION_CODENAME=REL
PLATFORM_VERSION=14
PRODUCT_INCLUDE_TAGS=com.android.mainline
TARGET_PRODUCT=xrda3car
TARGET_BUILD_VARIANT=userdebug
TARGET_ARCH=x86_64
TARGET_ARCH_VARIANT=silvermont
HOST_OS=linux
HOST_OS_EXTRA=Linux-5.15.0-139-generic-x86_64-Ubuntu-20.04.6-LTS
HOST_CROSS_OS=windows
BUILD_ID=UQ1A.240105.004.A1
OUT_DIR=out
============================================
[100% 9/9] Install: out/target/product/xrda3car/vendor/bin/hw/android.hardware.lights-service.xrda3

#### build completed successfully (3 seconds) ####
 


31. 
 
# ls -l $OUT/vendor/bin/hw/android.hardware.lights-service.xrda3 
 -rwxrwxr-x 1 xrda3 xrda3 15336 Nov 14 19:53 /home/xrda3/aosp_14_training/out/target/product/xrda3car/vendor/bin/hw/android.hardware.lights-service.xrda3
 
 
	Run the cuttlefish and Check that the lights HAL is running:


32. 
# ps -A | grep lights
nobody         412     1   11006296   5464 binder_ioctl_write_read 0 S android.hardware.lights-service.xrda3

	Below The lights HAL is listed as a service:

33. 
# service list | grep Lights
56	android.hardware.light.ILights/default: [android.hardware.light.ILights]
173	lights: [android.hardware.lights.ILightsManager]


	logcat messages:
	
 # logcat -d | grep android.hardware.lights-service.example
                                                                                                                                      
11-21 07:52:52.830   412   412 I android.hardware.lights-service.xrda3: Lights reporting supported lights
11-21 07:52:59.389   412   412 I android.hardware.lights-service.xrda3: Lights setting state for id=0 to color ff666666

	
_______________________________________________________________________________________________________________________________________________________________
