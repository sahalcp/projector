import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/models/group/groupListVideoAlbumModel.dart';

class GroupsProvider extends ChangeNotifier {
  GroupsProvider();

  /// Whether the page is in busy state
  bool isBusy = true;

  /// Error message if exists
  String errorMessage;

  /// Users Media
  GroupListVideoAlbumModel userMediaModel;

  /// All Videos of user
  List<Video> userVideos;

  /// All Alnbums of user
  List<Album> userAlbums;

  /// Gorups List of User
  List groupListData = [];

  /// Map of user's medias already selected in group
  List<Map<String, dynamic>> checkedGroupItems = [];

  void initialize() async {
    try {
      await GroupService().getMyGroups().then((val) {
        groupListData = val;
      });

      await _fetchGroupVideos();

      final userMediaData =
          await ContentDashboardService().getVideoAndAlbumOfUser();

      if (userMediaData != null) {
        userMediaModel = userMediaData;
        userVideos = userMediaData.videoListResponse;
        userAlbums = userMediaData.albumListResponse;
      }

      isBusy = false;

      notifyListeners();
    } catch (e) {
      isBusy = false;
      errorMessage = "Error occured while initializing groups";
      print("$errorMessage: ${e.toString()}");
      notifyListeners();
    }
  }

  /// Update an item in the group list data.
  void updateItemInGroup(
      {Video video,
      Album album,
      String groupId,
      bool isAlbum = false,
      bool isAddition}) {
    final groupIndex =
        checkedGroupItems.indexWhere((e) => e['groupId'] == groupId);
    if (isAlbum) {
      final List<Album> checkedAlbums = checkedGroupItems[groupIndex]['albums'];
      (isAddition)
          ? checkedAlbums.add(album)
          : checkedAlbums.removeWhere((e) => e.id == album.id);
      checkedGroupItems[groupIndex]['albums'] = checkedAlbums;
    } else {
      final List<Video> checkedVideos = checkedGroupItems[groupIndex]['videos'];
      (isAddition)
          ? checkedVideos.add(video)
          : checkedVideos.removeWhere((e) => e.id == video.id);
      checkedGroupItems[groupIndex]['videos'] = checkedVideos;
    }

    notifyListeners();
  }

  Future<void> _fetchGroupVideos() async {
    groupListData.forEach((e) async {
      await ContentDashboardService()
          .getVideoAndAlbumsOfGroup(groupId: e['id'])
          .then((val) {
        checkedGroupItems.add({
          "groupId": e['id'],
          "albums": val.albumListResponse,
          "videos": val.videoListResponse
        });
      });
    });
  }

  Future<bool> saveGroupData({String groupId}) async {
    List<String> videoList = [];
    List<String> albumList = [];
    final groupCheckedData =
        checkedGroupItems.firstWhereOrNull((e) => e['groupId'] == groupId);

    groupCheckedData['videos'].forEach((Video item) {
      videoList.add(item.id);
    });

    groupCheckedData['albums'].forEach((Album item) {
      albumList.add(item.id);
    });

    return await GroupService().addFilesToGroup(
        groupId: groupId,
        videos: videoList.join(','),
        albums: albumList.join(','));
  }
}
