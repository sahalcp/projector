import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoToast {
  /// Show Snackbar info for user with a message
  static showSnackBar(BuildContext context, {String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
