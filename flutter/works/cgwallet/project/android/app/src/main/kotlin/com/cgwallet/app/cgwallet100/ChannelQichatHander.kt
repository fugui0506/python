package com.cgwallet.app.cgwallet100

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import android.os.Handler
import android.os.Looper


import com.teneasy.sdk.ChatLib
import com.teneasy.sdk.Result
import com.teneasy.sdk.TeneasySDKDelegate
import com.teneasy.sdk.LineDetectLib
import com.teneasy.sdk.LineDetectDelegate
import com.teneasyChat.api.common.CMessage
import com.teneasyChat.gateway.GGateway

class ChannelQichatHander(private val context: Context, private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    private val qiChatSDK = ChatDelegateHandler(channel)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "lineDetect" -> {
                val baseUrl = call.argument<String>("baseUrl")
                val tenantId = call.argument<Int>("tenantId")

                if (baseUrl != null && tenantId != null) {
                    qiChatSDK.lineDetect(baseUrl, tenantId, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }

            "initSDK" -> {
                val wssUrl = call.argument<String>("wssUrl")
                val cert = call.argument<String>("cert")
                val token = call.argument<String>("token")
                val userId = call.argument<Int>("userId")
                val sign = call.argument<String>("sign")

                if (wssUrl != null && cert != null && token != null && userId != null && sign != null) {
                    qiChatSDK.initSDK(wssUrl, cert, token, userId, sign, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }

            "sendText" -> {
                val content = call.argument<String>("content")
                val consultId = call.argument<Number>("consultId")?.toLong()
                val replyMsgId = call.argument<Number>("replyMsgId")?.toLong()

                if (content != null && consultId != null && replyMsgId != null) {
                    qiChatSDK.sendText(content, consultId, replyMsgId)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }

            "sendImage" -> {
                val imageUrl = call.argument<String>("imageUrl")
                val consultId = call.argument<Number>("consultId")?.toLong()
                val replyMsgId = call.argument<Number>("replyMsgId")?.toLong()

                if (imageUrl != null && consultId != null && replyMsgId != null) {
                    qiChatSDK.sendImage(imageUrl, consultId, replyMsgId)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }

            "sendVideo" -> {
                val videoUrl = call.argument<String>("videoUrl")
                val consultId = call.argument<Number>("consultId")?.toLong()
                val replyMsgId = call.argument<Number>("replyMsgId")?.toLong()

                if (videoUrl != null && consultId != null && replyMsgId != null) {
                    qiChatSDK.sendVideo(videoUrl, consultId, replyMsgId)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }

            "disconnect" -> {
                qiChatSDK.disconnect()
            }
            else -> result.notImplemented()
        }
    }
}

class ChatDelegateHandler(private val channel: MethodChannel) : TeneasySDKDelegate {
    private var chatLib: ChatLib? = null
    // 切换到主线程执行
    private val mainHandler = Handler(Looper.getMainLooper())

    // 检查线路
    fun lineDetect(lineDetect: String, tenantId: Int, result: MethodChannel.Result) {
        println("正在检查线路...")

        val lineLib = LineDetectLib(lineDetect, object : LineDetectDelegate {
            override fun useTheLine(line: String) {
                result.success(line)
            }

            override fun lineError(error: Result) {
                result.success("")
            }
        }, tenantId)
        lineLib.getLine()
    }

    fun initSDK(wssUrl: String, cert: String, token: String, userId: Int, sign: String, result: MethodChannel.Result) {
        println("正在初始化 SDK ...")

        val baseUrl = "wss://$wssUrl/v1/gateway/h5?"
        // cert, 第一次进入使用
        // token，可以为空，也可以代替cert使用
        // wssUrl wss链接
        // userId 用户id
        chatLib = ChatLib(
            cert = cert,
            token = token,
            baseUrl = baseUrl,
            userId = userId,
            sign = sign,
            custom = java.net.URLEncoder.encode(
                """
                    {
                    "userlever": 0,
                    "username": "",
                    "platform": 2,
                    }
                """.trimIndent(), "UTF-8"
            )
        )
        chatLib?.listener = this
        chatLib?.makeConnect()
    }

    // 成功连接，并返回相关信息，例如workerId
    override fun connected(c: GGateway.SCHi) {
        println("连接成功 ...")

        // val workerId = c.workerId
        mainHandler.post {
            channel.invokeMethod("connected", c.token)
        }
    }

    // 对方删除了消息，会回调这个函数
    override fun msgDeleted(msg: CMessage.Message?, payloadId: Long, msgId: Long, errMsg: String) {
        mainHandler.post {
            val msgMap = mapOf(
                "msgId" to msg?.msgId
            )
            channel.invokeMethod("msgDeleted", msgMap)
        }
    }
    
    // 消息发送出去，收到回执才算成功，并需要改变消息的状态
    override fun msgReceipt(msg: CMessage.Message?, payloadId: Long, msgId: Long, errMsg: String) {
        mainHandler.post {
            val msgMap = mapOf(
                "msgId" to msg?.msgId
            )
            channel.invokeMethod("msgReceipt", msgMap)
        }
    }

    // 收到对方消息
    override fun receivedMsg(msg: CMessage.Message) {
        mainHandler.post {
            val msgMap = mapOf(
                "content" to msg.content.data,
                "imageUrl" to msg.image.uri,
                "msgId" to msg.msgId,
                "video" to msg.video.uri,
                "replyMsgID" to msg.replyMsgId,
            )
            channel.invokeMethod("receivedMsg", msgMap)
        }
    }

    // 聊天sdk里面有什么异常，会从这个回调告诉
    override fun systemMsg(msg: Result) {
        mainHandler.post {
            val msgMap = mapOf(
                "code" to msg.code,
                "msg" to msg.msg
            )
            channel.invokeMethod("error", msgMap)
        }
        // println(msg)
    }

    // 发送消息
    fun sendText(content: String, consultId: Long, replyMsgId: Long) {
        // CMessage.MessageFormat.MSG_TEXT
        // CMessage.MessageFormat.MSG_IMG
        // CMessage.MessageFormat.MSG_VIDEO

        chatLib?.sendMessage(content, CMessage.MessageFormat.MSG_TEXT, consultId, replyMsgId)
    }

    // 中断连接
    fun disconnect() {
        chatLib?.disConnect()
        chatLib = null
        println("连接已断开")
    }

    // 发送图片
    fun sendImage(imageUrl: String, consultId: Long, replyMsgId: Long) {
        chatLib?.sendMessage(imageUrl, CMessage.MessageFormat.MSG_IMG, consultId, replyMsgId)
    }

    // 发送视频
    fun sendVideo(videoUrl: String, consultId: Long, replyMsgId: Long) {
        chatLib?.sendMessage(videoUrl, CMessage.MessageFormat.MSG_VIDEO, consultId, replyMsgId)
    }

    //客服更换了，需要更换客服信息
    override fun workChanged(msg: GGateway.SCWorkerChanged) {
        println(msg)
    }
}
