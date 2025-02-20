package com.netease.nis.captcha_plugin_flutter

import android.text.TextUtils
import com.netease.nis.captcha.CaptchaConfiguration

/**
 * @author liuxiaoshuai
 * @date 2022/7/21
 * @desc
 * @email liulingfeng@mistong.com
 */
object StyleSettingTools {
    fun setStyle(
        styleConfig: Map<String, Any?>,
        builder: CaptchaConfiguration.Builder
    ): CaptchaConfiguration.Builder {

        try {
            val radius = (styleConfig["radius"] ?: -1) as Int
            val capBarTextAlign = (styleConfig["capBarTextAlign"] ?: "") as String
            val capBarBorderColor = (styleConfig["capBarBorderColor"] ?: "") as String
            val capBarTextColor = (styleConfig["capBarTextColor"] ?: "") as String
            val capBarTextSize = (styleConfig["capBarTextSize"] ?: -1) as Int
            val capBarTextWeight = (styleConfig["capBarTextWeight"] ?: "") as String
            val capBarTitleHeight = (styleConfig["capBarTitleHeight"] ?: -1) as Int
            val capBodyPadding = (styleConfig["capBodyPadding"] ?: -1) as Int
            val capPaddingTop = (styleConfig["capPaddingTop"] ?: -1) as Int
            val capPaddingRight = (styleConfig["capPaddingRight"] ?: -1) as Int
            val capPaddingBottom = (styleConfig["capPaddingBottom"] ?: -1) as Int
            val capPaddingLeft = (styleConfig["capPaddingLeft"] ?: -1) as Int
            val paddingTop = (styleConfig["paddingTop"] ?: -1) as Int
            val paddingBottom = (styleConfig["paddingBottom"] ?: -1) as Int
            val capBorderRadius = (styleConfig["capBorderRadius"] ?: -1) as Int
            val borderColor = (styleConfig["borderColor"] ?: "") as String
            val background = (styleConfig["background"] ?: "") as String
            val borderColorMoving = (styleConfig["borderColorMoving"] ?: "") as String
            val backgroundMoving = (styleConfig["backgroundMoving"] ?: "") as String
            val borderColorSuccess = (styleConfig["borderColorSuccess"] ?: "") as String
            val backgroundSuccess = (styleConfig["backgroundSuccess"] ?: "") as String
            val backgroundError = (styleConfig["backgroundError"] ?: "") as String
            val borderColorError = (styleConfig["borderColorError"] ?: "") as String
            val slideBackground = (styleConfig["slideBackground"] ?: "") as String
            val textSize = (styleConfig["textSize"] ?: -1) as Int
            val textColor = (styleConfig["textColor"] ?: "") as String
            val height = (styleConfig["height"] ?: -1) as Int
            val borderRadius = (styleConfig["borderRadius"] ?: -1) as Int
            val gap = (styleConfig["gap"] ?: "") as String
            val executeBorderRadius = (styleConfig["executeBorderRadius"] ?: -1) as Int
            val executeBackground = (styleConfig["executeBackground"] ?: "") as String
            val executeTop = (styleConfig["executeTop"] ?: "") as String
            val executeRight = (styleConfig["executeRight"] ?: "") as String

            if (radius != -1) {
                builder.setRadius(radius)
            }
            if (!TextUtils.isEmpty(capBarTextAlign)) {
                builder.setCapBarTextAlign(capBarTextAlign)
            }
            if (!TextUtils.isEmpty(capBarBorderColor)) {
                builder.setCapBarBorderColor(capBarBorderColor)
            }
            if (!TextUtils.isEmpty(capBarTextColor)) {
                builder.setCapBarTextColor(capBarTextColor)
            }
            if (capBarTextSize != -1) {
                builder.setCapBarTextSize(capBarTextSize)
            }
            if (!TextUtils.isEmpty(capBarTextWeight)) {
                builder.setCapBarTextWeight(capBarTextWeight)
            }
            if (capBarTitleHeight != -1) {
                builder.setCapBarHeight(capBarTitleHeight)
            }
            if (capBodyPadding != -1) {
                builder.setCapPadding(capBodyPadding)
            }
            if (capPaddingTop != -1) {
                builder.setCapPaddingTop(capPaddingTop)
            }
            if (capPaddingRight != -1) {
                builder.setCapPaddingRight(capPaddingRight)
            }
            if (capPaddingBottom != -1) {
                builder.setCapPaddingBottom(capPaddingBottom)
            }
            if (capPaddingLeft != -1) {
                builder.setCapPaddingLeft(capPaddingLeft)
            }
            if (paddingTop != -1) {
                builder.setPaddingTop(paddingTop)
            }
            if (paddingBottom != -1) {
                builder.setPaddingBottom(paddingBottom)
            }
            if (capBorderRadius != -1) {
                builder.setImagePanelBorderRadius("${capBorderRadius}px")
            }
            if (!TextUtils.isEmpty(borderColor)) {
                builder.setControlBarBorderColor(borderColor)
            }
            if (!TextUtils.isEmpty(background)) {
                builder.setControlBarBackground(background)
            }
            if (!TextUtils.isEmpty(borderColorMoving)) {
                builder.setControlBarBorderColorMoving(borderColorMoving)
            }
            if (!TextUtils.isEmpty(backgroundMoving)) {
                builder.setControlBarBackgroundMoving(backgroundMoving)
            }
            if (!TextUtils.isEmpty(borderColorSuccess)) {
                builder.setControlBarBorderColorSuccess(borderColorSuccess)
            }
            if (!TextUtils.isEmpty(backgroundSuccess)) {
                builder.setControlBarBackgroundSuccess(backgroundSuccess)
            }
            if (!TextUtils.isEmpty(backgroundError)) {
                builder.setControlBarBackgroundError(backgroundError)
            }
            if (!TextUtils.isEmpty(borderColorError)) {
                builder.setControlBarBorderColorError(borderColorError)
            }
            if (!TextUtils.isEmpty(slideBackground)) {
                builder.setControlBarSlideBackground(slideBackground)
            }
            if (textSize != -1) {
                builder.setControlBarTextSize("${textSize}px")
            }
            if (!TextUtils.isEmpty(textColor)) {
                builder.setControlBarTextColor(textColor)
            }
            if (height != -1) {
                builder.setControlBarHeight("${height}px")
            }
            if (borderRadius != -1) {
                builder.setControlBarBorderRadius("${borderRadius}px")
            }
            if (!TextUtils.isEmpty(gap)) {
                builder.setGap(gap)
            }
            if (executeBorderRadius != -1) {
                builder.setExecuteBorderRadius("${executeBorderRadius}px")
            }
            if (!TextUtils.isEmpty(executeBackground)) {
                builder.setExecuteBackground(executeBackground)
            }
            if (!TextUtils.isEmpty(executeTop)) {
                builder.setExecuteTop(executeTop)
            }
            if (!TextUtils.isEmpty(executeRight)) {
                builder.setExecuteRight(executeRight)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return builder
    }

    fun string2LangType(langTypeStr: String): CaptchaConfiguration.LangType {
        return when (langTypeStr) {
            "am" -> {
                CaptchaConfiguration.LangType.LANG_AM
            }
            "ar" -> {
                CaptchaConfiguration.LangType.LANG_AR
            }
            "as" -> {
                CaptchaConfiguration.LangType.LANG_AS
            }
            "az" -> {
                CaptchaConfiguration.LangType.LANG_AZ
            }
            "be" -> {
                CaptchaConfiguration.LangType.LANG_BE
            }
            "bg" -> {
                CaptchaConfiguration.LangType.LANG_BG
            }
            "bn" -> {
                CaptchaConfiguration.LangType.LANG_BN
            }
            "bo" -> {
                CaptchaConfiguration.LangType.LANG_BO
            }
            "bs" -> {
                CaptchaConfiguration.LangType.LANG_BS
            }
            "ca" -> {
                CaptchaConfiguration.LangType.LANG_CA
            }
            "cs" -> {
                CaptchaConfiguration.LangType.LANG_CS
            }
            "da" -> {
                CaptchaConfiguration.LangType.LANG_DA
            }
            "de" -> {
                CaptchaConfiguration.LangType.LANG_DE
            }
            "el" -> {
                CaptchaConfiguration.LangType.LANG_EL
            }
            "en" -> {
                CaptchaConfiguration.LangType.LANG_EN
            }
            "en-GB" -> {
                CaptchaConfiguration.LangType.LANG_EN
            }
            "en-US" -> {
                CaptchaConfiguration.LangType.LANG_EN_US
            }
            "es" -> {
                CaptchaConfiguration.LangType.LANG_ES
            }
            "es-la" -> {
                CaptchaConfiguration.LangType.LANG_ES_LA
            }
            "et" -> {
                CaptchaConfiguration.LangType.LANG_ET
            }
            "eu" -> {
                CaptchaConfiguration.LangType.LANG_EU
            }
            "fa" -> {
                CaptchaConfiguration.LangType.LANG_FA
            }
            "fi" -> {
                CaptchaConfiguration.LangType.LANG_FI
            }
            "fr" -> {
                CaptchaConfiguration.LangType.LANG_FR
            }
            "gl" -> {
                CaptchaConfiguration.LangType.LANG_GL
            }
            "gu" -> {
                CaptchaConfiguration.LangType.LANG_GU
            }
            "hi" -> {
                CaptchaConfiguration.LangType.LANG_HI
            }
            "hr" -> {
                CaptchaConfiguration.LangType.LANG_HR
            }
            "hu" -> {
                CaptchaConfiguration.LangType.LANG_HU
            }
            "id" -> {
                CaptchaConfiguration.LangType.LANG_ID
            }
            "it" -> {
                CaptchaConfiguration.LangType.LANG_IT
            }
            "he" -> {
                CaptchaConfiguration.LangType.LANG_HE
            }
            "ja" -> {
                CaptchaConfiguration.LangType.LANG_JA
            }
            "jv" -> {
                CaptchaConfiguration.LangType.LANG_JV
            }
            "ka" -> {
                CaptchaConfiguration.LangType.LANG_KA
            }
            "kk" -> {
                CaptchaConfiguration.LangType.LANG_KK
            }
            "km" -> {
                CaptchaConfiguration.LangType.LANG_KM
            }
            "kn" -> {
                CaptchaConfiguration.LangType.LANG_KN
            }
            "ko" -> {
                CaptchaConfiguration.LangType.LANG_KO
            }
            "lo" -> {
                CaptchaConfiguration.LangType.LANG_LO
            }
            "lt" -> {
                CaptchaConfiguration.LangType.LANG_LT
            }
            "lv" -> {
                CaptchaConfiguration.LangType.LANG_LV
            }
            "mai" -> {
                CaptchaConfiguration.LangType.LANG_MAI
            }
            "mi" -> {
                CaptchaConfiguration.LangType.LANG_MI
            }
            "mk" -> {
                CaptchaConfiguration.LangType.LANG_MK
            }
            "ml" -> {
                CaptchaConfiguration.LangType.LANG_ML
            }
            "mn" -> {
                CaptchaConfiguration.LangType.LANG_MN
            }
            "mr" -> {
                CaptchaConfiguration.LangType.LANG_MR
            }
            "ms" -> {
                CaptchaConfiguration.LangType.LANG_MS
            }
            "my" -> {
                CaptchaConfiguration.LangType.LANG_MY
            }
            "no" -> {
                CaptchaConfiguration.LangType.LANG_NO
            }
            "ne" -> {
                CaptchaConfiguration.LangType.LANG_NE
            }
            "nl" -> {
                CaptchaConfiguration.LangType.LANG_NL
            }
            "or" -> {
                CaptchaConfiguration.LangType.LANG_OR
            }
            "pa" -> {
                CaptchaConfiguration.LangType.LANG_PA
            }
            "pl" -> {
                CaptchaConfiguration.LangType.LANG_PL
            }
            "pt" -> {
                CaptchaConfiguration.LangType.LANG_PT
            }
            "pt-br" -> {
                CaptchaConfiguration.LangType.LANG_PT_BR
            }
            "ro" -> {
                CaptchaConfiguration.LangType.LANG_RO
            }
            "ru" -> {
                CaptchaConfiguration.LangType.LANG_RU
            }
            "si" -> {
                CaptchaConfiguration.LangType.LANG_SI
            }
            "sk" -> {
                CaptchaConfiguration.LangType.LANG_SK
            }
            "sl" -> {
                CaptchaConfiguration.LangType.LANG_SL
            }
            "sr" -> {
                CaptchaConfiguration.LangType.LANG_SR
            }
            "sv" -> {
                CaptchaConfiguration.LangType.LANG_SV
            }
            "sw" -> {
                CaptchaConfiguration.LangType.LANG_SW
            }
            "ta" -> {
                CaptchaConfiguration.LangType.LANG_TA
            }
            "te" -> {
                CaptchaConfiguration.LangType.LANG_TE
            }
            "th" -> {
                CaptchaConfiguration.LangType.LANG_TH
            }
            "fil" -> {
                CaptchaConfiguration.LangType.LANG_FIL
            }
            "tr" -> {
                CaptchaConfiguration.LangType.LANG_TR
            }
            "ug" -> {
                CaptchaConfiguration.LangType.LANG_UG
            }
            "uk" -> {
                CaptchaConfiguration.LangType.LANG_UK
            }
            "ur" -> {
                CaptchaConfiguration.LangType.LANG_UR
            }
            "uz" -> {
                CaptchaConfiguration.LangType.LANG_UZ
            }
            "vi" -> {
                CaptchaConfiguration.LangType.LANG_VI
            }
            "zh-CN" -> {
                CaptchaConfiguration.LangType.LANG_ZH_CN
            }
            "zh-HK" -> {
                CaptchaConfiguration.LangType.LANG_ZH_HK
            }
            "zh-TW" -> {
                CaptchaConfiguration.LangType.LANG_ZH_TW
            }
            else -> CaptchaConfiguration.LangType.LANG_ZH_CN
        }
    }
}