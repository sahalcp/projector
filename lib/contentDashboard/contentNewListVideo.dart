import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/cacheService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/shimmer/shimmerLoading.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/uploading/summaryScreen.dart';
import 'package:sizer/sizer.dart';

import '../widgets/widgets.dart';

class ContentNewListVideo extends StatefulWidget {
  ContentNewListVideo({
    this.videoId,
  });

  final String videoId;
  @override
  _ContentNewListVideoState createState() => _ContentNewListVideoState();
}

class _ContentNewListVideoState extends State<ContentNewListVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController streamContentList = StreamController.broadcast();

  String filterText = 'Date';
  var isVideoSelected = true;
  var isVideoProcessing = false;
  var processingThumbnail = "";
  String uploadingVideoId, uploadingVideotitle;
  Timer timer;

  @override
  void initState() {
    _getProcessingVideo(widget.videoId);

    super.initState();
  }

  _getProcessingVideo(String videoId) async {
    if (videoId == null || videoId == '') {
      videoId = (await CacheService().readIntFromCache('videoId')).toString();
    }

    if (videoId != null && videoId != "") {
      setState(() {
        uploadingVideoId = videoId;
        timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          // call Api here
          VideoService()
              .getVideoStatus(videoId: uploadingVideoId.toString())
              .then((response) {
            if (response['success'] == true) {
              var videos = response['videos'][0];

              processingThumbnail = videos['thumbnails'][0];
              var status = videos['status'];
              var title = videos['title'];
              uploadingVideotitle = title;
              if (status == "Completed") {
                setState(() {
                  isVideoProcessing = false;
                  timer.cancel();
                });
              } else if (status == "Not Started") {
                setState(() {
                  isVideoProcessing = true;
                });
              } else {
                setState(() {
                  isVideoProcessing = true;
                });
              }
            }
          });
        });
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    viewData(title, data, addOn, context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Container(
            // height: 300,
            padding: EdgeInsets.only(left: 11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 11.0),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          filterText = data[index];
                        });

                        VideoService()
                            .getMyContentsAll(sortBy: filterText)
                            .then((val) {
                          streamContentList.add(val);
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        data[index],
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 11.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '$addOn',
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff5AA5EF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            bottom: PreferredSize(
                child: Container(
                  color: Colors.grey[200],
                  height: 2.0,
                ),
                preferredSize: Size.fromHeight(4.0)),
            elevation: 0,
            // backgroundColor: Color(0xff1A1D2A),
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                navigateRemoveLeft(context, StartWatchingScreen());
                // if (Navigator.canPop(context)) {
                //   Navigator.pop(context);
                // } else {
                //   SystemNavigator.pop();
                // }
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
            titleSpacing: 0.0,
            title: Text(
              'Content',
              style: GoogleFonts.poppins(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          key: _scaffoldKey,
          // drawer: DrawerList(title: title),
          body: Container(
              color: Colors.white,
              width: width,
              // padding: EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: width,
                        color: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isVideoSelected = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Videos',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.0,
                                      color: isVideoSelected
                                          ? Color(0xff5AA5EF)
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      height: 2,
                                      color: isVideoSelected
                                          ? Color(0xff5AA5EF)
                                          : Colors.transparent),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isVideoSelected = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Photo Albums',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.0,
                                      color: isVideoSelected
                                          ? Colors.black
                                          : Color(0xff5AA5EF),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      height: 2,
                                      color: isVideoSelected
                                          ? Colors.transparent
                                          : Color(0xff5AA5EF)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        color: Color(0xff2E2E2E),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              filterText,
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32.0),
                                      topRight: Radius.circular(32.0),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Container(
                                      height: height * 0.3,
                                      padding: EdgeInsets.only(
                                        top: 11.0,
                                        // left: 39.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              height: 3,
                                              width: 60,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 19),
                                          Container(
                                            padding:
                                                EdgeInsets.only(left: 39.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                viewData(
                                                    '',
                                                    [
                                                      'date',
                                                      'name',
                                                      'category'
                                                    ],
                                                    'Cancel',
                                                    context),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      isVideoProcessing == true &&
                              uploadingVideoId != null &&
                              uploadingVideoId != ""
                          ? Container(
                              height: height * 0.11,
                              width: width,
                              color: Colors.grey,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Container(
                                        height: 80,
                                        width: 135,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: processingThumbnail != null
                                                ? NetworkImage(
                                                    processingThumbnail)
                                                : AssetImage(''),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Container(
                                        width: width * 0.3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(height: 15),
                                            Text(
                                              uploadingVideotitle,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Processing...  ',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: FutureBuilder(
                          future: VideoService()
                              .getMyContentsAll(sortBy: filterText),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var videoContent = [];
                              var photoContent = [];

                              var videosList = snapshot.data['video'];
                              videoContent = videosList;

                              var albumList = snapshot.data['album'];
                              photoContent = albumList;

                              /* for (var item in snapshot.data) {
                        if (item['type'] == "album") {
                          photoContent.add(item);
                        } else {
                          videoContent.add(item);
                        }
                      }*/

                              return (isVideoSelected
                                      ? videoContent.isEmpty
                                      : photoContent.isEmpty)
                                  ? Container(
                                      height: height * 0.2,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No Contents',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: isVideoSelected
                                              ? videoContent.length
                                              : photoContent.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var contextData = isVideoSelected
                                                ? videoContent
                                                : photoContent;
                                            var contentId = contextData[index]
                                                ['content_id'];

                                            String type =
                                                contextData[index]['type'];

                                            var image =
                                                contextData[index]['thumbnail'];
                                            var description = contextData[index]
                                                ['description'];
                                            var title =
                                                contextData[index]['title'];
                                            var status =
                                                contextData[index]['status'];
                                            var visibility = contextData[index]
                                                ['visibility'];

                                            return type == "album"
                                                ? Container(
                                                    child: InkWell(
                                                    onTap: () {
                                                      navigate(
                                                        context,
                                                        SummaryScreen(
                                                          type: type,
                                                          contentId: contentId,
                                                          pageType: "profile",
                                                          title: title,
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: width *
                                                                    0.17,
                                                              ),
                                                              Container(
                                                                height: 85,
                                                                width: 85,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    image: image !=
                                                                            null
                                                                        ? NetworkImage(
                                                                            image,
                                                                          )
                                                                        : AssetImage(
                                                                            ''),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.03,
                                                              ),
                                                              Container(
                                                                width:
                                                                    width * 0.3,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // SizedBox(height: 15),
                                                                    Text(
                                                                      title !=
                                                                              null
                                                                          ? title
                                                                          : "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      description !=
                                                                              null
                                                                          ? description
                                                                          : "",
                                                                      maxLines:
                                                                          2,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 8.0),
                                                            child: Text(
                                                              _checkVisibilityStatus(
                                                                  visibility),
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                                : Container(
                                                    child: InkWell(
                                                    onTap: () {
                                                      navigate(
                                                        context,
                                                        SummaryScreen(
                                                          type: type,
                                                          contentId: contentId,
                                                          pageType: "profile",
                                                          title: title,
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: deviceType ==
                                                                        DeviceType
                                                                            .mobile
                                                                    ? height *
                                                                        0.10
                                                                    : height *
                                                                        0.12,
                                                                width: deviceType ==
                                                                        DeviceType
                                                                            .mobile
                                                                    ? width *
                                                                        0.37
                                                                    : width *
                                                                        0.20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    image:
                                                                        NetworkImage(
                                                                      image,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.03,
                                                              ),
                                                              Container(
                                                                width:
                                                                    width * 0.3,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // SizedBox(height: 15),
                                                                    Text(
                                                                      title !=
                                                                              null
                                                                          ? title
                                                                          : "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      description !=
                                                                              null
                                                                          ? description
                                                                          : "",
                                                                      maxLines:
                                                                          2,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          status == '0'
                                                              ? Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 8.0),
                                                                  child: Text(
                                                                    'DRAFT',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                          },
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    );
                            } else {
                              return contentLoading(height, width);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      );
    });
  }
}

_checkVisibilityStatus(String status) {
  if (status == "1") {
    return "PRIVATE";
  } else if (status == "2") {
    return "PUBLIC";
  } else if (status == "3") {
    return "GROUP";
  } else {
    return "";
  }
}

allVideosAppBar(title, context, height, width, _scaffoldKey) {
  return Padding(
    padding: EdgeInsets.only(
      left: 13.0,
      right: 16.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // _scaffoldKey.currentState.openDrawer();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 25,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                navigate(
                  context,
                  ContentViewScreen(
                    myVideos: true,
                    userId: '',
                  ),
                );
              },
              child: Text(
                'Content',
                style: GoogleFonts.poppins(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        Row(
          children: [
            // InkWell(
            //   onTap: () {
            //     navigateLeft(context, SelectVideoView());
            //   },
            //   child: Icon(
            //     Icons.video_call,
            //     size: 30,
            //   ),
            // ),
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                navigate(context, ViewProfilePage());
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image(
                    height: 20.0,
                    color: Colors.white,
                    image: AssetImage(
                      'images/person.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
