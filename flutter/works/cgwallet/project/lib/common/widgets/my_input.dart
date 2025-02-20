import 'dart:async';
import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyInput extends StatelessWidget {
  const MyInput({
    super.key,
    this.controller,
    this.focusNode,
    this.maxLines,
    this.textInputAction,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.obscureText = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.onTap,
    this.autofocus = false,
    this.enabled,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 0),
    this.color,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.errorText,
    this.maxLength,
    this.inputFormatters,
    this.border,
    this.minLines,
    this.buildCounter,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final bool obscureText;
  final BorderRadiusGeometry borderRadius;
  final void Function()? onTap;
  final bool autofocus;
  final bool? enabled;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final TextAlign textAlign;
  final void Function(String)? onChanged;
  final String? errorText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter;

  /// 账号输入框
  /// 普通的输入框，可以清除内容
  factory MyInput.normal(TextEditingController controller, FocusNode focusNode, {
    String? hintText, 
    Widget? prefixIcon, 
    Color? color,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    final showSuffixIcon = false.obs;

    if (controller.text.isNotEmpty) {
      showSuffixIcon.value = true;
    }

    final suffixIcon = Obx(() => showSuffixIcon.value
      ? MyButton.icon(
          onPressed: () {
            controller.text = '';
            showSuffixIcon.value = false;
            // if (!focusNode.hasFocus) focusNode.requestFocus();
          }, 
          icon: Get.theme.myIcons.inputClear,
        )
      : const SizedBox());

    void onChanged(String text) {
      if (text.isEmpty) {
        showSuffixIcon.value = false;
      } else {
        showSuffixIcon.value = true;
      }
    }

    final prefixIconDefault = SizedBox(width: 40, height: 40, child: Center(
      child:SizedBox(width: 20, height: 20, child: Get.theme.myIcons.inputPerson)
    ));

    return MyInput(
      color: color ?? Get.theme.myColors.input,
      controller: controller, 
      focusNode: focusNode,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      prefixIcon: prefixIcon ?? prefixIconDefault,
      suffixIcon: suffixIcon,
      hintText: hintText ?? Lang.inputAccountHintText.tr,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      maxLines: 1,
      maxLength: maxLength,
      buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
        return null;
      },
    );
  }

  /// 密码输入框
  static Widget password(TextEditingController controller, FocusNode focusNode, String hintText, {Widget? icon, TextInputType keyboardType = TextInputType.visiblePassword, int? maxLength}) {
    final showSuffixIcon = false.obs;
    final obscureText = true.obs;

    if (controller.text.isNotEmpty) {
      showSuffixIcon.value = true;
    }

    void onChanged(String text) {
      if (text.isEmpty) {
        showSuffixIcon.value = false;
      } else {
        showSuffixIcon.value = true;
      }
    }

    final showIcon = MyButton.icon(
      onPressed: () {
        obscureText.value = false;
        // if (!focusNode.hasFocus) focusNode.requestFocus();
      }, 
      icon: Get.theme.myIcons.inputShow,
    );

    final hideIcon = MyButton.icon(
      onPressed: () {
        obscureText.value = true;
        // if (!focusNode.hasFocus) focusNode.requestFocus();
      }, 
      icon: Get.theme.myIcons.inputHide,
    );

    

    final prefixIcon = SizedBox(width: 40, height: 40, child: Center(
      child:SizedBox(width: 20, height: 20, child: icon ?? Get.theme.myIcons.inputPassword)
    ));

    return Obx(() => MyInput(
      color: Get.theme.myColors.input,
      obscureText: obscureText.value,
      controller: controller, 
      focusNode: focusNode,
      keyboardType: keyboardType,
      prefixIcon: prefixIcon,
      suffixIcon: showSuffixIcon.value 
        ? obscureText.value ? showIcon : hideIcon
        : null,
      hintText: hintText,
      onChanged: onChanged,
      maxLines: 1,
      maxLength: maxLength,
      buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
        return null;
      },
    ));
  }

  /// 可以输入全部的输入框
  factory MyInput.amountAll(TextEditingController controller, FocusNode focusNode, {String? hintText, void Function()? onPressed, bool enabled = true}) {
    final showSuffixIcon = false.obs;

    if (controller.text.isNotEmpty) {
      showSuffixIcon.value = true;
    }

    void onChanged(String text) {
      if (text.isEmpty) {
        showSuffixIcon.value = false;
      } else {
        showSuffixIcon.value = true;
      }
    }

    final suffixIcon = SizedBox(width: 120, height: 40, child: Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Obx(() => showSuffixIcon.value
          ? MyButton.icon(
              onPressed: () {
                controller.text = '';
                showSuffixIcon.value = false;
                // if (!focusNode.hasFocus) focusNode.requestFocus();
              }, 
              icon: Get.theme.myIcons.inputClear,
            )
          : const SizedBox()
        ),
        MyButton.text(onPressed: () {
          onPressed?.call();
          onChanged(controller.text);
        }, text: Lang.buyOrderViewAll.tr, textColor: Get.theme.myColors.primary),
        const SizedBox(width: 4),
      ]),
    ));

    

    return MyInput(
      color: Get.theme.myColors.cardBackground,
      controller: controller, 
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      suffixIcon: suffixIcon,
      hintText: hintText ?? Lang.inputAccountHintText.tr,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      enabled: enabled,
      maxLines: 1,
    );
  }

  /// 图片验证码
  /// 点击验证码可以重新请求
  factory MyInput.captcha(TextEditingController controller, FocusNode focusNode, Rx<CaptchaModel> source) {
    final loading = false.obs;

    Future<void> getCaptcha() async {
      await source.value.update();
      source.refresh();
    }

    void onLoading() async {
      loading.value = true;
      await getCaptcha();
      loading.value = false;
    }

    final prefixIcon = SizedBox(width: 40, height: 40, child: Center(
      child:SizedBox(width: 20, height: 20, child: Get.theme.myIcons.inputCode)
    ));

    final suffixIcon = Obx(() => MyButton.widget(
      onPressed: loading.value ? null : onLoading,
      child: loading.value
        ? MyCard(borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: Get.theme.myColors.onBackground.withOpacity( 0.05),
            width: 100,
            height: 40,
            child: Center(child: Get.theme.myIcons.loadingIcon)
          )
       : source.value.picPath.isNotEmpty
          ? Image.memory(base64Decode(source.value.picPath.split(',').last),
              height: 40,
              width: 100,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            )
          : MyButton.filedLong(
              textColor: Get.theme.myColors.primary,
              color: Get.theme.myColors.onBackground.withOpacity( 0.05),
              onPressed: onLoading, 
              text: Lang.inputCaptchaSendText.tr,
            )
      ));

    return MyInput(
      controller: controller, 
      color: Get.theme.myColors.input,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: Lang.inputCaptchaHintText.tr,
      maxLines: 1,
    );
  }

  /// 手机号码
  /// 有手机验证码发送按钮
  /// 账号输入框
  factory MyInput.phone(TextEditingController controller, FocusNode focusNode) {
    final showSuffixIcon = false.obs;

    if (controller.text.isNotEmpty) {
      showSuffixIcon.value = true;
    }

    final suffixIcon = Obx(() => showSuffixIcon.value
      ? MyButton.icon(
          onPressed: () {
            controller.text = '';
            showSuffixIcon.value = false;
            // if (!focusNode.hasFocus) focusNode.requestFocus();
          }, 
          icon: Get.theme.myIcons.inputClear,
        )
      : const SizedBox());

    void onChanged(String text) {
      if (text.isEmpty) {
        showSuffixIcon.value = false;
      } else {
        showSuffixIcon.value = true;
      }
    }

    final prefixIcon = SizedBox(width: 40, height: 40, child: Center(
      child:SizedBox(width: 20, height: 20, child: Get.theme.myIcons.inputPhone)
    ));

    return MyInput(
      controller: controller, 
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
      color: Get.theme.myColors.input,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: Lang.inputPhoneHintText.tr,
      onChanged: onChanged,
      maxLines: 1,
    );
  }

  /// 手机号码
  /// 有手机验证码发送按钮
  /// 账号输入框
  factory MyInput.phoneSendCode(TextEditingController controller, FocusNode focusNode, {String? hintText, bool isCheck = false, required RxBool loading, required RxInt codeTimer}) {
    Timer? timer;
    String code = '';

    void stopTimer() {
      timer?.cancel();
      timer = null;
      codeTimer.value = 0;
    }

    void startTimer() {
      stopTimer();
      codeTimer.value = 60;
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          codeTimer.value--;
          if (codeTimer.value <= 0) {
            stopTimer();
            loading.value = false;
          }
        },
      );
    }

    Future<void> response({required String validate}) async {
      return UserController.to.dio?.post(ApiPath.base.sendSms1,
        onSuccess: (code, msg, results) {
          startTimer();
          MyAlert.snackbar(msg);
        },
        data: {
          'phone': controller.text,
          'validate': validate,
        },
        onError: () async {
          loading.value = false;
        },
      );
    }

    void onChanged(String value) {
      if (value.isEmpty) {
        loading.value = true;
      } else {
        loading.value = false;
      }
    }

    Future<void> sendSms() async {
      showCaptcha(
        onSuccess: (value) async {
          code = value;
          if (value.isNotEmpty) {
            await response(validate: value);
          }
        },
        onClose: () async {
          await Future.delayed(const Duration(seconds: 3));
          if (code.isEmpty) {
            loading.value = false;
          }
        },
        onError: () {
          loading.value = false;
        },
      );
    }



    void onLoading() async {
      Get.focusScope?.unfocus();
      loading.value = true;
      await sendSms();
    }

    final prefixIcon = SizedBox(width: 40, height: 40, child: Center(
        child:SizedBox(width: 20, height: 20, child: Get.theme.myIcons.newPhone)
    ));

    final suffixIcon = SizedBox(height: 40, child: Padding(padding: const EdgeInsets.all(4),
        child: Obx(() => MyButton.filedShort(
          textColor: loading.value ? Get.theme.myColors.onButtonDisable : Get.theme.myColors.onPrimary,
          color: loading.value ? Get.theme.myColors.buttonDisable : Get.theme.myColors.primary,
          onPressed: loading.value ? null : onLoading,
          text: loading.value && codeTimer.value > 0 ? '${codeTimer.value}' : Lang.inputSendSmsButtonText2.tr,
        ))));

    return MyInput(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      color: Get.theme.myColors.input,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText ?? Lang.inputPhoneCodeHintText.tr,
      maxLines: 1,
      onChanged: onChanged
    );
  }

  /// 手机验证码
  /// 集成发送验证码功能
  factory MyInput.phoneCode(TextEditingController controller, FocusNode focusNode, {String? phone, TextEditingController? phoneController,}) {
    final loading = false.obs;
    final codeTimer = 0.obs;
    Timer? timer;

    void stopTimer() {
      timer?.cancel();
      timer = null;
      codeTimer.value = 0;
    }

    void startTimer() {
      stopTimer();
      const oneSec = Duration(seconds: 1);
      codeTimer.value = 60;
      timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          codeTimer.value--;
          if (codeTimer <= 0) {
            stopTimer();
            loading.value = false;
            codeTimer.value = 0;
          }
        },
      );
    }

    Future<void> sendSms() async {
      await UserController.to.dio?.post(ApiPath.base.sendSms,
        onSuccess: (code, msg, results) {
          startTimer();
          MyAlert.snackbar('短信已成功发送');
        },
        data: {
          'phone': phoneController == null ? phone ?? '' : phoneController.text,
        },
        onError: () async {
          loading.value = false;
        },
      );
    }

    void onLoading() async {
      loading.value = true;
      await sendSms();
    }

    final prefixIcon = SizedBox(width: 40, height: 40, child: Center(
      child:SizedBox(width: 20, height: 20, child: Get.theme.myIcons.inputCode)
    ));

    final suffixIcon = SizedBox(height: 40, child: Padding(padding: const EdgeInsets.all(4),
      child: Obx(() => MyButton.filedShort(
      textColor: loading.value ? Get.theme.myColors.onButtonDisable : Get.theme.myColors.onSecondary,
      color: loading.value ? Get.theme.myColors.buttonDisable : Get.theme.myColors.secondary,
      onPressed: loading.value ? null : onLoading, 
      text: loading.value && codeTimer.value > 0 ? '${codeTimer.value}' : Lang.inputSendSmsButtonText.tr,
    ))));

    return MyInput(
      controller: controller, 
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      color: Get.theme.myColors.input,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: Lang.inputPhoneCodeHintText.tr,
      maxLines: 1,
    );
  }

  factory MyInput.textIcon(TextEditingController controller, FocusNode focusNode, {
    bool enabled = true, 
    required String title, 
    required String hintText, 
    List<TextInputFormatter>? inputFormatters, 
    TextInputType? keyboardType,
  }) {
    final prefixIcon = Padding(padding: const EdgeInsets.all(16), child: Text(title, style: Get.theme.myStyles.inputBankTitle));

    return MyInput(
      enabled: enabled,
      controller: controller, 
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      keyboardType: keyboardType,
      borderRadius: BorderRadius.circular(10),
      prefixIcon: prefixIcon,
      hintText: hintText,
      color: Get.theme.myColors.inputBank,
      textAlign: TextAlign.end,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Get.theme.myColors.inputBank,
          width: 0.8,
        ),
      ),
      maxLines: 1,
    );
  }

  factory MyInput.search(TextEditingController controller, FocusNode focusNode, String hintText, MyButton searchButton) {
    final prefixIcon = SizedBox(width: 40, height: 40, child: Center(
      child:SizedBox(width: 20, height: 20, child: Get.theme.myIcons.inputSearch)
    ));
    final suffixIcon = SizedBox(height: 40, child: Padding(padding: const EdgeInsets.all(4), child: searchButton));
    return MyInput(
      controller: controller, 
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      borderRadius: BorderRadius.circular(10),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
      color: Get.theme.myColors.input,
      textAlign: TextAlign.start,
      maxLines: 1,
    );
  }

  factory MyInput.amount(TextEditingController controller, FocusNode focusNode, String hintText) {
    return MyInput(
      controller: controller, 
      padding: const EdgeInsets.all(16), 
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      border: OutlineInputBorder(
        borderSide: BorderSide.none, 
        borderRadius: BorderRadius.circular(10)
      ),
      borderRadius: BorderRadius.circular(10),
      hintText: hintText,
      color: Get.theme.myColors.input.withOpacity( 0),
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLines: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: textInputAction,
      scrollPadding: EdgeInsets.zero,
      maxLength: maxLength,
      focusNode: focusNode,
      controller: controller,
      onSubmitted: (value) => Get.focusScope?.unfocus(),
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      buildCounter: buildCounter,
      decoration: InputDecoration(
        fillColor: color,
        filled: true,
        isDense: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: padding,
        hintText: hintText,
        hintStyle: Get.theme.myStyles.inputHint,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Get.theme.myColors.primary,
            width: 0.8,
          ),
        ),
        enabledBorder: border ?? OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Get.theme.myColors.inputBorder,
            width: 0.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Get.theme.myColors.error,
            width: 0.8,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Get.theme.myColors.error,
            width: 0.8,
          ),
        ),
        errorText: errorText,
        errorStyle: Get.theme.myStyles.inputError,
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: color ?? Get.theme.myColors.inputBorder.withOpacity( 0),
            width: 0.8,
          ),
        ),
      ),
      obscureText: obscureText,
      onTap: onTap,
      cursorColor: Get.theme.myColors.primary,
      cursorWidth: 1.6,
      style: Get.theme.myStyles.inputText,
      autofocus: autofocus,
      enabled: enabled,
      textAlign: textAlign,
      textAlignVertical: TextAlignVertical.center,
      minLines: minLines,
    );
  }
}