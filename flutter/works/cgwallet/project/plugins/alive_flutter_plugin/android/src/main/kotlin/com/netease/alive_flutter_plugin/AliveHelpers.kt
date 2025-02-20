package com.netease.alive_flutter_plugin

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.netease.nis.alivedetected.ActionType
import com.netease.nis.alivedetected.AliveDetector
import com.netease.nis.alivedetected.DetectedListener
import com.netease.nis.alivedetected.NISCameraPreview
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * @author liuxiaoshuai
 * @date 2024/4/29
 * @desc
 */
class AliveHelpers {
    private var aliveDetector = AliveDetector.getInstance()
    var events: EventChannel.EventSink? = null
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    fun init(
        context: Context,
        cameraPreview: NISCameraPreview?,
        businessId: String,
        timeout: Int,
        isDebug: Boolean,
    ) {
        if (cameraPreview == null) {
            Log.e(AliveDetector.TAG, "预览view为空")
            return
        }
        aliveDetector.init(context, cameraPreview, businessId)
        aliveDetector.setDebugMode(isDebug)
        aliveDetector.setTimeOut(timeout.toLong() * 1000)
    }

    fun startDetect(result: MethodChannel.Result) {
        aliveDetector.setDetectedListener(object : DetectedListener {
            override fun onPassed(isPassed: Boolean, token: String?) {
                val data = HashMap<String, Any?>()
                data["isPassed"] = isPassed
                data["token"] = token
                sendEventData("onChecked", data)
            }

            override fun onCheck() {
                //本地验证通过提交远程检测
            }

            override fun onActionCommands(actionTypes: Array<ActionType>) {
                val data = HashMap<String, Any?>()
                data["actions"] = buildActionCommand(actionTypes)

                try {
                    val resultData = HashMap<String, Any?>()
                    resultData["method"] = "onConfig"
                    resultData["data"] = data
                    uiThreadHandler.post {
                        result.success(resultData)
                    }
                } catch (e: Exception) {
                    Log.e(AliveDetector.TAG, "Reply already submitted")
                }
            }

            override fun onReady(isInitSuccess: Boolean) {
                val data = HashMap<String, Any?>()
                data["initResult"] = isInitSuccess
                sendEventData("onReady", data)
            }

            override fun onError(code: Int, msg: String?, token: String?) {
                val data = HashMap<String, Any?>()
                data["code"] = code
                data["message"] = msg
                sendEventData("onError", data)
            }

            override fun onStateTipChanged(actionType: ActionType?, stateTip: String?, code: Int) {
                val data = HashMap<String, Any?>()
                if (actionType == ActionType.ACTION_ERROR) {
                    data["code"] = code
                    data["message"] = stateTip
                    sendEventData("onError", data)
                } else {
                    data["currentStep"] = actionType?.actionID?.toInt()
                    data["message"] = stateTip
                    sendEventData("onChecking", data)
                }
            }

            override fun onOverTime() {
                val data = HashMap<String, Any?>()
                sendEventData("overTime", data)
            }

        })
        aliveDetector.startDetect()
    }

    fun stopDetect() {
        aliveDetector.stopDetect()
    }

    fun destroy() {
        aliveDetector.destroy()
    }

    private fun buildActionCommand(actionCommands: Array<ActionType>): String {
        val commands = StringBuilder()
        for (actionType in actionCommands) {
            commands.append(actionType.actionID)
        }
        return commands.toString()
    }

    private fun sendEventData(method: String, data: Map<String, Any?>?) {
        try {
            val eventData = HashMap<String, Any?>()
            eventData["method"] = method
            if (data != null) {
                eventData["data"] = data
            }
            uiThreadHandler.post {
                events?.success(eventData)
            }
        } catch (e: Exception) {
            Log.e(AliveDetector.TAG, "Reply already submitted")
        }
    }
}