
  DateTime buttonClickedTime;

  bool isSingleClick(DateTime currentTime) {
    if (buttonClickedTime == null) {
      buttonClickedTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(buttonClickedTime).inSeconds}');
    if (currentTime.difference(buttonClickedTime).inSeconds < 3) {
      //set this difference time in seconds
      return true;
    }

    buttonClickedTime = currentTime;
    return false;
  }

