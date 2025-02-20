import Flutter
import UIKit
import Photos

class ChannelImageHandler {
    static func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let channel = ChannelImageHandler()
        switch call.method {
            case "saveImageToGallery":
                guard let args = call.arguments as? [String: Any],
                      let imagePath = args["path"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Image path is required", details: nil))
                    return
                }
                channel.saveImageToGallery(imagePath: imagePath, result: result)
            case "decodeQRCode":
                NSLog("Base URL for line detection:------------asdf-asf-sa-fsa-fsa-fs-afss")

                guard let args = call.arguments as? [String: Any],
                      let imagePath = args["path"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Image path is required", details: nil))
                    return
                }
                channel.decodeQRCode(from: imagePath, result: result)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    private func saveImageToGallery(imagePath: String, result: @escaping FlutterResult) {
        guard let url = URL(string: imagePath) else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid image path", details: nil))
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
        }) { success, error in
            if success {
                result(true)
            } else {
                let errorMessage = error?.localizedDescription ?? "Unknown error"
                result(FlutterError(code: "SAVE_FAILED", message: "Failed to save image: \(errorMessage)", details: nil))
            }
        }
    }
    
    private func decodeQRCode(from path: String, result: @escaping FlutterResult) {
        guard let image = UIImage(contentsOfFile: path) else {
            result(FlutterError(code: "IMAGE_ERROR", message: "Cannot load image from path", details: nil))
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let ciImage = CIImage(image: image)
        let features = detector?.features(in: ciImage!) as? [CIQRCodeFeature]
        let qrCodeMessages = features?.compactMap { $0.messageString }
        
        if let message = qrCodeMessages?.first {
            result(message)
        } else {
            result(FlutterError(code: "QR_CODE_NOT_FOUND", message: "No QR code found in the image", details: nil))
        }
    }
}
