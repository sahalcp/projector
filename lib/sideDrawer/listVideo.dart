import 'package:flutter/material.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/data/checkConnection.dart';
import 'package:projector/editVideo.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/uploading/selectVideo.dart';
// import '../getStartedScreen.dart';
import '../signInScreen.dart';
import '../widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ListVideo extends StatefulWidget {
  @override
  _ListVideoState createState() => _ListVideoState();
}

class _ListVideoState extends State<ListVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String title = 'All Videos';
  int videosCount = 4;

  @override
  void initState() {
    //CheckConnectionService().init(_scaffoldKey);
    super.initState();
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

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
       // drawer: DrawerList(title: title),
        body: Container(
         // color: Colors.white,
           color: Color(0xff1A1A26),
          width: width,
          // padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(height: height * 0.02),
              allVideosAppBar(title, context, height, width, _scaffoldKey),
              SizedBox(height: height * 0.03),
              Container(
                width: width,
                color: Color(0xff2E2E2E),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  Most Recent',
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
                                    padding: EdgeInsets.only(left: 39.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        viewData(
                                            '',
                                            ['Most Recent', 'Most Viewed'],
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
              Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 14.0,
                ),
                child: FutureBuilder(
                  future: VideoService().getMyVideoList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ? Container(
                              height: height * 0.2,
                              alignment: Alignment.center,
                              child: Text(
                                'No Videos Added',
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
                                  itemCount: snapshot.data.length < videosCount
                                      ? snapshot.data.length
                                      : videosCount,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    int videoId =
                                        int.parse(snapshot.data[index]['id']);
                                    String name = snapshot.data[index]['title'];
                                    String categoryId =
                                        snapshot.data[index]['category_id'];
                                    String description =
                                        snapshot.data[index]['description'];
                                    var status = snapshot.data[index]['status'];
                                    var videoFile =
                                        snapshot.data[index]['video_file'];
                                    var thumbnails =
                                        snapshot.data[index]['thumbnails'];
                                    var subCatId =
                                        snapshot.data[index]['subcategory_id'];
                                    var playlistIds =
                                        snapshot.data[index]['playlist_id'];
                                    var groupId =
                                        snapshot.data[index]['group_id'];
                                    var visibility =
                                        snapshot.data[index]['visibility'];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute<Null>(
                                            builder: (BuildContext context) {
                                              return EditVideo(
                                                videoId: videoId,
                                                img: thumbnails.length == 0
                                                    ? 'images/simon.png'
                                                    : thumbnails[0],
                                                title: name,
                                                desc: description,
                                                status: status,
                                                categoryId: categoryId,
                                                subCatId: subCatId,
                                                playlistIds: playlistIds,
                                                groupId: groupId,
                                                visibility:
                                                    int.parse(visibility),
                                              );
                                            },
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: height * 0.12,
                                                  width: width * 0.4,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image:
                                                          thumbnails.length == 0
                                                              ? AssetImage(
                                                                  'images/simon.png',
                                                                )
                                                              : NetworkImage(
                                                                  thumbnails[0],
                                                                ),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // SizedBox(height: 15),
                                                      Text(
                                                        name,
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        description,
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
                                            status == '0'
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text(
                                                      'DRAFT',
                                                      style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    if (videosCount == snapshot.data.length) {
                                      setState(() {
                                        videosCount = 4;
                                      });
                                    } else {
                                      setState(() {
                                        videosCount = snapshot.data.length;
                                      });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                        top: 20.0,
                                      ),
                                      child: Text(
                                        videosCount == snapshot.data.length
                                            ? 'View Less'
                                            : 'View More',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
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
              ),
            ],
          ),
        ),
      ),
    );
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
                  color: Colors.white
                ),
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
                  border: Border.all(
                      color:  Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image(
                    height: 20.0,
                    color:  Colors.white,
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
