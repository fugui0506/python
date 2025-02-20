import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

import '../widgets/my_alert.dart';

extension StringExtension on String {
  /// 加密
  String encrypt(String keyStr) {
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.ecb,
      padding: 'PKCS7',
    ));

    final encrypted = encrypter.encrypt(this, iv: iv);
    return encrypted.base64;
  }

  /// 解密
  String decrypt(String keyStr) {
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.ecb,
      padding: 'PKCS7',
    ));

    final decrypted = encrypter.decrypt(Encrypted.fromBase64(this), iv: iv);
    return decrypted;
  }

  /// 加密超长字符串
  String encryptChun(String keyStr) {
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.ecb,
      padding: 'PKCS7',
    ));
    final encrypted = <String>[];

    const chunkSize = 256;
    for (int i = 0; i < length; i += chunkSize) {
      final chunk = substring(i, i + chunkSize > length ? length : i + chunkSize);
      final encryptedChunk = encrypter.encrypt(chunk, iv: iv).base64;
      encrypted.add(encryptedChunk);
    }

    return encrypted.join(':::');  // 使用特定的分隔符合并块
  }

  /// 解密超长字符串
  String decryptChun(String keyStr) {
    if (isEmpty) {
      return '';
    }
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.ecb,
      padding: 'PKCS7',
    ));
    
    final decrypted = <String>[];

    final encryptedChunks = split(':::');

    for (final chunk in encryptedChunks) {
      final decryptedChunk = encrypter.decrypt64(chunk, iv: iv);
      decrypted.add(decryptedChunk);
    }

    return decrypted.join();
  }

  // 校验中文名字
  bool isChineseName() {
    // 正则表达式
    final RegExp regex = RegExp(r'^[\u4e00-\u9fa5·]{2,20}$');
    return regex.hasMatch(this);
  }

  // toStringAsFixed
  String fixed(int fractionDigits) {
    if(!isNumber()) return this;
    return double.parse(this).toStringAsFixed(fractionDigits);
  }

  // 校验身份证
  bool isChineseID() {
    // 正则表达式
    final RegExp regex18 = RegExp(r'^\d{6}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$');
    final RegExp regex15 = RegExp(r'^\d{6}\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}$');

    if (regex18.hasMatch(this)) {
      if (length != 18) return false;

      final List<int> weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      final List<String> checkDigits = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

      int sum = 0;
      for (int i = 0; i < 17; i++) {
        sum += int.parse(this[i]) * weights[i];
      }

      int mod = sum % 11;
      String expectedCheckDigit = checkDigits[mod];
      String actualCheckDigit = this[17].toUpperCase();

      return expectedCheckDigit == actualCheckDigit;
    } else if (regex15.hasMatch(this)) {
      return true;
    } else {
      return false;
    }
  }

  // 隐藏中间字符串的中间部分
  String hideMiddle(int keepStartLength, int keepEndLength) {
    if (length <= keepStartLength + keepEndLength) {
      // 如果字符串长度小于或等于要显示的字符总数，则不做处理
      return this;
    }

    String start = substring(0, keepStartLength);
    String end = substring(length - keepEndLength);
    String ellipsis = List.filled(length - keepStartLength - keepEndLength, '*').join();
    return '$start$ellipsis$end';
  }

  /// 手机号验证
  bool isChinaPhone() {
    return RegExp(r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$").hasMatch(this);
  }

  /// 纯数字验证
  bool isNumber() {
    return RegExp(r"^\d+(\.\d+)?$").hasMatch(this);
  }

  /// 邮箱验证
  bool isEmail() {
    return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(this);
  }

  /// 验证URL
  bool isUrl() {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(this);
  }

  /// 验证中文
  bool isChinese() {
    return RegExp(r"[\u4e00-\u9fa5]").hasMatch(this);
  }

  /// 匹配中文，英文字母
  bool isChar() {
    return RegExp(r"^[a-zA-Z0-9_\u4e00-\u9fa5]+$").hasMatch(this);
  }

  /// 验证码密码：8-16位，至少包含一个字母一个数字，其他不限制
  /// r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
  bool isPassword() {
    return RegExp(r"^(?=.*[a-zA-Z])(?=.*\d)[^]{8,16}$").hasMatch(this);
  }

  /// 验证用户名 6-16位的字母和数字组合
  bool isUserName() {
    return RegExp(r"^[a-zA-Z](?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]{5,15}$").hasMatch(this);
  }

  /// 验证用户名 6-16位 字母开头，可以包含数字和下划线
  bool isUserNameSenond() {
    return RegExp(r"^[a-zA-Z]\w{5,15}$").hasMatch(this);
  }

  /// 复制字符串到粘贴板
  Future<void> copyToClipBoard() async {
    await Clipboard.setData(ClipboardData(text: this));
    MyAlert.snackbar('已成功复制到粘贴板');
  }

  String removeHtmlTags() {
    final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return replaceAll(regExp, '');
  }
}
