import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contentDashboard/layoutCategoryScreen.dart';
import 'package:projector/contentDashboard/layoutPhotoAlbumScreen.dart';
import 'package:projector/contentDashboard/layoutPlaylistScreen.dart';
import 'package:projector/contentDashboard/layoutSubCategoryScreen.dart';
import 'package:projector/sideDrawer/contentLayoutScreen.dart';
import 'package:projector/widgets/widgets.dart';

class LayoutPage extends StatefulWidget {
  // const LayoutPage({Key key}) : super(key: key);
  List<String> item = ["Categories", "Playlists", "Photo Albums"];

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  var selectedBackgroundImageId;
  String parentId, subCategoryId;
    void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = widget.item.removeAt(oldindex);
      widget.item.insert(newindex, items);
    });
  }

  void sorting() {
    setState(() {
      widget.item.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          elevation: 1,
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
              "Content Layout",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image(
                  width: 20,
                  height: 20.0,
                  color: Colors.black,
                  image: AssetImage(
                    'images/person.png',
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          var title = 'Playlist';
                          addBottomSheetData(title == 'Category'
                              ? 1
                              : title == 'Sub-Category'
                              ? 2
                              : 3,
                              title,
                              context,
                              setState);
                        },
                        child: Text(
                          'Add Playlist',
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: (){
                          var title = 'Category';
                          addBottomSheetData(title == 'Category'
                              ? 1
                              : title == 'Sub-Category'
                              ? 2
                              : 3,
                              title,
                              context,
                              setState);
                        },
                        child: Text(
                          'Add Category',
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Choose Order/Edit",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),),
                    margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: FutureBuilder(
                      future: ContentDashboardService().getContentType(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){

                          return Container(
                            width: width,
                            //margin: EdgeInsets.only(left: 15, right: 15),
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.white,
                            ),
                            child: ReorderableListView(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              children: List.generate(snapshot.data.length, (index) {
                                var id = snapshot.data[index]['id'];
                                var contentType = snapshot.data[index]['content_type'];
                                var orderNumber = snapshot.data[index]['order_number'];

                                return Card(
                                  color: Colors.white,
                                  key: ValueKey(contentType),
                                  elevation: 0,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 16.0, right: 16.0, bottom: 16.0),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 2.0,
                                          spreadRadius: 2.0,
                                          offset: Offset(1.0,
                                              0.0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image(
                                            height: 20,
                                            width: 20,
                                            image:
                                            AssetImage('images/drag_indicator.png'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            contentType,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: (){
                                            // id = 1 (Categories)
                                            // id = 2 (Playlists)
                                            // id = 3 (Photos Albums)
                                            if(id == "1"){
                                              navigate(context, LayoutCategoryScreen());
                                            }
                                            if(id == "2"){
                                              navigate(context, LayoutPlaylistScreen());
                                            }
                                            if(id == "3"){
                                              navigate(context, LayoutPhotoAlbumScreen());
                                            }

                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 16.0),
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 7.0,
                                                bottom: 7.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(5.0)),
                                              border: Border.all(color: Colors.grey[200]),
                                            ),
                                            child: Text(
                                              "Edit",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              onReorder:
                                  (int oldIndex, int newIndex) async {
                                setState(() {
                                 // loading = true;
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

                                await ContentDashboardService()
                                    .reOrderContentType(items);
                                setState(() {
                                  //loading = false;
                                });
                              }
                            ),
                          );
                        }else {
                          return Container();
                        }
                      },
                    )
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                            offset: Offset(1.0,
                                0.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         SizedBox(width: 20,),
                          Container(
                            margin: EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Subcategories",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: (){
                              navigate(context, LayoutSubCategoryScreen());
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 16.0),
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 7.0,
                                  bottom: 7.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(color: Colors.grey[200]),
                              ),
                              child: Text(
                                "Edit",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: height * 0.24,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Slide Show Settings',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [

                                Icon(
                                  Icons.access_time,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "Slide Show Speed",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),
                            Row(
                              children: [

                                Icon(
                                  Icons.transform_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "Slide Show Transition",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 30),

                            Center(
                              child: Container(
                                width: 100,
                                height: height * 0.04,
                                decoration: BoxDecoration(
                                  color: Color(0xffa7a4a4),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                      'Update',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(height: height * 0.01),
                          ],
                        )
                    ),
                    height: height * 0.28,
                    width: width,
                    margin: EdgeInsets.only(bottom: 6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.29),
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
    addBottomSheetData(id, title, context1, setStateModal) {
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
                              Text(
                                'Add New $title',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              TextField(
                                decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.teal),
                                  ),
                                  labelText: 'Add',
                                  suffixStyle: const TextStyle(color: Colors.green),
                                ),
                                onChanged: (value) => {val = value},
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  onPressed: () async {
                                    if (val.length != 0) {
                                      setState(() {
                                        loading = true;
                                      });
                                      if (id == 1) {
                                        var categoryAdded = await VideoService()
                                            .addEditCategory(
                                            title: val,
                                            bgImageId: selectedBackgroundImageId);
                                        if (categoryAdded['success'] == true) {
                                          parentId =
                                              categoryAdded['category_id'].toString();

                                          Navigator.pop(context);
                                        }
                                      } else if (id == 2) {
                                        var subCategoryAdded = await VideoService()
                                            .addEditSubCategory(title: val);
                                        // print(subCategoryAdded);
                                        if (subCategoryAdded['success'] == true) {
                                          subCategoryId =
                                              subCategoryAdded['subcategory_id']
                                                  .toString();

                                          Navigator.pop(context);
                                        }
                                      } else {
                                        var addPlaylist = await VideoService()
                                            .addEditPlaylist(title: val);
                                        if (addPlaylist['success'] == true) {

                                          Navigator.pop(context);
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    loading ? 'Creating...' : 'Create',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              title == 'Category'
                                  ? Container(
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
                              )
                                  : Container(),
                              title == 'Category'
                                  ? Container(
                                height: 200,
                                child: SingleChildScrollView(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap:
                                    true,
                                    physics:
                                    NeverScrollableScrollPhysics(),
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
                                                          snapshot.data[index]
                                                          ['id'];
                                                          setStateM(() {
                                                            selectedBackground =
                                                                index;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets.all(3.0),
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

                                                              image: NetworkImage(
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
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Center(
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      margin: EdgeInsets.all(5),
                                                      child: CircularProgressIndicator(
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
                              )
                                  : Container()
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
