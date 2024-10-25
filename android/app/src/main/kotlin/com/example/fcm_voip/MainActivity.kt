package com.stlghana.fcm_voip

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.stlghana.fcm_voip/anydesk"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openAnyDesk") {
                val packageName = "com.anydesk.anydeskandroid"
                val installedPackages = packageManager.getInstalledPackages(0).map { it.packageName }
                Log.d("InstalledPackages", installedPackages.toString()) 

                // Attempt to launch AnyDesk
                val launchIntent: Intent? = packageManager.getLaunchIntentForPackage(packageName)

                if (launchIntent != null) {
                    startActivity(launchIntent)
                    result.success(null)
                } else {
                    Log.e("AnyDesk", "AnyDesk is not installed")
                    result.error("UNAVAILABLE", "AnyDesk not installed", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
