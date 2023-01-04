import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/uploadNewFlow/uploadScreen.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock/wakelock.dart';

class SelectVideoView extends StatefulWidget {
  @override
  _SelectVideoViewState createState() => _SelectVideoViewState();
}

class _SelectVideoViewState extends State<SelectVideoView> {
  bool videoSelected = false, loading = false, isUploadButtonVisible = true;
  List thumbnail = [];
  List<AssetEntity> _mediaList = [];
  Dio dio = Dio();
  String _path = "";
  File videoFile;
  Future<File> videoFileData;
  Uint8List snapShotData;
  var selectedVideoSize;
  final picker = ImagePicker();

  fetchMedia() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

      PhotoManager.clearFileCache();

      albums.forEach((list) async {
        List<AssetEntity> media = await list.getAssetListPaged(page: 0, size: 100);
        // print(media);
        media.forEach((m) {
          if (m.type == AssetType.video) {
            _mediaList.add(m);
          }
        });
        setState(() {});
      });
    }
  }

  selectVideoFromFileManager() async {
     final pickedFile = await picker.getVideo(source: ImageSource.gallery);


     if(pickedFile !=null){
       File file = File(pickedFile.path);
       videoFile = file;
       final size = file.lengthSync() / 1000000;
       selectedVideoSize = size;
       print("videosize---$selectedVideoSize");

       if (selectedVideoSize == 0.0) {
         videoSelected = false;
       } else {
         videoSelected = true;
       }

      /* var img = await VideoThumbnail.thumbnailFile(
         video: file.path,
         imageFormat: ImageFormat.JPEG,
         maxWidth: width.toInt(),
         // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
         quality: 100,
       );
       thumbnail.add(img);*/
       setState(() {
         videoSelected = true;
       });

     }

   /* File file = await FilePicker.getFile(
      type: FileType.video,
    );
    // print(file);
    if (file != null) {
      thumbnail = [];
      videoFile = file;
      //print("videofile----$videoFile");
      final size = file.lengthSync() / 1000000;
      selectedVideoSize = size;
      print("videosize---$selectedVideoSize");

      if (selectedVideoSize == 0.0) {
        videoSelected = false;
      } else {
        videoSelected = true;
      }

      // for (var count = 0; count < 3; count++) {
      var img = await VideoThumbnail.thumbnailFile(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: width.toInt(),
        // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 100,
      );
      thumbnail.add(img);
      // }
      // print(thumbnail);
      setState(() {
        videoSelected = true;
      });
    }*/
  }

  bool videoUploading = false, videoUploaded = false;
  bool isFileManagerPicked = false;
  int selectedVideoFile;
  int totalProgressValue = 0;
  double circleLoadingPercentageValue = 0.0;
  CancelToken cancelToken = CancelToken();

  uploadVideo() async {
    String fileName = videoFile.path.split('/').last;
    var token = await UserData().getUserToken();

    List images = [];
    // thumbnail.forEach((image) {
    //   List<int> imageBytes;
    //   String base64Image;
    //   if (image != null) {
    //     imageBytes = File(image).readAsBytesSync();
    //     base64Image = Base64Encoder().convert(imageBytes);
    //     images.add('$base64Image');
    //   }
    // });
    // var thumbnailString =
    //     images.reduce((value, element) => value + ' , ' + element);

    /// set state changed
    setState(() {
      loading = true;
      isUploadButtonVisible = false;
      //videoUploading = true;
    });
    //loading = true;
    try {
      var data = await dio.post(
        '$serverUrl/addVideoContnet',
        data: FormData.fromMap({
          "token": token,
          "video_file":
              await MultipartFile.fromFile(videoFile.path, filename: fileName),
          "status": 0,
          // "thumbnails": thumbnailString,
        }),
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          // print("$val1 : $val2");
          final progressTotal = sent / total * 100;
          totalProgressValue = progressTotal.round();

          /// set state changed
          setState(() {
            if (totalProgressValue > 100) {
              totalProgressValue = 100;
            }
            totalProgressValue = totalProgressValue;
          });

          // totalProgressValue = totalProgressValue;

          circleLoadingPercentageValue = totalProgressValue / 100;
          if (circleLoadingPercentageValue > 1.0) {
            circleLoadingPercentageValue = 1.0;
          }

           print("loading value"+totalProgressValue.toString());

          if (totalProgressValue == 100) {
            /// set state changed
            /* setState(() {
              loading = false;
              // videoUploaded = true;
              // videoUploading = false;
            });*/

          }

          /*if ((sent / total) * 100 == 100.00) {
            setState(() {
             // videoUploaded = true;
              loading = false;
             // videoUploading = false;
            });
          }*/
        },
      );
       print("upload video content1 ------"+data.data.toString());
      // print("upload video content load1 ------");
      if (data.data['success']) {
        //print("upload video content load2 ------");
        //print("upload video content2 ------"+data.toString());

        // getMySubscription().then((sub) {
        //   print(sub);
        //   if (sub['subscription']== 'Free') {
        //       Navigator.of(context).push(
        //         CupertinoPageRoute<Null>(
        //           builder: (BuildContext context) {
        //             return SubscriptionScreen();
        //           },
        //         ),
        //       );
        //   } else {
        /// set state changed
        setState(() {
          loading = false;
        });

        Navigator.of(context).push(
          CupertinoPageRoute<Null>(
            builder: (BuildContext context) {
              //----show adddetails screen

              // return AddDetailsScreen(
              //   image: data.data['suggestedThumbnails'],
              //   videoFile: videoFile,
              //   videoId: data.data['video_id'],
              // );

              return UploadScreen(
                image: data.data['suggestedThumbnails'],
                videoFile: videoFile,
                videoId: data.data['video_id'],
              );
            },
          ),
        );

        /* Future.delayed(Duration(seconds: 1), () {
          setState(() {
            loading = false;
            videoUploaded = false;
          });
          Navigator.of(context).push(
            CupertinoPageRoute<Null>(
              builder: (BuildContext context) {
                return AddDetailsScreen(
                  image: data.data['suggestedThumbnails'],
                  videoFile: videoFile,
                  videoId: data.data['video_id'],
                );
              },
            ),
          );
        });*/

        // }
        // });
        //  videoFile = File(path);

        // var storage =
        //     int.parse(maxStorage) - diskUsed;
        //     // print(storage);
        //     // print( videoFile.lengthSync() / 1024);
        // if (storage >=
        //     videoFile.lengthSync() / 1024) {

        // data['video_id'];
      } else {
        print("upload video content load3 ------");
        Fluttertoast.showToast(msg: 'Try Again', backgroundColor: Colors.black);
      }
    } catch (e) {
      print("upload video content failed ------");
      print("upload video content failed ------${e.toString()}");
      // setState(() {
      //   videoUploading = false;
      // });
      // Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.black);
    }
  }

  @override
  void initState() {
    fetchMedia();
    Wakelock.enable();
    // Permission.storage.isGranted.then((value) {
    //   print(value);
    //   if (!value) {
    //     Permission.storage.request();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    // cancelToken.cancel();
    super.dispose();
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
                Wakelock.disable();
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
            ),
            titleSpacing: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Upload Video",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // print(videoFile);
                    print("videosize---$selectedVideoSize");
                    // await uploadVideo();

                    if (loading == true) {
                      if (Navigator.canPop(context)) {
                        cancelToken.cancel();
                        Navigator.pop(context);
                      } else {
                        cancelToken.cancel();
                        SystemNavigator.pop();
                      }
                    } else {
                      var response = await ViewService().checkStorage();
                      var storageUsed = response['storageUsed'];
                      var totalStorage = storageUsed['total_storage'];
                      var usedStorage = storageUsed['used_storage'];

                      var availableStorage = double.parse(totalStorage) -
                          double.parse(usedStorage);

                      if (double.parse(totalStorage) >= availableStorage &&
                          availableStorage > 0 &&
                          availableStorage > selectedVideoSize) {
                        print("storage available---");
                        await uploadVideo();
                      } else {
                        print("storage not available---");
                        storageDialog(context, height, width);
                      }
                    }
                  },
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          loading == true ? 'Cancel' : 'Choose',
                          style: GoogleFonts.poppins(
                              color: videoSelected
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
          // floatingActionButton: videoSelected
          //     ? InkWell(
          //         onTap: () async {
          //           // print(videoFile);
          //           print("videosize---$selectedVideoSize");
          //           // await uploadVideo();

          //           var response = await ViewService().checkStorage();
          //           var storageUsed = response['storageUsed'];
          //           var totalStorage = storageUsed['total_storage'];
          //           var usedStorage = storageUsed['used_storage'];

          //           var availableStorage =
          //               double.parse(totalStorage) - double.parse(usedStorage);

          //           if (double.parse(totalStorage) > availableStorage &&
          //               availableStorage > 0 &&
          //               availableStorage > selectedVideoSize) {
          //             print("storage available---");
          //             await uploadVideo();
          //           } else {
          //             print("storage not available---");
          //             storageDialog(context, height, width);
          //           }
          //         },
          //         child: Visibility(
          //           visible: isUploadButtonVisible,
          //           child: Container(
          //             margin: EdgeInsets.only(bottom: 16.0),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10.0),
          //               color: Color(0xff5AA5EF),
          //             ),
          //             height: height * 0.05,
          //             width: width * 0.5,
          //             child: Center(
          //               child: Text(
          //                 'Upload',
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 20.0,
          //                     fontWeight: FontWeight.w500),
          //               ),
          //             ),
          //           ),
          //         ))
          //     : Container(),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,

          // body: WillPopScope(
          // // ignore: missing_return
          // onWillPop: () async {
          // if (videoUploading) {
          // dio.close(force: true);
          // return true;
          // } else
          // return true;
          // },
          // child: ModalProgressHUD(

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
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 18),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 26.0),
                    //   child: Text(
                    //     'Select file',
                    //     style: GoogleFonts.poppins(
                    //       fontSize: 13.0,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // // SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.all(24.0),
                      height: height * 0.35,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: videoSelected
                          ? _checkCondition()
                          : Column(
                              children: [
                                SizedBox(height: height * 0.07),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: width * 0.18,
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isFileManagerPicked = true;
                                      });

                                      selectVideoFromFileManager();
                                    },
                                    child: Image(
                                      height: 75,
                                      width: 75,
                                      image:
                                          AssetImage('images/video_upload.png'),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: height * 0.016),
                                Text(
                                  'Choose video to add \n to your projector.',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: height * 0.01),
                    /*videoUploaded
                      ? Center(
                    child: Container(
                      height: height * 0.1,
                      child: LottieBuilder.asset('images/Success.json'),
                    ),
                  )
                      : videoUploading
                      ? LottieBuilder.asset('images/Loader.json')
                      : Container(),*/
                    new Expanded(
                      child: GridView.builder(
                          itemCount: _mediaList.length,
                          shrinkWrap: true,
                          physics:
                              ScrollPhysics(parent: BouncingScrollPhysics()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder<Uint8List>(
                              future: _mediaList[index].thumbnailData,
                              builder: (BuildContext context, snapshot) {
                                // if (snapshot.connectionState ==
                                //     ConnectionState.done) {
                                var duration = _mediaList[index].videoDuration;
                                var hours = duration.inHours;
                                var minutes = duration.inMinutes > 60
                                    ? duration.inMinutes % 60
                                    : duration.inMinutes;
                                var seconds = duration.inSeconds > 60
                                    ? duration.inSeconds.toInt() % 60
                                    : duration.inSeconds;

                                final bytes = snapshot.data;

                                // If we have no data, display a spinner
                                if (bytes == null)
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          margin: EdgeInsets.all(5),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );

                                return InkWell(
                                    onTap: () async {
                                      selectedVideoFile = index;
                                      videoFileData = _mediaList[index].file;

                                      _getPath(bytes);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: selectedVideoFile == index
                                                  ? Colors.white
                                                  : Colors.transparent)),
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: Image.memory(
                                              bytes,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 5, bottom: 5),
                                              child: Text(
                                                '$hours:$minutes:$seconds',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                //}
                                return Container();
                              },
                            );
                          }),
                    ),

                    // InkWell(
                    //   onTap: () {
                    //     // navigate(context, AddDetailsScreen());
                    //   },
                    //   child: Image(
                    //     height: height * 0.4,
                    //     width: width,
                    //     image: AssetImage('images/img.png'),
                    //     fit: BoxFit.fitWidth,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  _getPath(Uint8List bytes) async {
    final file = await videoFileData; // the method return Future<File>
    setState(() {
      snapShotData = bytes;
      _path = file.path;
      // print("pathhhh"+_path);
      videoFile = File(_path);
      final size = file.lengthSync() / 1000000;
      selectedVideoSize = size;
      print("videosize- ---$selectedVideoSize");
      if (selectedVideoSize == 0.0) {
        videoSelected = false;
      } else {
        videoSelected = true;
      }

      isFileManagerPicked = false;
    });
  }

  _checkCondition() {
    if (isFileManagerPicked) {
      if (thumbnail.length != 0) {
        return Image(
          image: FileImage(File(thumbnail[0])),
        );
      }
    } else {
      if (snapShotData != null) {
        return Image.memory(snapShotData, fit: BoxFit.cover);
      }
    }
  }
}
