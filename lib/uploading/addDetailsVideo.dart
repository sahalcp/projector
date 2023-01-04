import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
// import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

import '../widgets/widgets.dart';

class AddDetailsScreen extends StatefulWidget {
  AddDetailsScreen({
    @required this.image,
    @required this.videoFile,
    this.videoId,
  });

  final List image;
  final File videoFile;
  final int videoId;

  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  int selectedThumbnail;
  int selectedThumbnailLocal = 0;
  bool details = true,
      category = false,
      visibilty = false,
      checked1 = false, // checked radio button 1
      checked2 = false,
      checked3 = false,
      titleBool = false,
      descritionBool = false,
      thumbnailBool = false,
      categoryBool = false,
      subCategoryBool = false,
      playlistsBool = false,
      loading = false,
      titleErrorBool = false,
      descriptionErrorBool = false,
      videoUploading = false,
      videoUploaded = false;
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
      descriptionController = TextEditingController();
  FocusNode titleNode, descriptionNode;
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();
  List<bool> categorySelected = [], subSelected = [], playlistSelected = [];
  int categoryPrevious, subPrevious, playlistPrevious;
  var selectedBackgroundImageId;

  // List playlists = ['Playlist 1', 'Playlist 2'];
  List thumbnails = [],
      categoryData = [],
      subCategoryData = [],
      playlistData = [];
  List<bool> groupSelected = [];
  List groupListIds = [];
  var groupSelectedId = '';

  File _image;
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
    //setState(() {
    // widget.image.forEach((img) {
    //   thumbnails.add(File(img));print(thumbnails);
    // });
    //});

    /* if (descriptionNode != null) {
      descriptionNode.addListener(() {
        if (descriptionNode.hasFocus) {
          hintTextDescription = '';
        } else {
          hintTextDescription = 'Short lens view of your video, tell your viewers what your video is about';
        }
      });
    }*/

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
    titleNode.requestFocus();
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
      });
    } else {
      setState(() {
        playlistText = '';
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
                                    });
                                    Navigator.pop(context);
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
                                    });
                                    Navigator.pop(context);
                                  }
                                } else {
                                  var addPlaylist = await VideoService()
                                      .addEditPlaylist(title: val);
                                  if (addPlaylist['success'] == true) {
                                    var data =
                                        await VideoService().getMyPlaylist();
                                    setState(() {
                                      loading = false;
                                      playlistData = data;
                                      playlistSelected.add(false);
                                    });
                                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var titleStyle = GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
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
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
            ),
            titleSpacing: 0.0,
            title: Text(
              "Upload Video",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          key: key,
          body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ModalProgressHUD(
              inAsyncCall: loading,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            visibilty
                                ? 'Visibility'
                                : category
                                    ? 'Category'
                                    : 'Details',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.018),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: thumbnailBool
                                      ? Color(0xff5AA5EF)
                                      : descritionBool
                                          ? Color(0xff9BC7F2)
                                          : titleBool
                                              ? Color(0xff707070)
                                              : Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: playlistSelected.contains(true)
                                      ? Color(0xff5AA5EF)
                                      : subCategoryBool
                                          ? Color(0xff9BC7F2)
                                          : categoryBool
                                              ? Color(0xffBDD9F5)
                                              : category
                                                  ? Colors.white
                                                  : Color(0xff707070),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: checked1 || checked2 || checked3
                                      ? Color(0xff5AA5EF)
                                      : visibilty
                                          ? Colors.white
                                          : Color(0xff707070),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.03),
                        Container(
                          height: height * 0.68,
                          margin: EdgeInsets.only(
                            left: 4.0,
                            right: 2.0,
                          ),
                          child: !category
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 26.0,
                                        bottom: 15.0,
                                        left: 9.0,
                                        right: 7.0,
                                      ),
                                      height: height * 0.4,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 13.0),
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Container(
                                            //height: height * 0.1,
                                            height: 100,
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: titleNode.hasFocus
                                                    ? Colors.blue
                                                    : Color(0xffE8E8E8),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Title",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),

                                                Align(
                                                  alignment: Alignment.center,
                                                  child: TextField(
                                                    controller: titleController
                                                      ..selection = TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  titleController
                                                                      .text
                                                                      .length),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          40),
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    focusNode: titleNode,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),

                                                    onChanged: (val) {
                                                      if (val.length < 40) {
                                                        setState(() {
                                                          titleBool = true;
                                                        });

                                                        title = val;
                                                        titleController =
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

                                                    //maxLength: 40,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      hintText:
                                                          'Create title for your photo',
                                                      hintMaxLines: 3,
                                                      hintStyle: TextStyle(
                                                        color:
                                                            Color(0xff9F9E9E),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                )

                                                /*Visibility(
                                                  visible: titleErrorBool,
                                                  child: Center(
                                                    child: Text(
                                                      titleError,
                                                      style: TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.red,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),*/

                                                // Center(
                                                //   child: Text(
                                                //     'Create title for your video',
                                                //     style: TextStyle(
                                                //       fontSize: 12.0,
                                                //       color: Color(0xff9F9E9E),
                                                //       fontWeight: FontWeight.w400,
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Container(
                                            height: height * 0.2,
                                            width: width,
                                            padding:
                                                EdgeInsets.only(bottom: 14.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: descriptionNode.hasFocus
                                                    ? Colors.blue
                                                    : Color(0xffE8E8E8),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Description",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: TextField(
                                                    controller: descriptionController
                                                      ..selection = TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  descriptionController
                                                                      .text
                                                                      .length),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          120),
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    focusNode: descriptionNode,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),

                                                    onChanged: (val) {
                                                      if (val.length < 120) {
                                                        setState(() {
                                                          descritionBool = true;
                                                          thumbnailBool = true;
                                                        });

                                                        description = val;
                                                        descriptionController =
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

                                                    // keyboardType: TextInputType.name,
                                                    // textInputAction: TextInputAction.done,
                                                    // maxLength: 40,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      hintText:
                                                          'Short lens view of your album, tell your viewers what your album is about',
                                                      hintMaxLines: 3,
                                                      hintStyle: TextStyle(
                                                        color:
                                                            Color(0xff9F9E9E),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                )

                                                /*Visibility(
                                                  visible: descriptionErrorBool,
                                                  child: Center(
                                                    child: Text(
                                                      descriptionError,
                                                      style: TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.red,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),*/

                                                // Text(
                                                //   'Share what your video is about',
                                                //   style: TextStyle(
                                                //     fontSize: 12.0,
                                                //     color: Color(0xff9F9E9E),
                                                //     fontWeight: FontWeight.w400,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height * 0.05),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'Thumbnail',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // Row(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
/*Container(
  height: height * 0.15,
  child: Row(
      children: [
        InkWell(
          onTap: (){
getImage();
          },
          child: Container(
            width: width * 0.25,
            height: height * 0.14,
            color: Colors.grey,
child: Center(
  child:  Icon(
      Icons.add_rounded,
      size: 70.0,
      color: Colors.white,
    )
),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          width: width * 0.25,
          height: height * 0.14,
          margin: EdgeInsets.only(
            top: 7.0,
            left: 5.0,
            right: 5.0,
          ),
           child: _image != null ? Image.file(_image,fit: BoxFit.fill,) : Container(),
        ),
      ],
  ),
),*/

                                    Container(
                                      height: height * 0.15,
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
                                                  width: width * 0.25,
                                                  height: height * 0.14,
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
                                                      selectedThumbnail = -1;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
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
                                                            fit: BoxFit.fill,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: selectedThumbnail ==
                                                                      index
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .transparent,
                                                              width: 2),

                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              widget
                                                                  .image[index],
                                                            ),
                                                            fit: BoxFit.fill,
                                                          ),

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
                                  ],
                                )
                              : !visibilty
                                  ? Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 16.0,
                                            top: 13.0,
                                            right: 15.0,
                                          ),
                                          width: width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Categories',
                                                style: TextStyle(
                                                  color: Color(0xff585858),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'This section is Required in order to proceed',
                                                style: TextStyle(
                                                  color: Color(0xffB9B8B8),
                                                  fontSize: 8.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(height: height * 0.015),
                                              Container(
                                                height: height * 0.12,
                                                padding: EdgeInsets.only(
                                                  top: 13.0,
                                                  left: 11.0,
                                                  // bottom: 11.0,
                                                  right: 15.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  border: Border.all(
                                                    color: Color(0xffE8E8E8),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Category',
                                                      style: titleStyle,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Visibility(
                                                          visible:
                                                              categoryText != ''
                                                                  ? false
                                                                  : true,
                                                          child: Text(
                                                            'Select a main category that\nyour video fits into.',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            // categorySelected = [];
                                                            // List.generate(
                                                            //     cat.length,
                                                            //     (index) {
                                                            //   categorySelected
                                                            //       .add(false);
                                                            // });
                                                            setState(() {
                                                              if (categoryPrevious !=
                                                                  null)
                                                                categorySelected[
                                                                        categoryPrevious] =
                                                                    true;
                                                            });

                                                            /// bottom sheet for category
                                                            showModalBottomSheet(
                                                              context: context,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          32.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          32.0),
                                                                ),
                                                              ),
                                                              builder:
                                                                  (context) {
                                                                return StatefulBuilder(builder:
                                                                    (BuildContext
                                                                            context,
                                                                        StateSetter
                                                                            setState) {
                                                                  return Container(
                                                                    height: categoryData.length !=
                                                                            0
                                                                        ? height *
                                                                            0.3 *
                                                                            categoryData
                                                                                .length
                                                                        : height *
                                                                            0.15,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: 11.0,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Center(
                                                                          child: Container(
                                                                              height: 3,
                                                                              width: 60,
                                                                              color: Colors.black),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                19),
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(left: 39.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                  );
                                                                });
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            width: width * 0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 16.0,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    categoryText != ''
                                                        ? Container(
                                                            height:
                                                                height * 0.02,
                                                            width: width * 0.25,
                                                            color: Color(
                                                                0xff5AA5EF),
                                                            child: Center(
                                                              child: Text(
                                                                categoryText,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
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
                                                          height: subCategoryData
                                                                      .length !=
                                                                  0
                                                              ? height *
                                                                  0.3 *
                                                                  subCategoryData
                                                                      .length
                                                              : height * 0.30,
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 11.0,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Center(
                                                                child:
                                                                    Container(
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
                                                        );
                                                      });
                                                    },
                                                  );
                                                  // }
                                                },
                                                child: Container(
                                                  height: height * 0.1,
                                                  padding: EdgeInsets.only(
                                                    top: 13.0,
                                                    left: 11.0,
                                                    // bottom: 11.0,
                                                    right: 15.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    border: Border.all(
                                                      color: Color(0xffE8E8E8),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Sub-Category',
                                                        style: titleStyle,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Visibility(
                                                            visible:
                                                                subCategoryText !=
                                                                        ''
                                                                    ? false
                                                                    : true,
                                                            child: Text(
                                                              'Better sort your video for your viewers.',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: width * 0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 16.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      subCategoryText != ''
                                                          ? Container(
                                                              height:
                                                                  height * 0.02,
                                                              width:
                                                                  width * 0.25,
                                                              color: Color(
                                                                  0xff5AA5EF),
                                                              child: Center(
                                                                child: Text(
                                                                  subCategoryText,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xffD9D9DA),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                padding: EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Playlist',
                                                      style: titleStyle,
                                                    ),
                                                    Text(
                                                      'Add your video to one or more playlist.\nPlaylist’s can help your audience view\nspecial collections.',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.013),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            playlistText,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
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
                                                                context:
                                                                    context,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            32.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            32.0),
                                                                  ),
                                                                ),
                                                                builder:
                                                                    (context) {
                                                                  return StatefulBuilder(builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return Container(
                                                                      height: height *
                                                                              0.3 ??
                                                                          height *
                                                                              0.6,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top:
                                                                            11.0,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                Container(
                                                                              height: 3,
                                                                              width: 60,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 19),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.only(left: 39.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                viewData(
                                                                                  'Playlists',
                                                                                  playlistData,
                                                                                  playlistSelected,
                                                                                  'Add Playlist',
                                                                                  context,
                                                                                ),
                                                                                SizedBox(height: 10),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                                                },
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 30.0,
                                                              color: Color(
                                                                  0xff5AA5EF),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
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
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Visibility',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Choose when to publish and who can see your video.',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: height * 0.07),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    visibilityId = 2;
                                                    checked2 = false;
                                                    checked1 = true;
                                                    checked3 = false;
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    checkBox(height, width,
                                                        checked1),
                                                    Flexible(
                                                      child: Text(
                                                        'Anyone can view on My Projector account',
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
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    checkBox(height, width,
                                                        checked2),
                                                    Text(
                                                      'Only I can View (Private)',
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
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          // final userData = new Map<String,dynamic>.from(snapshot.data);
                                                          // _isChecked = List<bool>.filled(snapshot.data.length, false);
                                                          return Container(
                                                            width: width,
                                                            height:
                                                                height * 0.15,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 8.0,
                                                                    left: 8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                                            margin:
                                                                EdgeInsets.only(
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
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0),
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
                                    ),
                        ),
                        // videoUploaded
                        //     ? Center(
                        //         child: Container(
                        //           height: height * 0.1,
                        //           child: LottieBuilder.asset('images/Success.json'),
                        //         ),
                        //       )
                        //     : videoUploading && videoId == null
                        //         ? LottieBuilder.asset('images/Loader.json')
                        //         :
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (visibilty)
                                    setState(() {
                                      // checked3 = checked2 = checked1 = false;
                                      visibilty = false;
                                    });
                                  else if (category)
                                    setState(() {
                                      category = false;
                                    });
                                  else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 7),
                                  height: height * 0.065,
                                  // width: width * 0.44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color:
                                          Color(0xff5AA5EF).withOpacity(0.46),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Previous',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (category) {
                                    if (visibilty) {
                                      // print(visibilityId);
                                      // print(groupId);
                                      if (visibilityId == 3 &&
                                          visibilityId != null) {
                                        if (groupListIds != null &&
                                            groupListIds.length > 0) {
                                          setState(() {
                                            loading = true;
                                          });
                                          // var playlistId = playlistIds.reduce(
                                          //     (value, element) =>
                                          //         value + ',' + element);

                                          if (groupListIds.length != 0) {
                                            groupSelectedId = groupListIds
                                                .reduce((value, element) =>
                                                    value + ',' + element);
                                          }

                                          await VideoService().addVideoContent(
                                            // videoFile: widget.videoFile,
                                            videoId: widget.videoId,
                                            categoryId: parentId,
                                            playlistId: playlistId,
                                            visibility: visibilityId,
                                            groupId: groupSelectedId,
                                            status: 1,
                                          );
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.of(context).pop();
                                          // todo setUserStarted
                                          /// group click page
                                          // await UserData().setUserStarted();

                                          navigate(context, NewListVideo());

                                          /* Navigator.of(context).push(
                                          CupertinoPageRoute<Null>(
                                            builder: (BuildContext context) {
                                              return EditVideo(
                                                videoId: widget.videoId,
                                                title: title,
                                                desc: description,
                                                cat: categoryText,
                                                subCat: subCategoryText,
                                                img: widget.image[0],
                                                status: '1',
                                                categoryId: parentId,
                                                subCatId: subCategoryId,
                                                playlistIds: playlistIds,
                                                groupId: groupSelectedId,
                                                visibility: visibilityId,
                                              );
                                            },
                                          ),
                                        );*/
                                        } else {
                                          // key.currentState.showSnackBar(
                                          //   SnackBar(
                                          //     content: Text(
                                          //         'Select any group from list'),
                                          //   ),
                                          // );
                                        }
                                      } else if (visibilityId != null) {
                                        setState(() {
                                          loading = true;
                                        });
                                        await VideoService().addVideoContent(
                                          // videoFile: widget.videoFile,
                                          videoId: widget.videoId,
                                          categoryId: parentId,
                                          // playlistId: playlistId,
                                          visibility: visibilityId,
                                          status: 1,
                                        );
                                        // Future.delayed(Duration(seconds: 1), () {
                                        setState(() {
                                          loading = false;
                                        });
                                        // todo setUserStarted
                                        //await UserData().setUserStarted();
                                        Navigator.of(context).pop();

                                        navigate(context, NewListVideo());

                                        /*Navigator.of(context).push(
                                        CupertinoPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return EditVideo(
                                              videoId: widget.videoId,
                                              title: title,
                                              desc: description,
                                              cat: categoryText,
                                              subCat: subCategoryText,
                                              img: null,
                                              status: '1',
                                              categoryId: parentId,
                                              subCatId: subCategoryId,
                                              playlistIds: playlistIds,
                                              groupId: groupSelectedId,
                                              visibility: visibilityId,
                                              // categoryId: ca,
                                            );
                                          },
                                        ),
                                      );*/

                                      }
                                      // navigate(context, );
                                      // editDialog(context, height, width);
                                    } else if (parentId != null ||
                                        sharedParentId != null &&
                                            subPrevious != null) {
                                      setState(() {
                                        videoUploading = true;
                                      });
                                      var playlistId = '';
                                      if (playlistIds.length != 0) {
                                        playlistId = playlistIds.reduce(
                                            (value, element) =>
                                                value + ',' + element);
                                      }
                                      await VideoService().addVideoContent(
                                        videoId: widget.videoId,
                                        categoryId: parentId,
                                        subCategoryId: subCategoryId,
                                        playlistId: playlistId,
                                        status: 0,
                                      );
                                      setState(() {
                                        videoUploading = false;
                                        visibilty = true;
                                      });
                                    } else {
                                      // key.currentState.showSnackBar(
                                      //   SnackBar(
                                      //     content:
                                      //         Text('All fields are necessary'),
                                      //   ),
                                      // );
                                    }
                                  } else if (details) {
                                    if (title.length > 40) {
                                      setState(() {
                                        titleErrorBool = true;
                                      });
                                    } else if (description.length > 120) {
                                      setState(() {
                                        descriptionErrorBool = true;
                                      });
                                    } else if (title.length == 0 &&
                                        description.length == 0) {
                                      // key.currentState.showSnackBar(
                                      //   SnackBar(
                                      //     content: Text(
                                      //         'Title and Description cannot be empty'),
                                      //   ),
                                      // );
                                    } else if (selectedThumbnail == null) {
                                      // key.currentState.showSnackBar(
                                      //   SnackBar(
                                      //     content: Text(
                                      //         'Add one thumbnail for video'),
                                      //   ),
                                      // );
                                    } else {
                                      setState(() {
                                        videoUploading = true;
                                      });
                                      // var images = [];

                                      //  print(widget.image[selectedThumbnail]);

                                      /// clicked thumbnail from local file
                                      if (selectedThumbnailLocal == 1) {
                                        List<int> imageBytes =
                                            _image.readAsBytesSync();
                                        String base64Image =
                                            base64Encode(imageBytes);
                                        String finalBase64Image =
                                            "data:image/jpeg;base64," +
                                                base64Image;

                                        var data = await VideoService()
                                            .addVideoContent(
                                          title: title,
                                          description: description,
                                          status: 0,
                                          videoId: widget.videoId,
                                          //thumbnail: widget.image[selectedThumbnail],
                                          customThumbnail: base64Image,
                                        );
                                        // }
                                        if (data['success'] == true) {
                                          // if (videoId == null) {
                                          //   Future.delayed(Duration(seconds: 3), () {
                                          //     setState(() {
                                          //       videoUploaded = false;
                                          //       category = true;
                                          //     });
                                          //   });
                                          // } else {
                                          // setState(() {
                                          //   videoUploaded = false;
                                          //   category = true;
                                          // });
                                          // }
                                          setState(() {
                                            // videoId = data['video_id'];
                                            FocusScope.of(context).unfocus();
                                            titleErrorBool = false;
                                            descriptionErrorBool = false;
                                            category = true;
                                          });
                                          // });
                                        }
                                        setState(() {
                                          videoUploading = false;
                                        });
                                      }

                                      /// clicked thumbnail from api call
                                      else if (selectedThumbnail != null) {
                                        var data = await VideoService()
                                            .addVideoContent(
                                          title: title,
                                          description: description,
                                          status: 0,
                                          videoId: widget.videoId,
                                          thumbnail:
                                              widget.image[selectedThumbnail],
                                          //customThumbnail: base64Image,
                                        );
                                        // }
                                        if (data['success'] == true) {
                                          // if (videoId == null) {
                                          //   Future.delayed(Duration(seconds: 3), () {
                                          //     setState(() {
                                          //       videoUploaded = false;
                                          //       category = true;
                                          //     });
                                          //   });
                                          // } else {
                                          // setState(() {
                                          //   videoUploaded = false;
                                          //   category = true;
                                          // });
                                          // }
                                          setState(() {
                                            // videoId = data['video_id'];
                                            FocusScope.of(context).unfocus();
                                            titleErrorBool = false;
                                            descriptionErrorBool = false;
                                            category = true;
                                          });
                                          // });
                                        }
                                        setState(() {
                                          videoUploading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 7.0),
                                  height: height * 0.065,
                                  // width: 161,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: Color(0xff5AA5EF),
                                        width: visibilty ? 2 : 0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      videoUploading
                                          ? 'Uploading'
                                          : visibilty
                                              ? 'Publish'
                                              : 'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

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
