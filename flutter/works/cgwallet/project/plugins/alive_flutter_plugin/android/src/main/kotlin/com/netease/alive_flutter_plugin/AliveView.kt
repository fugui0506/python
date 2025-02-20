package com.netease.alive_flutter_plugin


import android.content.Context
import android.graphics.Color
import android.util.DisplayMetrics
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * Created by hzhuqi on 2020/11/30
 */
class AliveView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView,
    MethodChannel.MethodCallHandler {
    private var cameraPreview: FrameLayout
    private var params: Map<String?, Any?>? = creationParams

    init {
        cameraPreview = LayoutInflater.from(context)
            .inflate(getLayoutId(context), null) as FrameLayout
    }

    fun getCameraView(): CircleCameraPreview {
        val cameraView: CircleCameraPreview = cameraPreview.findViewById(R.id.surface_view)
        val root: FrameLayout = cameraPreview.findViewById(R.id.root)
        params?.let {
            if (it.containsKey("width") && it.containsKey("height")) {
                val width = dpTpPx(cameraView, (it["width"] as Int).toFloat())
                val height = dpTpPx(cameraView, (it["height"] as Int).toFloat())
                val layoutParams = FrameLayout.LayoutParams(width.toInt(), height.toInt())
                layoutParams.gravity = Gravity.CENTER
                cameraView.layoutParams = layoutParams
            }

            if (it.containsKey("backgroundColor")) {
                root.setBackgroundColor(Color.parseColor(it["backgroundColor"] as String))
            }
        }
        return cameraView
    }

    fun destroy() {
        val root: FrameLayout = cameraPreview.findViewById(R.id.root)
        (root.parent as ViewGroup).removeView(root)
    }

    override fun getView(): View {
        return cameraPreview
    }

    override fun dispose() {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    }

    private fun getLayoutId(context: Context): Int {
        return context.resources.getIdentifier("preview_layout", "layout", context.packageName)
    }

    private fun dpTpPx(view: View, value: Float): Double {
        val dm: DisplayMetrics = view.resources.displayMetrics
        return (TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, dm) + 0.5)
    }
}