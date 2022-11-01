import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/player/videoPlayerBothWidget.dart';
import 'package:projector/player/videoPlayerFullscreenWidget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayVideoScreenNew extends StatefulWidget {
  PlayVideoScreenNew({
    @required this.video,
    this.title,
    this.videoId,
    this.screenView,
    this.nextVideoTitle,
    this.nextVideoThumbnail,
    this.nextVideoUrl,
    this.nextVideoScreenView,
    this.nextVideoId,
    this.pausedPosition,
  });

  String video,
      videoId,
      title,
      screenView,
      nextVideoTitle,
      nextVideoThumbnail,
      nextVideoUrl,
      nextVideoScreenView,
      nextVideoId;

  var pausedPosition;

  @override
  _PlayVideoScreenNewState createState() => _PlayVideoScreenNewState();
}

class _PlayVideoScreenNewState extends State<PlayVideoScreenNew>
    with WidgetsBindingObserver {
  VideoPlayerController _controller;
  String position = '';

  @override
  void initState() {
    super.initState();
    // print("video order number---->${widget.video}");

    setState(() {
      //_enableRotation();
      Wakelock.enable();
    });

    if (widget.screenView == "2") {
      if (Platform.isAndroid) {
        //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      } else if (Platform.isIOS) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
      }
    } else if (widget.screenView == "1") {
      if (Platform.isAndroid) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      } else if (Platform.isIOS) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
      }
    } else {
      if (Platform.isAndroid) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      } else if (Platform.isIOS) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
      }
    }

    _controller = VideoPlayerController.network(widget.video)
      ..addListener(() => setState(() {
            // print("width---->${_controller.value.size.width}");
            // print("height---->${_controller.value.size.height}");

            var positionMin = _controller.value.position.inMinutes < 60
                ? _controller.value.position.inMinutes
                : _controller.value.position.inMinutes % 60;

            var positionSec = _controller.value.position.inSeconds < 60
                ? _controller.value.position.inSeconds
                : _controller.value.position.inSeconds % 60;

            position = '$positionMin:$positionSec';
          }))
      ..setLooping(false)
      ..initialize().then((_) {
        if (widget.pausedPosition > 0) {
          _controller.seekTo(Duration(seconds: widget.pausedPosition));
        }

        _controller.play();
      });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: WillPopScope(
        onWillPop: () async {
          //back button pressed
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.black,
          ),
          body: widget.screenView == "1"
              ? VideoPlayerBothWidget(
                  controller: _controller,
                  title: widget.title,
                  videoUrl: widget.video,
                  nextVideoTitle: widget.nextVideoTitle,
                  nextVideoThumbnail: widget.nextVideoThumbnail,
                  nextVideoUrl: widget.nextVideoUrl,
                  nextScreenView: widget.nextVideoScreenView,
                  nextVideoId: widget.nextVideoId,
                  onClickedBackButton: () async {
                    var response = await VideoService().updateVideoPaused(
                        videoId: widget.videoId, pausedTime: position);
                    if (response["success"]) {
                      Navigator.pop(context);
                      Wakelock.disable();
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    } else {
                      Navigator.pop(context);
                      Wakelock.disable();
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    }
                  },
                  onClickedPlayNextVideo: () async {
                    print("next play clicked fun--->");

                    var response = await VideoService()
                        .getVideoDetails(widget.nextVideoId.toString());

                    var detailVideoId = response['id'];
                    var videoUrlS3 = response['video_file'];
                    var detailVideoTitle = response['title'];
                    var detailOrderNumber = response['order_number'];
                    var orientation = response['orientation'];

                    var videoUrlRaw = response['video_raw_file'];

                    if (videoUrlRaw != null && videoUrlRaw != "") {
                      videoUrlRaw = videoUrlRaw;
                    } else {
                      videoUrlRaw = videoUrlS3;
                    }

                    if (orientation == "2") {
                      if (Platform.isAndroid) {
                        //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                      } else if (Platform.isIOS) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitDown]);
                      }
                    } else if (orientation == "1") {
                      if (Platform.isAndroid) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeLeft]);
                      } else if (Platform.isIOS) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeRight]);
                      }
                    } else {
                      if (Platform.isAndroid) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeLeft]);
                      } else if (Platform.isIOS) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeRight]);
                      }
                    }

                    widget.screenView = orientation;

                    _controller.dispose();
                    _controller = null;

                    _controller = VideoPlayerController.network(videoUrlS3)
                      ..addListener(() => setState(() {
                            //print("width---->${_controller.value.size.width}");
                            // print("height---->${_controller.value.size.height}");
                          }))
                      ..setLooping(false)
                      ..initialize().then((_) {
                        _controller.play();
                      });

                    widget.title = detailVideoTitle;
                    widget.videoId = detailVideoId;
                    widget.screenView = orientation;

                    var listOrderNumber = "";
                    var nextVideoThumbnail = "";
                    var nextVideoTitle = "";
                    var nextVideoUrl = "";
                    var nextVideoRawUrl = "";
                    var nextScreenView = "";
                    var nextVideoId = "";
                    bool isPlayNextEnd = false;

                    for (var i = 0; i < response['videos'].length; i++) {
                      isPlayNextEnd = false;
                      if (int.parse(response['videos'][i]['order_number']) >
                          int.parse(detailOrderNumber)) {
                        isPlayNextEnd = true;

                        listOrderNumber = response['videos'][i]['order_number'];
                        nextVideoThumbnail =
                            response['videos'][i]['thumbnails'];
                        nextVideoTitle = response['videos'][i]['title'];
                        nextVideoUrl = response['videos'][i]['video_file'];
                        nextVideoRawUrl =
                            response['videos'][i]['video_raw_file'];
                        nextScreenView = response['videos'][i]['orientation'];
                        nextVideoId = response['videos'][i]['id'];

                        if (nextVideoRawUrl != null && nextVideoRawUrl != "") {
                          nextVideoRawUrl = nextVideoRawUrl;
                        } else {
                          nextVideoRawUrl = nextVideoUrl;
                        }

                        widget.video = nextVideoRawUrl;
                        widget.nextVideoId = nextVideoId;
                        widget.nextVideoThumbnail = nextVideoThumbnail;
                        widget.nextVideoTitle = nextVideoTitle;
                        widget.nextVideoScreenView = nextScreenView;
                        break;
                      }
                    }

                    if (isPlayNextEnd == false) {
                      if (response['videos'].length > 0) {
                        listOrderNumber = response['videos'][0]['order_number'];
                        nextVideoThumbnail =
                            response['videos'][0]['thumbnails'];
                        nextVideoTitle = response['videos'][0]['title'];
                        nextVideoUrl = response['videos'][0]['video_file'];
                        nextVideoRawUrl =
                            response['videos'][0]['video_raw_file'];
                        nextScreenView = response['videos'][0]['orientation'];
                        nextVideoId = response['videos'][0]['id'];

                        if (nextVideoRawUrl != null && nextVideoRawUrl != "") {
                          nextVideoRawUrl = nextVideoRawUrl;
                        } else {
                          nextVideoRawUrl = nextVideoUrl;
                        }
                      }

                      widget.video = nextVideoRawUrl;
                      widget.nextVideoId = nextVideoId;
                      widget.nextVideoThumbnail = nextVideoThumbnail;
                      widget.nextVideoTitle = nextVideoTitle;
                      widget.nextVideoScreenView = nextScreenView;
                    }
                  },
                )
              : VideoPlayerFullscreenWidget(
                  controller: _controller,
                  title: widget.title,
                  videoUrl: widget.video,
                  nextVideoTitle: widget.nextVideoTitle,
                  nextVideoThumbnail: widget.nextVideoThumbnail,
                  nextVideoUrl: widget.nextVideoUrl,
                  nextScreenView: widget.nextVideoScreenView,
                  nextVideoId: widget.nextVideoId,
                  onClickedBackButton: () async {
                    var response = await VideoService().updateVideoPaused(
                        videoId: widget.videoId, pausedTime: position);
                    if (response["success"]) {
                      Navigator.pop(context);
                      Wakelock.disable();
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    } else {
                      Navigator.pop(context);
                      Wakelock.disable();
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    }
                  },
                  onClickedPlayNextVideo: () async {
                    print("next play clicked fun 1--->");

                    var response = await VideoService()
                        .getVideoDetails(widget.nextVideoId.toString());

                    var detailVideoId = response['id'];
                    var videoUrlS3 = response['video_file'];
                    var detailVideoTitle = response['title'];
                    var detailOrderNumber = response['order_number'];
                    var orientation = response['orientation'];
                    var videoUrlRaw = response['video_raw_file'];

                    if (videoUrlRaw != null && videoUrlRaw != "") {
                      videoUrlRaw = videoUrlRaw;
                    } else {
                      videoUrlRaw = videoUrlS3;
                    }

                    if (orientation == "2") {
                      if (Platform.isAndroid) {
                        //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                      } else if (Platform.isIOS) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitDown]);
                      }
                    } else if (orientation == "1") {
                      if (Platform.isAndroid) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeLeft]);
                      } else if (Platform.isIOS) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeRight]);
                      }
                    } else {
                      if (Platform.isAndroid) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeLeft]);
                      } else if (Platform.isIOS) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.landscapeRight]);
                      }
                    }

                    _controller.dispose();
                    _controller = null;

                    _controller = VideoPlayerController.network(videoUrlS3)
                      ..addListener(() => setState(() {
                            //print("width---->${_controller.value.size.width}");
                            // print("height---->${_controller.value.size.height}");
                          }))
                      ..setLooping(false)
                      ..initialize().then((_) {
                        _controller.play();
                      });

                    widget.title = detailVideoTitle;
                    widget.videoId = detailVideoId;
                    widget.screenView = orientation;

                    var list = [];

                    var videosList = response['videos'];

                    list = videosList;

                    var listOrderNumber = "";
                    var nextVideoThumbnail = "";
                    var nextVideoTitle = "";
                    var nextVideoUrl = "";
                    var nextVideoRawUrl = "";
                    var nextScreenView = "";
                    var nextVideoId = "";
                    bool isPlayNextEnd = false;

                    for (var i = 0; i < response['videos'].length; i++) {
                      isPlayNextEnd = false;
                      if (int.parse(response['videos'][i]['order_number']) >
                          int.parse(detailOrderNumber)) {
                        isPlayNextEnd = true;

                        listOrderNumber = response['videos'][i]['order_number'];
                        nextVideoThumbnail =
                            response['videos'][i]['thumbnails'];
                        nextVideoTitle = response['videos'][i]['title'];
                        nextVideoUrl = response['videos'][i]['video_file'];
                        nextVideoRawUrl =
                            response['videos'][i]['video_raw_file'];
                        nextScreenView = response['videos'][i]['orientation'];
                        nextVideoId = response['videos'][i]['id'];

                        if (nextVideoRawUrl != null && nextVideoRawUrl != "") {
                          nextVideoRawUrl = nextVideoRawUrl;
                        } else {
                          nextVideoRawUrl = nextVideoUrl;
                        }

                        widget.video = nextVideoRawUrl;
                        widget.nextVideoId = nextVideoId;
                        widget.nextVideoThumbnail = nextVideoThumbnail;
                        widget.nextVideoTitle = nextVideoTitle;
                        widget.nextVideoScreenView = nextScreenView;

                        break;
                      }
                    }

                    if (isPlayNextEnd == false) {
                      if (response['videos'].length > 0) {
                        listOrderNumber = response['videos'][0]['order_number'];
                        nextVideoThumbnail =
                            response['videos'][0]['thumbnails'];
                        nextVideoTitle = response['videos'][0]['title'];
                        nextVideoUrl = response['videos'][0]['video_file'];
                        nextVideoRawUrl =
                            response['videos'][0]['video_raw_file'];
                        nextScreenView = response['videos'][0]['orientation'];
                        nextVideoId = response['videos'][0]['id'];

                        if (nextVideoRawUrl != null && nextVideoRawUrl != "") {
                          nextVideoRawUrl = nextVideoRawUrl;
                        } else {
                          nextVideoRawUrl = nextVideoUrl;
                        }
                      }

                      widget.video = nextVideoRawUrl;
                      widget.nextVideoId = nextVideoId;
                      widget.nextVideoThumbnail = nextVideoThumbnail;
                      widget.nextVideoTitle = nextVideoTitle;
                      widget.nextVideoScreenView = nextScreenView;
                    }
                  },
                ),
        ),
      ),
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
