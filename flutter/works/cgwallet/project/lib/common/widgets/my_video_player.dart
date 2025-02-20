import 'dart:io';

import 'package:cgwallet/common/common.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    super.key,
    this.videoUrl,
    this.file,
  });

  final String? videoUrl;
  final File? file;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  bool isShowLoading = true;

  final customControls = const MaterialControls();

  Future<void> initPlayer() async {
    if (widget.videoUrl == null && widget.file == null) {
      throw('视频地址和视频文件不能同时为空');
    } else {
      if (widget.file != null) {
        videoPlayerController = VideoPlayerController.file(widget.file!);
      } else {
        videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      }
    }
    
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      customControls: customControls,
    );

    try {
      await videoPlayerController.initialize();
      setState(() {
        isShowLoading = false;
      });

      MyLogger.w('视频初始化成功');
    } catch (e) {
      MyLogger.w(e.toString());
    }
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyVideoPlayer oldWidget) {
    // 页面刷新的时候
    // 先暂停旧的视频，然后重新初始化
    videoPlayerController.pause();

    videoPlayerController.dispose().then((value) {
      chewieController.dispose();
      initPlayer();
      setState(() {
        isShowLoading = true;
      });
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // 视频的封面
    final imageBox = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
    );

    // 视频区的遮罩，主要是遮住封面图
    final mark = Container(
      color: Colors.black.withOpacity( 0.7),
      width: double.infinity,
      height: double.infinity,
    );

    // 加载中：精彩即将开始。。。
    final loadingContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme.of(context).myIcons.loadingIcon,
        const SizedBox(height: 8, width: double.infinity),
        Text(
          Lang.videoPlayerLoading.tr,
          style: Theme.of(context).myStyles.labelLight,
        ),
      ],
    );

    final loadingBox = Stack(children: [
      imageBox,
      mark,
      loadingContent,
    ]);

    final size = MediaQuery.of(context).size.width - 40 - 32;

    // 加载中的组成方式：
    // 封面图放最底下
    // 遮罩罩住封面图
    // 加载动画
    // 最后把加载中放到顶层
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size, maxHeight: size), 
      child: isShowLoading
      ? loadingBox
      : MyCard.normal(
        color: Theme.of(context).myColors.dark,
        child: Chewie(controller: chewieController),
      )
    );
  }
}
