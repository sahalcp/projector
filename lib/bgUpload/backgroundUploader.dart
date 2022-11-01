import 'dart:async';
import 'dart:io';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:projector/constant.dart';

class BackgroundUploader {
  BackgroundUploader._();

  static final uploader = FlutterUploader();

  static Future<String> uploadEnqueue(
      {List<File> file, token, visibility, albumId, groupId}) async {
    List<FileItem> fileItem = [];
    for (var i = 0; i < file.length; i++) {
      fileItem.add(FileItem(path: file[i].path, field: "photo_file[]"));
    }

    final String taskId = await uploader.enqueue(
      MultipartFormDataUpload(
        url: '$serverUrl/addPhotoContent',
        method: UploadMethod.POST,
        data: {
          "token": token,
          "visibility": visibility.toString(),
          "album_id": albumId.toString(),
          "group_id": groupId.toString(),
        },
        files: fileItem,
        tag: "Media Uploading",
      ),
    );

    uploader.progress.listen((result) {
      print("progress3434-->$result");

      String bgProcessTitle = '';
      if (result.status == UploadTaskStatus.failed) {
        bgProcessTitle = 'Upload Failed';
      } else if (result.status == UploadTaskStatus.canceled) {
        bgProcessTitle = 'Upload Canceled';
      } else if (result.status == UploadTaskStatus.complete) {
        bgProcessTitle = 'Upload Complete';
      } else if (result.status == UploadTaskStatus.running) {
        bgProcessTitle = 'Upload In Progress';
      }

      print("progress result111-->$bgProcessTitle");
    });

    uploader.result.listen((result) {
      uploader.clearUploads();
      print("progress2121-->$result");
      String bgProcessTitle = '';
      if (result.status == UploadTaskStatus.failed) {
        bgProcessTitle = 'Upload Failed';
      } else if (result.status == UploadTaskStatus.canceled) {
        bgProcessTitle = 'Upload Canceled';
        uploader.cancelAll();
      } else if (result.status == UploadTaskStatus.complete) {
        bgProcessTitle = 'Upload Complete';
      } else if (result.status == UploadTaskStatus.running) {
        bgProcessTitle = 'Upload In Progress';
      }

      print("progress result222-->$bgProcessTitle");
    }, onError: (error) {
      //handle failure
     uploader.cancelAll();
    });

    return taskId;
  }

  static Future<String> videoUploadEnqueue(
      {File file, token, videoId}) async {


    final String taskId = await uploader.enqueue(
      MultipartFormDataUpload(
        url: '$serverUrl/addMobileVideoContent',
        method: UploadMethod.POST,
        data: {
          "token": token,
          "video_id": videoId.toString(),
        },
        files: [FileItem(path: file.path, field: "video_file")],
        tag: "Media Uploading",
      ),
    );

    uploader.progress.listen((result) {
      print("progress video-->$result");

      String bgProcessTitle = '';
      if (result.status == UploadTaskStatus.failed) {
        bgProcessTitle = 'Upload Failed';
      } else if (result.status == UploadTaskStatus.canceled) {
        bgProcessTitle = 'Upload Canceled';
      } else if (result.status == UploadTaskStatus.complete) {
        bgProcessTitle = 'Upload Complete';
      } else if (result.status == UploadTaskStatus.running) {
        bgProcessTitle = 'Upload In Progress';
      }

      print("progress video result111-->$bgProcessTitle");
    });

    uploader.result.listen((result) {
      uploader.clearUploads();
      print("progress video2121-->$result");
      String bgProcessTitle = '';
      if (result.status == UploadTaskStatus.failed) {
        bgProcessTitle = 'Upload Failed';
      } else if (result.status == UploadTaskStatus.canceled) {
        bgProcessTitle = 'Upload Canceled';
        uploader.cancelAll();
      } else if (result.status == UploadTaskStatus.complete) {
        bgProcessTitle = 'Upload Complete';
      } else if (result.status == UploadTaskStatus.running) {
        bgProcessTitle = 'Upload In Progress';
      }

      print("progress video result222-->$bgProcessTitle");
    }, onError: (error) {
      //handle failure
      uploader.cancelAll();
    });

    return taskId;
  }
}
