import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/signUpWebViewScreen.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class GuideScreens extends StatefulWidget {
  @override
  State createState() => new GuideScreensState();
}

class GuideScreensState extends State<GuideScreens> {
  final _controller = new PageController();
  VideoPlayerController _videoPlayerController;
  bool isLastPage = false;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4')
      ..initialize().then((_) {
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);

        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Widget customPageView() => PageView(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _controller,
        onPageChanged: (index) {
          if (index == 2) {
            setState(() {
              isLastPage = true;
            });
          } else {
            setState(() {
              isLastPage = false;
            });
          }
        },
        children: [
          guideScreen1Data(),
          guideScreen2Data(),
          guideScreen3Data(),
        ],
      );

  Widget pageingIndicator() => Positioned(
        bottom: 25.0,
        left: 0.0,
        right: 0.0,
        child: Column(
          children: [
            new Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(20.0),
              child: new Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    radius: 4.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.white,
                  ),
                ),
              ),
            ),
            loginButton(),
          ],
        ),
      );

  Widget loginButton() => InkWell(
        onTap: () {
          navigateToLogin();
        },
        child: Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff5AA5EF),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'SIGN UP OR LOG IN',
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );

  Widget guideScreen1Data() => Container(
        margin: EdgeInsets.only(bottom: 100),
        // color: Color(0xff1A1C22),
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: 0.4,
          colors: [Colors.grey.shade600, Color(0xff1A1C22)],
        )),
        child: Stack(
          children: [
            SizedBox(
              height: 10,
            ),
            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "WELCOME",
                  style: GoogleFonts.montserrat(
                    fontSize: 38.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'images/guide_screen1.png',
                height: 300,
                width: 300,
              ),
            ),

            /* Positioned(
          bottom: 300.0,
          left: 0.0,
          right: 0.0,
          child: Image.asset(
            'images/guide_screen5.png',
            height: 300,
            width: 300,
          ),
        ),*/

            //     /* Positioned(
            //   bottom: 50.0,
            //   left: 0.0,
            //   right: 0.0,
            //   child: Image.asset(
            //     'images/guide_screen_gradient.png',
            //     height: 800,
            //     width: 800,
            //   ),
            // ),*/

            Positioned(
              bottom: 100.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Its time to ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "start building ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "your",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "very own ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "streaming app",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "!",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget guideScreen2Data() => Container(
        margin: EdgeInsets.only(bottom: 100),
        // color: Color(0xff1A1C22),
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: 0.4,
          colors: [Colors.grey.shade600, Color(0xff1A1C22)],
        )),
        child: Stack(
          children: [
            SizedBox(
              height: 10,
            ),
            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "UPLOAD",
                  style: GoogleFonts.montserrat(
                    fontSize: 38.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'images/guide_screen2.png',
                height: 200,
                width: 200,
              ),
            ),
            Positioned(
              bottom: 100.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "All of your ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "videos and photos ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "from your phone or computer ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "www.projector.app",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget guideScreen3Data() => Container(
        margin: EdgeInsets.only(bottom: 100),
        // color: Color(0xff1A1C22),
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: 0.5,
          colors: [Colors.grey.shade600, Color(0xff1A1C22)],
        )),
        child: Stack(
          children: [
            SizedBox(
              height: 10,
            ),
            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "ENJOY",
                  style: GoogleFonts.montserrat(
                    fontSize: 38.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 150),
              child: Center(
                child: Image.asset(
                  'images/guide_screen3.png',
                  height: 350,
                  width: 350,
                ),
              ),
            ),
            Positioned(
              bottom: 100.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Stream your memories ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "on the ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "big screen with the ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Projector ",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                        Text(
                          "TV Apps",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff1A1C22),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'images/newLogoText.png',
            height: 50,
            width: 100,
          ),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          SizedBox.expand(
              child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: _videoPlayerController.value.size?.width ?? 0,
              height: _videoPlayerController.value.size?.height ?? 0,
              child: VideoPlayer(_videoPlayerController),
            ),
          )),
          Positioned(
            top: 30.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "WELCOME",
                style: GoogleFonts.montserrat(
                  fontSize: 38.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Its time to ",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                        //textAlign: TextAlign.center,
                      ),
                      Text(
                        "start building ",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                        //textAlign: TextAlign.center,
                      ),
                      Text(
                        "your",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "very own ",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                        //textAlign: TextAlign.center,
                      ),
                      Text(
                        "streaming app",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                        //textAlign: TextAlign.center,
                      ),
                      Text(
                        "!",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(bottom: 20.0, right: 0.0, left: 0.0, child: loginButton()),
        ],
      ),
    );
  }

  void navigateToLogin() async {
    navigateReplace(context, SignUpWebViewScreen());
  }
}
