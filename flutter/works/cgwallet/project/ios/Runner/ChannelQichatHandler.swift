import Flutter
import UIKit
import TeneasyChatSDK_iOS

// Handler 类
class ChannelQichatHandler {
    static var qichatLib: QiChatLib?

    static func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let channel = ChannelQichatHandler()
        switch call.method {
        case "lineDetect":
            guard let args = call.arguments as? [String: Any],
                  let baseUrl = args["baseUrl"] as? String,
                  let tenantId = args["tenantId"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Base URL is required", details: nil))
                return
            }
            channel.lineDetect(baseUrl: baseUrl, tenantId: tenantId, result: result)
        case "initSDK":
            guard let args = call.arguments as? [String: Any],
                  let wssUrl = args["wssUrl"] as? String,
                  let cert = args["cert"] as? String,
                  let token = args["token"] as? String,
                  let userId = args["userId"] as? Int32,
                  let sign = args["sign"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Required parameters are missing", details: nil))
                return
            }
            self.qichatLib = QiChatLib()
            self.qichatLib?.initSDK(wssUrl: wssUrl, cert: cert, token: token, userId: userId, sign: sign, result: result)
        case "sendText":
            guard let args = call.arguments as? [String: Any],
                  let content = args["content"] as? String,
                  let consultId = args["consultId"] as? Int64,
                  let replyMsgId = args["replyMsgId"] as? Int64 else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Required parameters are missing", details: nil))
                return
            }
            self.qichatLib?.sendText(content: content, consultId: consultId, replyMsgId: replyMsgId, result: result)

        case "sendImage":
            guard let args = call.arguments as? [String: Any],
                  let imageUrl = args["imageUrl"] as? String,
                  let consultId = args["consultId"] as? Int64,
                  let replyMsgId = args["replyMsgId"] as? Int64 else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Required parameters are missing", details: nil))
                return
            }
            self.qichatLib?.sendImage(imageUrl: imageUrl, consultId: consultId, replyMsgId: replyMsgId, result: result)
        
         case "sendVideo":
            guard let args = call.arguments as? [String: Any],
                  let videoUrl = args["videoUrl"] as? String,
                  let consultId = args["consultId"] as? Int64,
                  let replyMsgId = args["replyMsgId"] as? Int64 else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Required parameters are missing", details: nil))
                return
            }
            self.qichatLib?.sendVideo(videoUrl: videoUrl, consultId: consultId, replyMsgId: replyMsgId, result: result)
        
        case "disconnect":
            self.qichatLib?.disconnect()
        
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func lineDetect(baseUrl: String, tenantId: Int, result: @escaping FlutterResult) {
        let lineDetectLib = ChannelLineDetectLib()
        lineDetectLib.lineDetect(baseUrl: baseUrl, tenantId: tenantId, result: result)
    }
}

class ChannelLineDetectLib: LineDetectDelegate {
    private var flutterResult: FlutterResult?

    func lineDetect(baseUrl: String, tenantId: Int, result: @escaping FlutterResult) {
        debugPrint("Base URL for line detection: %@", baseUrl)
        self.flutterResult = result

        let lineLib = LineDetectLib(baseUrl, delegate: self, tenantId: tenantId)
        lineLib.getLine()
    }

    // 实现 LineDetectDelegate 的回调方法
    public func useTheLine(line: String) {
        debugPrint("Line detection successful, line is: %@", line)

        if let result = flutterResult {
            result(line)
            flutterResult = nil
        }
    }

    public func lineError(error: TeneasyChatSDK_iOS.Result) {
        debugPrint("Line detection failed, error code: %d, error message: %@", error.Code, error.Message)

        if let result = flutterResult {
            result("")
            flutterResult = nil
        }
    }
}

// QiChatLib 类
class QiChatLib: teneasySDKDelegate {
    var lib = ChatLib.shared
    var channelCallBack: FlutterMethodChannel?

    func initSDK(wssUrl: String, cert: String, token: String, userId: Int32, sign: String, result: @escaping FlutterResult) {
        let wssUrlLong = "wss://" + wssUrl + "/v1/gateway/h5?"
        let jsonStringParams = "{\"username\":\"\",\"platform\":1,\"userlevel\":0}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        lib.myinit(userId: userId, cert: cert, token: token, baseUrl: wssUrlLong, sign: sign, custom: jsonStringParams ?? "")
        lib.callWebsocket()
        lib.delegate = self

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let flutterViewController = appDelegate.window?.rootViewController as? FlutterViewController {
            channelCallBack = FlutterMethodChannel(name: "com.cgwallet.app.channel/qichat", binaryMessenger: flutterViewController.binaryMessenger)
        }
    }

    func sendText(content: String, consultId: Int64, replyMsgId: Int64, result: @escaping FlutterResult) {
        // case .msgText:
        //     sendTextMessage(txt: msg)
        // case .msgVoice:
        //     sendVideoMessage(url: msg)
        // case .msgImg:
        //     sendImageMessage(url: msg)
        // case .msgVideo:
        //     sendVideoMessage(url: msg)
        // case .msgFile:
        //     sendFileMessage(url: msg)
        lib.sendMessage(msg: content, type: .msgText, consultId: consultId, replyMsgId: replyMsgId)
    }

    func sendImage(imageUrl: String, consultId: Int64, replyMsgId: Int64, result: @escaping FlutterResult) {
        lib.sendMessage(msg: imageUrl, type: .msgImg, consultId: consultId, replyMsgId: replyMsgId)
    }

    func sendVideo(videoUrl: String, consultId: Int64, replyMsgId: Int64, result: @escaping FlutterResult) {
        lib.sendMessage(msg: videoUrl, type: .msgVideo, consultId: consultId, replyMsgId: replyMsgId)
    }

    // 中断连接
    func disconnect() {
        lib.disConnect()
        // lib.delegate = nil
        print("连接已断开")
    }

    public func connected(c: Gateway_SCHi) {
        channelCallBack?.invokeMethod("connected", arguments: c.token)
    }

    public func msgDeleted(msg: TeneasyChatSDK_iOS.CommonMessage, payloadId: UInt64, errMsg: String?) {
        debugPrint("Message deleted: %@, Payload ID: %d, Error: %@", "\(msg)", payloadId, errMsg ?? "No error message")
        let arguments: [String: Any] = [
            "msgId": msg.msgID,
        ]
        channelCallBack?.invokeMethod("msgDeleted", arguments: arguments)
    }

    public func msgReceipt(msg: TeneasyChatSDK_iOS.CommonMessage, payloadId: UInt64, errMsg: String?) {
        debugPrint("Message receipt: MsgId: %@, Payload ID: %d", msg.msgID, payloadId)
        let arguments: [String: Any] = [
            "msgId": msg.msgID,
        ]
        channelCallBack?.invokeMethod("msgReceipt", arguments: arguments)
    }

    public func receivedMsg(msg: TeneasyChatSDK_iOS.CommonMessage) {
        debugPrint("Received message: Content: %@, Image URL: %@, MsgId: %@", "\(msg.content.data)", "\(msg.image.uri)", "\(msg.msgID)")
        let arguments: [String: Any] = [
            "content": msg.content.data,
            "imageUrl": msg.image.uri,
            "msgId": msg.msgID,
            "video": msg.video.uri,
            "replyMsgID": msg.replyMsgID,
        ]
        channelCallBack?.invokeMethod("receivedMsg", arguments: arguments)
    }

    public func systemMsg(result: TeneasyChatSDK_iOS.Result) {
        debugPrint("System message: Code: %d, Message: %@", result.Code, result.Message)
        let arguments: [String: Any] = [
            "code": result.Code,
            "msg": result.Message,
        ]
        channelCallBack?.invokeMethod("systemMsg", arguments: arguments)
    }

    public func workChanged(msg: Gateway_SCWorkerChanged) {
        debugPrint("Work changed: %@", "\(msg)")
    }
}
