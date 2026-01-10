// FIXME: your file license if you have one

#pragma once

#include <android/hardware/echo/1.0/IEcho.h>
#include <hidl/MQDescriptor.h>
#include <hidl/Status.h>

namespace android::hardware::echo::implementation {

using ::android::hardware::hidl_array;
using ::android::hardware::hidl_memory;
using ::android::hardware::hidl_string;
using ::android::hardware::hidl_vec;
using ::android::hardware::Return;
using ::android::hardware::Void;
using ::android::sp;

struct Echo : public V1_0::IEcho {
    // Methods from ::android::hardware::echo::V1_0::IEcho follow.
    Return<void> echoString(const hidl_string& input, echoString_cb _hidl_cb) override;
    Return<int32_t> echoInt(int32_t input) override;
    Return<void> processData(const hidl_vec<uint8_t>& data, processData_cb _hidl_cb) override;

    // Methods from ::android::hidl::base::V1_0::IBase follow.

};

// FIXME: most likely delete, this is only for passthrough implementations
// extern "C" IEcho* HIDL_FETCH_IEcho(const char* name);

}  // namespace android::hardware::echo::implementation
