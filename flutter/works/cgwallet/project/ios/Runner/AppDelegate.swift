import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // 初始化图片处理通道
        let channelImageHandler = FlutterMethodChannel(name: "com.cgwallet.app.channel/image", binaryMessenger: flutterViewController.binaryMessenger)
        channelImageHandler.setMethodCallHandler { [weak self] (call, result) in
            ChannelImageHandler.handler(call, result: result)
        }

        // 初始化起聊SDK通道
        let channelQichatHandler = FlutterMethodChannel(name: "com.cgwallet.app.channel/qichat", binaryMessenger: flutterViewController.binaryMessenger)
        channelQichatHandler.setMethodCallHandler { [weak self] (call, result) in
            ChannelQichatHandler.handler(call, result: result)
        }
        
        // 注册其他插件
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
