package com.netease.alive_flutter_plugin

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * Created by hzhuqi on 2020/11/30
 */
class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    lateinit var aliveView: AliveView

    override fun create(
        context: Context?,
        viewId: Int,
        args: Any?
    ): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        aliveView = AliveView(context!!, viewId, creationParams)
        return aliveView
    }
}