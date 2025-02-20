import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<String?> getNumberPassword() async {
  return await MyAlert.bottomSheet(child: const MyNumberPasswordInput());
}

class MyNumberPasswordInput extends StatefulWidget {
  const MyNumberPasswordInput({
    super.key,
  });

  @override
  State<MyNumberPasswordInput> createState() => _MyNumberPasswordInputState();
}

class _MyNumberPasswordInputState extends State<MyNumberPasswordInput> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final text = <String>['', '', '', '', '', ''].obs;

  AnimationController? animationController;
  Animation<double>? opacity;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    if (animationController != null) {
      opacity = Tween(begin: 1.0, end: 0.0).animate(animationController!);
    }
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> stringToList(List<String> value) {
      var list = <String>[];
      for (int i = 0; i < 6; i++) {
        if (i < value.length) {
          list.add('*');
        } else {
          list.add('');
        }
      }
      return list;
    }

    final input = MyInput(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      controller: textEditingController,
      focusNode: focusNode,
      maxLength: 6,
      onChanged: (value) {
        text.value = stringToList(value.split(''));
        if (value.length == 6) {
          Get.back(result: value);
        }
      },
      autofocus: true,
    );

    final title = Text('确认资金密码', style: Theme.of(context).myStyles.labelBig);
    return Column(
      children: [
        title,
        SizedBox(height: 30, child: Opacity(opacity: 0, child: input)),
        Row(children: text.asMap().entries.map((e) => Expanded(child: Obx(() => _buildInputBox(context, text, focusNode, e.key, opacity)))).toList()),
      ],
    );
  }
}

Widget _buildInputBox(
  BuildContext context,
  List<String> strList,
  FocusNode focusNode,
  int index,
  Animation<double>? opacity,
) {
  int i = 0;
  for (var element in strList) {
    if (element != '') {
      i++;
    }
  }
  
  final focus = Container(
    height: 20,
    width: 2,
    color: Theme.of(context).myColors.primary,
  );

  final del = CircleAvatar(
    backgroundColor: Theme.of(context).myColors.onCardBackground,
    radius: 5,
  );

  final card = MyCard(
    padding: EdgeInsets.zero,
    width: 50,
    height: 50,
    border: strList[index] == '' && i != index
        ? null
        : Border.all(color: Theme.of(context).myColors.primary, width: 2),
    color: Theme.of(context).myColors.buttonDisable.withOpacity( 0.5),
    borderRadius: BorderRadius.circular(8),
    margin:  const EdgeInsets.only(right: 10),
    child: i == index
        ? opacity == null ? focus : FadeTransition(alwaysIncludeSemantics: true, opacity: opacity, child: Center(child: focus))
        : strList[index].isEmpty? null : Center(child: del),
  );

  return MyButton.widget(onPressed: () => focusNode.requestFocus(), child: card);
}
