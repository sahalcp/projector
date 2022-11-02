import 'package:flutter/material.dart';
import 'package:projector/widgets/info_toast.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/contentDashboard/layout/layout_provider.dart';

class SlideshowSettings extends StatelessWidget {
  SlideshowSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
          padding: EdgeInsets.all(20.0),
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Slide Show Settings',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              _settingItems(context),
            ],
          )),
    );
  }

  _settingItems(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final provider = context.watch<LayoutProvider>();

    if (provider.errorMessage != null) {
      return Center(
        child: Text(provider.errorMessage),
      );
    }

    if (provider.slideshowSpeed != null &&
        provider.slideshowTransition != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Slideshow Speed",
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      provider.updateSlideshowSpeed(isAddition: false);
                    },
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    "${provider.slideshowSpeed}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      provider.updateSlideshowSpeed(isAddition: true);
                    },
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.transform_rounded,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Slideshow Transition",
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              DropdownButton(
                  value: provider.slideshowTransition,
                  isDense: true,
                  items: _getDropdownItems()
                      .map((e) => DropdownMenuItem(
                          value: e['value'],
                          child: Text(
                            e['title'],
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          )))
                      .toList(),
                  onChanged: (val) {
                    provider.updateSlideshowTransition(val);
                  })
            ],
          ),
          SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: (provider.isSettingsUpdated)
                      ? Colors.blue
                      : Color(0xffa7a4a4)),
              child: Text('Update',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
              onPressed: () async {
                if (!provider.isSettingsUpdated) return;

                if (await provider.saveSlideshowSettings()) {
                  InfoToast.showSnackBar(context,
                      message: "Settings updated successfully");
                } else {
                  InfoToast.showSnackBar(context,
                      message:
                          "Error updating slideshow settings. Please try again.");
                }
              },
            ),
          )
        ],
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Map<String, String>> _getDropdownItems() => [
        {"title": "Fade In", "value": "fadeIn"},
        {"title": "Spinner", "value": "spinner"},
        {"title": "Move Down", "value": "moveDown"},
        {"title": "Move Up", "value": "moveUp"},
        {"title": "Move Right", "value": "moveLeftToRight"},
        {"title": "Move Left", "value": "moveRightToLeft"},
        {"title": "Slide In", "value": "slideIn"}
      ];
}
