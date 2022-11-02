import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/accountSettings/NotificationInvitationScreen.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/constant.dart';
import 'package:projector/contents/albumDetailsScreen.dart';
import 'package:projector/contents/category_video_list.dart';
import 'package:projector/contents/contentDetailsScreen.dart';
import 'package:projector/shimmer/shimmerLoading.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/uploadPopupDialog.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../startWatching.dart';

class NewContentViewScreen extends StatefulWidget {
  NewContentViewScreen({
    @required this.myVideos,
    @required this.userId,
    this.userEmail,
    this.userImage,
  });

  final bool myVideos;
  final String userId, userEmail, userImage;

  @override
  _NewContentViewScreenState createState() => _NewContentViewScreenState();
}

class _NewContentViewScreenState extends State<NewContentViewScreen> {
  String name = '', searchText = '', image;
  StreamController searchVideoList = StreamController.broadcast();
  bool isResumeWatching = true;
  int notificationBadge = 0;
  List resumeListData = [];
  var storageAvailable;
  var availableStorage;
  var isLaunchSubscriptionWeb = false;
  var resumeTitle;
  var resumeSubCategory;
  var resumeThumbnails;
  var resumeVideoId;
  StreamController resumeController = StreamController.broadcast();

  var categoryListData = [];

  /*setLength(int i) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if(i==0){
        setState(() {
          isResumeWatching = false;
        });

      }else{
        setState(() {
          isResumeWatching = true;
        });
      };
    });
  }*/

  @override
  void initState() {
    print("userid-->" + widget.userId);

    ViewService().checkSubscription().then((response) {
      if (response['has_subsription'] == false) {
        isLaunchSubscriptionWeb = true;
      } else {
        ViewService().checkStorage().then((data) {
          var storageUsed = data['storageUsed'];
          var totalStorage = storageUsed['total_storage'];
          var usedStorage = storageUsed['used_storage'];

          availableStorage =
              double.parse(totalStorage) - double.parse(usedStorage);

          storageAvailable = double.parse(totalStorage) >= availableStorage &&
              availableStorage > 0;
        });
      }
    });

    ViewService().getAllViewRequestSentNotification('3', context).then((val) {
      notificationBadge = notificationBadge + val.length;

      if (notificationBadge > 0) {
        notificationBadge = 1;
      } else {
        notificationBadge = 0;
      }

      /*setState(() {
        if(notificationBadge>0){
          notificationBadge = 1;
        }else{
          notificationBadge = 0;
        }
      });*/
    });

    ViewService().getMyNotificationsLandingPage().then((data) {
      if (data['success'] == true) {
        var unreadCount = data['unread_count'];
        notificationBadge = unreadCount;
        if (notificationBadge > 0) {
          notificationBadge = 1;
        } else {
          notificationBadge = 0;
        }

        /* setState(() {
          if (notificationBadge > 0) {
            notificationBadge = 1;
          } else {
            notificationBadge = 0;
          }
        });*/
      }
    });

    VideoService().getResumeWatchingList(widget.userId).then((data) {
      if (data != null) {
        resumeController.add(data);
        resumeListData = data;

        setState(() {
          resumeListData = data;
          print("resume list data--->");
          List.generate(resumeListData.length, (index) {});
        });
      }
    });

    name = widget.userEmail != null ? widget.userEmail : '';
    if (name.isNotEmpty && name != "Welcome") {
      name = widget.userEmail != null ? widget.userEmail + '\'s' : '';
    }

    image = widget.userImage;

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  bool searchVideos = false;

  _goToContentDetailScreen({videoId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailScreen(
          videoId: videoId,
        ),
      ),
    ).then((value) {
      setState(() {
        VideoService().getResumeWatchingList(widget.userId).then((data) {
          if (data != null) {
            resumeController.add(data);
            resumeListData = data;

            setState(() {
              resumeListData = data;
              print("resume list data--->");
              List.generate(resumeListData.length, (index) {});
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double videoHeight = height * 0.11;
    double tabVideoHeight = height * 0.16;
    double videoWidth = width * 0.40;
    double tabVideoWidth = width * 0.25;
    double albumHeight = 105;
    double albumWidth = 105;
    double tabAlbumWidth = 150;
    double tabAlbumHeight = 150;
    double titleSize = 11;
    double tabTitleSize = 14;
    double subCategorySize = 7;
    double tabSubCategorySize = 10;
    double noVideosSize = 14.0;
    double mainTitleSize = 14.0;
    double tabMainTitleSize = 18.0;
    double videoMarginLeft = 16.0;
    double videoMarginRight = 5.0;

    return Sizer(builder: (context, orientation, deviceType) {
      /* if(deviceType == DeviceType.mobile){
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }else{
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      }*/
      return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            //backgroundColor: Color(0xff1A1D2A),
            backgroundColor: appBgColor,
            title: Container(
                child: Row(
              children: [
                InkWell(
                  onTap: () {
                    navigateRemove(context, StartWatchingScreen());
                  },
                  child: Image(
                    width: 45,
                    height: 45,
                    image: AssetImage('images/logoTransparent.png'),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    //commingSoonDialog(context);

                    if (isLaunchSubscriptionWeb == true) {
                      launch(serverPlanUrl);
                    } else {
                      if (storageAvailable) {
                        showPopupUpload(
                            context: context,
                            availableStorage: availableStorage);
                      } else {
                        storageDialog(context, height, width);
                      }
                    }
                  },
                  child: Icon(
                    Icons.video_call,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    //navigate(context, NotificationInvitationScreen());
                  },
                  child: new Stack(
                    children: <Widget>[
                      new IconButton(
                          icon: Icon(
                            Icons.notifications,
                            size: 31,
                          ),
                          onPressed: () {
                            navigate(context, NotificationInvitationScreen());
                          }),
                      notificationBadge != 0
                          ? new Positioned(
                              right: 11,
                              top: 11,
                              child: new Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 11,
                                  minHeight: 11,
                                ),
                                child: Text(
                                  '$notificationBadge',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : new Container()
                    ],
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    navigate(context, ViewProfilePage());
                  },
                  child: image != null
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 21,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(image),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image(
                              width: 20,
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
            )),
          ),
          key: _scaffoldKey,
          //TODO: drawer
          /* drawer: DrawerList(title: ''),*/
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: appBgColor,
              // border: Border(top: BorderSide(color: Colors.grey[400], width: 1.0),),
            ),
            //color: Colors.white,
            height:
                deviceType == DeviceType.mobile ? height * 0.10 : height * 0.11,
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              onTap: (val) {
                if (val == 3) {
                  navigateReplace(context, StartWatchingScreen());
                } else
                  setState(() {
                    selectedIndex = val;
                  });
              },
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              // backgroundColor: Color(0xff1A1D2A),
              backgroundColor: appBgColor,
              selectedFontSize: deviceType == DeviceType.mobile ? 9 : 14,
              selectedLabelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
              ),
              unselectedFontSize: deviceType == DeviceType.mobile ? 9 : 14,
              unselectedItemColor: Colors.white,
              selectedIconTheme: IconThemeData(color: Color(0xff5AA5EF)),
              selectedItemColor: Color(0xff5AA5EF),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: deviceType == DeviceType.mobile ? 30 : 38,
                  ),
                  label: 'HOME',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: deviceType == DeviceType.mobile ? 30 : 38,
                  ),
                  label: 'SEARCH',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.bookmark_outline,
                    size: deviceType == DeviceType.mobile ? 30 : 38,
                  ),
                  label: 'WATCHLIST',
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    height: deviceType == DeviceType.mobile ? 30 : 38,
                    width: deviceType == DeviceType.mobile ? 30 : 38,
                    image: AssetImage('images/logoTransparent.png'),
                  ),
                  label: 'PROJECTOR',
                ),
              ],
            ),
          ),
          body: Container(
            // color: Color(0xff1a1d2a),
            color: appBgColor,
            // padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView(
              children: [
                selectedIndex == 2
                    //todo: watchlist view
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // videoTitle('Resume Watching'),
                            SizedBox(height: height * 0.023),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Your Watchlist',
                                textScaleFactor: 1,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.023),
                            FutureBuilder(
                              future: VideoService().getWatchlist(
                                widget.userId == '',
                                id: widget.userId,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    // height: height * 0.16,
                                    child: snapshot.data.length == 0
                                        ? Center(
                                            child: Text(
                                              'No Videos',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        : GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? 2
                                                            : 3,
                                                    childAspectRatio:
                                                        deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? 1
                                                            : 1.3,
                                                    crossAxisSpacing: 5),
                                            itemCount: snapshot.data.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              var title =
                                                  snapshot.data[index]['title'];
                                              var subCategory = snapshot
                                                  .data[index]['SubCategory'];

                                              var image = snapshot
                                                          .data[index]
                                                              ['thumbnails']
                                                          .length >
                                                      0
                                                  ? snapshot.data[index]
                                                      ['thumbnails'][0]
                                                  : snapshot.data[index]
                                                      ['thumbnails'];
                                              return InkWell(
                                                onTap: () {
                                                  _goToContentDetailScreen(
                                                      videoId: snapshot
                                                          .data[index]['id']);

                                                  /*navigate(
                                                    context,
                                                    ContentDetailScreen(
                                                      videoId: snapshot
                                                          .data[index]['id'],
                                                    ),
                                                  );*/
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        // margin: EdgeInsets.all(4),
                                                        height: deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? videoHeight
                                                            : tabVideoHeight,
                                                        // width: width * 0.36,
                                                        decoration:
                                                            BoxDecoration(
                                                          // border: Border.all(
                                                          //   color: Colors.white,
                                                          // ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                image),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      subCategory == null
                                                          ? SizedBox(
                                                              height: 0,
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                                  child: Text(
                                                                    subCategory ??
                                                                        '',
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: deviceType ==
                                                                              DeviceType.mobile
                                                                          ? subCategorySize
                                                                          : tabSubCategorySize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                      // SizedBox(
                                                      //   height: 3,
                                                      // ),
                                                      Text(
                                                        ' $title',
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: Colors.white,
                                                          fontSize: deviceType ==
                                                                  DeviceType
                                                                      .mobile
                                                              ? titleSize
                                                              : tabTitleSize,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  );
                                } else {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : selectedIndex == 1
                        //todo: search view
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 40),
                                height: height * 0.07,
                                child: TextField(
                                  style: GoogleFonts.poppins(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  onChanged: (val) async {
                                    setState(() {
                                      searchText = val;
                                    });
                                    var res = await VideoService().searchVideo(
                                      widget.userId == '',
                                      key: val.toLowerCase(),
                                      id: widget.userId,
                                    );
                                    searchVideoList.add(res['videos']);
                                  },
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0),
                                    hintText: 'Search',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    fillColor: Color(0xff656565),
                                    filled: true,
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              if (searchText.isNotEmpty)
                                SizedBox(height: height * 0.02),
                              if (searchText.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  child: Text(
                                    searchText ?? '',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 49,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (searchText.isNotEmpty)
                                SizedBox(height: height * 0.02),
                              if (searchText.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  child: Text(
                                    ' Results for $searchText',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 10),
                              if (searchText.isNotEmpty)
                                StreamBuilder(
                                  stream: searchVideoList.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data.length == 0
                                          ? Center(
                                              child: Text(
                                                'No Videos',
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            )
                                          : GridView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          deviceType ==
                                                                  DeviceType
                                                                      .mobile
                                                              ? 2
                                                              : 3,
                                                      childAspectRatio:
                                                          deviceType ==
                                                                  DeviceType
                                                                      .mobile
                                                              ? 1.15
                                                              : 1.3,
                                                      crossAxisSpacing: 5),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var image = '';
                                                var title = snapshot.data[index]
                                                    ['title'];
                                                var subCategory = snapshot
                                                    .data[index]['SubCategory'];
                                                image = snapshot.data[index]
                                                    ['thumbnails'];
                                                return InkWell(
                                                  onTap: () {
                                                    _goToContentDetailScreen(
                                                        videoId: snapshot
                                                            .data[index]['id']);

                                                    /*navigate(
                                                      context,
                                                      ContentDetailScreen(
                                                        videoId: snapshot
                                                            .data[index]['id'],
                                                      ),
                                                    );*/
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 16,
                                                            right: 16,
                                                            top: 4,
                                                            bottom: 4),
                                                        height: deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? videoHeight
                                                            : tabVideoHeight,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                image),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          // border: Border.all(
                                                          //   color: Colors.white,
                                                          // ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      subCategory == null
                                                          ? SizedBox(height: 0)
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                                  child: Text(
                                                                    subCategory ??
                                                                        '',
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          subCategorySize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                      Text(
                                                        ' $title',
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: Colors.white,
                                                          fontSize: titleSize,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                    } else {
                                      return Container(
                                          // child: Center(
                                          //   child: CircularProgressIndicator(),
                                          // ),
                                          );
                                    }
                                  },
                                ),
                            ],
                          )
                        //todo: playlist view
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.03),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    //'${widget.myVideos ? "Your" : name} Projector',
                                    '$name Projector',
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: deviceType == DeviceType.mobile
                                          ? 25.0
                                          : 35.0,
                                    ),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.03),

                              // TODO: category list start
                              Container(
                                height: deviceType == DeviceType.mobile
                                    ? height * 0.09
                                    : height * 0.15,
                                child: FutureBuilder(
                                  future: VideoService().getUserContentList(
                                      widget.userId, context),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data.length == 0
                                          ? Center(
                                              child: Text(
                                                'No Categories',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: noVideosSize,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                itemCount: snapshot.data.length,
                                                shrinkWrap: true,
                                                // physics: NeverScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  var categoryList = snapshot
                                                          .data[index]['id'] ==
                                                      "1";

                                                  return categoryList
                                                      ? Container(
                                                          child: ListView
                                                              .builder(
                                                                  itemCount: snapshot
                                                                      .data[
                                                                          index]
                                                                          [
                                                                          'content']
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  // physics: NeverScrollableScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  itemBuilder:
                                                                      (context,
                                                                          contentIndex) {
                                                                    var title = snapshot.data[index]['content']
                                                                            [
                                                                            contentIndex]
                                                                        [
                                                                        'title'];
                                                                    var image = snapshot.data[index]['content']
                                                                            [
                                                                            contentIndex]
                                                                        [
                                                                        'icon'];

                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        navigate(
                                                                          context,
                                                                          CategoryVideoList(
                                                                            userId:
                                                                                widget.userId,
                                                                            categoryData:
                                                                                snapshot.data[index]['content'][contentIndex],
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 15),
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                4,
                                                                            left:
                                                                                16.0),
                                                                        height: height *
                                                                            0.08,
                                                                        width: deviceType == DeviceType.mobile
                                                                            ? videoWidth
                                                                            : videoWidth *
                                                                                0.6,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xff2F303D),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.transparent,
                                                                            width:
                                                                                3.0,
                                                                          ),
                                                                          image:
                                                                              DecorationImage(
                                                                            // image: AssetImage('images/pic.png'),
                                                                            colorFilter:
                                                                                new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                                                            image:
                                                                                NetworkImage(image),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            title,
                                                                            overflow:
                                                                                TextOverflow.fade,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              color: Colors.white,
                                                                              fontSize: deviceType == DeviceType.mobile ? 20 : 25,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            );
                                    } else {
                                      return categoryLoading(
                                          height,
                                          deviceType == DeviceType.mobile
                                              ? videoWidth
                                              : videoWidth * 0.8);
                                    }
                                  },
                                ),
                              ),
                              // TODO: category list end
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 40),
                                  //videoTitle('Resume Watching'),
                                  if (resumeListData.length > 0)
                                    Visibility(
                                      visible: isResumeWatching,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          videoTitle(
                                              title: 'Resume Watching',
                                              deviceType: deviceType),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var response =
                                                  await VideoService()
                                                      .clearResumeList(
                                                          userId:
                                                              widget.userId);

                                              if (response['success'] == true) {
                                                var message =
                                                    response['message'];
                                                Fluttertoast.showToast(
                                                    msg: message,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white);
                                                setState(() {
                                                  resumeListData.length = 0;
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Clear All",
                                              style: GoogleFonts.montserrat(
                                                fontSize: deviceType ==
                                                        DeviceType.mobile
                                                    ? 13.0
                                                    : 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  //Todo: resume list start
                                  if (resumeListData.length > 0)
                                    Visibility(
                                      visible: isResumeWatching,
                                      //visible: resumeDataLength == 0? false : true,
                                      child: Container(
                                        height: deviceType == DeviceType.mobile
                                            ? height * 0.2
                                            : height * 0.25,
                                        child: ListView.builder(
                                          itemCount: resumeListData.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            var title =
                                                resumeListData[index]['title'];
                                            var subCategory =
                                                resumeListData[index]
                                                    ['SubCategory'];
                                            var image = resumeListData[index]
                                                ['thumbnails'];
                                            var videoId =
                                                resumeListData[index]['id'];

                                            return InkWell(
                                              onTap: () {
                                                _goToContentDetailScreen(
                                                    videoId: videoId);

                                                /*Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ContentDetailScreen(
                                                            videoId: videoId,
                                                          ),
                                                        ),
                                                      );*/
                                              },
                                              child: Container(
                                                width: deviceType ==
                                                        DeviceType.mobile
                                                    ? videoWidth
                                                    : tabVideoWidth,
                                                margin: EdgeInsets.only(
                                                    right: videoMarginRight,
                                                    left: videoMarginLeft),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: deviceType ==
                                                              DeviceType.mobile
                                                          ? videoHeight
                                                          : tabVideoHeight,
                                                      width: videoWidth,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          child: Image(
                                                            image: NetworkImage(
                                                                image),
                                                            fit: BoxFit.fill,
                                                          )),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            subCategory ?? '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: deviceType ==
                                                                      DeviceType
                                                                          .mobile
                                                                  ? subCategorySize
                                                                  : tabSubCategorySize,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        title ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: Colors.white,
                                                          fontSize: deviceType ==
                                                                  DeviceType
                                                                      .mobile
                                                              ? titleSize
                                                              : tabTitleSize,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  //Todo: resume list end

                                  //Todo: playlist start
                                  Container(
                                    child: FutureBuilder(
                                      future: VideoService().getUserContentList(
                                          widget.userId, context),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return snapshot.data.length == 0
                                              ? Center(
                                                  child: Text(
                                                    'No Playlists',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: noVideosSize,
                                                    ),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        var mainTitle = snapshot
                                                                .data[index]
                                                            ['content_type'];
                                                        //id == 1 (categories)
                                                        //id == 2 (playlists)
                                                        //id == 3 (photo albums)

                                                        var photoAlbum =
                                                            snapshot.data[index]
                                                                    ['id'] ==
                                                                "3";

                                                        return photoAlbum
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  snapshot.data[index]['content']
                                                                              .length ==
                                                                          0
                                                                      ? Container()
                                                                      : Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            //videoTitle(name + "'s Photo Album"),
                                                                            //videoTitle('${widget.myVideos ? "Your" : name} Photo Album'),
                                                                            videoTitle(
                                                                                title: '$name Photo Album',
                                                                                deviceType: deviceType),
                                                                            Container(
                                                                              height: deviceType == DeviceType.mobile ? height * 0.2 : height * 0.25,
                                                                              child: ListView.builder(
                                                                                itemCount: snapshot.data[index]['content'].length,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.horizontal,
                                                                                itemBuilder: (context, contentIndex) {
                                                                                  var image = "", id = '', title = '';

                                                                                  id = snapshot.data[index]['content'][contentIndex]['id'];
                                                                                  image = snapshot.data[index]['content'][contentIndex]['icon'];

                                                                                  title = snapshot.data[index]['content'][contentIndex]['title'];
                                                                                  return Container(
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                            builder: (context) => AlbumDetailScreen(
                                                                                              albumId: id,
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child: Container(
                                                                                        width: deviceType == DeviceType.mobile ? albumWidth : tabAlbumWidth,
                                                                                        margin: EdgeInsets.only(bottom: 4.0, right: videoMarginRight, left: videoMarginLeft, top: 10.0),
                                                                                        child: Column(
                                                                                          // mainAxisAlignment:
                                                                                          //  MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              height: deviceType == DeviceType.mobile ? albumHeight : tabAlbumHeight,
                                                                                              width: deviceType == DeviceType.mobile ? albumWidth : tabAlbumWidth,
                                                                                              child: ClipRRect(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                  child: Image(
                                                                                                    image: NetworkImage(image),
                                                                                                    fit: BoxFit.fill,
                                                                                                  )),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 3,
                                                                                            ),
                                                                                            Text(
                                                                                              '$title',
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: GoogleFonts.montserrat(
                                                                                                color: Colors.white,
                                                                                                fontSize: deviceType == DeviceType.mobile ? titleSize : tabTitleSize,
                                                                                                fontWeight: FontWeight.w700,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                ],
                                                              )
                                                            : Container(
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount: snapshot
                                                                      .data[
                                                                          index]
                                                                          [
                                                                          'content']
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          contentIndex) {
                                                                    var mainTitle =
                                                                        snapshot.data[index]['content'][contentIndex]
                                                                            [
                                                                            'title'];
                                                                    var itemVideoCount = snapshot
                                                                        .data[
                                                                            index]
                                                                            [
                                                                            'content']
                                                                            [
                                                                            contentIndex]
                                                                            [
                                                                            'videos']
                                                                        .length;

                                                                    return Visibility(
                                                                      visible: itemVideoCount >
                                                                              0
                                                                          ? true
                                                                          : false,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                                                                child: Text(
                                                                                  '$mainTitle',
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: GoogleFonts.montserrat(
                                                                                    fontSize: deviceType == DeviceType.mobile ? mainTitleSize : tabMainTitleSize,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            height: deviceType == DeviceType.mobile
                                                                                ? height * 0.2
                                                                                : height * 0.25,
                                                                            child:
                                                                                ListView.builder(
                                                                              itemCount: snapshot.data[index]['content'][contentIndex]['videos'].length,
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemBuilder: (context, index1) {
                                                                                var image = "", id = '', title = '', subCategory;
                                                                                id = snapshot.data[index]['content'][contentIndex]['videos'][index1]['id'];
                                                                                image = snapshot.data[index]['content'][contentIndex]['videos'][index1]['thumbnails'];
                                                                                title = snapshot.data[index]['content'][contentIndex]['videos'][index1]['title'];
                                                                                subCategory = snapshot.data[index]['content'][contentIndex]['videos'][index1]['SubCategory'];

                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    _goToContentDetailScreen(videoId: id);

                                                                                    /*Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                              builder: (context) => ContentDetailScreen(
                                                                                                videoId: id,
                                                                                              ),
                                                                                            ),
                                                                                          );*/
                                                                                  },
                                                                                  child: Container(
                                                                                    width: deviceType == DeviceType.mobile ? videoWidth : tabVideoWidth,
                                                                                    margin: EdgeInsets.only(bottom: 4.0, right: videoMarginRight, left: videoMarginLeft),
                                                                                    child: Column(
                                                                                      // mainAxisAlignment:
                                                                                      //  MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: deviceType == DeviceType.mobile ? videoHeight : tabVideoHeight,
                                                                                          width: videoWidth,
                                                                                          child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: Image(
                                                                                                image: NetworkImage(image),
                                                                                                fit: BoxFit.fill,
                                                                                              )),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                '',
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: GoogleFonts.poppins(
                                                                                                  color: Colors.white,
                                                                                                  fontSize: 10,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                subCategory ?? '',
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: GoogleFonts.poppins(
                                                                                                  color: Colors.white,
                                                                                                  fontSize: deviceType == DeviceType.mobile ? subCategorySize : tabSubCategorySize,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                                textAlign: TextAlign.right,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            title ?? '',
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: GoogleFonts.montserrat(
                                                                                              color: Colors.white,
                                                                                              fontSize: deviceType == DeviceType.mobile ? titleSize : tabTitleSize,
                                                                                              fontWeight: FontWeight.w700,
                                                                                            ),
                                                                                            textAlign: TextAlign.left,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                      },
                                                    )
                                                  ],
                                                );
                                        } else {
                                          return playListLoading(
                                              deviceType == DeviceType.mobile
                                                  ? videoHeight
                                                  : tabVideoHeight,
                                              deviceType == DeviceType.mobile
                                                  ? videoWidth
                                                  : tabVideoWidth);
                                        }
                                      },
                                    ),
                                  ),
                                  //Todo: playlist end

                                  // Todo: All video list start
                                  SizedBox(
                                      height: deviceType == DeviceType.mobile
                                          ? 10.0
                                          : 20.0),
                                  Container(
                                    //padding: EdgeInsets.only(left: 16),
                                    height: deviceType == DeviceType.mobile
                                        ? height * 0.3
                                        : height * 0.35,
                                    child: FutureBuilder(
                                      future: VideoService()
                                          .getUserAllVideoList(widget.userId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data.length == 0) {
                                            return Center(
                                              child: Text(
                                                'No Videos',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: noVideosSize,
                                                ),
                                              ),
                                            );
                                          }
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              videoTitle(
                                                  title: 'All Videos',
                                                  deviceType: deviceType),
                                              SizedBox(height: 8.0),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      snapshot.data.length,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  // physics: SnappingListScrollPhysics(itemWidth: width),
                                                  itemBuilder:
                                                      (context, index) {
                                                    var title = snapshot
                                                        .data[index]['title'];
                                                    var subCategory =
                                                        snapshot.data[index]
                                                            ['SubCategory'];
                                                    var image =
                                                        snapshot.data[index]
                                                            ['thumbnails'];

                                                    return InkWell(
                                                      onTap: () {
                                                        _goToContentDetailScreen(
                                                            videoId: snapshot
                                                                    .data[index]
                                                                ['id']);

                                                        /*  navigate(
                                                                      context,
                                                                      ContentDetailScreen(
                                                                        videoId: snapshot
                                                                                .data[
                                                                            index]['id'],
                                                                      ),
                                                                    );*/
                                                      },
                                                      child: Container(
                                                        width: deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? videoWidth
                                                            : tabVideoWidth,
                                                        margin: EdgeInsets.only(
                                                            right:
                                                                videoMarginRight,
                                                            left:
                                                                videoMarginLeft),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: deviceType ==
                                                                      DeviceType
                                                                          .mobile
                                                                  ? videoHeight
                                                                  : tabVideoHeight,
                                                              width: videoWidth,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image(
                                                                    image: NetworkImage(
                                                                        image),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    '',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    subCategory ??
                                                                        '',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: deviceType ==
                                                                              DeviceType.mobile
                                                                          ? subCategorySize
                                                                          : tabSubCategorySize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                title ?? '',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: deviceType ==
                                                                          DeviceType
                                                                              .mobile
                                                                      ? titleSize
                                                                      : tabTitleSize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return videoLoading(
                                              deviceType == DeviceType.mobile
                                                  ? videoHeight
                                                  : tabVideoHeight,
                                              deviceType == DeviceType.mobile
                                                  ? videoWidth
                                                  : tabVideoWidth);
                                        }
                                      },
                                    ),
                                  ),
                                  // Todo: All video list end
                                ],
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
