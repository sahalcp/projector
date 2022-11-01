import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoExpanded extends StatelessWidget {
  final width;
  final height;
  const LogoExpanded({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/logoName.svg",
            height: height ?? 60,
            // fit: BoxFit.fit,
          ),
        ],
      ),
    );
  }
}
