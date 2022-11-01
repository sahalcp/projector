import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contentDashboard/layoutCategoryPreviewScreen.dart';
import 'package:projector/contentDashboard/layoutSubCategoryPreviewScreen.dart';
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

class LayoutSubCategoryScreen extends StatefulWidget {
  @override
  _LayoutSubCategoryScreenState createState() =>
      _LayoutSubCategoryScreenState();
}

class _LayoutSubCategoryScreenState extends State<LayoutSubCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false, edit = false, spin = false;
  final formKey = GlobalKey<FormState>();
  String title = '' ,subCategoryId;
  TextEditingController text;

  @override
  void initState() {
    setState(() {
      text = TextEditingController(text: title);

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
        key: _scaffoldKey,
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
              "Subcategories",
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
                // Divider(
                //   height: 1.0,
                //   color: Color(0xff707070),
                // ),
                SizedBox(height: 5),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            addBottomSheetData(context1: context,setStateModal: setState,title: "",isAddCategory: true);
                          },
                          child: Text(
                            'Add New Subcategories',
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

                FutureBuilder(
                  future: VideoService().getMySubCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                             title = snapshot.data['data'][index]['title'];
                            var subCategoryId =
                                snapshot.data['data'][index]['id'];

                            return Container(
                              height: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                      top: 1.0,
                                      bottom: 1.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height * 0.08,
                                          width: width * 0.8,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  top: height * 0.02,
                                                  child: Text(
                                                    '$title',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            /*Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LayoutSubCategoryPreviewScreen(
                                                        title: title,
                                                        subCategoryId:
                                                        subCategoryId),
                                              ),
                                            ).then((value) {
                                              setState(() {});
                                            });*/


                                            addBottomSheetData(context1: context,
                                                setStateModal: setState,
                                                title: snapshot.data['data'][index]['title'],
                                            subCategoryId: snapshot.data['data'][index]['id'],isAddCategory: false);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Color(0xffA0A0A0),
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () async{
                                            setState(() {
                                              loading = true;
                                            });
                                            var res = await ContentDashboardService()
                                                .deleteSubCategory(
                                                subCatId: subCategoryId);

                                            if (res['success']) {

                                            }
                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: Color(0xffA0A0A0),
                                            size: 25,
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

                          });
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
               // SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  addBottomSheetData({context1, setStateModal,title,subCategoryId,isAddCategory}) {
    var val = '';
    bool loading = false;
    TextEditingController controller = TextEditingController(text: title);
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
                             isAddCategory ? 'Add New Subcategory' : 'Edit Subcategory',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.teal),
                                ),
                                labelText: isAddCategory ? 'Add' : '',
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
                                    if(isAddCategory){
                                      var subCategoryAdded = await VideoService()
                                          .addEditSubCategory(title: val);

                                      if (subCategoryAdded['success'] == true) {
                                        subCategoryId =
                                            subCategoryAdded['subcategory_id']
                                                .toString();

                                        Navigator.pop(context);
                                    }

                                    }else{
                                      var res =
                                      await VideoService()
                                          .addEditSubCategory(
                                        title: controller.text,
                                        categoryId: subCategoryId,
                                      );
                                      if (res['success'] == true) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                  isAddCategory ?  loading ? 'Creating...' : 'Create' : 'Save',
                                  style: TextStyle(color: Colors.white),
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



