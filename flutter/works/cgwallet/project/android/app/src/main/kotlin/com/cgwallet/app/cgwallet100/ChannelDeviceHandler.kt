package com.cgwallet.app.cgwallet100

import android.content.Context
import android.provider.Settings
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ChannelDeviceHandler(private val context: Context) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getAndroidId" -> result.success(getAndroidId() ?: run {
                result.error("UNAVAILABLE", "Android ID not available.", null)
                return
            })
            else -> result.notImplemented()
        }
    }

    private fun getAndroidId(): String? {
        return Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
    }
}
