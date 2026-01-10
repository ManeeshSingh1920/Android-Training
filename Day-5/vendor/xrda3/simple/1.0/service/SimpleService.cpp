#include <android-base/logging.h>
#include <hidl/HidlTransportSupport.h>

#include <vendor/xrda3/simple/1.0/ISimple.h>

using ::android::sp;
using ::android::status_t;
using ::android::hardware::configureRpcThreadpool;
using ::android::hardware::joinRpcThreadpool;
using ::vendor::xrda3::simple::V1_0::ISimple;

struct Simple : public ISimple {
    ::android::hardware::Return<int32_t> add(int32_t a, int32_t b) override {
        int32_t result = a + b;
        LOG(INFO) << "HIDL Simple.add(" << a << ", " << b << ") = " << result;
        return result;
    }
};

int main() {
    android::base::InitLogging(nullptr, android::base::StderrLogger);

    sp<ISimple> service = new Simple();

    // One thread in the RPC threadpool, caller will join.
    configureRpcThreadpool(1 /*threads*/, true /*callerWillJoin*/);

    status_t status = service->registerAsService("default");
    if (status != android::OK) {
        LOG(ERROR) << "Cannot register ISimple service, status = " << status;
        return 1;
    }

    LOG(INFO) << "vendor.xrda3.simple@1.0 ISimple service is up";
    joinRpcThreadpool();   // never returns

    return 0;
}

