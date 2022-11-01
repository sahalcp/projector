class GroupListVideoAlbumModel {
  bool success;
  String datetime;
  List<Album> albumListResponse;
  List<Video> videoListResponse;

  GroupListVideoAlbumModel(
      {this.success, this.datetime, this.albumListResponse, this.videoListResponse});

  GroupListVideoAlbumModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    datetime = json['datetime'];
    if (json['album'] != null) {
      albumListResponse = <Album>[];
      json['album'].forEach((v) {
        albumListResponse.add(new Album.fromJson(v));
      });
    }
    if (json['video'] != null) {
      videoListResponse = <Video>[];
      json['video'].forEach((v) {
        videoListResponse.add(new Video.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['datetime'] = this.datetime;
    if (this.albumListResponse != null) {
      data['album'] = this.albumListResponse.map((v) => v.toJson()).toList();
    }
    if (this.videoListResponse != null) {
      data['video'] = this.videoListResponse.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Album {
  String id;
  String orderNumber;
  String userId;
  String title;
  String description;
  String visibility;
  String icon;
  String status;
  String publishDate;
  String created;
  String updated;
  String bannerView;
  int selected;

  Album(
      {this.id,
      this.orderNumber,
      this.userId,
      this.title,
      this.description,
      this.visibility,
      this.icon,
      this.status,
      this.publishDate,
      this.created,
      this.updated,
      this.bannerView,
      this.selected});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    visibility = json['visibility'];
    icon = json['icon'];
    status = json['status'];
    publishDate = json['publish_date'];
    created = json['created'];
    updated = json['updated'];
    bannerView = json['banner_view'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['visibility'] = this.visibility;
    data['icon'] = this.icon;
    data['status'] = this.status;
    data['publish_date'] = this.publishDate;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['banner_view'] = this.bannerView;
    data['selected'] = this.selected;
    return data;
  }
}

class Video {
  String id;
  String visibility;
  String groupId;
  String orderNumber;
  String categoryId;
  String subcategoryId;
  String playlistId;
  String userId;
  String title;
  String description;
  String thumbnails;
  String videoFile;
  String videoRawFile;
  String videoDuration;
  String thumbnailHover;
  String videoVtt;
  String status;
  String orientation;
  String created;
  String publishDate;
  String views;
  String updated;
  String bannerView;
  String videoSize;
  String notifyStatus;
  String category;
  String subCategory;
  int selected;
  bool isChecked = false;

  Video(
      {this.id,
      this.visibility,
      this.groupId,
      this.orderNumber,
      this.categoryId,
      this.subcategoryId,
      this.playlistId,
      this.userId,
      this.title,
      this.description,
      this.thumbnails,
      this.videoFile,
      this.videoRawFile,
      this.videoDuration,
      this.thumbnailHover,
      this.videoVtt,
      this.status,
      this.orientation,
      this.created,
      this.publishDate,
      this.views,
      this.updated,
      this.bannerView,
      this.videoSize,
      this.notifyStatus,
      this.category,
      this.subCategory,
      this.selected,
      this.isChecked});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visibility = json['visibility'];
    groupId = json['group_id'];
    orderNumber = json['order_number'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    playlistId = json['playlist_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    thumbnails = json['thumbnails'];
    videoFile = json['video_file'];
    videoRawFile = json['video_raw_file'];
    videoDuration = json['video_duration'];
    thumbnailHover = json['thumbnail_hover'];
    videoVtt = json['video_vtt'];
    status = json['status'];
    orientation = json['orientation'];
    created = json['created'];
    publishDate = json['publish_date'];
    views = json['views'];
    updated = json['updated'];
    bannerView = json['banner_view'];
    videoSize = json['video_size'];
    notifyStatus = json['notify_status'];
    category = json['Category'];
    subCategory = json['SubCategory'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['visibility'] = this.visibility;
    data['group_id'] = this.groupId;
    data['order_number'] = this.orderNumber;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['playlist_id'] = this.playlistId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumbnails'] = this.thumbnails;
    data['video_file'] = this.videoFile;
    data['video_raw_file'] = this.videoRawFile;
    data['video_duration'] = this.videoDuration;
    data['thumbnail_hover'] = this.thumbnailHover;
    data['video_vtt'] = this.videoVtt;
    data['status'] = this.status;
    data['orientation'] = this.orientation;
    data['created'] = this.created;
    data['publish_date'] = this.publishDate;
    data['views'] = this.views;
    data['updated'] = this.updated;
    data['banner_view'] = this.bannerView;
    data['video_size'] = this.videoSize;
    data['notify_status'] = this.notifyStatus;
    data['Category'] = this.category;
    data['SubCategory'] = this.subCategory;
    data['selected'] = this.selected;
    return data;
  }
}
