import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'advancedOverlayWidget.dart';

class VideoPlayerFullscreenWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final String title;
  final String videoUrl;
  final String nextVideoTitle;
  final String nextVideoThumbnail;
  final String nextVideoUrl;
  final String nextScreenView;
  final String nextVideoId;
  final VoidCallback onClickedPlayNextVideo;
  final VoidCallback onClickedBackButton;

  const VideoPlayerFullscreenWidget({
    Key key,
    @required this.controller,
    this.title,
    this.videoUrl,
    this.nextVideoTitle,
    this.nextVideoThumbnail,
    this.nextVideoUrl,
    this.nextScreenView,
    this.nextVideoId,
    this.onClickedPlayNextVideo,
    this.onClickedBackButton,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Center(child: CircularProgressIndicator());

  Widget buildVideo() => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(
            child: AdvancedOverlayWidget(
              controller: controller,
              title: title,
              videoUrl: videoUrl,
              nextVideoTitle: nextVideoTitle,
              nextVideoThumbnail: nextVideoThumbnail,
              nextVideoUrl: nextVideoUrl,
              nextScreenView: nextScreenView,
              nextVideoId: nextVideoId,
              onClickedFullScreen: () {

                print("clicked---?");
                /* target = isPortrait
                          ? Orientation.landscape
                          : Orientation.portrait;

                      if (isPortrait) {
                        AutoOrientation.landscapeRightMode();
                      } else {
                        AutoOrientation.portraitUpMode();
                      }*/
              },
              onClickedPlayNextVideo: onClickedPlayNextVideo,
              onClickedBackButton: onClickedBackButton,
            ),
          ),
          //BasicOverlayWidget(controller: controller),
        ],
      );

  Widget buildVideoPlayer() => buildFullScreen(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = controller.value.size;
    final width = size.width;
    final height = size.height;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
