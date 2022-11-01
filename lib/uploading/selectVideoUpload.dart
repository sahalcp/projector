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
import 'package:sizer/sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock/wakelock.dart';

class SelectVideoUploadView extends StatefulWidget {
  SelectVideoUploadView({
    this.videoFile
  });

  final File videoFile;

  @override
  _SelectVideoUploadViewState createState() => _SelectVideoUploadViewState();
}

class _SelectVideoUploadViewState extends State<SelectVideoUploadView> {
  bool loading = false, isUploadButtonVisible = true;
  Dio dio = Dio();
  String _path = "";
  //File videoFile;
  Future<File> videoFileData;
  Uint8List snapShotData;
  var selectedVideoSize;

  bool videoUploading = false, videoUploaded = false;
  bool isFileManagerPicked = false;
  int selectedVideoFile;
  int totalProgressValue = 0;
  double circleLoadingPercentageValue = 0.0;
  CancelToken cancelToken = CancelToken();

  uploadVideo() async {
    String fileName = widget.videoFile.path.split('/').last;
    var token = await UserData().getUserToken();

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
              await MultipartFile.fromFile(widget.videoFile.path, filename: fileName),
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
                videoFile: widget.videoFile,
                videoId: data.data['video_id'],
              );
            },
          ),
        );
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

    uploadVideo();

    /*File file = File(widget.videoFilePath);
    videoFile = file;
    final size = file.lengthSync() / 1000000;
    selectedVideoSize = size;
    print("videosize---$selectedVideoSize");

    if (selectedVideoSize == 0.0) {
      videoSelected = false;
    } else {
      videoSelected = true;
      print("videosize selected---$videoSelected");

      uploadVideo();

    }*/

    Wakelock.enable();
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
    return Sizer(builder: (context, orientation, deviceType) {
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
                      if (Navigator.canPop(context)) {
                        cancelToken.cancel();
                        Navigator.pop(context);
                      } else {
                        cancelToken.cancel();
                        SystemNavigator.pop();
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                                color: Color(0xff5AA5EF),
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
                      totalProgressValue == 100? Container(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                        ),
                      ) :  CircularPercentIndicator(
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
                      SizedBox(height: 15,),
                      Text(
                        totalProgressValue == 100 ? "Your content is being uploaded, this could take a few minutes" : '',
                        textAlign: TextAlign.center,
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
              ),
            )),
      );
    });

  }
}
