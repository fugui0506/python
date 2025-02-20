class CaptchaPluginConfig {
  // 验证码圆角
  int? radius;

  // 弹框头部标题文字对齐方式，可选值为 left center right
  final String? capBarTextAlign;

  // 弹框头部下边框颜色，想要去掉的话可取 transparent 或者与背景色同色 #fff
  final String? capBarBorderColor;

  // 弹框头部标题文字颜色
  final String? capBarTextColor;

  // 弹框头部标题文字字体大小
  final int? capBarTextSize;

  // 弹框头部标题文字字体体重，可设置粗细，
  // 参考：capBarTextWeight: normal、bold、lighter、bolder、100、200、300、400``、500、600、700、800、900
  // 更多详情参考：https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight``
  final String? capBarTextWeight;

  // 弹框头部标题所在容器高度
  final int? capBarTitleHeight;

  // 验证码弹框 body 部分的内边距，相当于总体设置 capPaddingTop，capPaddingRight，capPaddingBottom，capPaddingLeft
  final int? capBodyPadding;

  // 验证码弹框 body 部分的【上】内边距，覆盖 capPadding 对于上内边距的设置,单位px
  final int? capPaddingTop;

  // 验证码弹框 body 部分的【右】内边距，覆盖 capPadding 对于右内边距的设置,单位px
  final int? capPaddingRight;

  // 验证码弹框 body 部分的【底】内边距，覆盖 capPadding 对于底内边距的设置,单位px
  final int? capPaddingBottom;

  // 验证码弹框 body 部分的【左】内边距，覆盖 capPadding 对于左内边距的设置,单位px
  final int? capPaddingLeft;

  // 弹框【上】内边距，实践时候可与 capPaddingTop 配合,单位px
  final int? paddingTop;

  // 弹框【下】内边距，实践时候可与 capPaddingBottom 配合,单位px
  final int? paddingBottom;

  // 验证码弹框body圆角
  final int? capBorderRadius;

  // 滑块的边框颜色
  final String? borderColor;

  // 滑块的背景颜色
  final String? background;

  // 滑块的滑动时边框颜色，滑动类型验证码下有效
  final String? borderColorMoving;

  // 滑块的滑动时背景颜色，滑动类型验证码下有效
  final String? backgroundMoving;

  // 滑块的成功时边框颜色，此颜色同步了文字成功时文字颜色、滑块背景颜色
  final String? borderColorSuccess;

  // 滑块的成功时背景颜色
  final String? backgroundSuccess;

  // 滑块的失败时背景颜色
  final String? backgroundError;

  // 失败时边框颜色
  final String? borderColorError;

  // 滑块的滑块背景颜色
  final String? slideBackground;

  // 滑块的内容文本大小
  final int? textSize;

  // 滑块内容文本颜色（滑块滑动前的颜色，失败、成功前的颜色）
  final String? textColor;

  // 滑块的高度
  final int? height;

  // 滑块的圆角
  final int? borderRadius;

  // 滑块与验证码视图之间的距离,单位px
  final String? gap;

  // 组件圆角大小
  final int? executeBorderRadius;

  // 组件背景色
  final String? executeBackground;

  // 组件外层容器距离组件顶部距离,单位px
  final String? executeTop;

  // 组件外层容器距离组件右侧距离,单位px
  final String? executeRight;

  CaptchaPluginConfig ({
    this.radius,
    this.capBarTextAlign,
    this.capBarBorderColor,
    this.capBarTextColor,
    this.capBarTextSize,
    this.capBarTextWeight,
    this.capBarTitleHeight,
    this.capBodyPadding,
    this.capPaddingTop,
    this.capPaddingRight,
    this.capPaddingBottom,
    this.capPaddingLeft,
    this.paddingTop,
    this.paddingBottom,
    this.capBorderRadius,
    this.borderColor,
    this.background,
    this.borderColorMoving,
    this.backgroundMoving,
    this.borderColorSuccess,
    this.backgroundSuccess,
    this.backgroundError,
    this.borderColorError,
    this.slideBackground,
    this.textSize,
    this.textColor,
    this.height,
    this.borderRadius,
    this.gap,
    this.executeBorderRadius,
    this.executeBackground,
    this.executeTop,
    this.executeRight,
  });

  Map<String, dynamic> toJson() {
    return {
      'radius': radius,
      'capBarTextAlign': capBarTextAlign,
      'capBarBorderColor': capBarBorderColor,
      'capBarTextColor': capBarTextColor,
      'capBarTextSize': capBarTextSize,
      'capBarTextWeight': capBarTextWeight,
      'capBarTitleHeight': capBarTitleHeight,
      'capBodyPadding': capBodyPadding,
      'capPaddingTop': capPaddingTop,
      'capPaddingRight': capPaddingRight,
      'capPaddingBottom': capPaddingBottom,
      'capPaddingLeft': capPaddingLeft,
      'paddingTop': paddingTop,
      'paddingBottom': paddingBottom,
      'capBorderRadius': capBorderRadius,
      'borderColor': borderColor,
      'background': background,
      'borderColorMoving': borderColorMoving,
      'backgroundMoving': backgroundMoving,
      'borderColorSuccess': borderColorSuccess,
      'backgroundSuccess': backgroundSuccess,
      'backgroundError': backgroundError,
      'borderColorError': borderColorError,
      'slideBackground': slideBackground,
      'textSize': textSize,
      'textColor': textColor,
      'height': height,
      'borderRadius': borderRadius,
      'gap': gap,
      'executeBorderRadius': executeBorderRadius,
      'executeBackground': executeBackground,
      'executeTop': executeTop,
      'executeRight': executeRight,
    }..removeWhere((key, value) => value == null);
  }
}