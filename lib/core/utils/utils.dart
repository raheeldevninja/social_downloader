import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class Utils {

  static void showCustomSnackBar(
      BuildContext context, String message, ContentType contentType) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Social Downloader',
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

}