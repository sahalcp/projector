import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/photoService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

import '../widgets/widgets.dart';

class SummaryScreen extends StatefulWidget {
  SummaryScreen({
    this.contentId,
    this.type,
    this.pageType,
    this.title,
    @required this.image,
    @required this.videoFile,
    this.img,
  });

  final String contentId;
  final String type;
  final String pageType;
  final String title;

  List image;
  final File videoFile;
  int videoId;
  final String img;

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  bool isDetailsShown = true,
      isCategoriesSHown = true,
      isVisibilityShown = true;

  FocusNode node = FocusNode();
  FocusNode titleNode, descriptionNode;
  ScrollController _scrollController = new ScrollController();

  TextEditingController emailCon;
  int selectedThumbnail = 0;
  int selectedThumbnailLocal = 0;
  bool details = true,
      category = false,
      visibilty = false,
      checked1 = false, // checked radio button 1
      checked2 = false,
      checked3 = false,
      titleBool = true,
      visibilityBool = true,
      descritionBool = true,
      thumbnailBool = true,
      categoryBool = true,
      subCategoryBool = true,
      playlistsBool = false,
      loading = false,
      titleErrorBool = false,
      descriptionErrorBool = false,
      videoUploading = false,
      localThumbanilSelected = false,
      videoUploaded = false;

  bool _showFab = true;
  bool removeUserProgress = false;

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
  int visibilityId, groupIndex, selectedIndex;
  double percentageUpload = 0;
  List playlistIds = [], playlistNames = [];
  TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController(),
      titleControllerPhoto = TextEditingController(),
      descriptionControllerPhoto = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();
  List<bool> categorySelected = [], subSelected = [], playlistSelected = [];
  int categoryPrevious, subPrevious, playlistPrevious;
  var selectedBackgroundImageId;

  var IsUploading = false;

  List thumbnails = [],
      categoryData = [],
      subCategoryData = [],
      playlistData = [];
  List<bool> groupSelected = [];
  List groupListIds = [];
  var groupSelectedId = '';

  List<File> imageList;
  File imageFile;
  dynamic selectedAlbumId;
  File _image;

  Dio dio = Dio();
  int totalProgressValue = 0;
  var circleLoadingPercentageValue = 0.0;
  var videoId;

  final picker = ImagePicker();
  String hintTextTitle = 'title hint';
  String hintTextDescription =
      'Short lens view of your video, tell your viewers what your video is about';

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

  createPath() async {
    final String appDir =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    // final Directory appDirFolder = Directory('$appDir/$path');
    final dir = Directory('$appDir/')
        .create(recursive: true)
        .then((value) => value.path);
    return dir;
  }

  Future<void> getCategoryId() async {
    var categoryId = await UserData().getCategoryId();

    setState(() {
      sharedParentId = categoryId;
      print("sharedIdd--$sharedParentId");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    VideoService().getMyPlaylist().then((data) {
      if (data != null) {
        setState(() {
          playlistData = data;
          List.generate(playlistData.length, (index) {
            playlistSelected.add(false);
          });
        });
      }
    });

    if (widget.type == "album") {
      PhotoService().getMyAlbumDetail(albumId: widget.contentId).then((data) {
        if (data != null) {
          setState(() {
            var icon = data[0]['icon'];
            List PhotoArray = [];
            PhotoArray.add(icon);
            widget.image = PhotoArray;
            title = data[0]['title'];
            description = data[0]['description'];
            titleControllerPhoto = TextEditingController(text: title);
            descriptionControllerPhoto =
                TextEditingController(text: description);
            var photoID = data[0]['id'];
            var group_id = data[0]["group_id"];
            visibilityId = int.parse(data[0]['visibility']);
            print("visibility Alb--$visibilityId");

            switch (visibilityId) {
              case 1:
                checked1 = false;
                checked2 = true;
                checked3 = false;
                break;

              case 2:
                checked1 = true;
                checked2 = false;
                checked3 = false;
                break;

              case 3:
                checked1 = false;
                checked2 = false;
                checked3 = true;
                break;

              default:
                break;
            }
          });
        }
      });
    } else {
      VideoService().getVideoDetails(widget.contentId).then((data) {
        if (data != null) {
          setState(() {
            var icon = data['thumbnails'][0],
                category = data['Category'],
                subCategory = data['SubCategory'];
            var playlist = data['playlists'];

            title = data['title'];
            description = data['description'];
            categoryText = data['Category'];
            subCategoryText = data['SubCategory'];
            widget.image = data['thumbnails'];

            titleController = TextEditingController(text: title);
            descriptionController = TextEditingController(text: description);

            videoId = data['id'];

            var group_id = data["group_id"];
            var playList_id = data["playlists"];

            parentId = data['category_id'];
            subCategoryId = data['subcategory_id'];
            playlistNames = data['playlists'];
            setPlaylist(playlistNames);
            visibilityId = int.parse(data['visibility']);
            print("visibility vid--$visibilityId");

            switch (visibilityId) {
              case 1:
                checked1 = false;
                checked2 = true;
                checked3 = false;
                break;

              case 2:
                checked1 = true;
                checked2 = false;
                checked3 = false;
                break;

              case 3:
                checked1 = false;
                checked2 = false;
                checked3 = true;
                break;

              default:
                break;
            }
          });
        }
      });
      VideoService().getMyCategory().then((data) {
        if (data != null) {
          setState(() {
            categoryData = data;
            List.generate(categoryData.length, (index) {
              categorySelected.add(false);
            });
          });
        }
      });
      VideoService().getMySubCategory().then((data) {
        if (data != null && data['success'] == true) {
          setState(() {
            subCategoryData = data['data'];
            List.generate(subCategoryData.length, (index) {
              subSelected.add(false);
            });
          });
        }
      });
    }
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
      setState(() {});
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

  viewData(title, data, boolData, addOn, context) {
    var height = MediaQuery.of(context).size.height;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: data.length == 0 ? 0 : height * 0.042 * data.length,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 11.0),
                    itemCount:
                        title == 'Category' ? categoryData.length : data.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // print(categoryData);
                      // print(categoryData[index]);
                      return FutureBuilder(
                        builder: (BuildContext context, snapshot) {
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                selectedIndex = index;
                              });
                              // setSelectedIndex(index);
                              if (title != 'Playlists') {
                                if (title == 'Category') {
                                  parentId = data[index]['id'];
                                  // print(parentId);
                                  categorySelected[index] = true;
                                  if (categoryPrevious != null)
                                    categorySelected[categoryPrevious] = false;
                                  categoryPrevious = index;
                                  // subSelected = [];
                                  // subCategoryData = [];
                                  // var res = await VideoService()
                                  //     .getMySubCategory(parentId: parentId);
                                  // if (res['success'] == true) {
                                  //   subCategoryData = res['data'];
                                  //   subCategoryText = '';
                                  //   subCategoryId = '';
                                  //   subCategoryBool = false;
                                  //   List.generate(subCategoryData.length,
                                  //       (index) {
                                  //     subSelected.add(false);
                                  //   });
                                  // }
                                } else {
                                  subCategoryId = data[index]['id'];
                                  subSelected[index] = true;
                                  if (subPrevious != null)
                                    subSelected[subPrevious] = false;
                                  subPrevious = index;
                                  setState(() {
                                    selectedIndex = null;
                                  });
                                }
                                setState(() {
                                  selectedIndex = null;
                                });

                                /// setting value category and sub category
                                setData(
                                    title == 'Category'
                                        ? categoryData[index]['title']
                                        : data[index]['title'],
                                    title);
                                Navigator.pop(context);
                              }
                            },
                            child: title == 'Category'
                                ? Text(
                                    categoryData[index]['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.0,
                                      color: selectedIndex == index ||
                                              categorySelected[index]
                                          ? Color(0xff5AA5EF)
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : title == 'Sub-Category'
                                    ? Text(
                                        data[index]['title'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.0,
                                          color: selectedIndex == index ||
                                                  subSelected[index]
                                              ? Color(0xff5AA5EF)
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            playlistSelected[index] =
                                                !playlistSelected[index];
                                            if (playlistSelected[index]) {
                                              playlistNames.add(
                                                  playlistData[index]['title']);
                                              playlistIds.add(
                                                  playlistData[index]['id']);
                                              setPlaylist(playlistNames);
                                            } else {
                                              playlistNames.remove(
                                                  playlistData[index]['title']);
                                              playlistIds.remove(
                                                  playlistData[index]['id']);
                                              setPlaylist(playlistNames);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 15,
                                                child: Checkbox(
                                                  value:
                                                      playlistSelected[index],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      playlistSelected[index] =
                                                          !playlistSelected[
                                                              index];
                                                      if (playlistSelected[
                                                          index]) {
                                                        playlistNames.add(
                                                            playlistData[index]
                                                                ['title']);
                                                        playlistIds.add(
                                                            playlistData[index]
                                                                ['id']);
                                                        setPlaylist(
                                                            playlistNames);
                                                      } else {
                                                        playlistNames.remove(
                                                            playlistData[index]
                                                                ['title']);
                                                        playlistIds.remove(
                                                            playlistData[index]
                                                                ['id']);
                                                        setPlaylist(
                                                            playlistNames);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                data[index]['title'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13.0,
                                                  color:
                                                      selectedIndex == index ||
                                                              playlistSelected[
                                                                  index]
                                                          ? Color(0xff5AA5EF)
                                                          : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 11.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    addData(
                        title == 'Category'
                            ? 1
                            : title == 'Sub-Category'
                                ? 2
                                : 3,
                        title,
                        context,
                        setState);
                  },
                  child: Text(
                    '$addOn',
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff5AA5EF),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
              ],
            ),
          ),
        ],
      );
    });
  }

  uploadPhotos() async {
    //uploadLoadingDialog(context);
    // List<MultipartFile> newList = new List<MultipartFile>();

    // for (var i = 0; i < imageList.length; i++) {
    //   MultipartFile imageFile = await MultipartFile.fromFile(imageList[i].path);
    //   newList.add(imageFile);
    // }

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
            // "photo_file": newList,
            "visibility": visibilityId,
            "album_id": widget.contentId,
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

          Fluttertoast.showToast(
            msg: 'Photo Published',
            textColor: Colors.black,
            backgroundColor: Colors.white,
          );
          setState(() {
            IsUploading = false;
            loading = false;
            //Navigator.pop(context);
            // videoUploaded = false;
          });
        });
      } else {
        IsUploading = false;
        Fluttertoast.showToast(msg: 'Try Again', backgroundColor: Colors.black);
      }
    } catch (e) {
      setState(() {
        IsUploading = false;
        // videoUploading = false;
      });
      // Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.black);
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

  setPlaylist(List data) {
    if (data.length != 0) {
      var text = data.reduce((value, element) => value + ',' + element);
      setState(() {
        playlistText = text;
        playlistsBool = true;
      });
    } else {
      setState(() {
        playlistText = '';
        playlistsBool = false;
      });
    }
  }

  addData(id, title, context1, setStateModal) {
    var val = '';
    int selectedBackground;
    bool loading = false;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateM) {
            return Container(
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
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New $title',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        TextField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal),
                            ),
                            labelText: 'Add',
                            suffixStyle: const TextStyle(color: Colors.green),
                          ),
                          onChanged: (value) => {val = value},
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (val.length != 0) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please wait while adding $title')));
                                setState(() {
                                  loading = true;
                                });
                                if (id == 1) {
                                  var categoryAdded = await VideoService()
                                      .addEditCategory(
                                          title: val,
                                          bgImageId: selectedBackgroundImageId);
                                  if (categoryAdded['success'] == true) {
                                    parentId =
                                        categoryAdded['category_id'].toString();
                                    // await UserData().setCategoryId(parentId);
                                    //print("categoryId--->"+parentId);

                                    var data =
                                        await VideoService().getMyCategory();
                                    setState(() {
                                      //getCategoryId();
                                      // print("catttttt---$sharedParentId");
                                      categoryText = val;
                                      categoryData = data;
                                      loading = false;
                                      categorySelected.add(false);
                                      categoryBool = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '$title: $val added successfully')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Failed to add $title')));
                                  }
                                } else if (id == 2) {
                                  var subCategoryAdded = await VideoService()
                                      .addEditSubCategory(title: val);
                                  // print(subCategoryAdded);
                                  if (subCategoryAdded['success'] == true) {
                                    subCategoryId =
                                        subCategoryAdded['subcategory_id']
                                            .toString();
                                    //print("categoryId sub--->"+subCategoryId);
                                    var res =
                                        await VideoService().getMySubCategory();
                                    // getCategoryId();
                                    // print("catttttt1---$sharedParentId");
                                    // print(data);
                                    setState(() {
                                      subCategoryText = val;
                                      subCategoryData = res['data'];
                                      subSelected.add(false);
                                      loading = false;
                                      subCategoryBool = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '$title: $val added successfully')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Failed to add $title')));
                                  }
                                } else {
                                  var addPlaylist = await VideoService()
                                      .addEditPlaylist(title: val);
                                  if (addPlaylist['success'] == true) {
                                    var data =
                                        await VideoService().getMyPlaylist();
                                    setState(() {
                                      playlistText = val;
                                      playlistsBool = true;
                                      loading = false;
                                      playlistData = data;
                                      playlistSelected.add(false);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '$title: $val added successfully')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Failed to add $title')));
                                  }
                                }
                              }
                            },
                            child: Text(
                              loading ? 'Creating...' : 'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        title == 'Category'
                            ? Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Select Background',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        title == 'Category'
                            ? Container(
                                child: FutureBuilder(
                                  future: VideoService()
                                      .getCategoryBackgroundImages(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data.length == 0
                                          ? Center(
                                              child: Text(
                                                'No Background',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              //alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 3,
                                                    crossAxisSpacing: 16,
                                                    mainAxisSpacing: 16,
                                                  ),
                                                  itemCount:
                                                      snapshot.data.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var image = snapshot
                                                        .data[index]['image'];
                                                    return InkWell(
                                                      onTap: () async {
                                                        selectedBackgroundImageId =
                                                            snapshot.data[index]
                                                                ['id'];
                                                        setStateM(() {
                                                          selectedBackground =
                                                              index;

                                                          // print("imageidd ---" +selectedBackgroundImageId);

                                                          //print("imageidd ---${selectedBackground == index}");
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        // padding:
                                                        // EdgeInsets.symmetric(
                                                        //     horizontal: 15),
// margin: EdgeInsets.only(right: 16,bottom: 16),
                                                        height: 90,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              // Color(0xff2F303D),
                                                              Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                            color: selectedBackground !=
                                                                        null &&
                                                                    selectedBackground ==
                                                                        index
                                                                ? Colors.blue
                                                                : Colors
                                                                    .transparent,
                                                            width: 3.0,
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            // image: AssetImage('images/pic.png'),

                                                            image: NetworkImage(
                                                                image),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                    } else {
                                      return CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.blue,
                                      );
                                    }
                                  },
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
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
                                          .getImage(
                                              source: ImageSource.gallery);
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
                                  child: ElevatedButton(
                              
                                    onPressed: () async {
                                      if (edit) {
                                        if (groupName != null &&
                                            groupName != '') {
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

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var titleStyle = GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: PreferredSize(
                child: Container(
                  color: Color.fromARGB(255, 194, 191, 191),
                  height: 1.0,
                ),
                preferredSize: Size.fromHeight(1.0)),
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                if (widget.pageType == "photo") {
                  navigate(context, StartWatchingScreen());
                } else {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                }
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
            titleSpacing: 0.0,
            title: Container(
              margin: EdgeInsets.only(right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.type == "album" ? "Upload Album" : "Upload Video",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.type == "album"
                          ? uploadEditPhoto()
                          : uploadEditVideo();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'UPDATE',
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: widget.type == "album"
                              ? (thumbnailBool &&
                                      titleBool &&
                                      descritionBool &&
                                      visibilityBool)
                                  ? Color(0xff5AA5EF)
                                  : Colors.grey
                              : (thumbnailBool &&
                                      titleBool &&
                                      descritionBool &&
                                      categoryBool &&
                                      subCategoryBool &&
                                      visibilityBool)
                                  ? Color(0xff5AA5EF)
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: widget.type == "album"
              ? Container(
                  child: FutureBuilder(
                    future: PhotoService()
                        .getMyAlbumDetail(albumId: widget.contentId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return IsUploading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SingleChildScrollView(
                                child: NotificationListener<
                                    UserScrollNotification>(
                                  onNotification: (notification) {
                                    final ScrollDirection direction =
                                        notification.direction;
                                    setState(() {
                                      if (direction ==
                                          ScrollDirection.reverse) {
                                        _showFab = false;
                                      } else if (direction ==
                                          ScrollDirection.forward) {
                                        _showFab = true;
                                      }
                                    });
                                    return true;
                                  },
                                  child: Container(
                                    //padding: EdgeInsets.only(left: 16, right: 16),
                                    color: Colors.white,
                                    // height: height,
                                    // width: width,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: height * 0.03),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 16, right: 16),
                                                width: width,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: localThumbanilSelected
                                                        ? FileImage(imageFile)
                                                        : NetworkImage(widget
                                                                .image[
                                                            selectedThumbnail ??
                                                                0]),
                                                    fit: BoxFit.fitHeight,
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
                                                padding: EdgeInsets.only(
                                                    top: 6.0,
                                                    left: 16.0,
                                                    right: 16.0),
                                                width: width,
                                                child: Text(
                                                  'Thumbnail',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),

                                              ///---Thumbnail liSt
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 16, right: 16),
                                                height: height * 0.13,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            getImage();
                                                          },
                                                          child: Container(
                                                            width: width * 0.26,
                                                            height:
                                                                height * 0.12,
                                                            color: Colors.grey,
                                                            child: Center(
                                                                child: Icon(
                                                              Icons.add_rounded,
                                                              size: 70.0,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              _image != null
                                                                  ? true
                                                                  : false,
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedThumbnailLocal =
                                                                    1;
                                                                selectedThumbnail =
                                                                    100;
                                                                localThumbanilSelected =
                                                                    true;
                                                                selectedThumbnailLocal =
                                                                    1;

                                                                imageFile =
                                                                    _image;
                                                              });
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: selectedThumbnailLocal ==
                                                                            1
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .transparent,
                                                                    width: 2),
                                                              ),
                                                              width:
                                                                  width * 0.25,
                                                              height:
                                                                  height * 0.14,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: 7.0,
                                                                left: 5.0,
                                                                right: 5.0,
                                                              ),
                                                              child: _image !=
                                                                      null
                                                                  ? Image.file(
                                                                      _image,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: height * 0.15,
                                                          child:
                                                              ListView.builder(
                                                            itemCount: widget
                                                                .image.length,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedThumbnail =
                                                                        index;
                                                                    selectedThumbnailLocal =
                                                                        0;
                                                                    localThumbanilSelected =
                                                                        false;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: width *
                                                                      0.25,
                                                                  height:
                                                                      height *
                                                                          0.14,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 7.0,
                                                                    left: 5.0,
                                                                    right: 5.0,
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(color: selectedThumbnail == index ? Colors.blue : Colors.transparent, width: 2),
                                                                      image: DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                          widget
                                                                              .image[index],
                                                                        ),
                                                                        fit: BoxFit
                                                                            .fill,
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
                                                  //   _scrollController.animateTo(
                                                  //       160,
                                                  //       duration:
                                                  //           const Duration(
                                                  //               milliseconds:
                                                  //                   500),
                                                  //       curve: Curves
                                                  //           .easeOut);
                                                  // }

                                                  // setState(() =>
                                                  //     isDetailsShown =
                                                  //         !isDetailsShown);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(12.0),
                                                  width: width,
                                                  color: (titleBool &&
                                                          descritionBool)
                                                      ? Color(0xff5AA5EF)
                                                      : Colors
                                                          .black, //Color(0xff5AA5EF),
                                                  child: Text(
                                                    'Details',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: height * 0.02),
                                              if (isDetailsShown) ...[
                                                // These children are only visible if condition is true
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 16),
                                                  width: width,
                                                  child: Text(
                                                    'Title',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                //----Text filed
                                                SizedBox(height: height * 0.02),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 16),
                                                  // height: height * 0.06,
                                                  child: TextFormField(
                                                    focusNode: titleNode,
                                                    controller: titleControllerPhoto
                                                      ..selection = TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  titleControllerPhoto
                                                                      .text
                                                                      .length),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          40),
                                                    ],
                                                    style:
                                                        GoogleFonts.montserrat(
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
                                                        if (val == '' ||
                                                            title == '') {
                                                          setState(() {
                                                            titleBool = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            titleBool = true;
                                                          });
                                                        }
                                                        title = val;
                                                        titleControllerPhoto =
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
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText: 'Title',
                                                      hintStyle: GoogleFonts
                                                          .montserrat(
                                                        color:
                                                            Color(0xff8E8E8E),
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xff5AA5EF),
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
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 16),
                                                  width: width,
                                                  child: Text(
                                                    'Description',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                //----Text filed
                                                SizedBox(height: height * 0.02),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 16),
                                                  // height: height * 0.06,
                                                  child: TextFormField(
                                                    focusNode: descriptionNode,
                                                    controller: descriptionControllerPhoto
                                                      ..selection = TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  descriptionControllerPhoto
                                                                      .text
                                                                      .length),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          120),
                                                    ],
                                                    style:
                                                        GoogleFonts.montserrat(
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
                                                            descritionBool =
                                                                false;
                                                            thumbnailBool =
                                                                false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            descritionBool =
                                                                true;
                                                            thumbnailBool =
                                                                true;
                                                          });
                                                        }
                                                        description = val;
                                                        descriptionControllerPhoto =
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
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          'Add Description',
                                                      hintStyle: GoogleFonts
                                                          .montserrat(
                                                        color:
                                                            Color(0xff8E8E8E),
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xff5AA5EF),
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
                                              //----Visiblity
                                              InkWell(
                                                onTap: () {
                                                  // if (!isVisibilityShown) {
                                                  //   _scrollController.animateTo(
                                                  //       250,
                                                  //       duration:
                                                  //           const Duration(
                                                  //               milliseconds:
                                                  //                   500),
                                                  //       curve: Curves
                                                  //           .easeOut);
                                                  // }
                                                  // setState(() =>
                                                  //     isVisibilityShown =
                                                  //         !isVisibilityShown);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(12.0),
                                                  width: width,
                                                  color: (checked1 ||
                                                          checked2 ||
                                                          checked3)
                                                      ? Color(0xff5AA5EF)
                                                      : Colors
                                                          .black, //Color(0xff5AA5EF),
                                                  child: Text(
                                                    'Visibility',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: height * 0.02),
                                              if (isVisibilityShown) ...[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10.0),
                                                  padding: EdgeInsets.only(
                                                    left: 13.0,
                                                    top: 16.0,
                                                    right: 10.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            visibilityId = 2;
                                                            checked2 = false;
                                                            checked1 = true;
                                                            checked3 = false;
                                                            visibilityBool =
                                                                true;
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            checkBox(
                                                                height,
                                                                width,
                                                                checked1),
                                                            Flexible(
                                                              child: Text(
                                                                'Anyone can view on Projector',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.02),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            visibilityId = 1;
                                                            checked2 = true;
                                                            checked1 = false;
                                                            checked3 = false;
                                                            visibilityBool =
                                                                true;
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            checkBox(
                                                                height,
                                                                width,
                                                                checked2),
                                                            Text(
                                                              'Only I can view',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.02),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            visibilityId = 3;
                                                            checked2 = false;
                                                            checked1 = false;
                                                            checked3 = true;
                                                            visibilityBool =
                                                                true;
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            checkBox(
                                                                height,
                                                                width,
                                                                checked3),
                                                            Text(
                                                              'Choose a group to share with',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  // final userData = new Map<String,dynamic>.from(snapshot.data);
                                                                  // _isChecked = List<bool>.filled(snapshot.data.length, false);
                                                                  return Container(
                                                                    width:
                                                                        width,
                                                                    height:
                                                                        height *
                                                                            0.15,
                                                                    padding: EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        left:
                                                                            8.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Color(0xff000000).withAlpha(29),
                                                                          blurRadius:
                                                                              6.0,
                                                                          // spreadRadius: 6.0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0,
                                                                    ),
                                                                    child:
                                                                        ListView(
                                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ListView
                                                                            .builder(
                                                                          itemCount: snapshot
                                                                              .data
                                                                              .length,
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            groupSelected.add(false);
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
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
                                                                                      height: 24.0,
                                                                                      width: 24.0,
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
                                                                                      width: 5.0,
                                                                                    ),

                                                                                    Text(
                                                                                      snapshot.data[index]['title'],
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.all(10.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              editDialog(
                                                                                context,
                                                                                height,
                                                                                width,
                                                                                true,
                                                                              ).then((value) {
                                                                                setState(() {});
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'New Group',
                                                                              style: TextStyle(
                                                                                color: Color(0xff5AA5EF),
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return Text(
                                                                      'Loading');
                                                                }
                                                              },
                                                            )
                                                          : Container(),
                                                      SizedBox(
                                                          height:
                                                              height * 0.05),
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
                                                    vertical: 20.0,
                                                    horizontal: 5.0),
                                                child: Container(
                                                  width: width,
                                                  height: 35,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        uploadEditPhoto();
                                                      },
                                                      child: Text(
                                                        'UPDATE',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            (thumbnailBool ==
                                                                        true &&
                                                                    titleBool ==
                                                                        true &&
                                                                    descritionBool ==
                                                                        true &&
                                                                    visibilityBool ==
                                                                        true)
                                                                ? Color(
                                                                    0xff5AA5EF)
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

                                              /// photo album delete
                                              InkWell(
                                                onTap: () async {
                                                  // isVideoView = false
                                                  // photo view

                                                  removeDialog(context, height,
                                                      width, false);
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Delete",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 16.0,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(height: height * 0.02),
                                            ]),
                                      ],
                                      controller: _scrollController,
                                    ),
                                  ),
                                ),
                              );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )
              : Container(
                  child: FutureBuilder(
                    ////---Show video details from content details
                    future: VideoService().getVideoDetails(widget.contentId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (IsUploading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Container(
                              // padding: EdgeInsets.only(left: 16, right: 16),
                              color: Colors.white,
                              // height: height,
                              // width: width,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: height * 0.03),
                                        //---Image view
                                        Container(
                                          width: width,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: localThumbanilSelected
                                                  ? FileImage(imageFile)
                                                  : NetworkImage(widget.image[
                                                      selectedThumbnail ?? 0]),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          // child: Card(
                                          //   color: Colors.black,
                                          // ),
                                        ),
                                        Container(),
                                        SizedBox(height: height * 0.03),
                                        //--Tumbnail
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 6, left: 16, right: 16),
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
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
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
                                                    visible: _image != null
                                                        ? true
                                                        : false,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedThumbnailLocal =
                                                              1;
                                                          selectedThumbnail =
                                                              100;
                                                          localThumbanilSelected =
                                                              true;
                                                          imageFile = _image;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: selectedThumbnailLocal ==
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
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : Container(),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.15,
                                                    child: ListView.builder(
                                                      itemCount:
                                                          widget.image.length,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedThumbnail =
                                                                  index;
                                                              selectedThumbnailLocal =
                                                                  0;
                                                              localThumbanilSelected =
                                                                  false;
                                                            });
                                                          },
                                                          child: Container(
                                                            width: width * 0.25,
                                                            height:
                                                                height * 0.14,
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 7.0,
                                                              left: 5.0,
                                                              right: 5.0,
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border: Border.all(
                                                                        color: selectedThumbnail ==
                                                                                index
                                                                            ? Colors
                                                                                .blue
                                                                            : Colors
                                                                                .transparent,
                                                                        width:
                                                                            2),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          NetworkImage(
                                                                        widget.image[
                                                                            index],
                                                                      ),
                                                                      fit: BoxFit
                                                                          .fill,
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
                                            //   _scrollController.animateTo(170,
                                            //       duration: const Duration(
                                            //           milliseconds: 500),
                                            //       curve: Curves.easeOut);
                                            // }

                                            // setState(() =>
                                            //     isDetailsShown = !isDetailsShown);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12.0),
                                            width: width,
                                            color: (titleBool && descritionBool)
                                                ? Color(0xff5AA5EF)
                                                : Colors
                                                    .black, //Color(0xff5AA5EF),
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
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
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
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            // height: height * 0.06,
                                            child: TextFormField(
                                              focusNode: titleNode,
                                              controller: titleController
                                                ..selection =
                                                    TextSelection.collapsed(
                                                        offset: titleController
                                                            .text.length),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    40),
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
                                                  if (val == '') {
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
                                                    backgroundColor:
                                                        Colors.black,
                                                    gravity:
                                                        ToastGravity.CENTER,
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
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                  color: Color(0xff8E8E8E),
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
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
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            // height: height * 0.06,
                                            child: TextFormField(
                                              focusNode: descriptionNode,
                                              controller: descriptionController
                                                ..selection =
                                                    TextSelection.collapsed(
                                                        offset:
                                                            descriptionController
                                                                .text.length),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    120),
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
                                                    backgroundColor:
                                                        Colors.black,
                                                    gravity:
                                                        ToastGravity.CENTER,
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
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                  color: Color(0xff8E8E8E),
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                        InkWell(
                                          onTap: () {
                                            // if (!isCategoriesSHown) {
                                            //   _scrollController.animateTo(500,
                                            //       duration: const Duration(
                                            //           milliseconds: 500),
                                            //       curve: Curves.easeOut);
                                            // }
                                            // setState(() => isCategoriesSHown =
                                            //     !isCategoriesSHown);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12.0),
                                            width: width,
                                            color: (categoryBool &&
                                                    subCategoryBool)
                                                ? Color(0xff5AA5EF)
                                                : Colors
                                                    .black, //Color(0xff5AA5EF),
                                            child: Text(
                                              'Categories',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height * 0.02),
                                        if (isCategoriesSHown) ...[
                                          ///--- category
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (categoryPrevious != null)
                                                  categorySelected[
                                                      categoryPrevious] = true;
                                              });

                                              /// bottom sheet for category
                                              showModalBottomSheet(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(32.0),
                                                    topRight:
                                                        Radius.circular(32.0),
                                                  ),
                                                ),
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                    return Container(
                                                      height:
                                                          categoryData.length !=
                                                                  0
                                                              ? height *
                                                                  0.3 *
                                                                  categoryData
                                                                      .length
                                                              : height * 0.15,
                                                      padding: EdgeInsets.only(
                                                        top: 11.0,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                  height: 3,
                                                                  width: 60,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            SizedBox(
                                                                height: 19),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          39.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  viewData(
                                                                    'Category',
                                                                    categoryData,
                                                                    categorySelected,
                                                                    'Add New Category',
                                                                    context,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              height: height * 0.12,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 4.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(
                                                  color: Color(0xffE8E8E8),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Category',
                                                        style: titleStyle,
                                                      ),
                                                      SizedBox(height: 4.0),
                                                      Container(
                                                        //height: height * 0.02,
                                                        width: width * 0.75,
                                                        color: Colors.white,
                                                        child: (categoryText !=
                                                                    null &&
                                                                categoryText !=
                                                                    '')
                                                            ? Text(
                                                                categoryText,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            : Text(
                                                                'Select a main category that\nyour video fits into.',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: width * 0.06,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          ///---Sub category
                                          SizedBox(height: height * 0.02),
                                          InkWell(
                                            onTap: () async {
                                              // if (parentId != null) {
                                              // if (subCategoryData.length !=
                                              //     0) {
                                              setState(() {
                                                if (subPrevious != null)
                                                  subSelected[subPrevious] =
                                                      true;
                                              });
                                              // }
                                              /// bottom sheet for sub category
                                              showModalBottomSheet(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(32.0),
                                                    topRight:
                                                        Radius.circular(32.0),
                                                  ),
                                                ),
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                    return Container(
                                                      height: subCategoryData
                                                                  .length !=
                                                              0
                                                          ? height *
                                                              0.3 *
                                                              subCategoryData
                                                                  .length
                                                          : height * 0.30,
                                                      padding: EdgeInsets.only(
                                                        top: 11.0,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            AlwaysScrollableScrollPhysics(),
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                height: 3,
                                                                width: 60,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 19),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          39.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  viewData(
                                                                    'Sub-Category',
                                                                    subCategoryData,
                                                                    subSelected,
                                                                    'Add Sub Category',
                                                                    context,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                              );
                                              // }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              height: height * 0.1,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 12.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(
                                                  color: Color(0xffE8E8E8),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Sub-Category',
                                                        style: titleStyle,
                                                      ),
                                                      SizedBox(height: 4.0),
                                                      Container(
                                                        //height: height * 0.02,
                                                        width: width * 0.75,
                                                        color: Colors.white,
                                                        child: (subCategoryText !=
                                                                    null &&
                                                                subCategoryText !=
                                                                    '')
                                                            ? Text(
                                                                subCategoryText,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            : Text(
                                                                'Better sort your video for your viewers.',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: width * 0.06,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                bottom: 20,
                                                top: 16.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xffD9D9DA),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Playlist',
                                                      style: titleStyle,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 4.0),
                                                      width: width * 0.75,
                                                      child: (playlistText !=
                                                              '')
                                                          ? Text(
                                                              playlistText,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          : Text(
                                                              'Add your video to one or more playlist.\nPlaylist’s can help your audience view\nspecial collections.',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      // print(playlistData);
                                                      setState(() {
                                                        if (playlistPrevious !=
                                                            null)
                                                          playlistSelected[
                                                                  playlistPrevious] =
                                                              true;
                                                      });
                                                      showModalBottomSheet(
                                                        context: context,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    32.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    32.0),
                                                          ),
                                                        ),
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return Container(
                                                              height: height *
                                                                      0.3 ??
                                                                  height * 0.6,
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 11.0,
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                physics:
                                                                    AlwaysScrollableScrollPhysics(),
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            3,
                                                                        width:
                                                                            60,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            19),
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              39.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          viewData(
                                                                            'Playlists',
                                                                            playlistData,
                                                                            playlistSelected,
                                                                            'Add Playlist',
                                                                            context,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 10),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 30.0,
                                                      color: Color(0xff5AA5EF),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],

                                        ///----Categories Section
                                        //----Visiblity
                                        InkWell(
                                          onTap: () {
                                            // if (!isVisibilityShown) {
                                            //   _scrollController.animateTo(780,
                                            //       duration: const Duration(
                                            //           milliseconds: 500),
                                            //       curve: Curves.easeOut);
                                            // }
                                            // setState(() => isVisibilityShown =
                                            //     !isVisibilityShown);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12.0),
                                            width: width,
                                            color: (checked1 ||
                                                    checked2 ||
                                                    checked3)
                                                ? Color(0xff5AA5EF)
                                                : Colors
                                                    .black, //Color(0xff5AA5EF),
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
                                            margin: EdgeInsets.only(left: 10.0),
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
                                                      checkBox(height, width,
                                                          checked1),
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
                                                      checkBox(height, width,
                                                          checked2),
                                                      Text(
                                                        'Only I can view',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                                      checkBox(height, width,
                                                          checked3),
                                                      Text(
                                                        'Choose a group to share with',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            // final userData = new Map<String,dynamic>.from(snapshot.data);
                                                            // _isChecked = List<bool>.filled(snapshot.data.length, false);
                                                            return Container(
                                                              width: width,
                                                              height:
                                                                  height * 0.15,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0,
                                                                      left:
                                                                          8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
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
                                                                    blurRadius:
                                                                        6.0,
                                                                    // spreadRadius: 6.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 10.0,
                                                                right: 10.0,
                                                              ),
                                                              child: ListView(
                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ListView
                                                                      .builder(
                                                                    itemCount:
                                                                        snapshot
                                                                            .data
                                                                            .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      groupSelected
                                                                          .add(
                                                                              false);
                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
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
                                                                              left: 10.0,
                                                                              right: 10.0,
                                                                              top: 10.0),
                                                                          child:
                                                                              Row(
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
                                                                                height: 24.0,
                                                                                width: 24.0,
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
                                                                                width: 5.0,
                                                                              ),

                                                                              Text(
                                                                                snapshot.data[index]['title'],
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.bold,
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
                                                                        .all(
                                                                            10.0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
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
                                                                      child:
                                                                          Text(
                                                                        'New Group',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xff5AA5EF),
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            return Text(
                                                                'Loading');
                                                          }
                                                        },
                                                      )
                                                    : Container(),
                                                SizedBox(height: height * 0.05),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                                onPressed: () {
                                                  uploadEditVideo();
                                                },
                                                child: Text(
                                                  'UPDATE',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                      (thumbnailBool == true &&
                                                              titleBool ==
                                                                  true &&
                                                              descritionBool ==
                                                                  true &&
                                                              categoryBool ==
                                                                  true &&
                                                              subCategoryBool ==
                                                                  true &&
                                                              visibilityBool ==
                                                                  true)
                                                          ? Color(0xff5AA5EF)
                                                          : Colors.black,
                                                )),
                                            color: (thumbnailBool == true &&
                                                    titleBool == true &&
                                                    descritionBool == true &&
                                                    categoryBool == true &&
                                                    subCategoryBool == true &&
                                                    visibilityBool == true)
                                                ? Color(0xff5AA5EF)
                                                : Colors.black,
                                          ),
                                        ),

                                        /// video delete
                                        InkWell(
                                          onTap: () async {
                                            // isVideoView = true
                                            // video view

                                            removeDialog(
                                                context, height, width, true);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Delete",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16.0,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        SizedBox(height: height * 0.02),
                                      ]),
                                ],
                                controller: _scrollController,
                              ),
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
        ));
  }

  uploadEditPhoto() async {
    if (thumbnailBool && titleBool && descritionBool && visibilityBool) {
      if (visibilityId == 3 && visibilityId != null) {
        if (groupListIds != null && groupListIds.length > 0) {
          // todo: upload photo api with group
          setState(() {
            IsUploading = true;
          });
          uploadPhotos();
        } else {
          // key.currentState.showSnackBar(
          //   SnackBar(
          //     content: Text('Select any group from list'),
          //   ),
          // );
        }
      } else if (visibilityId != null) {
        // todo : upload api call
        setState(() {
          IsUploading = true;
        });
        uploadPhotos();
      }

      if (imageFile != null) {
        setState(() {
          loading = true;
        });
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        String finalBase64Image = "data:image/jpeg;base64," + base64Image;
        var createAlbum = await PhotoService().addAlbum(
            title: titleControllerPhoto.text.toString(),
            description: descriptionControllerPhoto.text.toString(),
            icon: finalBase64Image,
            albumId: widget.contentId);
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
      } else {
        setState(() {
          loading = true;
        });
        var createAlbum = await PhotoService().addAlbum(
            title: titleControllerPhoto.text.toString(),
            description: descriptionControllerPhoto.text.toString(),
            albumId: widget.contentId);
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
      Fluttertoast.showToast(
        msg: 'All fields are necessary',
        textColor: Colors.white,
      );
    }
  }

  uploadEditVideo() async {
    if (thumbnailBool &&
        titleBool &&
        descritionBool &&
        categoryBool &&
        subCategoryBool &&
        visibilityBool) {
      setState(() {
        IsUploading = true;
      });
      String base64Image = '';
      if (_image != null) {
        List<int> imageBytes = _image.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      }
      var data = await VideoService().addVideoContent(
        title: title,
        description: description,
        status: 0,
        videoId: widget.contentId,
        customThumbnail: localThumbanilSelected ? base64Image : null,
        thumbnail:
            localThumbanilSelected ? null : widget.image[selectedThumbnail],
        categoryId: parentId,
        subCategoryId: subCategoryId,
        playlistId: playlistIds,
        groupId: groupListIds,
        visibility: visibilityId,
      );
      if (data['success'] == true) {
        setState(() {
          FocusScope.of(context).unfocus();
          titleErrorBool = false;
          descriptionErrorBool = false;
          category = true;
        });
        setState(() {
          IsUploading = false;
          videoUploading = false;
        });
        Navigator.of(context).pop();
        navigate(context, NewListVideo());
      } else {
        setState(() {
          IsUploading = false;
        });
        print('false');
      }
    } else {
      Fluttertoast.showToast(
        msg: 'All fields are necessary',
        textColor: Colors.white,
      );
    }
  }

  removeDialog(context, height, width, bool isVideoView) {
    return showDialog(
      context: context,
      barrierColor: Color(0xff333333).withOpacity(0.7),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: height * 0.5,
            color: Color(0xff333333).withOpacity(0.3),
            child: Dialog(
              backgroundColor: Colors.white.withOpacity(0),
              insetPadding: EdgeInsets.only(
                left: 26.0,
                right: 25.0,
                top: 60.0,
                bottom: 50.0,
              ),
              child: Container(
                //height: height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 17.0,
                                bottom: 36,
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      "Are you sure?",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(height: 24.0),
                                    Text(
                                      "Are you sure to delete this item? The process cannot be undone",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff0A112B),
                                      ),
                                    ),
                                    SizedBox(height: 36),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ButtonTheme(
                                            shape: new RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.grey[600],
                                                    width: 1.0)),
                                            child: ElevatedButton(
                                            
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Text(
                                                  "Delete",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xffFF0000),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (isVideoView == true) {
                                                  // video delete
                                                  removeUserProgress = true;
                                                  var res = await VideoService()
                                                      .deleteVideo(
                                                          videoId:
                                                              widget.contentId);

                                                  if (res['success'] == true) {
                                                    removeUserProgress = false;
                                                    navigateRemove(context,
                                                        NewListVideo());
                                                  }
                                                } else {
                                                  // album delete
                                                  removeUserProgress = true;
                                                  var res = await VideoService()
                                                      .deleteAlbum(
                                                          albumId:
                                                              widget.contentId);
                                                  if (res['success'] == true) {
                                                    removeUserProgress = false;
                                                    navigateRemove(context,
                                                        NewListVideo());
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                           
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                "Go back",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: removeUserProgress,
                        child: Positioned(
                          top: 100,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.all(5),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
