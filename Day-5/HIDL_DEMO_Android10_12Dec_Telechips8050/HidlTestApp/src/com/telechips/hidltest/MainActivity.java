package com.telechips.hidltest;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import android.os.RemoteException;
import android.os.IHwBinder;
import android.util.Log;

// HIDL imports for our Echo service
import android.hardware.echo.V1_0.IEcho;

import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends Activity {
    private static final String TAG = "HidlTestApp";
    
    // UI elements
    private TextView mResultsText;
    private LinearLayout mButtonLayout;
    
    // HIDL service
    private IEcho mEchoService = null;
    private ExecutorService mExecutor = Executors.newSingleThreadExecutor();
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Create UI programmatically
        createUI();
        
        connectToService();
    }
    
private void createUI() {
    // Parent layout (horizontal split)
    LinearLayout parentLayout = new LinearLayout(this);
    parentLayout.setOrientation(LinearLayout.HORIZONTAL);
    parentLayout.setPadding(30, 30, 30, 30);
    parentLayout.setBackgroundColor(Color.WHITE);

    // ---------- LEFT SIDE ----------
    LinearLayout leftLayout = new LinearLayout(this);
    leftLayout.setOrientation(LinearLayout.VERTICAL);
    leftLayout.setPadding(30, 30, 30, 30);
    leftLayout.setLayoutParams(new LinearLayout.LayoutParams(
            0, ViewGroup.LayoutParams.MATCH_PARENT, 1f)); // weight=1 for half width

    // Title
    TextView title = new TextView(this);
    title.setText("HIDL Echo Service Tester");
    title.setTextSize(30);
    title.setTextColor(Color.BLUE);
    title.setGravity(Gravity.CENTER);
    title.setPadding(0, 0, 0, 30);
    leftLayout.addView(title);

    // Status
    TextView status = new TextView(this);
    status.setId(android.R.id.text1);
    status.setText("Checking service status...");
    status.setTextSize(30);
    status.setPadding(20, 20, 20, 20);
    status.setBackgroundColor(Color.rgb(255, 165, 0)); // orange
    status.setGravity(Gravity.CENTER);
    leftLayout.addView(status);

    // Buttons layout
    mButtonLayout = new LinearLayout(this);
    mButtonLayout.setOrientation(LinearLayout.VERTICAL);
    mButtonLayout.setPadding(0, 30, 0, 30);

    // Button: Test String Echo
    Button btnString = new Button(this);
    btnString.setText("Test String Echo");
    btnString.setBackgroundColor(Color.GREEN);
    btnString.setTextColor(Color.BLACK);
    btnString.setOnClickListener(v -> testStringEcho());
    mButtonLayout.addView(btnString);

    // Spacer
    mButtonLayout.addView(spacer(20));

    // Button: Test Integer Echo
    Button btnInt = new Button(this);
    btnInt.setText("Test Integer Echo (x2)");
    btnInt.setBackgroundColor(Color.BLUE);
    btnInt.setTextColor(Color.WHITE);
    btnInt.setOnClickListener(v -> testIntEcho());
    mButtonLayout.addView(btnInt);

    // Spacer
    mButtonLayout.addView(spacer(20));

    // Button: Test Data
    Button btnData = new Button(this);
    btnData.setText("Test Data Processing (+1 to bytes)");
    btnData.setBackgroundColor(Color.rgb(255, 165, 0)); // orange
    btnData.setTextColor(Color.WHITE);
    btnData.setOnClickListener(v -> testDataProcessing());
    mButtonLayout.addView(btnData);

    leftLayout.addView(mButtonLayout);

    // ---------- RIGHT SIDE ----------
    LinearLayout rightLayout = new LinearLayout(this);
    rightLayout.setOrientation(LinearLayout.VERTICAL);
    rightLayout.setPadding(30, 30, 30, 30);
    rightLayout.setLayoutParams(new LinearLayout.LayoutParams(
            0, ViewGroup.LayoutParams.MATCH_PARENT, 1f)); // weight=1 for half width

    TextView resultsLabel = new TextView(this);
    resultsLabel.setText("Test Results:");
    resultsLabel.setTextSize(22);
    resultsLabel.setTextColor(Color.BLACK);
    resultsLabel.setPadding(0, 0, 0, 10);
    rightLayout.addView(resultsLabel);

    // Scrollable results
    ScrollView scrollView = new ScrollView(this);
    mResultsText = new TextView(this);
    mResultsText.setText("Results will appear here...\n\n");
    mResultsText.setTextSize(22);
    mResultsText.setBackgroundColor(Color.BLACK);
    mResultsText.setPadding(20, 20, 20, 20);
    mResultsText.setTextIsSelectable(true);
    scrollView.addView(mResultsText);

    LinearLayout.LayoutParams scrollParams = new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            0, 1f);
    scrollView.setLayoutParams(scrollParams);

    rightLayout.addView(scrollView);

    // Add left & right to parent
    parentLayout.addView(leftLayout);
    parentLayout.addView(rightLayout);

    setContentView(parentLayout);
}

// Helper: Spacer view
private TextView spacer(int height) {
    TextView space = new TextView(this);
    space.setHeight(height);
    return space;
}

    
    // private void connectToService() {
    //     mExecutor.execute(() -> {
    //         try {
    //             appendResult("🔍 Looking for HIDL Echo Service...");
                
    //             // Try to get the HIDL service
    //             mEchoService = IEcho.getService(true /* retry */);
                
    //             runOnUiThread(() -> {
    //                 TextView status = findViewById(android.R.id.text1);
    //                 if (mEchoService != null) {
    //                     status.setText("✅ HIDL Echo Service CONNECTED");
    //                     status.setBackgroundColor(Color.GREEN);
    //                     appendResult("🎉 SUCCESS: Connected to HIDL Echo Service!");
    //                     appendResult("Service: android.hardware.echo@1.0::IEcho");
    //                     appendResult("Ready for testing!\n");
    //                 } else {
    //                     status.setText("❌ HIDL Echo Service NOT FOUND");
    //                     status.setBackgroundColor(Color.RED);
    //                     appendResult("❌ ERROR: Could not connect to HIDL Echo Service");
    //                     appendResult("Make sure the service is running:");
    //                     appendResult("adb shell /vendor/bin/hw/android.hardware.echo@1.0-service &");
    //                 }
    //             });
                
    //         } catch (Exception e) {
    //             runOnUiThread(() -> {
    //                 TextView status = findViewById(android.R.id.text1);
    //                 status.setText("❌ Connection Error");
    //                 status.setBackgroundColor(Color.RED);
    //                 appendResult("❌ EXCEPTION: " + e.getMessage());
    //             });
    //         }
    //     });
    // }
//     private void connectToService() {
//     mExecutor.execute(() -> {
//         try {
//             appendResult("🔍 Looking for HIDL Echo Service...");

//             // Try to get the HIDL service
//             mEchoService = IEcho.getService(true /* retry */);

//             // ✅ Register death listener (this part was missing earlier)
//             if (mEchoService != null) {
//                 mEchoService.asBinder().linkToDeath(new IHwBinder.DeathRecipient() {
//                     @Override
//                     public void serviceDied(long cookie) {
//                         Log.e("HidlTestApp", "💀 Echo HAL service died!");
//                         runOnUiThread(() -> {
//                             TextView status = findViewById(android.R.id.text1);
//                             status.setText("⚠️ DISCONNECTED: Echo HAL died");
//                             status.setBackgroundColor(Color.RED);
//                             appendResult("💀 Service disconnected or killed.");
//                         });
//                     }
//                 }, 0);
//             }

//             runOnUiThread(() -> {
//                 TextView status = findViewById(android.R.id.text1);
//                 if (mEchoService != null) {
//                     status.setText("✅ HIDL Echo Service CONNECTED");
//                     status.setBackgroundColor(Color.GREEN);
//                     appendResult("🎉 SUCCESS: Connected to HIDL Echo Service!");
//                     appendResult("Service: android.hardware.echo@1.0::IEcho");
//                     appendResult("Ready for testing!\n");
//                 } else {
//                     status.setText("❌ HIDL Echo Service NOT FOUND");
//                     status.setBackgroundColor(Color.RED);
//                     appendResult("❌ ERROR: Could not connect to HIDL Echo Service");
//                     appendResult("Make sure the service is running:");
//                     appendResult("adb shell /vendor/bin/hw/android.hardware.echo@1.0-service &");
//                 }
//             });

//         } catch (Exception e) {
//             runOnUiThread(() -> {
//                 TextView status = findViewById(android.R.id.text1);
//                 status.setText("❌ Connection Error");
//                 status.setBackgroundColor(Color.RED);
//                 appendResult("❌ EXCEPTION: " + e.getMessage());
//             });
//         }
//     });
// }

private void connectToService() {
    mExecutor.execute(() -> {
        try {
            appendResult("🔍 Looking for HIDL Echo Service...");

            // Try to get the HIDL service
            mEchoService = IEcho.getService(true /* retry */);

            if (mEchoService != null) {
                // ✅ Register death listener
                mEchoService.asBinder().linkToDeath(new IHwBinder.DeathRecipient() {
                    @Override
                    public void serviceDied(long cookie) {
                        Log.e("HidlTestApp", "💀 Echo HAL service died!");
                        runOnUiThread(() -> {
                            TextView status = findViewById(android.R.id.text1);
                            status.setTextColor(Color.BLACK);
                            status.setText("⚠️ DISCONNECTED: Echo HAL died");
                            status.setBackgroundColor(Color.RED);
                            appendResult("💀 Service disconnected or killed.");
                        });

                        // Try to reconnect automatically
                        reconnectService();
                    }
                }, 0);
            }

            runOnUiThread(() -> {
                TextView status = findViewById(android.R.id.text1);
                if (mEchoService != null) {
                    status.setText("✅ HIDL Echo Service CONNECTED");
                    status.setTextColor(Color.BLACK);
                    status.setBackgroundColor(Color.GREEN);
                    appendResult("🎉 SUCCESS: Connected to HIDL Echo Service!");
                    appendResult("Service: android.hardware.echo@1.0::IEcho");
                    appendResult("Ready for testing!\n");
                } else {
                    status.setText("❌ HIDL Echo Service NOT FOUND");
                    status.setBackgroundColor(Color.RED);
                    appendResult("❌ ERROR: Could not connect to HIDL Echo Service");
                    appendResult("Make sure the service is running:");
                    appendResult("adb shell /vendor/bin/hw/android.hardware.echo@1.0-service &");
                }
            });

        } catch (Exception e) {
            runOnUiThread(() -> {
                TextView status = findViewById(android.R.id.text1);
                status.setText("❌ Connection Error");
                status.setBackgroundColor(Color.RED);
                appendResult("❌ EXCEPTION: " + e.getMessage());
            });
        }
    });
}
private void reconnectService() {
    mExecutor.execute(() -> {
        while (mEchoService == null) {
            try {
                Thread.sleep(1000); // wait before retry
                appendResult("🔁 Trying to reconnect to Echo HAL...");
                IEcho service = IEcho.getService();
                if (service != null) {
                    mEchoService = service;
                    runOnUiThread(() -> {
                        TextView status = findViewById(android.R.id.text1);
                        status.setText("✅ Reconnected to Echo HAL Service");
                        status.setBackgroundColor(Color.GREEN);
                        appendResult("✅ Successfully reconnected to Echo HAL!\n");
                    });

                    // Re-link death recipient
                    mEchoService.asBinder().linkToDeath(new IHwBinder.DeathRecipient() {
                        @Override
                        public void serviceDied(long cookie) {
                            Log.e("HidlTestApp", "💀 Echo HAL service died again!");
                            mEchoService = null;
                            reconnectService();
                        }
                    }, 0);
                    break;
                }
            } catch (Exception e) {
                Log.e("HidlTestApp", "Reconnect attempt failed: " + e.getMessage());
            }
        }
    });
}



    private void testStringEcho() {
        if (mEchoService == null) {
            showToast("Service not connected!");
            return;
        }
        
        mExecutor.execute(() -> {
            try {
                appendResult("\n--- Testing String Echo ---");
                String input = "Hello Telechips TCC8050!";
                appendResult("Input: \"" + input + "\"");
                
                // HIDL Java methods return values directly, no callbacks
                String result = mEchoService.echoString(input);
                
                runOnUiThread(() -> {
                    appendResult("Output: \"" + result + "\"");
                    appendResult("✅ String Echo Test PASSED");
                    showToast("String test completed!");
                });
                
            } catch (Exception e) {
                runOnUiThread(() -> {
                    appendResult("❌ String Echo Test FAILED: " + e.getMessage());
                    showToast("String test failed!");
                });
            }
        });
    }
    
    private void testIntEcho() {
        if (mEchoService == null) {
            showToast("Service not connected!");
            return;
        }
        
        mExecutor.execute(() -> {
            try {
                appendResult("\n--- Testing Integer Echo ---");
                int input = 42;
                appendResult("Input: " + input);
                
                int result = mEchoService.echoInt(input);
                
                runOnUiThread(() -> {
                    appendResult("Output: " + result);
                    appendResult("Expected: " + input + " × 2 = " + (input * 2));
                    appendResult(result == input * 2 ? "✅ Integer Echo Test PASSED" : "❌ Integer Echo Test FAILED");
                    showToast("Integer test completed!");
                });
                
            } catch (Exception e) {
                runOnUiThread(() -> {
                    appendResult("❌ Integer Echo Test FAILED: " + e.getMessage());
                    showToast("Integer test failed!");
                });
            }
        });
    }
    
    private void testDataProcessing() {
        if (mEchoService == null) {
            showToast("Service not connected!");
            return;
        }
        
        mExecutor.execute(() -> {
            try {
                appendResult("\n--- Testing Data Processing ---");
                
                // Create test data: [1, 2, 3, 4, 5]
                byte[] testData = {1, 2, 3, 4, 5};
                ArrayList<Byte> dataList = new ArrayList<>();
                for (byte b : testData) dataList.add(b);
                
                appendResult("Input: byte[" + testData.length + "] " + arrayToString(testData));
                
                // HIDL Java methods return values directly
                ArrayList<Byte> result = mEchoService.processData(dataList);
                
                runOnUiThread(() -> {
                    // Convert back to array for display
                    byte[] processedArray = new byte[result.size()];
                    for (int i = 0; i < result.size(); i++) {
                        processedArray[i] = result.get(i);
                    }
                    
                    appendResult("Output: byte[" + processedArray.length + "] " + arrayToString(processedArray));
                    appendResult("Expected: Each byte incremented by 1");
                    
                    boolean passed = true;
                    for (int i = 0; i < testData.length; i++) {
                        if (processedArray[i] != testData[i] + 1) {
                            passed = false;
                            break;
                        }
                    }
                    
                    appendResult(passed ? "✅ Data Processing Test PASSED" : "❌ Data Processing Test FAILED");
                    showToast("Data processing test completed!");
                });
                
            } catch (Exception e) {
                runOnUiThread(() -> {
                    appendResult("❌ Data Processing Test FAILED: " + e.getMessage());
                    showToast("Data processing test failed!");
                });
            }
        });
    }
    
    // Helper method to format byte array as string
    private String arrayToString(byte[] array) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < array.length; i++) {
            sb.append(array[i]);
            if (i < array.length - 1) sb.append(", ");
        }
        sb.append("]");
        return sb.toString();
    }
    
    // Helper method to append to results text
    private void appendResult(String text) {
        runOnUiThread(() -> {
            mResultsText.append(text + "\n");
        });
    }
    
    private void showToast(String message) {
        runOnUiThread(() -> Toast.makeText(MainActivity.this, message, Toast.LENGTH_SHORT).show());
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mExecutor != null) {
            mExecutor.shutdown();
        }
    }
}

