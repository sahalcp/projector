import 'package:flutter/material.dart';
import 'package:projector/apis/contentDashboardService.dart';

class LayoutProvider extends ChangeNotifier {
  LayoutProvider();

  /// Whether the page is in busy state
  bool isBusy = true;

  /// Error message if exists
  String errorMessage;

  /// Speed of the slideshow
  int slideshowSpeed;

  /// Slideshow transition
  String slideshowTransition;

  /// Whether the slideshow settings was updated or not. Defaults to false.
  bool isSettingsUpdated = false;

  void initialize() async {
    try {
      final settings = await ContentDashboardService().getSlideshowSettings();

      if (settings != null) {
        slideshowSpeed = int.tryParse(settings["transition_speed"]);
        slideshowTransition = settings["transition_type"];
        errorMessage = settings["error"];
      }

      isBusy = false;

      notifyListeners();
    } catch (e) {
      isBusy = false;
      errorMessage = "Error occured while initializing layout";
      print("$errorMessage: ${e.toString()}");
      notifyListeners();
    }
  }

  void updateSlideshowSpeed({bool isAddition = true}) {
    if (isAddition) {
      if (slideshowSpeed < 99) slideshowSpeed++;
    } else {
      if (slideshowSpeed > 4) slideshowSpeed--;
    }
    isSettingsUpdated = true;
    notifyListeners();
  }

  void updateSlideshowTransition(String val) {
    slideshowTransition = val;
    isSettingsUpdated = true;
    notifyListeners();
  }

  Future<bool> saveSlideshowSettings() async {
    final result = await ContentDashboardService().saveSlideshowSettings(
        slideshowSpeed: slideshowSpeed,
        slideshowTransition: slideshowTransition);

    if (result) {
      isSettingsUpdated = false;
      notifyListeners();
    }

    return result;
  }
}
