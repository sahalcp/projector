import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/videoService.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatefulWidget {
  PlayVideoScreen({
    @required this.video,
    this.title,
    this.videoId,
    this.screenView,
  });
  final String video, videoId, title, screenView;
  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen>
    with WidgetsBindingObserver {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  String position = '', duration = '';
  Duration current;
  bool loading = false;
  var totalSeconds = 0, sliderValue = 0.0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    /*if(widget.screenView == "2"){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
    }else if(widget.screenView == "1"){
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    }else{
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    }*/

    // SystemChrome.setEnabledSystemUIOverlays([]);
setState(() {
  _enableRotation();
});
    _controller = VideoPlayerController.network(widget.video);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.play();


    _controller.addListener(() {
      totalSeconds = _controller.value.duration.inSeconds;
      // var positionHrs = _controller.value.position.inHours;
      // var durationHrs = _controller.value.duration.inHours;
      var positionMin = _controller.value.position.inMinutes < 60
          ? _controller.value.position.inMinutes
          : _controller.value.position.inMinutes % 60;
      var durationMin = _controller.value.duration.inMinutes % 60;
      var positionSec = _controller.value.position.inSeconds < 60
          ? _controller.value.position.inSeconds
          : _controller.value.position.inSeconds % 60;
      var durationSec = _controller.value.duration.inSeconds % 60;

      // print(_controller.value.position.inSeconds);
      // print(totalSeconds);
      position = '$positionMin:$positionSec';
      duration = '$durationMin:$durationSec';
      sliderValue = _controller.value.position.inSeconds / totalSeconds;
      // print(sliderValue);

       //print("width---->${_controller.value.size.width}");
       //print("height---->${_controller.value.size.height}");

      // print(_controller.value.duration.inSeconds);
      // print(_controller.value.position);
      // print(_controller.value.duration);
      //setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
   // VideoService().updateVideoPaused(videoId: widget.videoId,pausedTime: position);
    // print('state = $state.......................................');
  }

  bool showControls = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var isScreenPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // setState(() {
          //   loading = true;
          // });
          // await VideoService().addToPauseList(videoId: widget.videoId);
          // await VideoService().updateVideoPaused(videoId: widget.videoId,pausedTime: position);
          setState(() {
            loading = false;
          });
          // Navigator.pop(context);
        },
        child: Container(
          height: height,
          width: width,
          color: Colors.black,
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ModalProgressHUD(
                  inAsyncCall: loading,
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            showControls = !showControls;
                          });
                        },

                        child: Container(
                          // height: height * 0.9,
margin: EdgeInsets.only(right: widget.screenView == "1" && !isScreenPortrait? 30 : 0,
  left: widget.screenView == "1" && !isScreenPortrait? 30 : 0,
    top: widget.screenView == "2" && isScreenPortrait? 30 : 0,
    bottom: widget.screenView == "2" && isScreenPortrait? 30 : 0),
                          height: height,
                          width: width,
                          child: Stack(
                            children: [
                              Positioned(
                                //top: isScreenPortrait? 250 : 0,
                                /// check screen orientation, screenview 1 = landscape, 2 = portrait
                                top: widget.screenView == "1" && isScreenPortrait? 250 : 0,
                                child: Container(
                                  // height: orientation == Orientation.portrait
                                  // /// portrait height
                                  //     ? height * 0.3
                                  //     : height,
                                  /// check screen orientation, screenview 1 = landscape, 2 = portrait
                                  height: widget.screenView == "1" && isScreenPortrait? height * 0.3 : height,
                                  width: width,
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                              ),
                              showControls
                                  ? Container(
                                // top: height * 0.01,
                                // left: width * 0.04,
                                margin: EdgeInsets.only(top: isScreenPortrait? 40 : 0),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });

                                     await VideoService().updateVideoPaused(videoId: widget.videoId,pausedTime: position);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10,top: isScreenPortrait? 15 : 30),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        Text(
                                          'Back',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ),

                              )
                                  : Container(),


                              /*showControls
          ? Positioned(
               top: height * 0.02,
               left: width /2,
               //right: width * 0.05,
               //right: width /2,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            widget.title ?? '',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        )
            )
          : Container(),*/

                              showControls
                                  ? Container(
                                margin: EdgeInsets.only(top: isScreenPortrait? 55 : 30),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    widget.title ?? '',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),

                              showControls
                                  ? Container(
                                  child:  Align(
                                    alignment: Alignment.center,
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _controller.seekTo(
                                              Duration(
                                                  seconds: _controller
                                                      .value
                                                      .position
                                                      .inSeconds -
                                                      10),
                                            );
                                          },
                                          child: Image(
                                            height: 24,
                                            image: AssetImage(
                                                'images/backwards.png'),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () async {
                                            if (_controller
                                                .value.isPlaying) {
                                              setState(() {
                                                _controller.pause();
                                              });

                                              // await  VideoService().updateVideoPaused(videoId: widget.videoId,pausedTime: position);
                                            } else {
                                              setState(() {
                                                _controller.play();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            _controller
                                                .value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white
                                                .withOpacity(0.5),
                                            size: 30.0,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            _controller.seekTo(
                                              Duration(
                                                  seconds: _controller
                                                      .value
                                                      .position
                                                      .inSeconds +
                                                      10),
                                            );
                                          },
                                          child: Image(
                                            height: 24,
                                            image: AssetImage(
                                                'images/forward.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              )
                                  :
                              Container(),

                              showControls
                                  ? Positioned(
                                top: orientation == Orientation.portrait
                                    ? height * 0.78
                                    : height * 0.70,
                                left: width * 0.04,
                                right: width * 0.04,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Visibility(
                                          visible: false,
                                          child:  Container(
                                            // width: width * 0.05,
                                            child: InkWell(
                                              onTap: () {
                                                if (_controller
                                                    .value.volume ==
                                                    1.0)
                                                  _controller
                                                      .setVolume(0.0);
                                                else
                                                  _controller
                                                      .setVolume(1.0);
                                                setState(() {});
                                              },
                                              child: Icon(
                                                _controller.value
                                                    .volume ==
                                                    1.0
                                                    ? Icons.volume_up
                                                    : Icons.volume_mute,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                size: 22.0,
                                              ),
                                            ),
                                          ),),

                                        /// Row play pause control widget

                                        Visibility(
                                          visible: false,
                                          child: InkWell(
                                            onTap: () {
                                              // orientation == Orientation.portrait
                                              //     ? SystemChrome
                                              //         .setPreferredOrientations([
                                              //         DeviceOrientation
                                              //             .landscapeLeft
                                              //       ])
                                              //     : SystemChrome
                                              //         .setPreferredOrientations([
                                              //         DeviceOrientation
                                              //             .portraitUp
                                              //       ]);
                                            },
                                            child: Icon(
                                              Icons.fullscreen,
                                              color: Colors.white
                                                  .withOpacity(0.5),
                                              size: 30.0,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SliderTheme(
                                      data: SliderTheme.of(context)
                                          .copyWith(
                                        activeTrackColor: Colors.white,
                                      ),
                                      child: Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        onChanged: (val) async {
                                          setState(() {
                                            sliderValue = val;
                                          });
                                          var dur = sliderValue *
                                              totalSeconds;

                                          _controller.seekTo(
                                            Duration(
                                                seconds: dur.toInt()),
                                          );
                                        },
                                        onChangeStart: (val) {},
                                        value: sliderValue,
                                        // max: 1.0,
                                        // min: 0.0,
                                      ),
                                    ),
                                    // SizedBox(height: 20),
                                    Text(
                                      '${position.toString()}/${duration.toString()}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Container()
                            ],
                          ),
                        ),

                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
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
