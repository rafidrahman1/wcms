package com.example.wms

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.wms/device_admin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setUninstallBlocked" -> {
                    val blocked = call.argument<Boolean>("blocked") ?: true
                    val success = setUninstallBlocked(blocked)
                    if (success) {
                        result.success(null)
                    } else {
                        result.error("UNAVAILABLE", "Not a device owner or admin.", null)
                    }
                }
                "isDeviceOwner" -> {
                    result.success(isDeviceOwner())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun setUninstallBlocked(blocked: Boolean): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminName = ComponentName(this, DeviceAdminReceiver::class.java)
        return try {
            if (dpm.isDeviceOwnerApp(packageName)) {
                dpm.setUninstallBlocked(adminName, packageName, blocked)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun isDeviceOwner(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        return dpm.isDeviceOwnerApp(packageName)
    }
}
