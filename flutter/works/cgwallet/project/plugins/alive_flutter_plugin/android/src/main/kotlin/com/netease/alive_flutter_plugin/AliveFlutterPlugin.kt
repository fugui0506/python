package com.netease.alive_flutter_plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** AliveFlutterPlugin */
class AliveFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var aliveHelper: AliveHelpers? = null
    private lateinit var nativeViewFactory: NativeViewFactory
    val EVENT_CHANNEL = "yd_alive_flutter_event_channel"

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "alive_flutter_plugin")
        channel.setMethodCallHandler(this)
        nativeViewFactory = NativeViewFactory()
        binding.platformViewRegistry.registerViewFactory("platform-view-alive", nativeViewFactory)
        aliveHelper = AliveHelpers()
        registerEventHandle(binding.binaryMessenger)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val businessId = call.argument<String>("businessID")
                val timeout = call.argument<Int>("timeout") ?: 30 // 超时时间
                val isDebug = call.argument<Boolean>("isDebug") ?: false // 是否debug模式

                if (businessId == null) {
                    Log.e("AliveFlutterPlugin", "业务id不能为空")
                    return
                }
                val aliveView = nativeViewFactory.aliveView
                aliveHelper?.init(
                    context,
                    aliveView.getCameraView(),
                    businessId,
                    timeout,
                    isDebug
                )
            }

            "startLiveDetect" -> {
                aliveHelper?.startDetect(result)
            }

            "stopLiveDetect" -> {
                aliveHelper?.stopDetect()
            }

            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "destroy" -> {
                aliveHelper?.destroy()
                nativeViewFactory.aliveView.destroy()
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun registerEventHandle(message: BinaryMessenger) {
        EventChannel(message, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                aliveHelper?.events = events
            }

            override fun onCancel(arguments: Any?) {

            }
        })
    }
}
