#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

#include <aidl/vendor/example/simple/ISimple.h>
#include "Simple.h"

using ::aidl::vendor::example::simple::ISimple;
using ::aidl::vendor::example::simple::SimpleHal;

int main() {
    android::base::InitLogging(nullptr);
    LOG(INFO) << "Starting Simple HAL service";

    // Unlimited binder threads as needed
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    // Create HAL implementation
    std::shared_ptr<SimpleHal> service = ndk::SharedRefBase::make<SimpleHal>();

    // Instance name: "vendor.example.simple.ISimple/default"
    const std::string instance = std::string() + ISimple::descriptor + "/default";

    binder_status_t status =
        AServiceManager_addService(service->asBinder().get(), instance.c_str());
    CHECK(status == STATUS_OK) << "Failed to register Simple HAL service";

    LOG(INFO) << "Simple HAL service registered as " << instance;

    ABinderProcess_joinThreadPool();
    LOG(ERROR) << "Simple HAL service exiting unexpectedly";
    return EXIT_FAILURE;  // should never be reached
}

