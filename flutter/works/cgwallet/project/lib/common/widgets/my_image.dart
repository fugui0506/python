import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  const MyImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.synchWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Widget? synchWidget;

  @override
  Widget build(BuildContext context) {
    final loading = Center(child: Theme.of(context).myIcons.loadingIcon);
    return RepaintBoundary(
      child: Image.network(imageUrl, 
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress != null) {
            return synchWidget ?? loading;
          } else {
            return child;
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return synchWidget ?? MyCard(
            width: width,
            height: height,
            child: FittedBox(child: Theme.of(context).myIcons.brokenImage),
          );
        },
        frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {      
          if (frame == null) {
            return synchWidget ?? loading;
          } else {
            return child;
          }
        },
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }

  // Widget _buildLoading() {
  //   return Container(
  //     width: width,
  //     height: height,
  //     decoration: BoxDecoration(
  //       borderRadius: borderRadius,
  //     ),
  //     clipBehavior: Clip.antiAlias,
  //     child: Center(child: Get.theme.myIcons.loadingIcon),
  //   );
  // }

  // Widget _buildImage(File file) {
  //   if (borderRadius == null) {
  //     return Image.file(file,
  //       width: width,
  //       height: height,
  //       fit: fit,
  //     );
  //   } else {
  //     return Container(
  //       width: width,
  //       height: height,
  //       decoration: BoxDecoration(
  //         borderRadius: borderRadius,
  //         image: DecorationImage(
  //           image: FileImage(file),
  //           fit: fit,
  //         ),
  //       ),
  //       clipBehavior: Clip.antiAlias,
  //     );
  //   }
  // }

  // Widget _buildError(BuildContext context) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     decoration: BoxDecoration(
  //       borderRadius: borderRadius,
  //     ),
  //     clipBehavior: Clip.antiAlias,
  //     child: LayoutBuilder(builder: (context, constraine) {
  //       double size = constraine.maxWidth * 0.5;
  //       if (constraine.maxWidth > constraine.maxHeight) {
  //         size = constraine.maxHeight * 0.5;
  //       }
  //       return Center(
  //         child: SizedBox(width: size, child: FittedBox(child: Theme.of(context).myIcons.brokenImage))
  //       );
  //     }),
  //   );
  // }
}

