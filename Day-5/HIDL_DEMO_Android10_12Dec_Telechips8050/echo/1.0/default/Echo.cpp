// FIXME: your file license if you have one

#define LOG_TAG "android.hardware.echo@1.0-service"

#include "Echo.h"
#include <log/log.h>

namespace android {
namespace hardware {
namespace echo {
namespace V1_0 {
namespace implementation {

// Methods from ::android::hardware::echo::V1_0::IEcho follow.
Return<void> Echo::echoString(const hidl_string& input, echoString_cb _hidl_cb) {
    ALOGI("HIDL echoString called with: %s", input.c_str());
    
    // Simple echo - add prefix to input
    // Convert HIDL string to std::string for concatenation
    std::string result = "HIDL Echo: " + std::string(input.c_str());
    ALOGI("HIDL echoString returning: %s", result.c_str());
    
    // Convert back to HIDL string for callback
    _hidl_cb(hidl_string(result));
    return Void();
}

Return<int32_t> Echo::echoInt(int32_t input) {
    ALOGI("HIDL echoInt called with: %d", input);
    
    // Double the input number
    int32_t result = input * 2;
    ALOGI("HIDL echoInt returning: %d", result);
    
    return result;
}

Return<void> Echo::processData(const hidl_vec<uint8_t>& data, processData_cb _hidl_cb) {
    ALOGI("HIDL processData called with %zu bytes", data.size());
    
    // Create a copy of input data
    hidl_vec<uint8_t> processed = data;
    
    // Simple processing: increment each byte by 1
    for (size_t i = 0; i < processed.size(); i++) {
        processed[i] = processed[i] + 1;
    }
    
    ALOGI("HIDL processData returning %zu processed bytes", processed.size());
    _hidl_cb(processed);
    return Void();
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace echo
}  // namespace hardware
}  // namespace android