import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/photoService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/editVideo.dart';
import 'package:flutter/cupertino.dart';
import 'package:projector/models/progressCount.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/uploading/summaryScreen.dart';

// import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/uploadPopupDialog.dart';
import 'package:projector/widgets/widgets.dart';

class AddPhotoDetailsScreen extends StatefulWidget {
  AddPhotoDetailsScreen({
    this.imageList,
    this.fileListThumb,
    //  this.videoFile,
    // this.videoId,
  });

  List<File> imageList;
  List<Widget> fileListThumb;

  // final File videoFile;
  // final int videoId;

  @override
  _AddPhotoDetailsScreenState createState() => _AddPhotoDetailsScreenState();
}

class _AddPhotoDetailsScreenState extends State<AddPhotoDetailsScreen> {
  int selectedThumbnail;
  bool details = true,
      // category = false,
      visibilty = false,
      checked1 = false, // checked radio button 1
      checked2 = false,
      checked3 = false,
      titleBool = false,
      descritionBool = false,
      thumbnailBool = false,
      categoryBool = false,
      subCategoryBool = false,
      playlistsBool = false,
      loading = false,
      titleErrorBool = false,
      descriptionErrorBool = false,
      videoUploading = false,
      videoUploaded = false;
  var descriptionHeight = 0.0;
  String hintText = 'Title',
      hintDescription = 'Description',
      title = '',
      description = '',
      categoryText = '',
      subCategoryText = '',
      groupListText = '',
      img = '',
      titleError = 'should not exceed 40 characters',
      descriptionError = 'should not exceed 120 characters',
      subCategoryId,
      playlistId,
      groupId;
  int visibilityId, groupIndex, selectedIndex;
  double percentageUpload = 0;
  List groupListIds = [], groupListNames = [], groupListData = [];
  TextEditingController titleController;
  TextEditingController descriptionController;
  FocusNode titleNode, descriptionNode;
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();
  List<bool> categorySelected = [], subSelected = [];
  List<bool> groupSelected = [];
  int categoryPrevious, subPrevious, playlistPrevious;

  // List playlists = ['Playlist 1', 'Playlist 2'];
  List thumbnails = [];
  dynamic selectedAlbumId;
  String selectedAlbumTitle;
  String selectedAlbumDescription;
  String base64Image;
  File imageFile;
  Dio dio = Dio();
  int totalProgressValue = 0;
  var circleLoadingPercentageValue = 0.0;

  Future<void> getAlbumDetail() async {
    var albumId = await UserData().getAlbumId();
    var title = await UserData().getAlbumTitle();
    var description = await UserData().getAlbumDescription();

    setState(() {
      selectedAlbumId = albumId;
      selectedAlbumTitle = title;
      selectedAlbumDescription = description;
      titleController = TextEditingController(
          text: selectedAlbumTitle != null ? selectedAlbumTitle : "");
      descriptionController = TextEditingController(
          text:
              selectedAlbumDescription != null ? selectedAlbumDescription : "");
    });
  }

  setCallbackCount(int count) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        totalProgressValue = count;
        // print("progress total1 ---- $totalProgressValue");
      });
    });
  }

  uploadPhotos() async {
    uploadLoadingDialog(context);
    List<MultipartFile> newList = new List<MultipartFile>();

    for (var i = 0; i < widget.imageList.length; i++) {
      MultipartFile imageFile =
          await MultipartFile.fromFile(widget.imageList[i].path);
      newList.add(imageFile);
    }

    var token = await UserData().getUserToken();
    setState(() {
      //videoUploading = true;
      loading = true;
    });
    var groupSelectedId = '';
    if (groupListIds.length != 0) {
      groupSelectedId =
          groupListIds.reduce((value, element) => value + ',' + element);
    }

    try {
      var data = await dio.post('$serverUrl/addPhotoContent',
          data: FormData.fromMap({
            "token": token,
            "photo_file": newList,
            "visibility": visibilityId,
            "album_id": selectedAlbumId,
            "group_id": groupSelectedId,
          }), onSendProgress: (sent, total) {
        final progressTotal = sent / total * 100;

        int totalProgressValue = progressTotal.round();
        //print("progress total ---- $totalProgressValue");

        //setCallbackCount(totalProgressValue);

        circleLoadingPercentageValue = totalProgressValue / 100;

        if (totalProgressValue == 100) {
          setState(() {
            loading = false;
            // videoUploaded = true;
            // videoUploading = false;
          });
        }
      }, onReceiveProgress: (received, total) {});

      if (data.data['success']) {
        // print("response --->" + data.toString());
        Future.delayed(Duration(seconds: 1), () {
          navigate(context, NewListVideo());

          /* Navigator.of(context).push(
            CupertinoPageRoute<Null>(
              builder: (BuildContext context) {
                return SummaryScreen(
                  type: "album",
                  contentId: selectedAlbumId.toString(),
                  pageType: "photo",
                );
              },
            ),
          );*/

          // navigate(
          //   context,
          //   AlbumViewScreen(
          //     type: "album",
          //     contentId: selectedAlbumId.toString(),
          //   ),
          // );

          Fluttertoast.showToast(
            msg: 'Photo Published',
            textColor: Colors.black,
            backgroundColor: Colors.white,
          );
          setState(() {
            loading = false;
            //Navigator.pop(context);
            // videoUploaded = false;
          });
        });
      } else {
        Fluttertoast.showToast(msg: 'Try Again', backgroundColor: Colors.black);
      }
    } catch (e) {
      setState(() {
        // videoUploading = false;
      });
      // Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.black);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getAlbumDetail();
    super.initState();
    titleNode = FocusNode();
    titleNode.requestFocus();
    descriptionNode = FocusNode();
    titleNode.addListener(() {
      if (titleNode.hasFocus) {
        hintText = '';
      } else {
        hintText = 'Title';
      }
      setState(() {});
    });
    descriptionNode.addListener(() {
      if (descriptionNode.hasFocus) {
        hintDescription = '';
      } else {
        hintDescription = 'Description';
      }
      setState(() {});
    });
  }

  List select = [false, false];

  void count() async {
    while (true) {
      setState(() {
        totalProgressValue = totalProgressValue;
      });
      // await Thread.sleep(10000);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var titleStyle = GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
            ),
            titleSpacing: 0.0,
            title: Text(
              "Upload Album",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          key: key,
          body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ModalProgressHUD(
              inAsyncCall: loading,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),

                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            visibilty ? 'Visibility' : 'Details',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.018),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: thumbnailBool
                                      ? Color(0xff5AA5EF)
                                      : descritionBool
                                          ? Color(0xff9BC7F2)
                                          : titleBool
                                              ? Color(0xff707070)
                                              : Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: checked1 || checked2 || checked3
                                      ? Color(0xff5AA5EF)
                                      : visibilty
                                          ? Colors.white
                                          : Color(0xff707070),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.03),
                        Container(
                          height: height * 0.68,
                          margin: EdgeInsets.only(
                            left: 4.0,
                            right: 2.0,
                          ),
                          child: details
                              //todo details view
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 26.0,
                                        bottom: 15.0,
                                        left: 9.0,
                                        right: 7.0,
                                      ),
                                      height: height * 0.4,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 13.0),
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Container(
                                            //height: height * 0.1,
                                            height: 100,
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: titleNode.hasFocus
                                                    ? Colors.blue
                                                    : Color(0xffE8E8E8),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Title",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),

                                                Align(
                                                  alignment: Alignment.center,
                                                  child: TextField(
                                                    controller: titleController
                                                      ..selection = TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  titleController
                                                                      .text
                                                                      .length),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          40),
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    focusNode: titleNode,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),

                                                    onChanged: (val) {
                                                      if (val.length < 40) {
                                                        setState(() {
                                                          titleBool = true;
                                                        });

                                                        title = val;
                                                        titleController =
                                                            TextEditingController(
                                                                text: val);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.black,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          textColor:
                                                              Colors.white,
                                                          msg:
                                                              'Should not exceed 40 characters',
                                                        );
                                                      }
                                                    },

                                                    //maxLength: 40,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      hintText:
                                                          'Create title for your photo',
                                                      hintMaxLines: 3,
                                                      hintStyle: TextStyle(
                                                        color:
                                                            Color(0xff9F9E9E),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                )

                                                /*Visibility(
                                          visible: titleErrorBool,
                                          child: Center(
                                            child: Text(
                                              titleError,
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),*/

                                                // Center(
                                                //   child: Text(
                                                //     'Create title for your photo',
                                                //     style: TextStyle(
                                                //       fontSize: 12.0,
                                                //       color: Color(0xff9F9E9E),
                                                //       fontWeight: FontWeight.w400,
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Container(
                                            height: height * 0.2,
                                            width: width,
                                            padding:
                                                EdgeInsets.only(bottom: 14.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: descriptionNode.hasFocus
                                                    ? Colors.blue
                                                    : Color(0xffE8E8E8),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Description",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),

                                                Align(
                                                  alignment: Alignment.center,
                                                  child: TextField(
                                                    controller: descriptionController
                                                      ..selection = TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  descriptionController
                                                                      .text
                                                                      .length),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          120),
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    focusNode: descriptionNode,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),

                                                    onChanged: (val) {
                                                      if (val.length < 120) {
                                                        setState(() {
                                                          descritionBool = true;
                                                          thumbnailBool = true;
                                                        });

                                                        description = val;
                                                        descriptionController =
                                                            TextEditingController(
                                                                text: val);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.black,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          textColor:
                                                              Colors.white,
                                                          msg:
                                                              'Should not exceed 120 characters',
                                                        );
                                                      }
                                                    },

                                                    // keyboardType: TextInputType.name,
                                                    // textInputAction: TextInputAction.done,
                                                    // maxLength: 40,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      hintText:
                                                          'Short lens view of your album, tell your viewers what your album is about',
                                                      hintMaxLines: 3,
                                                      hintStyle: TextStyle(
                                                        color:
                                                            Color(0xff9F9E9E),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                )

                                                /* Visibility(
                                          visible: descriptionErrorBool,
                                          child: Center(
                                            child: Text(
                                              descriptionError,
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),*/

                                                // Text(
                                                //   'Share what your photo is about',
                                                //   style: TextStyle(
                                                //     fontSize: 12.0,
                                                //     color: Color(0xff9F9E9E),
                                                //     fontWeight: FontWeight.w400,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height * 0.05),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'Thumbnail',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // Row(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    Container(
                                      height: height * 0.15,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(
                                            widget.imageList.length, (index) {
                                          imageFile = widget.imageList[index];

                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                //print("valueee --->"+titleController.text.toString());
                                                selectedThumbnail = index;
                                                imageFile =
                                                    widget.imageList[index];
                                              });
                                            },
                                            child: Container(
                                              width: width * 0.25,
                                              height: height * 0.14,
                                              margin: EdgeInsets.only(
                                                top: 7.0,
                                                left: 5.0,
                                                right: 5.0,
                                              ),
                                              padding: EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: selectedThumbnail ==
                                                            index
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                    width: 2),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          FileImage(imageFile),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                )
                              //todo visibility view
                              : Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 13.0,
                                        top: 16.0,
                                        right: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Visibility',
                                              style: GoogleFonts.poppins(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Choose when to publish and who can see your photo.',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.07),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                visibilityId = 2;
                                                checked2 = false;
                                                checked1 = true;
                                                checked3 = false;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                checkBox(
                                                    height, width, checked1),
                                                Flexible(
                                                  child: Text(
                                                    'Anyone can view on My Projector account',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                visibilityId = 1;
                                                checked2 = true;
                                                checked1 = false;
                                                checked3 = false;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                checkBox(
                                                    height, width, checked2),
                                                Text(
                                                  'Only I can View (Private)',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                visibilityId = 3;
                                                checked2 = false;
                                                checked1 = false;
                                                checked3 = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                checkBox(
                                                    height, width, checked3),
                                                Text(
                                                  'Choose a group to share with',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 32),
                                          checked3
                                              ? FutureBuilder(
                                                  future: GroupServcie()
                                                      .getMyGroups(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Container(
                                                        width: width,
                                                        height: height * 0.15,
                                                        // padding: EdgeInsets.only(
                                                        //     top: 8.0, left: 8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                      0xff000000)
                                                                  .withAlpha(
                                                                      29),
                                                              blurRadius: 6.0,
                                                              // spreadRadius: 6.0,
                                                            ),
                                                          ],
                                                        ),
                                                        margin: EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0,
                                                        ),
                                                        child: ListView(
                                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            ListView.builder(
                                                              itemCount:
                                                                  snapshot.data
                                                                      .length,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                groupSelected
                                                                    .add(false);
                                                                return InkWell(
                                                                  onTap: () {
                                                                    // setState(() {
                                                                    //   groupId = snapshot
                                                                    //       .data[
                                                                    //   index]['id'];
                                                                    //
                                                                    // });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0),
                                                                    child: Row(
                                                                      children: [
                                                                        // groupId ==
                                                                        //     snapshot.data[index]['id']
                                                                        //     ? Icon(
                                                                        //   Icons.check,
                                                                        //   size:
                                                                        //   16,
                                                                        // )
                                                                        //     : Container(
                                                                        //   width:
                                                                        //   16,
                                                                        // ),

                                                                        SizedBox(
                                                                          height:
                                                                              24.0,
                                                                          width:
                                                                              24.0,
                                                                          child: Checkbox(
                                                                              value: groupSelected[index],
                                                                              onChanged: (val) {
                                                                                setState(() {
                                                                                  groupSelected[index] = !groupSelected[index];

                                                                                  if (groupSelected[index]) {
                                                                                    groupListIds.add(snapshot.data[index]['id']);

                                                                                    //print("groupid add --->"+groupListIds.toString());

                                                                                  } else {
                                                                                    groupListIds.remove(snapshot.data[index]['id']);

                                                                                    //print("groupid remove --->"+groupListIds.toString());
                                                                                  }
                                                                                });
                                                                              }),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.0,
                                                                        ),
                                                                        Text(
                                                                          snapshot.data[index]
                                                                              [
                                                                              'title'],
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .all(10.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  editDialog(
                                                                    context,
                                                                    height,
                                                                    width,
                                                                    true,
                                                                  ).then(
                                                                      (value) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'New Group',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xff5AA5EF),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return Text('Loading');
                                                    }
                                                  },
                                                )
                                              : Container(),
                                          SizedBox(height: height * 0.05),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        // videoUploaded
                        //     ? Center(
                        //         child: Container(
                        //           height: height * 0.1,
                        //           child: LottieBuilder.asset('images/Success.json'),
                        //         ),
                        //       )
                        //     : videoUploading && videoId == null
                        //         ? LottieBuilder.asset('images/Loader.json')
                        //         :
                        Row(
                          children: [
                            //todo : previous button
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (visibilty)
                                    setState(() {
                                      // checked3 = checked2 = checked1 = false;
                                      visibilty = false;
                                      details = true;
                                    });
                                  else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 7),
                                  height: height * 0.065,
                                  // width: width * 0.44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color:
                                          Color(0xff5AA5EF).withOpacity(0.46),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Previous',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //todo : next button
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (visibilty) {
                                    if (visibilty) {
                                      // print(visibilityId);
                                      // print(groupId);
                                      if (visibilityId == 3 &&
                                          visibilityId != null) {
                                        if (groupListIds != null &&
                                            groupListIds.length > 0) {
                                          // todo: upload photo api with group
                                          uploadPhotos();
                                        } else {
                                          key.currentState.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Select any group from list'),
                                            ),
                                          );
                                        }
                                      } else if (visibilityId != null) {
                                        // todo : upload api call
                                        uploadPhotos();
                                      }
                                      // navigate(context, );
                                      // editDialog(context, height, width);
                                    } else {
                                      key.currentState.showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('All fields are necessary'),
                                        ),
                                      );
                                    }
                                  } else if (details) {
                                    if (titleController.text.toString().length >
                                        40) {
                                      setState(() {
                                        titleErrorBool = true;
                                      });
                                    } else if (descriptionController.text
                                            .toString()
                                            .length >
                                        120) {
                                      setState(() {
                                        descriptionErrorBool = true;
                                      });
                                    } else if (titleController.text
                                                .toString()
                                                .length ==
                                            0 &&
                                        descriptionController.text
                                                .toString()
                                                .length ==
                                            0) {
                                      key.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Title and Description cannot be empty'),
                                        ),
                                      );
                                    } else if (selectedThumbnail == null) {
                                      key.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text('Add one thumbnail'),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        //videoUploading = false;
                                        visibilty = true;
                                        details = false;
                                      });

                                      // todo : album details api call
                                      if (visibilty) {
                                        if (imageFile != null) {
                                          setState(() {
                                            loading = true;
                                          });

                                          List<int> imageBytes =
                                              imageFile.readAsBytesSync();
                                          String base64Image =
                                              base64Encode(imageBytes);
                                          String finalBase64Image =
                                              "data:image/jpeg;base64," +
                                                  base64Image;

                                          var createAlbum = await PhotoService()
                                              .addAlbum(
                                                  title: titleController.text
                                                      .toString(),
                                                  description:
                                                      descriptionController.text
                                                          .toString(),
                                                  icon: finalBase64Image,
                                                  albumId: selectedAlbumId
                                                      .toString());
                                          if (createAlbum['success'] == true) {
                                            setState(() {
                                              loading = false;
                                            });
                                            Fluttertoast.showToast(
                                              msg: 'Album details updated',
                                              textColor: Colors.black,
                                              backgroundColor: Colors.white,
                                            );
                                          }

                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      } else {
                                        //print("next screen1 --->");
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 7.0),
                                  height: height * 0.065,
                                  // width: 161,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: Color(0xff5AA5EF),
                                        width: visibilty ? 2 : 0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      videoUploading
                                          ? 'Uploading'
                                          : visibilty
                                              ? 'Publish'
                                              : 'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  uploadLoadingDialog(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // var thread = new Thread(count);
    // thread.start();
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Color(0xff333333).withOpacity(0.9),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              insetPadding: EdgeInsets.only(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: width,
                    height: height * 0.45,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.06),
                              Text(
                                'Upload File',
                                style: GoogleFonts.montserrat(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.10),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    totalProgressValue = totalProgressValue;
                                  });
                                },
                                child: Center(
                                  child: CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 10.0,
                                    percent: circleLoadingPercentageValue,
                                    center: Text(
                                      '$totalProgressValue%',
                                      style: GoogleFonts.poppins(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          });
        });
  }
}

checkBox(height, width, checked) {
  return Container(
    margin: EdgeInsets.only(right: 10.0),
    height: height * 0.03,
    width: width * 0.07,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: 1.0,
        color: Colors.black,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: height * 0.02,
            width: width * 0.05,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: checked ? Colors.black : Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
