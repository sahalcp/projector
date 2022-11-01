import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcaseWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final GlobalKey globalKey;

  const CustomShowcaseWidget({
    this.title,
    @required this.description,
    @required this.child,
    @required this.globalKey,
  });

  @override
  Widget build(BuildContext context) => Showcase(
    key: globalKey,
    showcaseBackgroundColor: Colors.white,
    contentPadding: EdgeInsets.all(12),
    showArrow: false,
    disableAnimation: false,
     title: title,
     titleTextStyle: TextStyle(color: Colors.blue,
         fontWeight: FontWeight.w600,
         fontSize: 18),
    description: description,
    descTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
    // overlayColor: Colors.white,
    // overlayOpacity: 0.7,
    child: child,
  );
}