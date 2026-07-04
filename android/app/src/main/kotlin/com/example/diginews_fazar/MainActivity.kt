package com.example.diginews_fazar

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.fazar.diginews/nim"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "reverseNIM") {
                val nim = call.argument<String>("nim")
                
                if (nim != null) {
                    // TANTANGAN ANTI-AI: Membalikkan urutan String NIM di Kotlin
                    val reversedNim = nim.reversed()
                    
                    // Tampilkan menggunakan Native Toast Android sesuai instruksi
                    Toast.makeText(this, "NIM Dibalik: $reversedNim", Toast.LENGTH_LONG).show()
                    
                    // Kembalikan hasilnya ke Dart
                    result.success(reversedNim)
                } else {
                    result.error("EMPTY", "NIM kosong", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}