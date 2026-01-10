package vendor.example.simple;

// Very simple AIDL HAL interface for demo
interface ISimple {
    int addInts(int a, int b);
    String echoString(String msg);
}

