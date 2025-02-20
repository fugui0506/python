package com.netease.nis.captcha_plugin_flutter

import android.app.Activity
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

/** CaptchaPluginFlutterPlugin */
class CaptchaPluginFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private val METHOD_CHANNEL = "yd_captcha_flutter_method_channel"
    private val EVENT_CHANNEL = "yd_captcha_flutter_event_channel"
    private var callHandler: CaptchaHelper? = null
    private var mActivity: WeakReference<Activity>? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
        channel.setMethodCallHandler(this)

        callHandler = CaptchaHelper()
        EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object :
            EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                callHandler?.events = events
            }

            override fun onCancel(arguments: Any?) {
                callHandler?.events = null
            }
        })
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.i("CaptchaPlugin", "onMethodCall:" + call.method)
        when (call.method) {
            "init" -> {
                mActivity?.get()?.let {
                    callHandler?.init(it, call)
                }
            }

            "showCaptcha" -> {
                callHandler?.showCaptcha()
            }
            "destroyCaptcha" -> {
                callHandler?.destroy()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.i("CaptchaPlugin", "activity:" + binding.activity)
        this.mActivity = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.mActivity = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivity() {
        this.mActivity = null
    }
}
