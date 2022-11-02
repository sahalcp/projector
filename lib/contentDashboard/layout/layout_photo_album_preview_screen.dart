import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/photoService.dart';

class LayoutPhotoAlbumPreviewScreen extends StatefulWidget {
  LayoutPhotoAlbumPreviewScreen({this.title, @required this.albumId});
  final String title, albumId;

  @override
  _LayoutPhotoAlbumPreviewScreenState createState() =>
      _LayoutPhotoAlbumPreviewScreenState();
}

class _LayoutPhotoAlbumPreviewScreenState
    extends State<LayoutPhotoAlbumPreviewScreen> {
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
              "Manage Photo Album",
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
                          future: PhotoService()
                              .getMyAlbumDetail(albumId: widget.albumId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data[0]['photos'].length != 0) {
                                snapshot.data[0]['photos'].sort((a, b) {
                                  if (int.parse(a['order_number']) >
                                      int.parse(b['order_number'])) {
                                    return 1;
                                  } else
                                    return -1;
                                });
                              }
                              var count = snapshot.data[0]['photos'].length;
                              var date =
                                  DateTime.parse(snapshot.data[0]['updated']);
                              int views = 0;
                              snapshot.data[0]['photos'].forEach((video) {
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
                                        snapshot.data[0]['icon'] != null
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

                                                          var res =
                                                              await PhotoService()
                                                                  .addAlbum(
                                                            title: title,
                                                            albumId:
                                                                widget.albumId,
                                                          );
                                                          if (res['success'] ==
                                                              true) {
                                                            setState(() {
                                                              edit = false;
                                                            });
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Title Updated');
                                                          }
                                                          setState(() {
                                                            spin = false;
                                                          });
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    height: height * 0.5,
                                    child: ReorderableListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                          snapshot.data[0]['photos'].length,
                                          (index) {
                                            var title = snapshot.data[0]
                                                ['photos'][index]['title'];
                                            var description = snapshot.data[0]
                                                ['photos'][index]['photos'];
                                            var thumbnail = snapshot.data[0]
                                                ['photos'][index]['photo_file'];
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
                                          var photos =
                                              snapshot.data[0]['photos'];
                                          // setState(() {
                                          if (newIndex > oldIndex) {
                                            newIndex -= 1;
                                          }
                                          final item =
                                              photos.removeAt(oldIndex);
                                          photos.insert(newIndex, item);
                                          var ids = [], orderNumbers = [];

                                          for (var i = 0;
                                              i < photos.length;
                                              i++) {
                                            orderNumbers.add(i);
                                            ids.add(photos[i]['id']);
                                          }
                                          Map<dynamic, dynamic> items =
                                              Map.fromIterables(
                                                  ids, orderNumbers);

                                          await ContentDashboardService()
                                              .reOrderPhotosList(items);
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
  String thumbnail;
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
                image: NetworkImage(thumbnail),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title != null ? title : "",
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  color: Color(0xff1A1D2A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description != null ? description : "",
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
