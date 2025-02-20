package com.cgwallet.app.cgwallet100

import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.provider.MediaStore
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.barcode.BarcodeScanning
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class ChannelImageHandler(private val context: Context) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveImageToGallery" -> {
                val imagePath = call.argument<String>("path")
                if (imagePath != null) {
                    saveImageToGallery(imagePath, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }
            "decodeQRCode" -> {
                val imagePath = call.argument<String>("path")
                if (imagePath != null) {
                    decodeQRCode(imagePath, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is required", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun saveImageToGallery(imagePath: String, result: MethodChannel.Result) {
        try {
            val file = File(imagePath)
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, file.name)
                put(MediaStore.Images.Media.MIME_TYPE, "image/png")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Wallet")
                    put(MediaStore.Images.Media.IS_PENDING, 1)
                }
            }

            val resolver = context.contentResolver
            val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)

            uri?.let { contentUri ->
                resolver.openOutputStream(contentUri)?.use { outputStream ->
                    FileInputStream(file).use { inputStream ->
                        inputStream.copyTo(outputStream)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        values.clear()
                        values.put(MediaStore.Images.Media.IS_PENDING, 0)
                        resolver.update(contentUri, values, null, null)
                    }

                    result.success(true)
                } ?: run {
                    result.error("SAVE_FAILED", "Failed to open output stream", null)
                }
            } ?: run {
                result.error("SAVE_FAILED", "Failed to create new MediaStore record", null)
            }
        } catch (e: Exception) {
            result.error("SAVE_FAILED", "Exception occurred: ${e.message}", null)
        }
    }

    private fun decodeQRCode(imagePath: String, result: MethodChannel.Result) {
        try {
            val file = File(imagePath)
            val bitmap = BitmapFactory.decodeFile(file.absolutePath)

            val image = InputImage.fromBitmap(bitmap, 0)
            val scanner = BarcodeScanning.getClient()

            scanner.process(image)
                .addOnSuccessListener { barcodes ->
                    if (barcodes.isNotEmpty()) {
                        val barcode = barcodes.first()
                        result.success(barcode.rawValue)
                    } else {
                        result.error("QR_CODE_NOT_FOUND", "No QR code found in the image", null)
                    }
                }
                .addOnFailureListener {
                    result.error("QR_CODE_DECODE_FAILED", "Failed to decode QR code: ${it.message}", null)
                }
        } catch (e: Exception) {
            result.error("DECODE_FAILED", "Exception occurred: ${e.message}", null)
        }
    }
}
