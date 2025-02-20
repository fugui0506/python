package com.netease.alive_flutter_plugin

import android.content.Context
import android.graphics.*
import android.os.Build
import android.util.AttributeSet
import com.netease.nis.alivedetected.NISCameraPreview
import kotlin.math.min

/**
 * @author liuxiaoshuai
 * @date 2021/10/18
 * @desc
 * @email liulingfeng@mistong.com
 */
class CircleCameraPreview : NISCameraPreview {
    /**
     * 剪切路径
     */
    private lateinit var clipPath: Path

    /**
     * 中心点坐标
     */
    private lateinit var centerPoint: Point

    constructor(context: Context?) : super(context) {
        init()
    }

    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs) {
        init()
    }

    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    ) {
        init()
    }

    private fun init() {
        this.isFocusable = true
        this.isFocusableInTouchMode = true
        clipPath = Path()
        centerPoint = Point()
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        // 坐标转换为实际像素
        val widthSize = MeasureSpec.getSize(widthMeasureSpec)
        val heightSize = MeasureSpec.getSize(heightMeasureSpec)
        // 计算出圆形的中心点
        centerPoint.x = widthSize shr 1
        centerPoint.y = heightSize shr 1
        // 计算出最短的边的一半作为半径
        /**
         * 半径
         */
        val radius = min(centerPoint.x, centerPoint.y)
        clipPath.reset()
        clipPath.addCircle(
            centerPoint.x.toFloat(),
            centerPoint.y.toFloat(),
            radius.toFloat(),
            Path.Direction.CCW
        )
        setMeasuredDimension(widthSize, heightSize)
    }

    override fun draw(canvas: Canvas) {
        //裁剪画布，并设置其填充方式
        canvas.drawFilter = PaintFlagsDrawFilter(
            0,
            Paint.ANTI_ALIAS_FLAG or Paint.FILTER_BITMAP_FLAG
        )
        if (Build.VERSION.SDK_INT >= 26) {
            canvas.clipPath(clipPath)
        } else {
            canvas.clipPath(clipPath, Region.Op.REPLACE)
        }
        super.draw(canvas)
    }
}