import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/widgets.dart';
// import '../signInScreen.dart';

class ContentPreviewScreen extends StatefulWidget {
  ContentPreviewScreen(
      {this.title, @required this.playlistId, @required this.isCategory});
  final String title, playlistId;
  final bool isCategory;

  @override
  _ContentPreviewScreenState createState() => _ContentPreviewScreenState();
}

class _ContentPreviewScreenState extends State<ContentPreviewScreen> {
  bool loading = false, edit = false, spin = false;
  final formKey = GlobalKey<FormState>();
  String title;
  TextEditingController text;

  @override
  void initState() {
    setState(() {
      text = TextEditingController(text: widget.title);
      title = widget.title;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Container(
            color: Colors.white,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.01),
                Padding(
                  padding: EdgeInsets.only(
                    left: 14,
                    top: 10,
                    right: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color:Colors.red
                            ),
                          ),

                          // Text(
                          //   widget.title,
                          //   style: TextStyle(
                          //     fontSize: 22,
                          //     color: Colors.black,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // SizedBox(width: width * 0.1),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              navigate(
                                context,
                                NewContentViewScreen(
                                  myVideos: true,
                                  userId: '',
                                ),
                              );
                            },
                            child: Text(
                              'View My Content',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              navigate(context, SelectVideoView());
                            },
                            child: Icon(
                              Icons.video_call,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              navigate(context, ViewProfilePage());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: title == ''
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(
                                  height: 20.0,
                                  color:
                                      title == '' ? Colors.white : Colors.black,
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
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 11.0,
                  ),
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: widget.isCategory
                              ? VideoService().getCategoryVideos(
                                  categoryId: widget.playlistId)
                              : VideoService().getPlaylistVideos(
                                  playlistId: widget.playlistId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data[0]['videos'].length != 0) {
                                snapshot.data[0]['videos'].sort((a, b) {
                                  if (int.parse(a['order_number']) >
                                      int.parse(b['order_number'])) {
                                    return 1;
                                  } else
                                    return -1;
                                });
                              }
                              var count = snapshot.data[0]['videos'].length;
                              var date =
                                  DateTime.parse(snapshot.data[0]['updated']);
                              int views = 0;
                              snapshot.data[0]['videos'].forEach((video) {
                                views += int.parse(video['views']);
                              });
                              return Column(
                                children: [
                                  Container(
                                    width: width,
                                    padding: EdgeInsets.only(
                                      top: 20.0,
                                      left: 28.0,
                                      right: 29.0,
                                      bottom: 40.0,
                                    ),
                                    color: Color(0xffF4F4F4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        snapshot.data[0]['video_count'] != 0
                                            ? Container(
                                                height: height * 0.2,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                            .data[0]['videos']
                                                        [0]['thumbnails'][0]),
                                                  ),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Color(0xff707070),
                                                    width: 1.0,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: height * 0.2,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Color(0xff707070),
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                        SizedBox(height: 10),
                                        edit
                                            ? Form(
                                                key: formKey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: width * 0.6,
                                                      child: TextFormField(
                                                        controller: text,
                                                        validator: (val) {
                                                          if (val.length == 0)
                                                            return 'Cannot be empty field';
                                                        },
                                                        onChanged: (val) {
                                                          title = val;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (formKey.currentState
                                                            .validate()) {
                                                          setState(() {
                                                            spin = true;
                                                          });

                                                          if (widget
                                                              .isCategory) {
                                                            var res =
                                                                await VideoService()
                                                                    .addEditCategory(
                                                              title: title,
                                                              categoryId: widget
                                                                  .playlistId,
                                                            );
                                                            if (res['success'] ==
                                                                true) {
                                                              setState(() {
                                                                edit = false;
                                                              });
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Title Updated');
                                                            }
                                                            setState(() {
                                                              spin = false;
                                                            });
                                                          } else {
                                                            var res =
                                                                await VideoService()
                                                                    .addEditPlaylist(
                                                              title: title,
                                                              playlistId: widget
                                                                  .playlistId,
                                                            );
                                                            if (res['success'] ==
                                                                true) {
                                                              setState(() {
                                                                edit = false;
                                                              });
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Title Updated');
                                                            }
                                                            setState(() {
                                                              spin = false;
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: spin
                                                          ? Container(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.black,
                                                              size: 30,
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '$title',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xff1A1D2A),
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        edit = true;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 14.0,
                                                      color: Color(0xff818181),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$count Videos • $views Views • Updated ${date.month}/${date.day}',
                                              style: GoogleFonts.poppins(
                                                color: Color(0xff818181),
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (widget.isCategory) {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  var res = await VideoService()
                                                      .deleteCategory(
                                                          catId: widget
                                                              .playlistId);
                                                  // print(res);
                                                  if (res['success']) {
                                                    Navigator.pop(context);
                                                  }

                                                  setState(() {
                                                    loading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  var res = await VideoService()
                                                      .deletePlaylist(
                                                          playlistId: widget
                                                              .playlistId);
                                                  // print(res);
                                                  if (res['success']) {
                                                    Navigator.pop(context);
                                                  }
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 20,
                                                width: width * 0.2,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Delete',
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xff818181),
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       'Public',
                                        //       style: GoogleFonts.poppins(
                                        //         color: Color(0xff818181),
                                        //         fontSize: 11.0,
                                        //         fontWeight: FontWeight.w500,
                                        //       ),
                                        //     ),
                                        //     Icon(
                                        //       Icons.keyboard_arrow_down,
                                        //       size: 16.0,
                                        //       color: Color(0xff818181),
                                        //     )
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.filter_list,
                                  //       color: Color(0xff5AA5EF),
                                  //     ),
                                  //     Text(
                                  //       'Filter',
                                  //       style: GoogleFonts.poppins(
                                  //         color: Color(0xff818181),
                                  //         fontSize: 14.0,
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Container(
                                    height: height * 0.4,
                                    child: ReorderableListView(
                                        children: List.generate(
                                          // separatorBuilder: (context, index) =>
                                          //     Divider(color: Color(0xff707070)),
                                          // physics: NeverScrollableScrollPhysics(),
                                          // itemCount:
                                          //     snapshot.data[0]['videos'].length,
                                          // shrinkWrap: true,
                                          // itemBuilder: (context, index) {
                                          snapshot.data[0]['videos'].length,
                                          (index) {
                                            var title = snapshot.data[0]
                                                ['videos'][index]['title'];
                                            var description = snapshot.data[0]
                                                    ['videos'][index]
                                                ['description'];
                                            var thumbnail = snapshot.data[0]
                                                ['videos'][index]['thumbnails'];
                                            return ContentPreviewCard(
                                              key: ValueKey(index),
                                              title: title,
                                              description: description,
                                              thumbnail: thumbnail,
                                            );
                                          },
                                        ),
                                        onReorder:
                                            (int oldIndex, int newIndex) async {
                                          setState(() {
                                            loading = true;
                                          });
                                          var videos =
                                              snapshot.data[0]['videos'];
                                          // setState(() {
                                          if (newIndex > oldIndex) {
                                            newIndex -= 1;
                                          }
                                          final item =
                                              videos.removeAt(oldIndex);
                                          videos.insert(newIndex, item);
                                          var ids = [], orderNumbers = [];

                                          for (var i = 0;
                                              i < videos.length;
                                              i++) {
                                            orderNumbers.add(i);
                                            ids.add(videos[i]['id']);
                                          }
                                          Map<dynamic, dynamic> items =
                                              Map.fromIterables(
                                                  ids, orderNumbers);
                                          if (widget.isCategory)
                                            await VideoService()
                                                .updateCategoryVideoOrder(
                                              categoryId: widget.playlistId,
                                              items: items,
                                            );
                                          else
                                            await VideoService()
                                                .updatePlaylistVideoOrder(
                                              playlistId: widget.playlistId,
                                              items: items,
                                            );
                                          setState(() {
                                            loading = false;
                                          });
                                        }),
                                  ),
                                  // Divider(color: Color(0xff707070))
                                ],
                              );
                            } else {
                              return Container(
                                height: height * 0.3,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

contentPreviewCard(height, width, key, title, description, thumbnail) {}

// ignore: must_be_immutable
class ContentPreviewCard extends StatelessWidget {
  ContentPreviewCard({this.title, this.description, this.thumbnail, this.key});

  final String title, description;
  List thumbnail;
  final Key key;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.1,
      margin: EdgeInsets.only(
        top: 12,
        bottom: 10,
      ),
      child: Row(
        children: [
          Image(
            width: 20,
            height: 20,
            image: AssetImage('images/drag.png'),
          ),
          SizedBox(width: 10),
          Container(
            height: height * 0.08,
            width: width * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                image: thumbnail.length == 0
                    ? AssetImage('images/mask.png')
                    : NetworkImage(thumbnail[0]),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  color: Color(0xff1A1D2A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 8.0,
                  color: Color(0xff1A1D2A),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
