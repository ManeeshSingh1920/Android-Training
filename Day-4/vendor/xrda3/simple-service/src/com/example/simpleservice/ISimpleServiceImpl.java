// Old code => 
// package com.example.simpleservice;
//
// import android.content.Context;
// import android.util.Log;
// import com.example.simplemanager.ISimpleManager;
//
// class ISimpleServiceImpl extends ISimpleManager.Stub {
//	private static final String LOGTAG = "SimpleService";
//	private Context mContext;
//
//	ISimpleServiceImpl(Context context) {
//		mContext = context;
//	}
//
//	public int addInts(int a, int b) {
//		Log.d(LOGTAG, "addInts");
//		return a + b;
//	}
//
//	public String echoString(String s) {
//		Log.d(LOGTAG, "echoString");
//		return s;
//	}
// }


// new code => 
package com.example.simpleservice;

import android.content.Context;
import android.util.Log;
import com.example.simplemanager.ISimpleManager;

class ISimpleServiceImpl extends ISimpleManager.Stub {
    private static final String LOGTAG = "SimpleService";
    private Context mContext;

    static {
        // Load JNI library from the APK
        System.loadLibrary("simple_hal_jni");
    }

    // Native methods implemented in SimpleHalJni.cpp
    private static native int nativeAddInts(int a, int b);
    private static native String nativeEchoString(String s);

    ISimpleServiceImpl(Context context) {
        mContext = context;
    }

    @Override
    public int addInts(int a, int b) {
        Log.d(LOGTAG, "addInts -> HAL");
        return nativeAddInts(a, b); // call the native methods, which in turn call the HAL.
    }

    @Override
    public String echoString(String s) {
        Log.d(LOGTAG, "echoString -> HAL");
        return nativeEchoString(s); // call the native methods, which in turn call the HAL.
    }
}

