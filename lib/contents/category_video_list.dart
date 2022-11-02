import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import 'contentDetailsScreen.dart';

class CategoryVideoList extends StatefulWidget {
  final String userId;
  final dynamic categoryData;

  CategoryVideoList({Key key, this.userId, this.categoryData})
      : super(key: key);

  @override
  State<CategoryVideoList> createState() => _CategoryVideoListState();
}

class _CategoryVideoListState extends State<CategoryVideoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBgColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appBgColor,
              gradient: RadialGradient(
                radius: 0.5,
                center: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 0, 30, 71),
                  appBgColor,
                ],
              ),
            ),
          ),
          ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            children: [
              _categoryTile(context),
              SizedBox(height: 56.0),
              _videoList(context),
            ],
          ),
        ],
      ),
    );
  }

  _categoryTile(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
        height: screenSize.height * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.white,
            width: 3.0,
          ),
          image: DecorationImage(
            image: NetworkImage(widget.categoryData['icon']),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            widget.categoryData['title'],
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  _videoList(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double videoHeight = screenSize.height * 0.11;
    double tabVideoHeight = screenSize.height * 0.16;
    return Sizer(
      builder: (context, orientation, deviceType) {
        return FutureBuilder(
            future: VideoService()
                .getCategoryDetail(widget.userId, widget.categoryData['id']),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An error occured.\nPlease try again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                return snapshot.data.length == 0
                    ? Center(
                        child: Text(
                          'No Videos',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              deviceType == DeviceType.mobile ? 2 : 3,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: snapshot.data['videos'].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var title = snapshot.data['videos'][index]['title'];
                          var subCategory =
                              snapshot.data['videos'][index]['SubCategory'];

                          var image =
                              snapshot.data['videos'][index]['thumbnails'];
                          return InkWell(
                            onTap: () {
                              navigate(
                                context,
                                ContentDetailScreen(
                                  videoId: snapshot.data['videos'][index]['id'],
                                ),
                              );
                            },
                            child: Container(
                              width: screenSize.width,
                              margin: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: deviceType == DeviceType.mobile
                                        ? videoHeight
                                        : tabVideoHeight,
                                    width: screenSize.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image(
                                          image: NetworkImage(image),
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          subCategory ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize:
                                                deviceType == DeviceType.mobile
                                                    ? 7
                                                    : 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      title ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 11
                                                : 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
      },
    );
  }
}
