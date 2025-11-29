#include <jni.h>
#include <string>

#include <android-base/logging.h>
#include <android/binder_manager.h>

#include <aidl/vendor/example/simple/ISimple.h>

using ::aidl::vendor::example::simple::ISimple;

static std::shared_ptr<ISimple> gHal;

// Lazily connect to HAL
static std::shared_ptr<ISimple> getHal() {
    if (gHal) return gHal;

    const std::string instance = std::string() + ISimple::descriptor + "/default";

    
    ndk::SpAIBinder binder(AServiceManager_getService(instance.c_str()));
    // You can keep getService (just deprecated), or switch to waitForService.
    // Better: ndk::SpAIBinder binder(AServiceManager_waitForService(instance.c_str()));
    

    if (!binder.get()) {   
        LOG(ERROR) << "Simple HAL service not found: " << instance;
        return nullptr;
    }

    gHal = ISimple::fromBinder(binder);
    if (!gHal) {
        LOG(ERROR) << "Failed to get ISimple interface";
    } else {
        LOG(INFO) << "Connected to Simple HAL: " << instance;
    }
    return gHal;
}

extern "C" JNIEXPORT jint JNICALL
Java_com_example_simpleservice_ISimpleServiceImpl_nativeAddInts(
        JNIEnv* /*env*/, jclass /*clazz*/, jint a, jint b) {
    auto hal = getHal();
    if (!hal) return -1;

    int32_t result = 0;
    auto status = hal->addInts(a, b, &result);
    if (!status.isOk()) {
        LOG(ERROR) << "HAL addInts failed: " << status.getDescription();
        return -1;
    }
    return static_cast<jint>(result);
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_simpleservice_ISimpleServiceImpl_nativeEchoString(
        JNIEnv* env, jclass /*clazz*/, jstring jmsg) {
    auto hal = getHal();
    if (!hal) return env->NewStringUTF("HAL not connected");

    const char* cmsg = env->GetStringUTFChars(jmsg, nullptr);
    std::string in_msg = cmsg ? cmsg : "";
    env->ReleaseStringUTFChars(jmsg, cmsg);

    std::string out;
    auto status = hal->echoString(in_msg, &out);
    if (!status.isOk()) {
        LOG(ERROR) << "HAL echoString failed: " << status.getDescription();
        out = "HAL error";
    }
    return env->NewStringUTF(out.c_str());
}

