import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projector/uploadNewFlow/paymentVideoPage.dart';
import 'package:projector/uploading/photo/selectPhoto.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

import '../uploadNewFlow/uploadScreen.dart';

showUploadDropDown(context) {
  List<PopupMenuItem<dynamic>> items = [];

  items.add(PopupMenuItem(
    child: InkWell(
      onTap: () {},
      child: Row(
        children: [
          Image(
            image: AssetImage('images/mask.png'),
            height: 35,
            width: 35,
          ),
          SizedBox(width: 10),
          Text(
            'Request access',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  ));

  items.add(
    PopupMenuItem(
      child: Text(
        'Account Settings',
        style: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Color(0xff02071A),
        ),
      ),
    ),
  );
  items.add(
    PopupMenuItem(
      child: Text(
        'Edit Profile',
        style: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Color(0xff02071A),
        ),
      ),
    ),
  );
  items.add(
    PopupMenuItem(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Text(
              'Log Out',
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Color(0xff02071A),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(10, 10, 10, 10),
    items: items,
  );
}

showPopupUpload(
    {context,
    uploadCount,
    double left,
    double top,
    double right,
    double bottom}) {
  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(left, top, right, bottom),
    color: Colors.white,

    //position where you want to show the menu on screen
    items: [
      /* PopupMenuItem<String>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Capture',
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.camera_alt_outlined,
                color: Colors.black,
                size: 25,
              )
            ],
          ),
          value: '1'),*/
      // PopupMenuDivider(),
      PopupMenuItem<String>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Photos',
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.image,
                color: Colors.black,
                size: 25,
              )
            ],
          ),
          value: '2'),
      PopupMenuDivider(),
      PopupMenuItem<String>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Videos',
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.video_call,
                color: Colors.black,
                size: 28,
              )
            ],
          ),
          value: '3'),
    ],
    elevation: 8.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
  ).then<void>((String itemSelected) {
    if (itemSelected == null) return;

    if (itemSelected == "1") {
      //capture
    } else if (itemSelected == "2") {
      //photo

      if (uploadCount != null && uploadCount > 2) {
        navigate(context, PaymentVideoPage(uploadCount: uploadCount));
      } else {
        navigate(context, SelectPhotoView());
      }
    } else {
      //video
      //navigate(context, SelectVideoView());

      if (uploadCount != null && uploadCount > 2) {
        navigate(context, PaymentVideoPage(uploadCount: uploadCount));
      } else {
        selectVideoFromFileManager(context);
      }
    }
  });
}

selectVideoFromFileManager(context) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getVideo(source: ImageSource.gallery);

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    final size = file.lengthSync() / 1000000;
    var selectedVideoSize = size;
    print("videosize selected---$selectedVideoSize");

    navigate(
        context,
        UploadScreen(
          videoFile: file,
        ));
  } else {
    //storageDialog(context, 100, 100);
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

showPopupMenu(context) {
  Theme(
    data: Theme.of(context).copyWith(
      dividerTheme: DividerThemeData(
        color: Colors.red,
      ),
      iconTheme: IconThemeData(color: Colors.green),
      textTheme: TextTheme().apply(bodyColor: Colors.orange),
    ),
    child: showPopupUpload(
        context: context, left: 25.0, top: 100, right: 0.0, bottom: 0.0),
  );
}
