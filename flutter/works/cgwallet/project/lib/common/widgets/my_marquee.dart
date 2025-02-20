import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';

class MyMarquee extends StatefulWidget {
  const MyMarquee({super.key, required this.contentList});

  final List<String> contentList;

  @override
  State<MyMarquee> createState() => _MyMarqueeState();
}

class _MyMarqueeState extends State<MyMarquee> {
  final ScrollController scrollController = ScrollController();
  int index = 0;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && mounted) {
        final maxScrollExtent = scrollController.position.maxScrollExtent;
        final duration = Duration(seconds: ((maxScrollExtent * 4) / 360).round()); // Adjust duration based on speed

        scrollController.animateTo(
          maxScrollExtent,
          duration: duration,
          curve: Curves.linear,
        ).then((_) {
          if (scrollController.hasClients && mounted) {
            scrollController.jumpTo(0.0);
            setState(() {
              index = (index + 1) % widget.contentList.length;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = Theme.of(context).myStyles.label;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          child: Row(
            children: [
              SizedBox(width: constraints.maxWidth),
              Text(widget.contentList[index], maxLines: 1, style: textStyle, textDirection: TextDirection.ltr),
              SizedBox(width: constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }
}

// class MyMarquee extends StatelessWidget {
//   const MyMarquee({
//     super.key,
//     required this.content,
//     required this.onDone,
//   });

//   final String content;
//   final void Function() onDone;

//   @override
//   Widget build(BuildContext context) {
//     final scrollController = ScrollController();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         final maxScrollExtent = scrollController.position.maxScrollExtent;
//         final duration = Duration(seconds: ((maxScrollExtent * 4) / 360).round()); // Adjust duration based on speed

//         scrollController.animateTo(
//           maxScrollExtent,
//           duration: duration,
//           curve: Curves.linear,
//         ).then((_) {
//           scrollController.jumpTo(0.0);
//           scrollController.dispose();
//           onDone();
//         });
//       }
//     });

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final textStyle = Theme.of(context).myStyles.label;
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           controller: scrollController,
//           child: Row(
//             children: [
//               SizedBox(width: constraints.maxWidth),
//               Text(content, maxLines: 1, style: textStyle, textDirection: TextDirection.ltr),
//               SizedBox(width: constraints.maxWidth),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
