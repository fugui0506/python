package com.cgwallet.app.cgwallet100

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        const val CHANNEL_DEVICE = "com.cgwallet.app.channel/device_info"
        const val CHANNEL_IMAGE = "com.cgwallet.app.channel/image"
        const val CHANNEL_QICHAT = "com.cgwallet.app.channel/qichat"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 注册 ChannelDeviceHandler
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_DEVICE).setMethodCallHandler(ChannelDeviceHandler(this))

        // 注册 ChannelImageHandler
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_IMAGE).setMethodCallHandler(ChannelImageHandler(this))

        // 注册 ChannelQichatHander
        var methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_QICHAT)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_QICHAT).setMethodCallHandler(ChannelQichatHander(this, methodChannel))
    }
}