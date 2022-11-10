import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/player/playVideoScreenNew.dart';
import 'package:projector/style.dart';
import 'package:sizer/sizer.dart';

class ContentDetailScreen extends StatefulWidget {
  ContentDetailScreen({@required this.videoId});

  final String videoId;

  @override
  _ContentDetailScreenState createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  bool loading = false;
  static const platform = const MethodChannel("flutter.native/helper");
  var videoUrl;
  var thumbnailPreview;
  var title;
  var spriteColumn;
  var spriteRow;
  var userVideoId;
  String _userToken;

  @override
  void initState() {
    /* VideoService().getWatchlist(true).then((data) {
      data.forEach((v) {
        if (v['id'] == widget.videoId) {
          setState(() {
            isWatchlist = true;
          });
        }
      });
    });*/
    getUserToken();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Future<void> getUserToken() async {
    var token = await UserData().getUserToken();

    setState(() {
      _userToken = token;
    });
  }

  Future<void> _flutterToAndroid() async {
    try {
      final String result = await platform.invokeMethod('flutterToNative', {
        "videoUrl": videoUrl,
        "thumbnailPreview": thumbnailPreview,
        "videoTitle": title,
        "spriteRow": spriteRow,
        "spriteColumn": spriteColumn,
        "videoId": userVideoId,
        "token": _userToken,
        "baseUrl": serverUrl
      });
      debugPrint('Result: $result ');
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }

  void _flutterToIos() async {
    try {
      final arguments = {
        'videoUrl': videoUrl,
        'thumbnailPreview': thumbnailPreview
      };
      final String result =
          await platform.invokeMethod('flutterToIosNative', arguments);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
      /*if(deviceType == DeviceType.mobile){
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }else{
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      }*/
      return Scaffold(
        backgroundColor: appBgColor,
        body: FutureBuilder(
          future: VideoService().getVideoDetails(widget.videoId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var response = snapshot.data;
              var image = response['thumbnails'][0],
                  description = response['description'],
                  category = response['Category'],
                  subCategory = response['SubCategory'],
                  date = response['publish_date'],
                  isInPausedList = response['isInPausedlist'],
                  isInWatchList = response['isInWatchlist'];
              userVideoId = response['id'];
              thumbnailPreview = response['thumbnail_hover'];
              title = response['title'];
              spriteRow = response['sprite_row'];
              spriteColumn = response['sprite_coloumn'];
              var orientation = response['orientation'];
              var orderNumber = response['order_number'];
              var pausedPosition = response['paused_at'];

              var bannerPreviewStyleId =
                  snapshot.data['banner_preview_style_id'];
              // bannerPreviewStyleId = 1 (large)
              // bannerPreviewStyleId = 2 (small)
              if (pausedPosition == "" || pausedPosition == null) {
                pausedPosition = 0;
              }

              //var  orientation = "2";
              // if(orientation !=null){
              //   orientation = orientation;
              // }else{
              //   orientation = "1";
              // }

              var year = DateTime.parse(date).year;
              var videoUrlS3 = response['video_file'];
              videoUrl = response['video_raw_file'];
              // print("video url raw--->$videoUrl");

              if (videoUrl != null && videoUrl != "") {
                videoUrl = videoUrl;
              } else {
                videoUrl = videoUrlS3;
              }

              // print("video url s3 --->$videoUrlS3");
              print("video id--->$userVideoId");

              // var videosList = response['videos'];

              // var list = videosList;

              // final filterOrderNumber =
              //     list.where((element) => orderNumber > element['order_number']);

              //video for loop
              // if orderNumber > list item order number
              // return

              var listOrderNumber = "";
              var nextVideoThumbnail = "";
              var nextVideoTitle = "";
              var nextVideoUrl = "";
              var nextVideoRawUrl = "";
              var nextScreenView = "";
              var nextVideoId = "";

              for (var i = 0; i < response['videos'].length; i++) {
                if (int.parse(response['videos'][i]['order_number']) >
                    int.parse(orderNumber)) {
                  listOrderNumber = response['videos'][i]['order_number'];
                  nextVideoThumbnail = response['videos'][i]['thumbnails'];
                  nextVideoTitle = response['videos'][i]['title'];
                  nextVideoUrl = response['videos'][i]['video_file'];
                  nextVideoRawUrl = response['videos'][i]['video_raw_file'];
                  nextScreenView = response['videos'][i]['orientation'];
                  nextVideoId = response['videos'][i]['id'];

                  if (nextVideoRawUrl != null && nextVideoRawUrl != "") {
                    nextVideoRawUrl = nextVideoRawUrl;
                  } else {
                    nextVideoRawUrl = nextVideoUrl;
                  }

                  break;
                }
              }

              // to get the first order number if the last next order number is finished
              if (nextVideoRawUrl.isEmpty) {
                if (response['videos'].length > 0) {
                  listOrderNumber = response['videos'][0]['order_number'];
                  nextVideoThumbnail = response['videos'][0]['thumbnails'];
                  nextVideoTitle = response['videos'][0]['title'];
                  nextVideoUrl = response['videos'][0]['video_file'];
                  nextVideoRawUrl = response['videos'][0]['video_raw_file'];
                  nextScreenView = response['videos'][0]['orientation'];
                  nextVideoId = response['videos'][0]['id'];

                  if (nextVideoRawUrl != null && nextVideoRawUrl != "") {
                    nextVideoRawUrl = nextVideoRawUrl;
                  } else {
                    nextVideoRawUrl = nextVideoUrl;
                  }
                }
              }

              //nextScreenView = snapshot.data['videos'][i]['orientation'];

              print("video orientation --->$orientation");
              // print("video id --->${widget.videoId}");
              //print("video url s3 --->${videoUrlS3}");
              //print("video url raw--->${videoUrl}");

              return Container(
                //color: Color(0xff17191E),
                color: Colors.black,
                width: width,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // bannerPreviewStyleId = 1 (large)
                          // bannerPreviewStyleId = 2 (small)

                          bannerPreviewStyleId == "2"
                              ? Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                    top: 50,
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                            Text(
                                              '',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          bannerPreviewStyleId == "2"
                              ? Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    foregroundDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                        begin: FractionalOffset.centerLeft,
                                        end: FractionalOffset.centerRight,
                                        stops: [0.0, 1.0],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                      foregroundDecoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 0.2, 0, 2],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          // colorFilter: new ColorFilter.mode(
                                          //     Colors.black.withOpacity(0.8),
                                          //     BlendMode.dstATop),
                                          image: NetworkImage(image),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 10,
                                          top: 50,
                                        ),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                  Text(
                                                    '',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (Platform.isAndroid) {
                                          /// Android-specific code
                                          //_flutterToAndroid();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayVideoScreenNew(
                                                title: title,
                                                video: videoUrlS3,
                                                videoId: userVideoId,
                                                screenView: orientation,
                                                nextVideoTitle: nextVideoTitle,
                                                nextVideoThumbnail:
                                                    nextVideoThumbnail,
                                                nextVideoUrl: nextVideoUrl,
                                                nextVideoScreenView:
                                                    nextScreenView,
                                                nextVideoId: nextVideoId,
                                                pausedPosition: 0,
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        } else if (Platform.isIOS) {
                                          /// iOS-specific code
                                          //_flutterToIos();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayVideoScreenNew(
                                                title: title,
                                                video: videoUrlS3,
                                                videoId: userVideoId,
                                                screenView: orientation,
                                                nextVideoTitle: nextVideoTitle,
                                                nextVideoThumbnail:
                                                    nextVideoThumbnail,
                                                nextVideoUrl: nextVideoUrl,
                                                nextVideoScreenView:
                                                    nextScreenView,
                                                nextVideoId: nextVideoId,
                                                pausedPosition: 0,
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      child: Image(
                                        height: 45,
                                        width: 45,
                                        image: AssetImage(
                                            'images/icon_play_new.png'),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        if (!isInWatchList) {
                                          setState(() {
                                            loading = true;
                                          });
                                          var res = await VideoService()
                                              .updateWatchlist(
                                            videoId: widget.videoId,
                                            action: 'add',
                                          );
                                          setState(() {
                                            loading = false;
                                          });
                                          if (res['success']) {
                                            setState(() {
                                              // isWatchlist = true;
                                            });
                                            VideoService()
                                                .getVideoDetails(widget.videoId)
                                                .then((data) {
                                              //videoController.add(data);
                                            });

                                            Fluttertoast.showToast(
                                              msg: 'Added to watchlist',
                                              textColor: Colors.black,
                                              backgroundColor: Colors.white,
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });
                                          var res = await VideoService()
                                              .updateWatchlist(
                                            videoId: widget.videoId,
                                            action: 'delete',
                                          );
                                          setState(() {
                                            loading = false;
                                          });
                                          if (res['success']) {
                                            setState(() {
                                              // isWatchlist = false;
                                            });
                                            VideoService()
                                                .getVideoDetails(widget.videoId)
                                                .then((data) {
                                              //videoController.add(data);
                                            });

                                            Fluttertoast.showToast(
                                              msg: 'Removed from watchlist',
                                              textColor: Colors.black,
                                              backgroundColor: Colors.white,
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        child: loading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : CircleAvatar(
                                                radius: deviceType ==
                                                        DeviceType.mobile
                                                    ? 18
                                                    : 22,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Center(
                                                  child: Icon(
                                                    isInWatchList
                                                        ? Icons.check
                                                        : Icons.add,
                                                    color: Colors.white,
                                                    size: deviceType ==
                                                            DeviceType.mobile
                                                        ? 25.0
                                                        : 30.0,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                isInPausedList == true
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayVideoScreenNew(
                                                title: title,
                                                video: videoUrlS3,
                                                videoId: userVideoId,
                                                screenView: orientation,
                                                nextVideoTitle: nextVideoTitle,
                                                nextVideoThumbnail:
                                                    nextVideoThumbnail,
                                                nextVideoUrl: nextVideoUrl,
                                                nextVideoScreenView:
                                                    nextScreenView,
                                                nextVideoId: nextVideoId,
                                                pausedPosition: pausedPosition,
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          height: 56,
                                          width: deviceType == DeviceType.mobile
                                              ? 220
                                              : 300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'RESUME WATCHING',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: deviceType ==
                                                          DeviceType.mobile
                                                      ? 18.0
                                                      : 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                isInPausedList == true
                                    ? SizedBox(height: 12)
                                    : Container(),
                                Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: deviceType == DeviceType.mobile
                                          ? 25.0
                                          : 35.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        //color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 28.0, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        year != null ? year.toString() : "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              deviceType == DeviceType.mobile
                                                  ? 15.0
                                                  : 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 11),
                                      Text(
                                        '|',
                                        style: GoogleFonts.comfortaa(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          category ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                deviceType == DeviceType.mobile
                                                    ? 15.0
                                                    : 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 11),
                                      Text(
                                        '|',
                                        style: GoogleFonts.comfortaa(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          subCategory ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                deviceType == DeviceType.mobile
                                                    ? 15.0
                                                    : 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    width: width,
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        height: 1.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 12.0
                                                : 20,
                                      ),
                                      maxLines: 5,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    });
  }
}
