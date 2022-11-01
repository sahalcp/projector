import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contentDashboard/layoutCategoryPreviewScreen.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/data/checkConnection.dart';
import 'package:projector/models/changeOrderModel.dart';
import 'package:projector/sideDrawer/contentPreviewScreen.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

import '../signInScreen.dart';

class LayoutCategoryScreen extends StatefulWidget {
  @override
  _LayoutCategoryScreenState createState() => _LayoutCategoryScreenState();
}

class _LayoutCategoryScreenState extends State<LayoutCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
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
              "Categories",
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
            width: width,
            // height: 100,
            // padding: EdgeInsets.all(16.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.01),

                Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    bottom: 5.0,
                  ),
                  child: Text(
                    'Categories',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Divider(
                  height: 1.0,
                  color: Color(0xff707070),
                ),
                FutureBuilder(
                  future: VideoService().getMyCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length != 0) {
                        snapshot.data.sort((a, b) {
                          if (int.parse(a['order_number']) >
                              int.parse(b['order_number'])) {
                            return 1;
                          } else
                            return -1;
                        });
                      }
                      return snapshot.data.length == 0
                          ? Container(
                              height: height * 0.1,
                              child: Center(
                                child: Text(
                                  'No Categories Found',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height:
                                  snapshot.data.length * height * 0.15,
                              child: ReorderableListView(
                                physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    snapshot.data.length,
                                    // (index) => null)
                                    // shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    (index) {
                                      // print(snapshot.data['data'][index]);
                                      var category =
                                          snapshot.data[index]['title'];
                                      var count = snapshot.data[index]
                                          ['video_count'];
                                      var id =
                                          snapshot.data[index]['id'];
                                      var thumbnails = snapshot.data
                                          [index]['thumbnails'];
                                      return CategoryCard(
                                        thumbnails: thumbnails,
                                        isCategory: true,
                                        category: category,
                                        key: ValueKey(index),
                                        videoCount: count,
                                        playlistId: id,
                                        onTapped: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LayoutCategoryPreviewScreen(
                                                title: category,
                                                playlistId: id,
                                                isCategory: true,
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                      );
                                    },
                                    // separatorBuilder: (ctx, index) => Divider(
                                    //   height: 1.0,
                                    //   color: Color(0xff707070),
                                    // ),
                                    // itemCount: snapshot.data['data'].length,
                                  ),
                                  onReorder:
                                      (int oldIndex, int newIndex) async {
                                    setState(() {
                                      loading = true;
                                    });
                                    var list = snapshot.data;
                                    // setState(() {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    final item =
                                        list.removeAt(oldIndex);
                                    list.insert(newIndex, item);
                                    var ids = [], orderNumbers = [];

                                    for (var i = 0;
                                        i < list.length;
                                        i++) {
                                      orderNumbers.add(i);
                                      ids.add(list[i]['id']);
                                    }
                                    Map<dynamic, dynamic> items =
                                        Map.fromIterables(ids, orderNumbers);
                                    // print(items);
                                    // var categoryId = list['data'][oldIndex]['id'];

                                    await VideoService()
                                        .updateCategoryOrder(items);
                                    setState(() {
                                      loading = false;
                                    });
                                  }),
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
                SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  CategoryCard({
    @required this.category,
    @required this.key,
    @required this.videoCount,
    @required this.playlistId,
    @required this.isCategory,
    this.onTapped,
    @required this.thumbnails,
  });

  final String category, playlistId;
  final Key key;
  final int videoCount;
  final bool isCategory;
  final Function onTapped;
  final List thumbnails;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 5.0,
              bottom: 5.0,
            ),
            child: Text(
              '$category',
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 5.0,
              bottom: 5.0,
            ),
            child: Row(
              children: [
                Image(
                  width: 16,
                  height: 16,
                  image: AssetImage('images/drag.png'),
                ),
                Container(
                  height: height * 0.08,
                  width: width * 0.8,
                  child: Stack(
                    children: [
                      thumbnails.length >= 1 && thumbnails[0] != null
                          ? Positioned(
                              left: width * 0.04,
                              child: Container(
                                height: height * 0.08,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(thumbnails[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      thumbnails.length >= 2 && thumbnails[1] != null
                          ? Positioned(
                              left: width * 0.1,
                              child: Container(
                                height: height * 0.08,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  // color: Color(0xff5AA5EF),
                                  image: DecorationImage(
                                    image: NetworkImage(thumbnails[1]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(
                                    color: Color(0xff707070),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      thumbnails.length >= 3 && thumbnails[2] != null
                          ? Positioned(
                              left: width * 0.16,
                              child: Container(
                                height: height * 0.08,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  // color: Colors.black,
                                  image: DecorationImage(
                                    image: NetworkImage(thumbnails[2]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(
                                    color: Color(0xff707070),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      thumbnails.length >= 4 && thumbnails[3] != null
                          ? Positioned(
                              left: width * 0.22,
                              child: Container(
                                height: height * 0.08,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(thumbnails[3]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(
                                    color: Color(0xff707070),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Positioned(
                          left: thumbnails.length >= 4
                              ? width * 0.47
                              : thumbnails.length >= 3
                                  ? width * 0.42
                                  : thumbnails.length >= 2
                                      ? width * 0.35
                                      : width * 0.3,
                          top: height * 0.01,
                          child: thumbnails.length == 0
                              ? Text(
                                  'No Videos',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Container()
                          // : CircleAvatar(
                          //     backgroundColor: Color(0xffF5F4F4),
                          //     child: Text(
                          //       '$videoCount',
                          //       style: GoogleFonts.poppins(
                          //         color: Colors.black,
                          //         fontSize: 13.0,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),
                          ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onTapped,
                  child: Icon(
                    Icons.edit,
                    color: Color(0xffA0A0A0),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Color(0xff707070),
          ),
        ],
      ),
    );
  }
}

dialogButtons(height, width, text, onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height * 0.04,
      width: width * 0.24,
      decoration: BoxDecoration(
        color: text == 'Cancel' ? Colors.white : Color(0xff5AA5EF),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: text == 'Cancel' ? Color(0xff707070) : Color(0xff5AA5EF),
        ),
      ),
      child: Center(
        child: Text(
          '$text',
          style: GoogleFonts.poppins(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
            color: text == 'Cancel' ? Colors.black : Colors.white,
          ),
        ),
      ),
    ),
  );
}
