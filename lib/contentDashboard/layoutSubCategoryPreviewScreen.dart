import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/widgets.dart';

class LayoutSubCategoryPreviewScreen extends StatefulWidget {
  LayoutSubCategoryPreviewScreen(
      {this.title, @required this.subCategoryId});
  final String title, subCategoryId;

  @override
  _LayoutSubCategoryPreviewScreenState createState() => _LayoutSubCategoryPreviewScreenState();
}

class _LayoutSubCategoryPreviewScreenState extends State<LayoutSubCategoryPreviewScreen> {
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
             "Manage Subcategory",
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
              children: [
                SizedBox(height: height * 0.01),

                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 11.0,
                  ),
                  child: Column(
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
                                          await VideoService()
                                              .addEditSubCategory(
                                            title: title,
                                            categoryId: widget
                                                .subCategoryId,
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
                              MainAxisAlignment.end,
                              children: [

                                InkWell(
                                  onTap: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      var res = await ContentDashboardService()
                                          .deleteSubCategory(
                                          subCatId: widget
                                              .subCategoryId);
                                      // print(res);
                                      if (res['success']) {
                                        Navigator.pop(context);
                                      }
                                      setState(() {
                                        loading = false;
                                      });

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

                          ],
                        ),
                      ),
                      // Divider(color: Color(0xff707070))
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
