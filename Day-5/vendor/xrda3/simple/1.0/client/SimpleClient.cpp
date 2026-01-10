#include <android-base/logging.h>
#include <vendor/xrda3/simple/1.0/ISimple.h>

using ::android::sp;
using ::vendor::xrda3::simple::V1_0::ISimple;

int main() {
    android::base::InitLogging(nullptr, android::base::StderrLogger);

    sp<ISimple> service = ISimple::getService("default");
    if (service == nullptr) {
        LOG(ERROR) << "Cannot get ISimple HIDL service";
        return 1;
    }

    int32_t result = service->add(10, 32);
    LOG(INFO) << "Client: 10 + 32 = " << result;

    return 0;
}

