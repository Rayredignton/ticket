import 'package:flutter/material.dart';
import 'package:ticket/app.dart';

class Utils{
  static showAppBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder, bool? isScrollControlled, Function? onThen,}) {
    showModalBottomSheet(context: navigatorKey.currentContext!, enableDrag: false, isDismissible: true, builder: builder, backgroundColor: Colors.transparent, isScrollControlled: isScrollControlled ?? false)
        .then((value) {
      if (onThen != null) {
        onThen();
      }
    });
  }

}