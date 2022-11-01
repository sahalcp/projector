import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/photoService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/uploading/selectFileMainScreen.dart';
import 'package:projector/widgets/widgets.dart';

class SummaryScreenVideo extends StatefulWidget {
  SummaryScreenVideo({ this.contentId,this.type,this.pageType});
  final String contentId;
  final String type;
  final String pageType;

  @override
  _SummaryScreenVideoState createState() => _SummaryScreenVideoState();
}

class _SummaryScreenVideoState extends State<SummaryScreenVideo> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {

              if(widget.pageType =="photo"){
                navigate(context, StartWatchingScreen());
              }else{
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
          title: Text(
          widget.type =="album"?  "Album Detail": "Video Detail",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: widget.type == "album" ?Container(
          child: FutureBuilder(
            future: PhotoService().getMyAlbumDetail(albumId: widget.contentId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length == 0
                    ? Container()
                    : Container(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var title = snapshot.data[index]['title'];
                              var description =
                                  snapshot.data[index]['description'];
                              var icon = snapshot.data[index]['icon'];

                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height * 0.03),
                                    Container(
                                      width: width,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(icon),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: height * 0.05),
                                          Text(
                                            "Title",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Text(
                                            title != null ? title : "",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.03),
                                          Text(
                                            "Description",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Text(
                                            description != null
                                                ? description
                                                : "",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ): Container(
          child: FutureBuilder(
            future: VideoService().getVideoDetails(widget.contentId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var icon = snapshot.data['thumbnails'][0],
                    title = snapshot.data['title'],
                    description = snapshot.data['description'],
                    category = snapshot.data['Category'],
                    subCategory = snapshot.data['SubCategory'];
                var playlist = snapshot.data['playlists'];

                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03),
                      Container(
                        width: width,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(icon),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 16.0, right: 16.0),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.05),
                            Text(
                              "Title",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              title != null ? title : "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              "Description",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              description != null
                                  ? description
                                  : "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              "Category",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              category != null
                                  ? category
                                  : "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              "SubCategory",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              subCategory != null
                                  ? subCategory
                                  : "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              playlist != null && playlist.length>0
                                  ? "Playlist"
                                  : "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              playlist != null && playlist.length>0
                                  ? playlist[0].toString()
                                  : "",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
