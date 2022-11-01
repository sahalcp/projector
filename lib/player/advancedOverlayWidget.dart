import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/player/playVideoScreenNew.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakelock/wakelock.dart';

class AdvancedOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onClickedFullScreen;
  final String title;
  final String videoUrl;
  final String nextVideoTitle;
  final String nextVideoThumbnail;
  final String nextVideoUrl;
  final String nextScreenView;
  final String nextVideoId;
  final VoidCallback onClickedPlayNextVideo;
  final VoidCallback onClickedBackButton;

  const AdvancedOverlayWidget({
    Key key,
    @required this.controller,
    this.onClickedFullScreen,
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
  _AdvancedOverlayWidgetState createState() => _AdvancedOverlayWidgetState();
}

class _AdvancedOverlayWidgetState extends State<AdvancedOverlayWidget> {
  static const allSpeeds = <double>[0.25, 0.5, 1, 1.5, 2, 3, 5, 10];
  bool showControls = true;
  String position = '', duration = '';
  Timer _timer;
  int _start = 10;
  var totalSeconds = 0, sliderValue = 0.0;

  String getPosition() {
    final duration = Duration(
        milliseconds: widget.controller.value.position.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _timeEnd();
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  VoidCallback _timeEnd() {
    return widget.onClickedPlayNextVideo;
  }

  @override
  void initState() {
    //print("advance--${widget.nextVideoId}");

    widget.controller.addListener(() {
      totalSeconds = widget.controller.value.duration.inSeconds;

      var positionMin = widget.controller.value.position.inMinutes < 60
          ? widget.controller.value.position.inMinutes
          : widget.controller.value.position.inMinutes % 60;

      var durationMin = widget.controller.value.duration.inMinutes % 60;
      var positionSec = widget.controller.value.position.inSeconds < 60
          ? widget.controller.value.position.inSeconds
          : widget.controller.value.position.inSeconds % 60;
      var durationSec = widget.controller.value.duration.inSeconds % 60;

      position = '$positionMin:$positionSec';
      duration = '$durationMin:$durationSec';

      sliderValue = widget.controller.value.position.inSeconds / totalSeconds;

      //print("player position--${widget.controller.value.position}");
     // print("player value--${widget.controller.value}");
     //  print("player position-- $position");
     //  print("player duration-- $duration");

      if (position == duration) {
        showControls = false;
        //print("equalllll");

       // startTimer();

        /*   if(_start ==0){
print("timer end--->");
        }else{
          print("timer not end--->");
        }*/
      } else {
        // print("not equalllll");
      }

      // print("screen orientation"+widget.nextScreenView);
    });

    super.initState();
  }

  @override
  void dispose() {
   // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    widget.controller.dispose();
   // _timer.cancel();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            showControls = !showControls;

            print("controlss click--$showControls");
          });
          // widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
        },
        child: Stack(
          children: <Widget>[
            buildPlay(),
            buildBackButton(),
            buildTitle(),
            //buildSpeed(),
            buildPositionText(),
            buildFullScreen(),
            buildPlayNextVideoScreen(),



            // buildPlayAgain()
            //buildDuration()
          ],
        ),
      );

  Widget buildIndicator() => Container(
        margin: EdgeInsets.all(24).copyWith(right: 0),
        height: 8,
        child: VideoProgressIndicator(widget.controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Colors.blue,
            )),
      );

  Widget buildIndicatorNew() => Container(
        margin: EdgeInsets.only(top: 25).copyWith(right: 0),
        height: 8,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
          ),
          child: Slider(
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            thumbColor: Colors.white,
            onChanged: (val) async {
              setState(() {
                sliderValue = val;
              });
              var dur = sliderValue * totalSeconds;

              widget.controller.seekTo(
                Duration(seconds: dur.toInt()),
              );
            },
            onChangeStart: (val) {},
            value: sliderValue,
            // max: 1.0,
            // min: 0.0,
          ),
        ),
      );

  Widget buildSpeed() => Align(
        alignment: Alignment.topRight,
        child: PopupMenuButton<double>(
          initialValue: widget.controller.value.playbackSpeed,
          tooltip: 'Playback speed',
          onSelected: widget.controller.setPlaybackSpeed,
          itemBuilder: (context) => allSpeeds
              .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  ))
              .toList(),
          child: Container(
            color: Colors.white38,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text('${widget.controller.value.playbackSpeed}x'),
          ),
        ),
      );

//widget.controller.value.isPlaying

  // await VideoService().updateVideoPaused(videoId: widget.videoId,pausedTime: position);
 // Navigator.pop(context);
  //Wakelock.disable();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Widget buildBackButton() => showControls
      ? Container()
      : Container(
          child: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                  onTap: widget.onClickedBackButton,
                  child: Container(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/chevron_left-24px.svg",
                          height: 45,
                          width: 45,
                          // fit: BoxFit.fit,
                        ),
                        //   Icons.arrow_back_ios,
                        //   color: Colors.white,
                        //   size: 18,
                        // ),
                        // Text(
                        //   'Back',
                        //   style: GoogleFonts.montserrat(
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white,
                        //   ),
                        //   textAlign: TextAlign.start,
                        // ),
                      ],
                    ),
                  ))),
        );

  Widget buildTitle() => showControls
      ? Container()
      : Container(
          child: Positioned(
              left: 24,
              bottom: 96,
              child: Text(
                widget.title != null ? widget.title : "",
                style: GoogleFonts.montserrat(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
        );

  Widget buildPlay() => showControls
      ? Container()
      : position == duration
          ? InkWell(
              onTap: () {
                setState(() {
                  widget.controller.play();
                });
              },
              child: Container(
                  color: Colors.black38,
                  child: Visibility(
                    visible: true,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 50,
                            width: 50,
                            image: (AssetImage('images/icon_play_again.png')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Play Again',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          : Container(
              color: Colors.black38,
              child: Visibility(
                visible: true,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.controller.seekTo(
                            Duration(
                                seconds:
                                    widget.controller.value.position.inSeconds -
                                        15),
                          );
                        },
                        child: SvgPicture.asset(
                          "images/Skip-froward.svg",
                          height: 45,
                          width: 45,
                          // fit: BoxFit.fit,
                        ),
                      ),
                      SizedBox(width: 100),
                      InkWell(
                        onTap: () async {
                          if (widget.controller.value.isPlaying) {
                            setState(() {
                              widget.controller.pause();
                            });

                            // await  VideoService().updateVideoPaused(videoId: widget.videoId,pausedTime: position);
                          } else {
                            setState(() {
                              widget.controller.play();
                            });
                          }
                        },
                        child: Image(
                          height: 35,
                          width: 35,
                          image: (widget.controller.value.isPlaying
                              ? AssetImage('images/Pause_white.png')
                              : AssetImage('images/play_White.png')),
                        ),
                      ),
                      SizedBox(width: 100),
                      InkWell(
                        onTap: () {
                          widget.controller.seekTo(
                            Duration(
                                seconds:
                                    widget.controller.value.position.inSeconds +
                                        15),
                          );
                        },
                        child: SvgPicture.asset(
                          "images/skip-ahead.svg",
                          height: 45,
                          width: 45,
                          // fit: BoxFit.fit,
                        ),
                      ),
                    ],
                  ),
                ),
              ));

  Widget buildPositionText() => showControls
      ? Container()
      : Positioned(
          right: 10,
          bottom: 35,
          child: Text(
            getPosition(),
            style: TextStyle(color: Colors.white),
          ),
        );

  Widget buildFullScreen() => showControls
      ? Container()
      : Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Row(
            children: [
              Expanded(child: buildIndicatorNew()),
              const SizedBox(width: 12),
              Visibility(
                visible: false,
                child: GestureDetector(
                  child: Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 28,
                  ),
                  onTap: widget.onClickedFullScreen,
                ),
              ),

              // const SizedBox(width: 8),
            ],
          ));

  Widget buildPlayNextVideoScreen() => showControls
      ? Container()
      : Container(
          child: Visibility(
            visible: position == duration &&
                    widget.nextVideoTitle != null &&
                    widget.nextVideoTitle != ""
                ? true
                : false,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 150,
                margin: EdgeInsets.only(bottom: 120, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: widget.onClickedPlayNextVideo,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image(
                              image: NetworkImage(widget.nextVideoThumbnail),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.nextVideoTitle != null
                                ? widget.nextVideoTitle
                                : "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                   /* Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Play Next Video in: $_start',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        );

  Widget buildPlayAgain() => showControls
      ? Container()
      : Container(
          color: Colors.black38,
          child: Visibility(
            visible: position == duration ? true : false,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {},
                    child: Image(
                      height: 45,
                      width: 45,
                      image: (AssetImage('images/icon_play_again.png')),
                    ),
                  ),
                  Text(
                    'Play Again',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ));

  Widget buildDuration() => showControls
      ? Container()
      : Container(
          color: Colors.black38,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$duration',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$position',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ));
}
