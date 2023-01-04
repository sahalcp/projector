import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/cacheService.dart';
import 'package:projector/widgets/info_toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

import '../bgUpload/backgroundUploader.dart';
import '../widgets/widgets.dart';
import 'paymentVideoPage.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({
    this.image,
    this.videoFile,
    this.videoId,
  });

  final List image;
  final File videoFile;
  final int videoId;

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _UploadScreenState extends State<UploadScreen> {
  bool isDetailsShown = true,
      isCategoriesSHown = true,
      isVisibilityShown = true;

  FocusNode node = FocusNode();
  FocusNode titleNode, descriptionNode;
  ScrollController _scrollController = new ScrollController();

  TextEditingController emailCon;
  int selectedThumbnail = 0;
  int selectedThumbnailLocal = 0;
  // int selectedThumbnailList = 0;
  // int selectedThumbnailListLocal = 0;
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
      titleErrorBool = false,
      descriptionErrorBool = false,
      videoUploading = false,
      localThumbanilSelected = false,
      videoUploaded = false;

  int selectedGeneratedThumbnailLocal = 1;
  bool localGeneratedThumbanilSelected = true;

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
  // Default visibility option set to Public
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

  List thumbnails = [],
      categoryData = [],
      subCategoryData = [],
      playlistData = [];
  List<bool> groupSelected = [];
  List groupListIds = [];
  var groupSelectedId = '';

  var IsvideoUploading = false;
  File _image;
  final picker = ImagePicker();
  String hintTextTitle = 'title hint';
  String hintTextDescription =
      'Short lens view of your video, tell your viewers what your video is about';

  Uint8List videoThumbnailByte;

  _getVideoThumbnail() async {
    videoThumbnailByte = await VideoThumbnail.thumbnailData(
      video: widget.videoFile.path,
      imageFormat: ImageFormat.JPEG,
    );
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

  bgUploadVideo({videoId}) async {
    var token = await UserData().getUserToken();

    _prepareMediaUploadListener();
    String taskId = await BackgroundUploader.videoUploadEnqueue(
      file: widget.videoFile,
      token: token,
      videoId: videoId,
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
    _getVideoThumbnail();

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
      return Container(
        // height: height * 0.6,
        child: Column(
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
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff5AA5EF),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: data.length == 0 ? 0 : height * 0.04 * data.length,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 11.0),
                      itemCount: title == 'Category'
                          ? categoryData.length
                          : data.length,
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
                                      categorySelected[categoryPrevious] =
                                          false;
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
                                                    playlistData[index]
                                                        ['title']);
                                                playlistIds.add(
                                                    playlistData[index]['id']);
                                                setPlaylist(playlistNames);
                                              } else {
                                                playlistNames.remove(
                                                    playlistData[index]
                                                        ['title']);
                                                playlistIds.remove(
                                                    playlistData[index]['id']);
                                                setPlaylist(playlistNames);
                                              }
                                            });
                                          },
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
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 11.0),
                  // add new category clickk

                  // SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      );
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
                                      playlistIds.add(playlistData.last['id']);
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
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        title == 'Category'
                            ? Container(
                                height: 200,
                                child: SingleChildScrollView(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                        child: FutureBuilder(
                                          future: VideoService()
                                              .getCategoryBackgroundImages(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return snapshot.data.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Background',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                            crossAxisSpacing:
                                                                16,
                                                            mainAxisSpacing: 16,
                                                          ),
                                                          itemCount: snapshot
                                                              .data.length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var image = snapshot
                                                                    .data[index]
                                                                ['image'];
                                                            return InkWell(
                                                              onTap: () async {
                                                                selectedBackgroundImageId =
                                                                    snapshot.data[
                                                                            index]
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
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
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
                                                                      Colors
                                                                          .grey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  border: Border
                                                                      .all(
                                                                    color: selectedBackground !=
                                                                                null &&
                                                                            selectedBackground ==
                                                                                index
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .transparent,
                                                                    width: 3.0,
                                                                  ),
                                                                  image:
                                                                      DecorationImage(
                                                                    // image: AssetImage('images/pic.png'),

                                                                    image: NetworkImage(
                                                                        image),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Center(
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      margin: EdgeInsets.all(5),
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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

  @override
  Widget build(BuildContext context) {
    final dataKey = new GlobalKey();
    const duration = Duration(milliseconds: 300);
    var titleStyle = GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      left: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          bottom: PreferredSize(
              child: Container(
                color: Color.fromARGB(255, 219, 218, 218),
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
          title: Text(
            'Upload Video ',
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: (circleLoading)
              ? Icon(Icons.hourglass_top)
              : Icon(Icons.file_upload),
          label: (circleLoading) ? Text("WAIT") : Text("PUBLISH"),
          foregroundColor: Colors.black,
          backgroundColor: (thumbnailBool &&
                  titleBool &&
                  descritionBool &&
                  categoryBool &&
                  subCategoryBool &&
                  visibilityBool)
              ? Color(0xff5AA5EF)
              : Colors.grey,
          onPressed: () async {
            if (circleLoading) return;

            if (thumbnailBool &&
                    titleBool &&
                    descritionBool &&
                    categoryBool &&
                    subCategoryBool &&
                    visibilityBool
                // selectedThumbnailList !=0 ||
                // selectedThumbnailListLocal !=0
                ) {
              String base64Image = '';
              if (_image != null) {
                List<int> imageBytes = _image.readAsBytesSync();
                base64Image = base64Encode(imageBytes);
              }

              if (videoThumbnailByte != null &&
                  localGeneratedThumbanilSelected == true) {
                base64Image = base64Encode(videoThumbnailByte);
              }

              setState(() {
                circleLoading = true;
              });

              //   customThumbnail:
              //   localThumbanilSelected
              //       ? base64Image
              //       : null,
              // thumbnail: localThumbanilSelected
              // ? null
              //     : widget
              //     .image[selectedThumbnail],

              /// video upload
              var data = await VideoService().addVideoContent(
                title: title.toString(),
                description: description,
                status: 0,
                videoId: widget.videoId,
                customThumbnail: base64Image,
                thumbnail: null,
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
                  circleLoading = false;
                });
                setState(() {
                  videoUploading = false;
                });

                var videoId = data['video_id'];

                UserData().setVideoId(videoId);

                final userDetails = await AccountService().getProfile();
                final uploadCount = userDetails['totalContentUploaded'];

                Navigator.of(context).pop();

                if (uploadCount != null) {
                  navigate(
                      context,
                      PaymentVideoPage(
                          videoId: videoId.toString(),
                          uploadCount: uploadCount));
                } else {
                  /// bgUpload video
                  bgUploadVideo(videoId: videoId);
                  print('videoidupload----->$videoId');
                  final promoSkipCount =
                      await CacheService().readIntFromCache("promoSkipCount");

                  navigate(
                      context,
                      NewListVideo(
                          videoId: videoId.toString(),
                          promoSkipCount: promoSkipCount));
                }
              } else {
                print('false');
              }

              setState(() {
                circleLoading = false;
              });
            } else {
              InfoToast.showSnackBar(context,
                  message: 'Please enter the required fields');
            }
          },
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: IsvideoUploading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: NotificationListener<UserScrollNotification>(
                    child: Container(
                      //padding: EdgeInsets.only(left: 16, right: 16),
                      color: Colors.white,
                      //  height: height,
                      // width: width,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.03),
                                //---Image view banner
                                /*  Container(
                                  width: width,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.image[selectedThumbnail ?? 0]),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  // child: Card(
                                  //   color: Colors.black,
                                  // ),
                                ),*/

                                // SizedBox(height: height * 0.03),
                                //--Thumbnail
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 6.0, left: 16.0, right: 16.0),
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
                                  padding: EdgeInsets.only(left: 16, right: 16),
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
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedThumbnailLocal = 0;
                                                selectedGeneratedThumbnailLocal =
                                                    1;
                                                selectedThumbnail = 0;
                                                localThumbanilSelected = false;
                                                localGeneratedThumbanilSelected =
                                                    true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        selectedGeneratedThumbnailLocal ==
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
                                              child: videoThumbnailByte != null
                                                  ? Image.memory(
                                                      videoThumbnailByte,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Container(),
                                            ),
                                          ),

                                          Visibility(
                                            visible:
                                                _image != null ? true : false,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedThumbnailLocal = 1;
                                                  selectedThumbnail = 0;
                                                  localThumbanilSelected = true;
                                                  // selectedThumbnailList = 0;
                                                  // selectedThumbnailListLocal = 1;
                                                  selectedGeneratedThumbnailLocal =
                                                      0;
                                                  localGeneratedThumbanilSelected =
                                                      false;
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

                                          /// thumbnail list

                                          /*  Container(
                                            height: height * 0.15,
                                            child: ListView.builder(
                                              itemCount: widget.image.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedThumbnail = index;
                                                      print("selectedThumbnail--->$selectedThumbnail");
                                                      selectedThumbnailLocal =
                                                          0;
                                                      localThumbanilSelected =
                                                          false;
                                                      // selectedThumbnailList = 1;
                                                      // selectedThumbnailListLocal = 0;
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
                                                                ? selectedThumbnailLocal == 1 ? Colors.transparent :Colors.blue
                                                                : Colors
                                                                    .transparent,
                                                            width: 2),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            widget.image[index],
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
                                          ),*/
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
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
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
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
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
                                              TextEditingController(text: val);
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
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    // padding: EdgeInsets.all(6.0),
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
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
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
                                              TextEditingController(text: val);
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
                                InkWell(
                                  onTap: () {
                                    // if (!isCategoriesSHown) {
                                    //   _scrollController.animateTo(500,
                                    //       duration: const Duration(milliseconds: 500),
                                    //       curve: Curves.easeOut);
                                    // }
                                    // setState(
                                    //     () => isCategoriesSHown = !isCategoriesSHown);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    width: width,
                                    color: (categoryBool && subCategoryBool)
                                        ? Color(0xff5AA5EF)
                                        : Colors.black, //Color(0xff5AA5EF),
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
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (categoryPrevious != null)
                                          categorySelected[categoryPrevious] =
                                              true;
                                      });

                                      /// bottom sheet for category
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32.0),
                                            topRight: Radius.circular(32.0),
                                          ),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Container(
                                              height: categoryData.length != 0
                                                  ? height *
                                                      0.3 *
                                                      categoryData.length
                                                  : height * 0.15,
                                              padding: EdgeInsets.only(
                                                top: 11.0,
                                              ),
                                              child: SingleChildScrollView(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                          height: 3,
                                                          width: 60,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(height: 19),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 39.0),
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
                                                          SizedBox(height: 10),
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
                                          horizontal: 12.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: Color(0xffE8E8E8),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                child: (categoryText != '')
                                                    ? Text(
                                                        categoryText,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    : Text(
                                                        'Select a main category that\nyour video fits into.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                  //---Sub category
                                  SizedBox(height: height * 0.02),
                                  InkWell(
                                    onTap: () async {
                                      // if (parentId != null) {
                                      // if (subCategoryData.length !=
                                      //     0) {
                                      setState(() {
                                        if (subPrevious != null)
                                          subSelected[subPrevious] = true;
                                      });
                                      // }
                                      /// bottom sheet for sub category
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32.0),
                                            topRight: Radius.circular(32.0),
                                          ),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Container(
                                              height:
                                                  subCategoryData.length != 0
                                                      ? height *
                                                          0.3 *
                                                          subCategoryData.length
                                                      : height * 0.30,
                                              padding: EdgeInsets.only(
                                                top: 11.0,
                                              ),
                                              child: SingleChildScrollView(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        height: 3,
                                                        width: 60,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 19),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 39.0),
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
                                                          SizedBox(height: 10),
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
                                          vertical: 4.0, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: Color(0xffE8E8E8),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                child: (subCategoryText != '')
                                                    ? Text(
                                                        subCategoryText,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    : Text(
                                                        'Better sort your video for your viewers.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Playlist',
                                              style: titleStyle,
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(top: 4.0),
                                              width: width * 0.75,
                                              child: (playlistText != '')
                                                  ? Text(
                                                      playlistText,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  : Text(
                                                      'Add your video to one or more playlist.\nPlaylist’s can help your audience view\nspecial collections.',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                            )
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {
                                              // print(playlistData);
                                              setState(() {
                                                if (playlistPrevious != null)
                                                  playlistSelected[
                                                      playlistPrevious] = true;
                                              });
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
                                                      height: height * 0.3 ??
                                                          height * 0.6,
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
                                                                    'Playlists',
                                                                    playlistData,
                                                                    playlistSelected,
                                                                    'Add Playlist',
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
                                    margin: EdgeInsets.only(left: 10.0),
                                    padding: EdgeInsets.only(
                                      left: 13.0,
                                      top: 16.0,
                                      right: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
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
                                              checkBox(height, width, checked1),
                                              Flexible(
                                                child: Text(
                                                  'Anyone can view on Projector',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
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
                                              checkBox(height, width, checked2),
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
                                              checkBox(height, width, checked3),
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
                                                      padding: EdgeInsets.only(
                                                          top: 8.0, left: 8.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                    0xff000000)
                                                                .withAlpha(29),
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
                                                            itemCount: snapshot
                                                                .data.length,
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
                                                            margin:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                editDialog(
                                                                  context,
                                                                  height,
                                                                  width,
                                                                  true,
                                                                ).then((value) {
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
                              ]),
                        ],
                        controller: _scrollController,
                      ),
                    ),
                  ),
                ),
        ),
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
  String email = '', groupName = '', groupStatusMsg = '';
  bool groupStatus = true;
  List users = [];
  List ids = [];
  List<Map<String, String>> selectedUser = [];
  File image;

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
                                child: ElevatedButton(
                        
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
