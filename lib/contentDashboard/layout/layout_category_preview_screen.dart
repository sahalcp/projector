import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/videoService.dart';
// import '../signInScreen.dart';

class LayoutCategoryPreviewScreen extends StatefulWidget {
  LayoutCategoryPreviewScreen(
      {this.title, @required this.playlistId, @required this.isCategory});
  final String title, playlistId;
  final bool isCategory;

  @override
  _LayoutCategoryPreviewScreenState createState() =>
      _LayoutCategoryPreviewScreenState();
}

class _LayoutCategoryPreviewScreenState
    extends State<LayoutCategoryPreviewScreen> {
  var selectedBackgroundImageId;
  bool loading = false, edit = false, spin = false;
  final formKey = GlobalKey<FormState>();
  String title;
  TextEditingController text;

  @override
  void initState() {
    setState(() {
      text = TextEditingController(text: widget.title);
      title = widget.title;
      // print("categoryid--->${widget.playlistId}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
          titleSpacing: 0.0,
          title: Transform(
            transform: Matrix4.translationValues(0.0, 0.0, 0.0),
            child: Text(
              widget.isCategory
                  ? title != null
                      ? title
                      : ""
                  : "Manage Playlist",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Container(
            color: Colors.white,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.01),
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
                                        widget.isCategory
                                            ? snapshot.data[0]['icon'] != null
                                                ? Container(
                                                    height: height * 0.2,
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              snapshot.data[0]
                                                                  ['icon']),
                                                          fit: BoxFit.fill),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff707070),
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
                                                        color:
                                                            Color(0xff707070),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  )
                                            : Container(),

                                        //  widget.isCategory? SizedBox(height: 10) : SizedBox(height: 0),

                                        widget.isCategory
                                            ? InkWell(
                                                child: Container(
                                                  child: Align(
                                                    child: Text(
                                                      'Edit Background',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            Color(0xff818181),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topRight,
                                                  ),
                                                  margin: EdgeInsets.all(10),
                                                ),
                                                onTap: () {
                                                  addBottomSheetData(
                                                      context, setState);
                                                },
                                              )
                                            : Container(),

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
                                    height: height * 0.5,
                                    child: ReorderableListView(
                                        physics: NeverScrollableScrollPhysics(),
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

  addBottomSheetData(context1, setStateModal) {
    var val = '';
    int selectedBackground;
    bool loading = false;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateM) {
            return Container(
              height: height * 0.6,
              padding: EdgeInsets.only(
                top: 11.0,
                // left: 39.0,
              ),
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 3,
                        width: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 19),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Select Background',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  child: FutureBuilder(
                                    future: VideoService()
                                        .getCategoryBackgroundImages(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data.length == 0
                                            ? Center(
                                                child: Text(
                                                  'No Background',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                //alignment: Alignment.centerLeft,
                                                child: Container(
                                                  child: GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 3,
                                                      crossAxisSpacing: 16,
                                                      mainAxisSpacing: 16,
                                                    ),
                                                    itemCount:
                                                        snapshot.data.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var image = snapshot
                                                          .data[index]['image'];
                                                      return InkWell(
                                                        onTap: () async {
                                                          selectedBackgroundImageId =
                                                              snapshot.data[
                                                                  index]['id'];

                                                          var categoryAdded =
                                                              await VideoService()
                                                                  .addEditCategory(
                                                                      categoryId:
                                                                          widget
                                                                              .playlistId,
                                                                      bgImageId:
                                                                          selectedBackgroundImageId);
                                                          if (categoryAdded[
                                                                  'success'] ==
                                                              true) {
                                                            Navigator.pop(
                                                                context);

                                                            setState(() {});
                                                          }

                                                          /*  setStateM(() {
                                                          selectedBackground =
                                                              index;
                                                        });*/
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          height: 90,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                // Color(0xff2F303D),
                                                                Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            border: Border.all(
                                                              color: selectedBackground !=
                                                                          null &&
                                                                      selectedBackground ==
                                                                          index
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .transparent,
                                                              width: 3.0,
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              // image: AssetImage('images/pic.png'),

                                                              image:
                                                                  NetworkImage(
                                                                      image),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin: EdgeInsets.all(5),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
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
