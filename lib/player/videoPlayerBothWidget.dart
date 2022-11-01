import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'advancedOverlayWidget.dart';

class VideoPlayerBothWidget extends StatefulWidget {
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

  const VideoPlayerBothWidget({
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
  _VideoPlayerBothWidgetState createState() => _VideoPlayerBothWidgetState();
}

class _VideoPlayerBothWidgetState extends State<VideoPlayerBothWidget> {
  Orientation target;

  @override
  void initState() {
    super.initState();
    print("videoplayerboth--"+widget.nextScreenView);

   /* setState(() {
      _enableRotation();
    });*/

   /* NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPortrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeLeft ||
          event == NativeDeviceOrientation.landscapeRight;
      final isTargetPortrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      if (isPortrait && isTargetPortrait || isLandscape && isTargetLandscape) {
        target = null;
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });*/
  }

  void setOrientation(bool isPortrait) {
    if (isPortrait) {
      //Wakelock.disable();
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      //Wakelock.enable();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.controller != null && widget.controller.value.isInitialized
          ? Container(alignment: Alignment.center, child: buildVideo())
          : Center(child: CircularProgressIndicator());

  Widget buildVideo() => OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          setOrientation(isPortrait);

          return Stack(
            fit: isPortrait ? StackFit.loose : StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child:  buildVideoPlayer(),
              ),

              Positioned.fill(
                child: AdvancedOverlayWidget(
                  controller: widget.controller,
                  title: widget.title,
                  videoUrl: widget.videoUrl,
                  nextVideoTitle: widget.nextVideoTitle,
                  nextVideoThumbnail: widget.nextVideoThumbnail,
                  nextVideoUrl: widget.nextVideoUrl,
                  nextVideoId: widget.nextVideoId,
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

                  onClickedPlayNextVideo: widget.onClickedPlayNextVideo,
                  onClickedBackButton: widget.onClickedBackButton,
                ),
              ),
            ],
          );
        },
      );

  Widget buildVideoPlayer() {
    final video = AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller),
    );

    return buildFullScreen(child: video);
  }

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = widget.controller.value.size;
    final width = size?.width ?? 0;
    final height = size?.height ?? 0;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
