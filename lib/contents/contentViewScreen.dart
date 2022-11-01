import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/accountSettings/NotificationInvitationScreen.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/contentDetailsScreen.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/commingSoon.dart';
import 'package:projector/widgets/widgets.dart';
import '../startWatching.dart';

class ContentViewScreen extends StatefulWidget {
  ContentViewScreen({
    @required this.myVideos,
    @required this.userId,
    this.userEmail,
    this.userImage,
  });

  final bool myVideos;
  final String userId, userEmail, userImage;

  @override
  _ContentViewScreenState createState() => _ContentViewScreenState();
}

class _ContentViewScreenState extends State<ContentViewScreen> {
  String name = '', searchText = '', categoryId = '', image;
  StreamController searchVideoList = StreamController.broadcast();
  bool selectedCategory = false;

  @override
  void initState() {
    if (widget.userId == '') {
      AccountService().getProfile().then((data) {
        // print(data);
        setState(() {
          image = data['image'];
          // name = data['first_name'] ?? '';
        });
      });
    } else {
      setState(() {
        name = widget.userEmail + '\'s' ?? '';
        image = widget.userImage;
      });
    }
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  bool searchVideos = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        //TODO: drawer
        /* drawer: DrawerList(title: ''),*/
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[400], width: 1.0))),
          //color: Colors.white,
          height: height * 0.07,
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
            backgroundColor: Color(0xff1A1D2A),
            selectedFontSize: 9,
            selectedLabelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
            ),
            unselectedFontSize: 9,
            unselectedItemColor: Colors.white,
            selectedIconTheme: IconThemeData(color: Color(0xff5AA5EF)),
            selectedItemColor: Color(0xff5AA5EF),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                label: 'SEARCH',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.bookmark_outline,
                  size: 30,
                ),
                label: 'WATCHLIST',
              ),
              BottomNavigationBarItem(
                icon: Image(
                  height: 30,
                  image: AssetImage('images/logoIcon.png'),
                ),
                label: 'PROJECTOR',
              ),
            ],
          ),
        ),
        body: Container(
          color: Color(0xff1a1d2a),
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: ListView(
            children: [
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     _scaffoldKey.currentState.openDrawer();
                  //   },
                  //   child: Icon(
                  //     Icons.menu,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Image(
                    height: 45,
                    image: AssetImage('images/logoIcon.png'),
                  ),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       searchVideos = !searchVideos;
                      //     });
                      //   },
                      //   child: Icon(
                      //     Icons.search,
                      //     size: 30,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          //commingSoonDialog(context);
                          navigate(context, SelectVideoView());
                        },
                        child: Icon(
                          Icons.video_call,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          navigate(context, NotificationInvitationScreen());
                        },
                        child: Image.asset(
                          "images/notificationWhite.png",
                          width: 30,
                          height: 30,
                        ),
                      ),

                      SizedBox(width: 20),
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
                                    height: 30.0,
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
              SizedBox(height: height * 0.015),
              selectedIndex == 2
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
                                            crossAxisCount: 2,
                                            childAspectRatio: 1,
                                          ),
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var title =
                                                snapshot.data[index]['title'];
                                            var category = snapshot.data[index]
                                                ['Category'];

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
                                                navigate(
                                                  context,
                                                  ContentDetailScreen(
                                                    videoId: snapshot
                                                        .data[index]['id'],
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      // margin: EdgeInsets.all(4),
                                                      height: height * 0.12,
                                                      // width: width * 0.36,
                                                      decoration: BoxDecoration(
                                                        // border: Border.all(
                                                        //   color: Colors.white,
                                                        // ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              image),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    category == null
                                                        ? SizedBox(
                                                            height: 0,
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8),
                                                                child: Text(
                                                                  category ??
                                                                      '',
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize: 9,
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
                                                        fontSize: 11.5,
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
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(color: Colors.grey),
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
                              Text(
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
                            if (searchText.isNotEmpty)
                              SizedBox(height: height * 0.02),
                            if (searchText.isNotEmpty)
                              Text(
                                ' Results for $searchText',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            SizedBox(height: 10),
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
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1.15,
                                                  crossAxisSpacing: 5),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var image = '';
                                            var title =
                                                snapshot.data[index]['title'];
                                            var category = snapshot.data[index]
                                                ['Category'];
                                            image = snapshot.data[index]
                                                ['thumbnails'];
                                            return InkWell(
                                              onTap: () {
                                                navigate(
                                                  context,
                                                  ContentDetailScreen(
                                                    videoId: snapshot
                                                        .data[index]['id'],
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(4),
                                                    height: height * 0.12,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image:
                                                            NetworkImage(image),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      // border: Border.all(
                                                      //   color: Colors.white,
                                                      // ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
                                                  category == null
                                                      ? SizedBox(height: 0)
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Text(
                                                                category ?? '',
                                                                textScaleFactor:
                                                                    1,
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize: 9,
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
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize: 12.5,
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
                      : Column(
                          children: [
                            Container(
                              height: height * 0.11,
                              // width: width,

                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //     image: AssetImage('images/unsplash.png'),
                              //   ),
                              // ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  '${widget.myVideos ? "YOUR" : name.toUpperCase()} \nPROJECTOR',
                                  textDirection: TextDirection.rtl,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 33.0,
                                  ),
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.04),
                            Container(
                              height: height * 0.09,
                              child: FutureBuilder(
                                future: widget.userId == ''
                                    ? VideoService().getMyCategory()
                                    : VideoService()
                                        .getMyFriendsCategory(widget.userId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data.length == 0
                                        ? Center(
                                            child: Text(
                                              'No Categories',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            alignment: Alignment.centerLeft,
                                            child: ListView.builder(
                                              itemCount: snapshot.data.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                var title = snapshot.data[index]
                                                    ['title'];
                                                return InkWell(
                                                  onTap: () {
                                                    if (categoryId ==
                                                        snapshot.data[index]
                                                            ['id']) {
                                                      setState(() {
                                                        categoryId = '';
                                                        selectedCategory =
                                                            false;
                                                      });
                                                    } else
                                                      setState(() {
                                                        categoryId = snapshot
                                                            .data[index]['id'];
                                                        selectedCategory = true;
                                                      });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    height: height * 0.08,
                                                    width: width * 0.44,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff2F303D),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        border: Border.all(
                                                          color: categoryId ==
                                                                  snapshot.data[
                                                                          index]
                                                                      ['id']
                                                              ? Colors.white
                                                              : Color(
                                                                  0xff3D3E49),
                                                          width: 3.0,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 3,
                                                          ),
                                                        ]),
                                                    child: Center(
                                                      child: Text(
                                                        title,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 2,
                                                      ),
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
                            SizedBox(height: height * 0.015),
                            // videoTitle('Resume Watching'),
                            // SizedBox(height: height * 0.015),
                            // FutureBuilder(
                            //   future: widget.userId == ''
                            //       ? VideoService().getCurrentWatching()
                            //       : VideoService()
                            //           .getMyFriendList(widget.userId, 'resume'),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasData) {
                            //       return Container(
                            //         height: height * 0.16,
                            //         child: snapshot.data.length == 0
                            //             ? Center(
                            //                 child: Text(
                            //                   'No Videos',
                            //                   style: GoogleFonts.montserrat(
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.w500,
                            //                     fontSize: 16,
                            //                   ),
                            //                 ),
                            //               )
                            //             : ListView.builder(
                            //                 itemCount: snapshot.data.length,
                            //                 shrinkWrap: true,
                            //                 scrollDirection: Axis.horizontal,
                            //                 itemBuilder: (context, index) {
                            //                   var image = '';
                            //                   var title =
                            //                       snapshot.data[index]['title'];

                            //                   if (widget.userId == '')
                            //                     image = snapshot.data[index]
                            //                         ['thumbnails'];
                            //                   else
                            //                     image = snapshot.data[index]
                            //                         ['thumbnails'];
                            //                   return InkWell(
                            //                     onTap: () {
                            //                       navigate(
                            //                         context,
                            //                         ContentDetailScreen(
                            //                           videoId: snapshot.data[index]
                            //                               ['id'],
                            //                         ),
                            //                       );
                            //                     },
                            //                     child: Column(
                            //                       children: [
                            //                         Container(
                            //                           margin: EdgeInsets.all(4),
                            //                           height: height * 0.12,
                            //                           width: width * 0.36,
                            //                           decoration: BoxDecoration(
                            //                             image: DecorationImage(
                            //                               image:
                            //                                   NetworkImage(image),
                            //                               fit: BoxFit.fill,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         Text(
                            //                           '$title',
                            //                           style: GoogleFonts.montserrat(
                            //                             color: Colors.white,
                            //                             fontSize: 15,
                            //                             fontWeight: FontWeight.w500,
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   );
                            //                 },
                            //               ),
                            //       );
                            //     } else {
                            //       return Container(
                            //         child: Center(
                            //           child: CircularProgressIndicator(),
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
                            // videoList(context, height, width),
                            SizedBox(height: height * 0.015),
                            // videoTitle('$name Playlist Videos'),
                            SizedBox(height: height * 0.015),
                            selectedCategory
                                ? FutureBuilder(
                                    future: widget.userId == ''
                                        ? VideoService().getCategoryVideos(
                                            categoryId: "$categoryId")
                                        : VideoService().getMyFriendsCategory(
                                            widget.userId,
                                            categoryId: categoryId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data.length == 0
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
                                            : Container(
                                                height: height * 0.23,
                                                child: ListView.builder(
                                                  itemCount:
                                                      snapshot.data.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "${snapshot.data[index]['title']}"
                                                                .toUpperCase(),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: height * 0.2,
                                                          child:
                                                              ListView.builder(
                                                            itemCount: snapshot
                                                                .data[index]
                                                                    ['videos']
                                                                .length,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index1) {
                                                              var image = '',
                                                                  id = '',
                                                                  title = '';
                                                              if (widget
                                                                      .userId ==
                                                                  '') {
                                                                var videos =
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'videos'];
                                                                if (videos !=
                                                                    null) {
                                                                  id = snapshot.data[
                                                                              index]
                                                                          [
                                                                          'videos']
                                                                      [
                                                                      index1]['id'];
                                                                  title = snapshot.data[index]
                                                                              [
                                                                              'videos']
                                                                          [
                                                                          index1]
                                                                      ['title'];
                                                                  image = snapshot
                                                                              .data[index]['videos'][index1][
                                                                                  'thumbnails']
                                                                              .length !=
                                                                          0
                                                                      ? snapshot.data[index]['videos']
                                                                              [
                                                                              index1]
                                                                          [
                                                                          'thumbnails'][0]
                                                                      : '';
                                                                }
                                                              } else {
                                                                image = snapshot
                                                                            .data[index]['videos'][index1][
                                                                                'thumbnails']
                                                                            .length !=
                                                                        0
                                                                    ? snapshot.data[index]['videos']
                                                                            [
                                                                            index1]
                                                                        [
                                                                        'thumbnails'][0]
                                                                    : '';
                                                                id = snapshot.data[
                                                                            index]
                                                                        [
                                                                        'videos']
                                                                    [
                                                                    index1]['id'];
                                                                title = snapshot
                                                                            .data[index]
                                                                        [
                                                                        'videos']
                                                                    [
                                                                    index1]['title'];
                                                              }
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ContentDetailScreen(
                                                                        videoId:
                                                                            id,
                                                                      ),
                                                                    ),
                                                                  ).then(
                                                                      (value) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              4),
                                                                      height:
                                                                          height *
                                                                              0.12,
                                                                      width: width *
                                                                          0.44,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(image),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: width *
                                                                          0.44,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        snapshot.data[index]['videos'][index1]['SubCategory'] ??
                                                                            '',
                                                                        style: GoogleFonts
                                                                            .montserrat(
                                                                          color:
                                                                              Colors.white70,
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: width *
                                                                          0.44,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 8),
                                                                        child:
                                                                            Text(
                                                                          '$title',
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                          maxLines:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
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
                                  )
                                : Column(
                                    children: [
                                      FutureBuilder(
                                        future: widget.userId == ''
                                            ? VideoService().getMyCategory()
                                            : VideoService()
                                                .getMyFriendsCategory(
                                                    widget.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return snapshot.data.length == 0
                                                ? Center(
                                                    child: Text(
                                                      'No Categories',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return FutureBuilder(
                                                        future: widget.userId ==
                                                                ''
                                                            ? VideoService()
                                                                .getCategoryVideos(
                                                                    categoryId:
                                                                        snapshot.data[index]
                                                                            [
                                                                            'id'])
                                                            : VideoService()
                                                                .getMyFriendsCategory(
                                                                    widget
                                                                        .userId,
                                                                    categoryId:
                                                                        snapshot
                                                                                .data[index]
                                                                            [
                                                                            'id']),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return snapshot.data
                                                                        .length ==
                                                                    0
                                                                ? Center(
                                                                    child: Text(
                                                                      'No Videos',
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    height:
                                                                        height *
                                                                            0.23,
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount: snapshot
                                                                          .data
                                                                          .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "${snapshot.data[index]['title']}".toUpperCase(),
                                                                                style: GoogleFonts.montserrat(
                                                                                  color: Colors.white,
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              height: height * 0.2,
                                                                              child: ListView.builder(
                                                                                itemCount: snapshot.data[index]['videos'].length,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.horizontal,
                                                                                itemBuilder: (context, index1) {
                                                                                  var image = '', id = '', title = '';
                                                                                  if (widget.userId == '') {
                                                                                    var videos = snapshot.data[index]['videos'];
                                                                                    if (videos != null) {
                                                                                      id = snapshot.data[index]['videos'][index1]['id'];
                                                                                      title = snapshot.data[index]['videos'][index1]['title'];
                                                                                      image = snapshot.data[index]['videos'][index1]['thumbnails'].length != 0 ? snapshot.data[index]['videos'][index1]['thumbnails'][0] : '';
                                                                                    }
                                                                                  } else {
                                                                                    image = snapshot.data[index]['videos'][index1]['thumbnails'].length != 0 ? snapshot.data[index]['videos'][index1]['thumbnails'][0] : '';
                                                                                    id = snapshot.data[index]['videos'][index1]['id'];
                                                                                    title = snapshot.data[index]['videos'][index1]['title'];
                                                                                  }
                                                                                  return InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                          builder: (context) => ContentDetailScreen(
                                                                                            videoId: id,
                                                                                          ),
                                                                                        ),
                                                                                      ).then((value) {
                                                                                        setState(() {});
                                                                                      });
                                                                                    },
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: EdgeInsets.all(4),
                                                                                          height: height * 0.12,
                                                                                          width: width * 0.44,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(6),
                                                                                            image: DecorationImage(
                                                                                              image: NetworkImage(image),
                                                                                              fit: BoxFit.fill,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: width * 0.44,
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                            snapshot.data[index]['videos'][index1]['SubCategory'] ?? '',
                                                                                            style: GoogleFonts.montserrat(
                                                                                              color: Colors.white70,
                                                                                              fontSize: 9,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: width * 0.44,
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.only(left: 8),
                                                                                            child: Text(
                                                                                              '$title',
                                                                                              style: GoogleFonts.montserrat(
                                                                                                color: Colors.white,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                              maxLines: 2,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                          } else {
                                                            return Container(
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      );
                                                    },
                                                  );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: height * 0.04),
                                      FutureBuilder(
                                        future: widget.userId == ''
                                            ? VideoService().getMyPlaylist()
                                            : VideoService().getMyFriendList(
                                                widget.userId, 'playlist'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return snapshot.data.length == 0
                                                ? Center(
                                                    child: Text(
                                                      'No Playlists',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "${snapshot.data[index]['title']}"
                                                                  .toUpperCase(),
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.2,
                                                            child: ListView
                                                                .builder(
                                                              itemCount: snapshot
                                                                  .data[index]
                                                                      ['videos']
                                                                  .length,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemBuilder:
                                                                  (context,
                                                                      index1) {
                                                                var image = '',
                                                                    id = '',
                                                                    title = '';
                                                                if (widget
                                                                        .userId ==
                                                                    '') {
                                                                  var videos = snapshot
                                                                              .data[
                                                                          index]
                                                                      [
                                                                      'videos'];
                                                                  if (videos !=
                                                                      null) {
                                                                    id = snapshot.data[index]
                                                                            [
                                                                            'videos']
                                                                        [
                                                                        index1]['id'];
                                                                    title = snapshot.data[index]['videos']
                                                                            [
                                                                            index1]
                                                                        [
                                                                        'title'];
                                                                    image = snapshot.data[index]['videos'][index1]['thumbnails'].length !=
                                                                            0
                                                                        ? snapshot.data[index]['videos'][index1]
                                                                            [
                                                                            'thumbnails'][0]
                                                                        : '';
                                                                  }
                                                                } else {
                                                                  image = snapshot.data[index]
                                                                              [
                                                                              'videos']
                                                                          [
                                                                          index1]
                                                                      [
                                                                      'thumbnails'];
                                                                  id = snapshot.data[
                                                                              index]
                                                                          [
                                                                          'videos']
                                                                      [
                                                                      index1]['id'];
                                                                  title = snapshot.data[index]
                                                                              [
                                                                              'videos']
                                                                          [
                                                                          index1]
                                                                      ['title'];
                                                                }
                                                                return InkWell(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ContentDetailScreen(
                                                                          videoId:
                                                                              id,
                                                                        ),
                                                                      ),
                                                                    ).then(
                                                                        (value) {
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        margin:
                                                                            EdgeInsets.all(4),
                                                                        height: height *
                                                                            0.12,
                                                                        width: width *
                                                                            0.44,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                NetworkImage(image),
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: width *
                                                                            0.44,
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Text(
                                                                          snapshot.data[index]['videos'][index1]['Category'] ??
                                                                              '',
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            color:
                                                                                Colors.white70,
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: width *
                                                                            0.44,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 8),
                                                                          child:
                                                                              Text(
                                                                            '$title',
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                            SizedBox(height: height * 0.015),
                          ],
                        ),

              // videoTitle('All Videos about $name'),
              // SizedBox(height: height * 0.015),
              // FutureBuilder(
              //   future: widget.userId == ''
              //       ? VideoService().getMyVideoList()
              //       : VideoService().getMyFriendList(widget.userId,''),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Container(
              //         height: height * 0.12,
              //         child: snapshot.data.length == 0
              //             ? Center(
              //                 child: Text(
              //                   'No Videos',
              //                   style: GoogleFonts.montserrat(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 16,
              //                   ),
              //                 ),
              //               )
              //             : ListView.builder(
              //                 itemCount: snapshot.data.length,
              //                 shrinkWrap: true,
              //                 scrollDirection: Axis.horizontal,
              //                 itemBuilder: (context, index) {
              //                   var image = '';
              //                   if (widget.userId == '')
              //                     image = snapshot.data[index]['thumbnails'][0];
              //                   else
              //                     image = snapshot.data[index]['thumbnails'];
              //                   return InkWell(
              //                     onTap: () {
              //                       navigate(
              //                         context,
              //                         ContentDetailScreen(
              //                           videoId: snapshot.data[index]['id'],
              //                         ),
              //                       );
              //                     },
              //                     child: Container(
              //                       margin: EdgeInsets.all(4),
              //                       height: height * 0.12,
              //                       width: width * 0.36,
              //                       decoration: BoxDecoration(
              //                         image: DecorationImage(
              //                           image: NetworkImage(image),
              //                           fit: BoxFit.fill,
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ),
              //       );
              //     } else {
              //       return Container(
              //         child: Center(
              //           child: CircularProgressIndicator(),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
