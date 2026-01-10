#define LOG_TAG "android.hardware.echo@1.0-service"

#include <android/hardware/echo/1.0/IEcho.h>
#include <hidl/LegacySupport.h>

#include "Echo.h"

using android::hardware::echo::V1_0::IEcho;
using android::hardware::echo::V1_0::implementation::Echo;
using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;
using android::sp;

int main() {
    ALOGI("=== Starting HIDL Echo Service ===");
    
    // Configure the thread pool
    configureRpcThreadpool(1, true /* willJoin */);
    
    // Create our service instance
    sp<IEcho> service = new Echo();
    
    // Register the service
    android::status_t status = service->registerAsService();
    
    if (status != android::OK) {
        ALOGE("=== FAILED to register HIDL Echo Service ===");
        ALOGE("=== Error code: %d ===", status);
        return -1;
    }
    
    ALOGI("=== HIDL Echo Service Registered Successfully ===");
    ALOGI("=== Service name: android.hardware.echo@1.0::IEcho ===");
    
    // Join the thread pool (keeps service running)
    joinRpcThreadpool();
    
    ALOGI("=== HIDL Echo Service Stopped ===");
    return 0;
}