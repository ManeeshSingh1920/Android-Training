#include "Simple.h"

namespace aidl::vendor::example::simple {

ndk::ScopedAStatus SimpleHal::addInts(int32_t a, int32_t b,
                                      int32_t* _aidl_return) {
    LOG(INFO) << "SimpleHal::addInts(" << a << ", " << b << ")";
    *_aidl_return = a + b;
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus SimpleHal::echoString(const std::string& in_msg,
                                         std::string* _aidl_return) {
    LOG(INFO) << "SimpleHal::echoString(" << in_msg << ")";
    *_aidl_return = std::string("HAL echo: ") + in_msg;
    return ndk::ScopedAStatus::ok();
}

} // namespace aidl::vendor::example::simple

