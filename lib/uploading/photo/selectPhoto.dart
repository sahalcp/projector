import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projector/apis/photoService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/data/utils.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/uploadNewFlow/photoUploadScreen.dart';
import 'package:projector/uploading/photo/addDetailsPhoto.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:projector/uploading/summaryScreen.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/uploadPopupDialog.dart';
import 'package:projector/widgets/widgets.dart';

import '../../bgUpload/backgroundUploader.dart';

class SelectPhotoView extends StatefulWidget {
  @override
  _SelectPhotoViewState createState() => _SelectPhotoViewState();
}

class _SelectPhotoViewState extends State<SelectPhotoView> {
  bool videoSelected = false, loading = false;
  bool isFileManagerPicked = false;
  List thumbnail = [];
  Dio dio = Dio();
  String _path = "";
  File videoFile;
  Future<File> videoFileData;
  Uint8List snapShotData;
  String _loginedUserId;
  List<Widget> fileListThumb;
  List<File> fileList = new List<File>();
  var selectedPhotoSize;

  bool PhotoSelected = false;

  bool checked = false;
  List albumList = [];
  int groupValue = 1;
  String selectedTitle;
  String selectedDescription;
  String visibilityId;
  String groupId;
  String albumIdValue;
  int albumLength;
  int totalProgressValue = 0;
  double circleLoadingPercentageValue = 0.0;

  Future pickFiles() async {
    List<Widget> thumbs = new List<Widget>();
    if (fileListThumb != null) {
      fileListThumb.forEach((element) {
        thumbs.add(element);
      });
    }

    FilePickerResult imageFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (imageFiles != null) {
      List<File> files = imageFiles.paths.map((path) => File(path)).toList();

      if (files != null && files.length > 0) {
        files.forEach((element) {
          thumbs.add(Container(
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: FileImage(element), fit: BoxFit.cover),
            ),
          ));
          if (fileList != null) {
            fileList.add(element);
          }
        });
        setState(() {
          fileListThumb = thumbs;
          PhotoSelected = true;
        });
      }
    }

    /* await FilePicker.getMultiFile(
      type: FileType.image,

      // allowedExtensions: ['jpg', 'jpeg', 'bmp', 'pdf', 'doc', 'docx'],
    ).then((files) {
      if (files != null && files.length > 0) {
        files.forEach((element) {
          // List<String> picExt = ['.jpg', '.jpeg'];

          // thumbs.add(Padding(
          //     padding: EdgeInsets.all(1),
          //     child:new Image.file(element)
          // )
          // );

          thumbs.add(Container(
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: FileImage(element), fit: BoxFit.cover),
            ),
          ));
          if (fileList != null) {
            fileList.add(element);
          }
        });
        setState(() {
          fileListThumb = thumbs;
          PhotoSelected = true;
        });
      }
    });*/
  }

  bool videoUploading = false, videoUploaded = false;
  bool circleLoading = false;
  CancelToken cancelToken = CancelToken();

  Future<void> getUserId() async {
    var userId = await UserData().getUserId();

    setState(() {
      _loginedUserId = userId;
    });
  }

  _isImageList() {
    if (fileList != null && fileList.length > 0) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    getUserId();
    pickFiles();
    PhotoService().getMyAlbum(userId: _loginedUserId).then((val) {
      albumLength = val.length;
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  cancelToken.cancel();
                  Navigator.pop(context);
                } else {
                  cancelToken.cancel();
                  SystemNavigator.pop();
                }
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
            ),
            titleSpacing: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Upload Photo",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (loading == true) {
                      if (Navigator.canPop(context)) {
                        cancelToken.cancel();
                        Navigator.pop(context);
                      } else {
                        cancelToken.cancel();
                        SystemNavigator.pop();
                      }
                    } else {

                      if(isSingleClick(DateTime.now())){
                        return;
                      }

                      setState(() {
                        isFileManagerPicked = true;
                      });
                      selectedPhotoSize = 0;
                      for (var i = 0; i < fileList.length; i++) {
                        //print(fileList[i]);
                        final size = fileList[i].lengthSync() / 1000000;
                        selectedPhotoSize = selectedPhotoSize + size;
                        //print(size);
                      }

                      if (fileList != null && fileList.length > 0) {
                        PhotoSelected = true;
                      } else {
                        PhotoSelected = false;
                      }
                      //print("total size--$selectedPhotoSize");

                      var response = await ViewService().checkStorage();
                      var storageUsed = response['storageUsed'];
                      var totalStorage = storageUsed['total_storage'];
                      var usedStorage = storageUsed['used_storage'];

                      var availableStorage = double.parse(totalStorage) -
                          double.parse(usedStorage);

                      if (double.parse(totalStorage) >= availableStorage &&
                          availableStorage > 0 &&
                          availableStorage >= selectedPhotoSize) {
                        print("photo storage available---");
                        albumBottomSheet();
                      } else {
                        print("photo storage not available---");
                        storageDialog(context, height, width);
                      }
                    }
                  },
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          loading == true ? 'Cancel' : 'Choose',
                          style: GoogleFonts.poppins(
                              color: _isImageList != null
                                  ? Color(0xff5AA5EF)
                                  : Colors.grey,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: loading,
            opacity: 0.3,
            color: Colors.black,
            progressIndicator: Container(
              decoration: BoxDecoration(
                color: Colors.black,
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
                                color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(24.0),
                    height: height * 0.35,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.07),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: width * 0.18,
                          child: InkWell(
                            onTap: () async {
                              // setState(() {
                              //   isFileManagerPicked = true;
                              // });

                              //selecteVideo(width);
                              // pickImages();
                              pickFiles();
                            },
                            child: Image(
                              height: height * 0.08,
                              width: width * 0.15,
                              image: AssetImage('images/photo_upload.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.016),
                        Text(
                          'Choose photo/s to add \n to existing or new album.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  fileListThumb != null
                      ? Expanded(
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: fileListThumb,
                          ),
                        )
                      : Text("")
                ],
              ),
            ),
          )),
    );
  }

  albumBottomSheet() {
    var val = '';
    bool loading = false;
    //var context;

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        context: context,
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                Container(
                  height: height * 0.6,
                  padding: EdgeInsets.only(
                    top: 11.0,
                    // left: 39.0,
                  ),
                  child: ListView(
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
                        padding: EdgeInsets.only(
                            left: 39.0, right: 39.0, bottom: 39.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Album',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Add New Album',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 50,
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    // borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                    // borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (value) => {val = value},
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (isSingleClick(DateTime.now())) {
                                    print('hold on, processing');
                                    return;
                                  }
                                  print("clicked create button--->");

                                  if (val.length != 0) {
                                    setState(() {
                                      loading = true;
                                      circleLoading = true;
                                    });

                                    var createAlbum = await PhotoService()
                                        .addAlbum(
                                            title: val,
                                            description: "",
                                            icon: "",
                                            albumId: "");
                                    if (createAlbum['success'] == true) {
                                      circleLoading = false;

                                      Fluttertoast.showToast(
                                          msg: 'Album created',
                                          backgroundColor: Colors.black);

                                      var title = createAlbum['data']['title'];

                                      var albumId = createAlbum['album_id'];
                                      // print("album id ------"+albumId.toString());
                                      //print("album title ------"+title.toString());
                                      await UserData().setAlbumId(albumId);
                                      await UserData().setAlbumTitle(
                                          title != null ? title : "");

                                      setState(() {
                                        circleLoading = false;
                                      });

                                      Navigator.of(context).push(
                                        CupertinoPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            ///---show photo upload
                                            ///
                                            // return AddPhotoDetailsScreen(
                                            //   imageList: fileList,
                                            //   fileListThumb: fileListThumb,
                                            // );

                                            // imageList: fileList,
                                            // fileListThumb: fileListThumb,
                                            // imageFileFirst: fileList[0],

                                            return PhotoUploadScreen(
                                              imageList: fileList,
                                              fileListThumb: [],
                                              imageFileFirst: fileList[0],
                                            );
                                          },
                                        ),
                                      );

                                      // Navigator.pop(context);
                                      // var res = await  PhotoService().getMyAlbum(userId: _loginedUserId);
                                      // albumList = res;
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Enter album name',
                                        backgroundColor: Colors.black);
                                  }
                                },
                                child: circleLoading
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      )
                                    : Text(
                                        'Create',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              child: FutureBuilder(
                                future: PhotoService()
                                    .getMyAlbum(userId: _loginedUserId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    albumList = snapshot.data;
                                    return Container(
                                      child: snapshot.data.length == 0
                                          ? Container()
                                          : Container(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Choose from existing Albums',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  ListView.builder(
                                                      itemCount:
                                                          snapshot.data.length,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        var title =
                                                            snapshot.data[index]
                                                                ['title'];
                                                        var id = snapshot
                                                            .data[index]['id'];
                                                        var description =
                                                            snapshot.data[index]
                                                                ['description'];
                                                        var visibility =
                                                            snapshot.data[index]
                                                                ['visibility'];
                                                        var orderNumber =
                                                            snapshot.data[index]
                                                                [
                                                                'order_number'];
                                                        var albumId = snapshot
                                                            .data[index]['id'];

                                                        return Container(
                                                            child: SizedBox(
                                                          height: 40,
                                                          child: Row(
                                                            children: [
                                                              Radio<int>(
                                                                toggleable:
                                                                    true,
                                                                groupValue:
                                                                    groupValue,
                                                                value:
                                                                    int.parse(
                                                                        id),
                                                                onChanged:
                                                                    (int val) {
                                                                  setState(() {
                                                                    selectedTitle =
                                                                        title;
                                                                    selectedDescription =
                                                                        description;
                                                                    groupValue =
                                                                        val;
                                                                    visibilityId =
                                                                        visibility;
                                                                    groupId =
                                                                        orderNumber;
                                                                    albumIdValue =
                                                                        albumId;
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                title,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                                      }),
                                                ],
                                              ),
                                            ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                albumLength > 0
                    ? Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Container(
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              onPressed: () async {
                                // print("radiovalue-->"+selectedTitle.toString()+","+groupValue.toString());

                                if (selectedDescription != null) {
                                  // Navigator.pop(context);
                                  // await UserData().setAlbumId(groupValue);
                                  // await UserData().setAlbumTitle(selectedTitle!=null?selectedTitle:"");
                                  //await UserData().setAlbumDescription(selectedDescription!=null?selectedDescription:"");
                                  //navigateLeft(context, SelectPhotoView());
                                  /// set loader
                                  /// Photo upload
                                  Navigator.pop(context);

                                  //uploadPhotos();
                                  bgUploadPhotos();

                                  navigate(context, NewListVideo());



                                  print("upload the files ---");
                                } else {
                                  Navigator.pop(context);
                                  await UserData().setAlbumId(groupValue);
                                  await UserData().setAlbumTitle(
                                      selectedTitle != null
                                          ? selectedTitle
                                          : "");
                                  await UserData().setAlbumDescription(
                                      selectedDescription != null
                                          ? selectedDescription
                                          : "");
                                  Navigator.of(context).push(
                                    CupertinoPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return PhotoUploadScreen(
                                          imageList: fileList,
                                          fileListThumb: [],
                                          imageFileFirst: fileList[0],
                                        );

                                        // return AddPhotoDetailsScreen(
                                        //   imageList: fileList,
                                        //   fileListThumb: fileListThumb,
                                        // );
                                      },
                                    ),
                                  );
                                  //Fluttertoast.showToast(msg: 'Choose Album', backgroundColor: Colors.black);
                                }
                              },
                              child: Text(
                                'Choose',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ))
                    : Container(),
              ],
            );
          });
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
    // uploadLoadingDialog(context);
    List<MultipartFile> newList = new List<MultipartFile>();

    for (var i = 0; i < fileList.length; i++) {
      MultipartFile imageFile = await MultipartFile.fromFile(fileList[i].path);
      newList.add(imageFile);
    }

    var token = await UserData().getUserToken();
    setState(() {
      //videoUploading = true;
      loading = true;
    });

    try {
      var data = await dio.post('$serverUrl/addPhotoContent',
          data: FormData.fromMap({
            "token": token,
            "photo_file[]": newList,
            "album_id": groupValue,
          }),
          cancelToken: cancelToken, onSendProgress: (sent, total) {
        //setCallbackCount(totalProgressValue);

        final progressTotal = sent / total * 100;
        totalProgressValue = progressTotal.round();

        /// set state changed
        setState(() {
          if (totalProgressValue > 100) {
            totalProgressValue = 100;
          }
          totalProgressValue = totalProgressValue;
        });

        circleLoadingPercentageValue = totalProgressValue / 100;
        if (circleLoadingPercentageValue > 1.0) {
          circleLoadingPercentageValue = 1.0;
        }

        print("loading value" + totalProgressValue.toString());

        if (totalProgressValue == 100) {
          /* setState(() {
            loading = false;
            // videoUploaded = true;
            // videoUploading = false;
          });*/
        }
      }, onReceiveProgress: (received, total) {});

      if (data.data['success']) {
        // print("response --->" + data.toString());

        setState(() {
          loading = false;
        });

        Navigator.of(context).push(
          CupertinoPageRoute<Null>(
            builder: (BuildContext context) {
              return NewListVideo();
            },
          ),
        );

        Fluttertoast.showToast(
          msg: 'Photo Published',
          textColor: Colors.black,
          backgroundColor: Colors.white,
        );

        /*  Future.delayed(Duration(seconds: 1), () {
          navigate(context, NewListVideo());

          */ /* Navigator.of(context).push(
            CupertinoPageRoute<Null>(
              builder: (BuildContext context) {
                return SummaryScreen(
                  type: "album",
                  contentId: groupValue.toString(),
                  pageType: "photo",
                );
              },
            ),
          );*/ /*



          setState(() {
            loading = false;
            //Navigator.pop(context);
            // videoUploaded = false;
          });
        });*/

      } else {
        Fluttertoast.showToast(msg: 'Try Again', backgroundColor: Colors.black);
      }
    } catch (e) {
      print("upload photo content failed 1 ------");
      print("upload photo content failed 1 ------${e.toString()}");
      setState(() {
        // videoUploading = false;
      });
      // Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.black);
    }
  }
  bgUploadPhotos() async{
    var token = await UserData().getUserToken();

    var groupSelectedId = '';


    _prepareMediaUploadListener();
    String taskId = await BackgroundUploader.uploadEnqueue(file:fileList,
      token: token,
      visibility: visibilityId,
      albumId: groupValue,
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

  _checkCondition() {
    if (fileList.length != 0) {
      return Image(
        image: FileImage(fileList[0]),
      );
    }
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
