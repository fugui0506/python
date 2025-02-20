package com.netease.nis.captcha_plugin_flutter

import android.app.Activity
import android.text.TextUtils
import android.util.Log
import com.netease.nis.captcha.Captcha
import com.netease.nis.captcha.CaptchaConfiguration
import com.netease.nis.captcha.CaptchaListener
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

/**
 * Created by hzhuqi on 2020/9/21
 */
class CaptchaHelper : CoroutineScope by MainScope() {
    var events: EventChannel.EventSink? = null

    fun init(activity: Activity, call: MethodCall) {
        try {
            val captchaId = call.argument<String>("captcha_id")
            val isDebug = call.argument<Boolean>("is_debug") ?: false //是否开启debug模式
            val dimAmount = call.argument<Double>("dimAmount") ?: 0.5 //弹窗透明度
            val controlBarStartUrl =
                call.argument<String>("control_bar_start_url") ?: "" //自定义滑块开始背景
            val controlBarMovingUrl =
                call.argument<String>("control_bar_moving_url") ?: ""//自定义滑块滑动背景
            val controlBarErrorUrl =
                call.argument<String>("control_bar_error_url") ?: "" //自定义滑块错误背景
            val isTouchOutsideDisappear =
                call.argument<Boolean>("is_touch_outside_disappear") ?: true //点击弹窗外部是否可以关闭验证码
            val timeout = call.argument<Int>("timeout") ?: (1000 * 10) //超时时间
            val isHideCloseBtn = call.argument<Boolean>("is_hide_close_button") ?: false //是否隐藏关闭按钮
            val useDefaultFallback =
                call.argument<Boolean>("use_default_fallback") ?: true //是否采用默认降级
            val failedMaxRetryCount = call.argument<Int>("failed_max_retry_count") ?: 3 //失败后尝试最大次数
            val languageType = call.argument<String>("language_type") ?: "" //多语言语言类型
            val theme = call.argument<String>("theme") ?: "light" // 主题
            val loadingText = call.argument<String>("loading_text") ?: ""// 加载文案
            val apiServer = call.argument<String>("api_server") ?: "" // 私有化接口
            val staticServer = call.argument<String>("static_server") ?: "" // 私有化资源
            val isShowLoading = call.argument<Boolean>("is_show_loading") ?: true // 是否显示loading
            val isCloseButtonBottom =
                call.argument<Boolean>("is_close_button_bottom") ?: false // 关闭按钮是否在下方

            val isMourningDay = call.argument<Boolean>("is_mourning_day") ?: false // 是否黑白模式
            val size = call.argument<String>("size") ?: "" // 适老化字体大小设置
            val refreshInterval = call.argument<Int>("refreshInterval") ?: 300 // 错误提示时长
            val isIpv6 = call.argument<Boolean>("isIpv6") ?: false // 网络是否ipv6
            val isShowInnerClose =
                call.argument<Boolean>("is_show_inner_close") ?: false // 是否显示验证码内部关闭按钮
            val canUpload = call.argument<Boolean>("can_upload") ?: true // 是否支持数据上报和崩溃收集

            val styleConfig = call.argument<Map<String, Any?>>("styleConfig") // 高级ui设置

            if (captchaId != null) {
                val builder = CaptchaConfiguration.Builder()
                builder.captchaId(captchaId)
                builder.listener(captchaListener)
                builder.debug(isDebug)
                builder.timeout(timeout.toLong())
                builder.backgroundDimAmount(dimAmount.toFloat())
                builder.failedMaxRetryCount(failedMaxRetryCount)
                if (!TextUtils.isEmpty(controlBarMovingUrl) &&
                    !TextUtils.isEmpty(controlBarStartUrl) &&
                    !TextUtils.isEmpty(
                        controlBarErrorUrl
                    )
                ) {
                    builder.controlBarImageUrl(
                        controlBarStartUrl,
                        controlBarMovingUrl,
                        controlBarErrorUrl
                    )
                }
                builder.touchOutsideDisappear(isTouchOutsideDisappear)
                builder.useDefaultFallback(useDefaultFallback)
                builder.hideCloseButton(isHideCloseBtn)
                builder.isShowLoading(isShowLoading)
                builder.isCloseButtonBottom(isCloseButtonBottom)
                if (!TextUtils.isEmpty(languageType)) {
                    builder.languageType(StyleSettingTools.string2LangType(languageType))
                }
                builder.theme(
                    if ("light" == theme)
                        CaptchaConfiguration.Theme.LIGHT
                    else
                        CaptchaConfiguration.Theme.DARK
                )
                if (!TextUtils.isEmpty(loadingText)) {
                    builder.loadingText(loadingText)
                }
                if (!TextUtils.isEmpty(apiServer)) {
                    builder.apiServer(apiServer)
                }
                if (!TextUtils.isEmpty(staticServer)) {
                    builder.staticServer(staticServer)
                }

                builder.isMourningDay(isMourningDay)
                if (!TextUtils.isEmpty(size)) {
                    builder.size(size)
                }

                builder.setRefreshInterval(refreshInterval)
                builder.ipv6(isIpv6)
                builder.isShowInnerClose(isShowInnerClose)
                builder.canUpload(canUpload)
                if (styleConfig != null) {
                    StyleSettingTools.setStyle(styleConfig, builder)
                }
                Captcha.getInstance().init(builder.build(activity))
                Log.i("CaptchaHelper", "初始化成功")
            } else {
                Log.e("CaptchaHelper", "业务id必须传")
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun showCaptcha() {
        Captcha.getInstance().validate()
    }

    fun destroy() {
        Captcha.getInstance().destroy()
    }

    private var captchaListener: CaptchaListener = object : CaptchaListener {
        override fun onValidate(result: String?, validate: String?, msg: String?) {
            val data = HashMap<String, Any?>()
            data["validate"] = validate
            data["result"] = result
            data["message"] = msg
            sendEventData("onSuccess", data)
        }

        override fun onError(code: Int, msg: String?) {
            val data = HashMap<String, Any?>()
            data["code"] = code
            data["message"] = msg
            sendEventData("onError", data)
        }

        override fun onClose(closeType: Captcha.CloseType?) {
            val data = HashMap<String, Any?>()
            closeType?.let {
                if (it == Captcha.CloseType.VERIFY_SUCCESS_CLOSE) {
                    data["message"] = "auto"
                } else {
                    data["message"] = "manual"
                }
            }
            sendEventData("onClose", data)
        }

        override fun onCaptchaShow() {
            sendEventData("onLoaded", null)
        }
    }

    private fun sendEventData(method: String, data: Map<String, Any?>?) {
        try {
            val eventData = HashMap<String, Any?>()
            eventData["method"] = method
            if (data != null) {
                eventData["data"] = data
            }
            launch(Dispatchers.Main) {
                events?.success(eventData)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}