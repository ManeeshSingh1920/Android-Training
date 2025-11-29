#pragma once

#include <android-base/logging.h>
#include <aidl/vendor/example/simple/BnSimple.h>

namespace aidl::vendor::example::simple {

using ::aidl::vendor::example::simple::BnSimple;

class SimpleHal : public BnSimple {
public:
    ndk::ScopedAStatus addInts(int32_t a, int32_t b,
                               int32_t* _aidl_return) override;

    ndk::ScopedAStatus echoString(const std::string& in_msg,
                                  std::string* _aidl_return) override;
};

} // namespace aidl::vendor::example::simple

