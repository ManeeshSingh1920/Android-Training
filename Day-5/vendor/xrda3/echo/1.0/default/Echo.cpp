// FIXME: your file license if you have one

#include "Echo.h"

namespace android::hardware::echo::implementation {

// Methods from ::android::hardware::echo::V1_0::IEcho follow.
Return<void> Echo::echoString(const hidl_string& input, echoString_cb _hidl_cb) {
    // TODO implement
    return Void();
}

Return<int32_t> Echo::echoInt(int32_t input) {
    // TODO implement
    return int32_t {};
}

Return<void> Echo::processData(const hidl_vec<uint8_t>& data, processData_cb _hidl_cb) {
    // TODO implement
    return Void();
}


// Methods from ::android::hidl::base::V1_0::IBase follow.

//IEcho* HIDL_FETCH_IEcho(const char* /* name */) {
    //return new Echo();
//}
//
}  // namespace android::hardware::echo::implementation
