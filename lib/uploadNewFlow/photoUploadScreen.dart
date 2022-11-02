import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/photoService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

import '../bgUpload/backgroundUploader.dart';
import '../widgets/widgets.dart';

class PhotoUploadScreen extends StatefulWidget {
  PhotoUploadScreen({
    this.imageList,
    this.fileListThumb,
    this.imageFileFirst,
  });

  List<File> imageList;
  List<Widget> fileListThumb;
  File imageFileFirst;

  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  bool isDetailsShown = true,
      isCategoriesSHown = true,
      isVisibilityShown = true;

  FocusNode node = FocusNode();
  FocusNode titleNode, descriptionNode;

  TextEditingController emailCon;
  int selectedThumbnail = 0;
  int selectedThumbnailLocal = 0;
  bool details = true,
      category = false,
      visibilty = false,
      checked1 = true, // Default checked radio button 1 in visibility: Public
      checked2 = false,
      checked3 = false,
      titleBool = false,
      visibilityBool = true,
      descritionBool = false,
      thumbnailBool = false,
      categoryBool = false,
      subCategoryBool = false,
      playlistsBool = false,
      circleLoading = false,
      loading = false,
      titleErrorBool = false,
      descriptionErrorBool = false,
      videoUploading = false,
      localThumbanilSelected = false,
      videoUploaded = false,
      progressLoading = false;

  bool _showFab = true;
  var descriptionHeight = 0.0;
  String hintText = 'Title',
      hintDescription = 'Description',
      title = '',
      description = '',
      categoryText = '',
      subCategoryText = '',
      playlistText = '',
      img = '',
      titleError = 'should not exceed 40 characters',
      descriptionError = 'should not exceed 120 characters',
      parentId,
      sharedParentId,
      subCategoryId,
      playlistId,
      groupId;
  int visibilityId = 2;
  int groupIndex, selectedIndex;
  double percentageUpload = 0;
  List playlistIds = [], playlistNames = [];
  TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();
  List<bool> categorySelected = [], subSelected = [], playlistSelected = [];
  int categoryPrevious, subPrevious, playlistPrevious;
  var selectedBackgroundImageId;
  int totalProgressValue = 0;
  double circleLoadingPercentageValue = 0.0;
  Dio dio = Dio();

  List thumbnails = [];
  dynamic selectedAlbumId;
  String selectedAlbumTitle;
  String selectedAlbumDescription;
  String base64Image;
  File imageFile;

  List<bool> groupSelected = [];
  List groupListIds = [];
  var groupSelectedId = '';
  var IsvideoUploading = false;

  File _image;
  final picker = ImagePicker();
  String hintTextTitle = 'title hint';
  String hintTextDescription =
      'Short lens view of your video, tell your viewers what your video is about';

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
      // imageFile = widget.imageList[0];
      imageFile = widget.imageFileFirst;
    });
  }

  /*setCallbackCount(int count) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        totalProgressValue = count;
        // print("progress total1 ---- $totalProgressValue");
      });
    });
  }*/

  uploadPhotos() async {
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
      progressLoading = true;
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
            "photo_file[]": newList,
            "visibility": visibilityId,
            "album_id": selectedAlbumId,
            "group_id": groupSelectedId,
          }), onSendProgress: (sent, total) {
        final progressTotal = sent / total * 100;
        totalProgressValue = progressTotal.round();

        setState(() {
          if (totalProgressValue > 100) {
            totalProgressValue = 100;
          }
          totalProgressValue = totalProgressValue;
        });

        // setCallbackCount(totalProgressValue);

        circleLoadingPercentageValue = totalProgressValue / 100;

        circleLoadingPercentageValue = totalProgressValue / 100;
        if (circleLoadingPercentageValue > 1.0) {
          circleLoadingPercentageValue = 1.0;
        }

        print("loading value" + totalProgressValue.toString());

        if (totalProgressValue == 100) {
          /*setState(() {
            loading = false;
            progressLoading = false;
            // videoUploaded = true;
            // videoUploading = false;
          });*/
        }
      }, onReceiveProgress: (received, total) {});

      if (data.data['success']) {
        // print("response --->" + data.toString());

        navigate(context, NewListVideo());

        Fluttertoast.showToast(
          msg: 'Photo Published',
          textColor: Colors.black,
          backgroundColor: Colors.white,
        );
        setState(() {
          loading = false;
          IsvideoUploading = false;
          progressLoading = false;
          //Navigator.pop(context);
          // videoUploaded = false;
        });
      } else {
        setState(() {
          IsvideoUploading = false;
          progressLoading = false;
        });
        Fluttertoast.showToast(msg: 'Try Again', backgroundColor: Colors.black);
      }
    } catch (e) {
      print("upload photo content failed ------");
      print("upload photo content failed ------${e.toString()}");
      setState(() {
        IsvideoUploading = false;
        progressLoading = false;
        // videoUploading = false;
      });
      // Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.black);
    }
  }

  bgUploadPhotos() async {
    var token = await UserData().getUserToken();

    var groupSelectedId = '';
    if (groupListIds.length != 0) {
      groupSelectedId =
          groupListIds.reduce((value, element) => value + ',' + element);
    }

    _prepareMediaUploadListener();
    String taskId = await BackgroundUploader.uploadEnqueue(
      file: widget.imageList,
      token: token,
      visibility: visibilityId,
      albumId: selectedAlbumId,
      groupId: groupSelectedId,
    );
    if (taskId != null) {
    } else {
      BackgroundUploader.uploader.cancelAll();
    }
  }

  static void _prepareMediaUploadListener() {
    //listen
    BackgroundUploader.uploader.result.listen((UploadTaskResponse response) {
      BackgroundUploader.uploader.clearUploads();

      if (response.status == UploadTaskStatus.complete) {
      } else if (response.status == UploadTaskStatus.canceled) {
        BackgroundUploader.uploader.cancelAll();
      }
    }, onError: (error) {
      //handle failure
      BackgroundUploader.uploader.cancelAll();
    });
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
    //titleNode.requestFocus();
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
      if (titleController.text.toString() != '') {
        titleBool = true;
      }
      setState(() {});
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List select = [false, false];

  /// setting value category and sub category
  setData(data, title) {
    if (title == 'Category') {
      setState(() {
        categoryText = data;
        categoryBool = true;
      });
    } else {
      setState(() {
        subCategoryText = data;
        subCategoryBool = true;
      });
    }
  }

  setSelectedIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataKey = new GlobalKey();
    const duration = Duration(milliseconds: 300);
    var titleStyle = GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    ScrollController _scrollController = new ScrollController();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          bottom: PreferredSize(
              child: Container(
                color: Color.fromARGB(255, 206, 203, 203),
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(1.0)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Upload Album ',
                style: GoogleFonts.poppins(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () async {
                  if (thumbnailBool &&
                      titleBool &&
                      descritionBool &&
                      visibilityBool) {
                    if (visibilityId == 3 && visibilityId != null) {
                      if (groupListIds != null && groupListIds.length > 0) {
                        // todo: upload photo api with group
                        // setState(() {
                        //   IsvideoUploading = true;
                        // });

                        // uploadPhotos();
                        bgUploadPhotos();
                        navigate(context, NewListVideo());
                      } else {
                        key.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Select any group from list'),
                          ),
                        );
                      }
                    } else if (visibilityId != null) {
                      // todo : upload api call
                      // setState(() {
                      //   IsvideoUploading = true;
                      // });
                      //  uploadPhotos();
                      bgUploadPhotos();
                      navigate(context, NewListVideo());
                    }

                    if (imageFile != null) {
                      setState(() {
                        loading = true;
                      });
                      List<int> imageBytes = imageFile.readAsBytesSync();
                      String base64Image = base64Encode(imageBytes);
                      String finalBase64Image =
                          "data:image/jpeg;base64," + base64Image;
                      var createAlbum = await PhotoService().addAlbum(
                          title: titleController.text.toString(),
                          description: descriptionController.text.toString(),
                          icon: finalBase64Image,
                          albumId: selectedAlbumId.toString());
                      if (createAlbum['success'] == true) {
                        setState(() {
                          loading = false;
                          IsvideoUploading = false;
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
                    Fluttertoast.showToast(
                      msg: 'All fields are necessary',
                      textColor: Colors.white,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    progressLoading == true ? '' : 'Publish',
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: (thumbnailBool &&
                              titleBool &&
                              descritionBool &&
                              visibilityBool)
                          ? Color(0xff5AA5EF)
                          : Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: IsvideoUploading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ModalProgressHUD(
                    inAsyncCall: progressLoading,
                    progressIndicator: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      width: width,
                      height: height,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            totalProgressValue == 100
                                ? Container(
                                    width: 70,
                                    height: 70,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 8,
                                    ),
                                  )
                                : CircularPercentIndicator(
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
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              totalProgressValue == 100
                                  ? "Please wait while we optimise the content"
                                  : '',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        color: Colors.white,
                        // height: height,
                        //width: width,
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height * 0.03),
                                  //----Upload video label
                                  //---Image view
                                  Container(
                                    width: width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        //image: FileImage(imageFile ?? widget.imageList.first),
                                        image: FileImage(widget.imageFileFirst),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // child: Card(
                                    //   color: Colors.black,
                                    // ),
                                  ),
                                  Container(),
                                  SizedBox(height: height * 0.02),
                                  //---Download thumbnail
                                  //--Tumbnail
                                  Container(
                                    padding: EdgeInsets.all(6.0),
                                    width: width,
                                    child: Text(
                                      'Thumbnail',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),

                                  ///---Thumnails list view
                                  // Container(
                                  //   height: height * 0.15,
                                  //   child: ListView(
                                  //     shrinkWrap: true,
                                  //     scrollDirection: Axis.horizontal,
                                  //     children:
                                  //         List.generate(widget.imageList.length, (index) {
                                  //       imageFile = widget.imageList[index];

                                  //       return InkWell(
                                  //         onTap: () {
                                  //           setState(() {
                                  //             //print("valueee --->"+titleController.text.toString());
                                  //             selectedThumbnail = index;
                                  //             imageFile = widget.imageList[index];
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           width: width * 0.25,
                                  //           height: height * 0.14,
                                  //           margin: EdgeInsets.only(
                                  //             top: 7.0,
                                  //             left: 5.0,
                                  //             right: 5.0,
                                  //           ),
                                  //           padding: EdgeInsets.all(3.0),
                                  //           decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //                 color: selectedThumbnail == index
                                  //                     ? Colors.blue
                                  //                     : Colors.transparent,
                                  //                 width: 2),
                                  //           ),
                                  //           child: Container(
                                  //             decoration: BoxDecoration(
                                  //               image: DecorationImage(
                                  //                   image: FileImage(imageFile),
                                  //                   fit: BoxFit.cover),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }),
                                  //   ),
                                  // ),
                                  Container(
                                    height: height * 0.13,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                getImage();
                                              },
                                              child: Container(
                                                width: width * 0.26,
                                                height: height * 0.12,
                                                color: Colors.grey,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.add_rounded,
                                                  size: 70.0,
                                                  color: Colors.white,
                                                )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Visibility(
                                              visible:
                                                  _image != null ? true : false,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedThumbnailLocal = 1;
                                                    selectedThumbnail = 0;
                                                    localThumbanilSelected =
                                                        true;
                                                    imageFile = _image;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            selectedThumbnailLocal ==
                                                                    1
                                                                ? Colors.blue
                                                                : Colors
                                                                    .transparent,
                                                        width: 2),
                                                  ),
                                                  width: width * 0.25,
                                                  height: height * 0.14,
                                                  margin: EdgeInsets.only(
                                                    top: 7.0,
                                                    left: 5.0,
                                                    right: 5.0,
                                                  ),
                                                  child: _image != null
                                                      ? Image.file(
                                                          _image,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                            ),

                                            /// list thumbnail loading all
                                            Container(
                                              height: height * 0.15,
                                              child: ListView.builder(
                                                itemCount: widget.imageList
                                                    .take(4)
                                                    .length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedThumbnail =
                                                            index;
                                                        selectedThumbnailLocal =
                                                            0;
                                                        localThumbanilSelected =
                                                            false;
                                                        imageFile = widget
                                                            .imageList[index];
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
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: selectedThumbnail ==
                                                                      index
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .transparent,
                                                              width: 2),
                                                          image:
                                                              DecorationImage(
                                                            image: FileImage(
                                                              widget.imageList[
                                                                  index],
                                                            ),
                                                            fit: BoxFit.fill,
                                                          )
                                                          // image: DecorationImage(
                                                          //   image: AssetImage('images/2.png'),
                                                          //   fit: BoxFit.fill,
                                                          // ),

                                                          // image: DecorationImage(
                                                          //   image: AssetImage(
                                                          //     'images/unsplash.png',
                                                          //   ),
                                                          //   fit: BoxFit.fill,
                                                          // ),
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  //---Details Header
                                  InkWell(
                                    onTap: () {
                                      // if (!isDetailsShown) {
                                      //   _scrollController.animateTo(160,
                                      //       duration: const Duration(milliseconds: 500),
                                      //       curve: Curves.easeOut);
                                      // }

                                      // setState(() => isDetailsShown = !isDetailsShown);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      width: width,
                                      color: (titleBool && descritionBool)
                                          ? Color(0xff5AA5EF)
                                          : Colors.black, //Color(0xff5AA5EF),
                                      child: Text(
                                        'Details',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: height * 0.02),
                                  if (isDetailsShown) ...[
                                    // These children are only visible if condition is true
                                    Container(
                                      padding: EdgeInsets.all(6.0),
                                      width: width,
                                      child: Text(
                                        'Title',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    //----Text filed
                                    SizedBox(height: height * 0.02),
                                    Container(
                                      // height: height * 0.06,
                                      child: TextFormField(
                                        focusNode: titleNode,
                                        controller: titleController
                                          ..selection = TextSelection.collapsed(
                                              offset:
                                                  titleController.text.length),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(40),
                                        ],
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 13.0,
                                        ),
                                        // validator: (val) {
                                        //   if (!EmailValidator.validate(email))
                                        //     return 'Not a valid email';
                                        //   return null;
                                        // },
                                        onChanged: (val) {
                                          if (val.length < 40) {
                                            if (val == '' || title == '') {
                                              setState(() {
                                                titleBool = false;
                                              });
                                            } else {
                                              setState(() {
                                                titleBool = true;
                                              });
                                            }
                                            title = val;
                                            titleController =
                                                TextEditingController(
                                                    text: val);
                                          } else {
                                            Fluttertoast.showToast(
                                              backgroundColor: Colors.black,
                                              gravity: ToastGravity.CENTER,
                                              textColor: Colors.white,
                                              msg:
                                                  'Should not exceed 40 characters',
                                            );
                                          }
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Title',
                                          hintStyle: GoogleFonts.montserrat(
                                            color: Color(0xff8E8E8E),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff5AA5EF),
                                              width: 2,
                                            ),
                                          ),
                                          // errorBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(5.0),
                                          // ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.03),
                                    Container(
                                      padding: EdgeInsets.all(6.0),
                                      width: width,
                                      child: Text(
                                        'Description',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    //----Text filed
                                    SizedBox(height: height * 0.02),
                                    Container(
                                      // height: height * 0.06,
                                      child: TextFormField(
                                        focusNode: descriptionNode,
                                        controller: descriptionController
                                          ..selection = TextSelection.collapsed(
                                              offset: descriptionController
                                                  .text.length),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(120),
                                        ],
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 13.0,
                                        ),
                                        // validator: (val) {
                                        //   if (!EmailValidator.validate(email))
                                        //     return 'Not a valid email';
                                        //   return null;
                                        // },
                                        onChanged: (val) {
                                          if (val.length < 120) {
                                            if (val == '') {
                                              setState(() {
                                                descritionBool = false;
                                                thumbnailBool = false;
                                              });
                                            } else {
                                              setState(() {
                                                descritionBool = true;
                                                thumbnailBool = true;
                                              });
                                            }
                                            description = val;
                                            descriptionController =
                                                TextEditingController(
                                                    text: val);
                                          } else {
                                            Fluttertoast.showToast(
                                              backgroundColor: Colors.black,
                                              gravity: ToastGravity.CENTER,
                                              textColor: Colors.white,
                                              msg:
                                                  'Should not exceed 120 characters',
                                            );
                                          }
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Add Description',
                                          hintStyle: GoogleFonts.montserrat(
                                            color: Color(0xff8E8E8E),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xff5AA5EF),
                                              width: 2,
                                            ),
                                          ),
                                          // errorBorder: OutlineInputBorder(
                                          //   borderRadius: BorderRadius.circular(5.0),
                                          // ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                  ],

                                  ///--Categories title
                                  ///
                                  ///
                                  ///
                                  ///
                                  //----Visiblity
                                  InkWell(
                                    onTap: () {
                                      // if (!isVisibilityShown) {
                                      //   _scrollController.animateTo(250,
                                      //       duration: const Duration(milliseconds: 500),
                                      //       curve: Curves.easeOut);
                                      // }
                                      // setState(
                                      //     () => isVisibilityShown = !isVisibilityShown);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      width: width,
                                      color: (checked1 || checked2 || checked3)
                                          ? Color(0xff5AA5EF)
                                          : Colors.black, //Color(0xff5AA5EF),
                                      child: Text(
                                        'Visibility',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  if (isVisibilityShown) ...[
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
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                visibilityId = 2;
                                                checked2 = false;
                                                checked1 = true;
                                                checked3 = false;
                                                visibilityBool = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                checkBox(
                                                    height, width, checked1),
                                                Flexible(
                                                  child: Text(
                                                    'Anyone can view on Projector',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black,
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
                                                visibilityBool = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                checkBox(
                                                    height, width, checked2),
                                                Text(
                                                  'Only I can view',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
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
                                                visibilityBool = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                checkBox(
                                                    height, width, checked3),
                                                Text(
                                                  'Choose a group to share with',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 32),
                                          checked3
                                              ? FutureBuilder(
                                                  future: GroupService()
                                                      .getMyGroups(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      // final userData = new Map<String,dynamic>.from(snapshot.data);
                                                      // _isChecked = List<bool>.filled(snapshot.data.length, false);
                                                      return Container(
                                                        width: width,
                                                        height: height * 0.15,
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8.0,
                                                                left: 8.0),
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
                                                                    // setState(
                                                                    //         () {
                                                                    //       groupId =
                                                                    //       snapshot.data[index]
                                                                    //       [
                                                                    //       'id'];
                                                                    //     });
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
                                                                        //   size: 16,
                                                                        // )
                                                                        //     : Container(
                                                                        //   width: 16,
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

                                                                                    //print("groupid add --->" + groupListIds.toString());
                                                                                  } else {
                                                                                    groupListIds.remove(snapshot.data[index]['id']);

                                                                                    //print("groupid remove --->" + groupListIds.toString());
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
                                  SizedBox(height: height * 0.02),
                                  Container(
                                    height: 70,
                                    width: width,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 5.0),
                                    child: Container(
                                      width: width,
                                      height: 35,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (thumbnailBool &&
                                                titleBool &&
                                                descritionBool &&
                                                visibilityBool) {
                                              if (visibilityId == 3 &&
                                                  visibilityId != null) {
                                                if (groupListIds != null &&
                                                    groupListIds.length > 0) {
                                                  // todo: upload photo api with group
                                                  //  uploadPhotos();
                                                  bgUploadPhotos();
                                                  navigate(
                                                      context, NewListVideo());
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
                                                // uploadPhotos();
                                                bgUploadPhotos();
                                                navigate(
                                                    context, NewListVideo());
                                              }

                                              if (imageFile != null) {
                                                setState(() {
                                                  loading = true;
                                                  circleLoading = true;
                                                });
                                                List<int> imageBytes =
                                                    imageFile.readAsBytesSync();
                                                String base64Image =
                                                    base64Encode(imageBytes);
                                                String finalBase64Image =
                                                    "data:image/jpeg;base64," +
                                                        base64Image;
                                                var createAlbum =
                                                    await PhotoService().addAlbum(
                                                        title: titleController
                                                            .text
                                                            .toString(),
                                                        description:
                                                            descriptionController
                                                                .text
                                                                .toString(),
                                                        icon: finalBase64Image,
                                                        albumId: selectedAlbumId
                                                            .toString());
                                                if (createAlbum['success'] ==
                                                    true) {
                                                  setState(() {
                                                    loading = false;
                                                    circleLoading = false;
                                                  });
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Album details updated',
                                                    textColor: Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                  );
                                                }
                                                setState(() {
                                                  loading = false;
                                                  circleLoading = false;
                                                });
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: 'All fields are necessary',
                                                textColor: Colors.white,
                                              );
                                            }
                                          },
                                          child: Center(
                                            child: circleLoading
                                                ? CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.white,
                                                  )
                                                : Text(
                                                    'PUBLISH',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: (thumbnailBool == true &&
                                                    titleBool == true &&
                                                    descritionBool == true &&
                                                    visibilityBool == true)
                                                ? Color(0xff5AA5EF)
                                                : Colors.black,
                                          )),
                                      color: (thumbnailBool &&
                                              titleBool &&
                                              descritionBool &&
                                              visibilityBool)
                                          ? Color(0xff5AA5EF)
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                ]),
                          ],
                          controller: _scrollController,
                        ),
                      ),
                    ))),
      ),
    );
  }
}

//----Check box widget
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

Future editDialog(context, height, width, edit, {groupId, title, grpimage}) {
  String email = '', groupName = '', groupStatusMsg = '', userId = '';
  bool groupStatus = true;
  List users = [];
  List ids = [];
  List<Map<String, String>> selectedUser = [];
  File image;
  bool loading = false;

  TextEditingController controller = TextEditingController(text: title);

  return showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          // color: Color(0xff333333).withOpacity(0.7),
          child: StatefulBuilder(
            builder: (context, setState) {
              List<Widget> sel = [];
              for (var item in selectedUser) {
                sel.add(ListTile(
                  trailing: InkWell(
                      onTap: () {
                        setState(() {
                          selectedUser.remove(item);
                        });
                      },
                      child: Icon(Icons.close)),
                  title: Text(
                    item['email'],
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xff14F47B),
                    child: Text(
                      item['email'].toString().substring(0, 1).toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 21.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ));
              }
              groupId = groupId;
              //groupName = title;
              // print(groupName);

              List<Widget> bottom = [];

              // print('userssssss' + users.toString());
              if (users != null && users.length > 0) {
                for (var index = 0; index < users.length; index++) {
                  bottom.add(InkWell(
                    onTap: () {
                      // print(selectedUser);
                      setState(() {
                        if (!ids.contains(
                          users[index]['id'],
                        )) {
                          ids.add(users[index]['id']);
                          selectedUser.add({
                            'id': users[index]['id'],
                            'email': users[index]['email'],
                          });
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff14F47B),
                            child: Text(
                              users[index]['email']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text(
                              //   '',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 18.0,
                              //     fontWeight: FontWeight.w500,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  '${users[index]['email']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff63676C),
                                  ),
                                  maxLines: 2,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
                }
              }

              return Dialog(
                backgroundColor: Colors.white.withOpacity(0),
                insetPadding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 60.0,
                  bottom: 80.0,
                ),
                child: ListView(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.54,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 17.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Color(0xff707070),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final pickedFile = await ImagePicker()
                                        .getImage(source: ImageSource.gallery);
                                    setState(() {
                                      image = File(pickedFile.path);
                                    });
                                  },
                                  child: image == null
                                      ? grpimage == null
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff5AA5EF),
                                              child: Image(
                                                height: 24,
                                                image: AssetImage(
                                                    'images/addPerson.png'),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff5AA5EF),
                                              backgroundImage:
                                                  NetworkImage(grpimage),
                                            )
                                      : CircleAvatar(
                                          backgroundColor: Color(0xff5AA5EF),
                                          backgroundImage: FileImage(image),
                                          // child: Image(
                                          //   height: 24,
                                          //   image: AssetImage('images/addPerson.png'),
                                          // ),
                                        ),
                                ),
                                SizedBox(width: 23),
                                // Text(
                                //   'Edit Group Name',
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 20.0,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.5,
                                  child: TextFormField(
                                    controller: controller,
                                    readOnly: !edit,
                                    maxLines: 1,
                                    onChanged: (val) {
                                      setState(() {
                                        groupName = val;
                                      });
                                      // print(groupName);
                                    },
                                    style: GoogleFonts.poppins(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      hintText: 'Edit Group Name',
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            groupStatus
                                ? Container()
                                : Center(
                                    child: Text(
                                      groupStatusMsg,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Column(
                              children: sel,
                            ),
                            TextFormField(
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              // ignore: missing_return
                              onChanged: (val) async {
                                email = val;
                                var data = await GroupService()
                                    .searchUserFriendList(email);

                                // GrpModel model =
                                //     grpModelFromJson(jsonEncode(data));
                                if (data['success'] == true) {
                                  setState(() {
                                    users = data['data'];
                                    // userId = data['data'][0]['id'];
                                    // print("userslist -->"+users.toString());
                                  });
                                } else {
                                  setState(() {
                                    users = [];
                                  });
                                }
                              },

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF8F9FA),
                                hintText: 'Add people to group',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff8E8E8E),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    // width: 2,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    // width: 2,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    // width: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            Column(
                              children: bottom,
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  // color: Color(0xff5AA5EF),
                                ),
                                child: RaisedButton(
                                  color: Color(0xff5AA5EF),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    if (edit) {
                                      if (groupName != '') {
                                        var data =
                                            await GroupService().addNewGroup(
                                          controller.text,
                                          image,
                                        );
                                        setState(() {
                                          groupStatus = false;
                                          groupStatusMsg = data['message'];
                                        });
                                        var groupId = data['id'];
                                        List problems = [];
                                        // if (EmailValidator.validate(email)) {
                                        if (data['success'] == true) {
                                          for (var item in selectedUser) {
                                            var d = await GroupService()
                                                .addMembersToGroup(
                                              groupId,
                                              item['id'],
                                            );
                                            if (d['success'] != true) {
                                              problems.add(item);
                                            }
                                            // print('messageeee' + d);
                                          }

                                          if (problems.length == 0) {
                                            Navigator.pop(context, 'Added');
                                          } else {
                                            String ayoo = '';
                                            for (var item in problems) {
                                              ayoo += item['email'] + ',';
                                            }
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          showConfirmDialog(context,
                                              text: data['message']);
                                        }

                                        // }
                                        // else{
                                        //   Navigator.pop(context,'Group Name already exist');
                                        // }
                                      }
                                    } else {
                                      // if (EmailValidator.validate(email)) {
                                      // print('xxxxx');
                                      List problems = [];
                                      // var data = await GroupServcie()
                                      //     .addMembersToGroup(groupId, userId);
                                      for (var item in selectedUser) {
                                        // print(item['id']);
                                        var d = await GroupService()
                                            .addMembersToGroup(
                                                groupId, item['id']);
                                        if (d['success'] != true) {
                                          problems.add(item);
                                        }
                                      }
                                      // print(groupId);
                                      if (problems.length == 0) {
                                        Navigator.pop(context, 'Added');
                                        showConfirmDialog(context,
                                            text: 'Members added to group');
                                      } else
                                        showConfirmDialog(context,
                                            text: 'Error');
                                      // }
                                      // else {
                                      //   print('workx');
                                      // }
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Done',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .055,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
