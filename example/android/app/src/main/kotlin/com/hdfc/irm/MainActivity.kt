package com.hdfc.irm

import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import com.microsoft.intune.mam.client.strict.MAMStrictMode

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        MAMStrictMode.enable()
    }
}
