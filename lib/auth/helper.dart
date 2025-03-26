import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper_functions/colors.dart';
import 'anim.dart';
import 'navigate.dart';

showLog(message) {
  log("APP SAYS: $message");
}

class Helper {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static toScreen(context, screen) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => screen));
  }

  static void nextScreenCloseOthersAnimation(context, page) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        ((route) => false));
  }

  static List<BoxShadow> softUiShadow = [
    const BoxShadow(
      color: Colors.white,
      offset: Offset(-5, -5),
      spreadRadius: 1,
      blurRadius: 15,
    ),
    BoxShadow(
      color: const Color(0XFF748CAC).withOpacity(.6),
      offset: const Offset(5, 5),
      spreadRadius: 1,
      blurRadius: 15,
    ),
  ];

  static back(context) {
    Navigator.pop(context);
  }

//  static void nextScreenCloseOthers(context, page) {
//   Navigator.pushAndRemoveUntil(
//       context, MaterialPageRoute(builder: (context) => page), (route) => false);
// }

  static void nextScreenCloseOthers(context, page) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  static toReplacementScreenSlideRightToLeft(screen) {
    Navigator.pushReplacement(
        navigatorKey.currentState!.context, SlideRightToLeft(page: screen));
  }

  static toReplacementScreenSlideLeftToRight(screen) {
    Navigator.pushReplacement(
        navigatorKey.currentState!.context, SlideLeftToRight(page: screen));
  }

  static toRemoveUntilScreen(screen) {
    Navigator.pushAndRemoveUntil(navigatorKey.currentState!.context,
        SlideRightToLeft(page: screen), (route) => false);
  }

  static onWillPop(screen) {
    Navigator.pushAndRemoveUntil(navigatorKey.currentState!.context,
        SlideRightToLeft(page: screen), (route) => false);
  }

  static showSnack(context, message,
      {color = colorPrimaryLight, duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 14)),
        backgroundColor: color,
        duration: Duration(seconds: duration)));
  }

  static circularProgress(context) {
    const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(colorPrimaryLight)));
  }

  static boxDecoration(Color color, double radius) {
    BoxDecoration(
        color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  static void nextScreeniOS(context, page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  static void openBottomSheet(
      {required BuildContext context,
      required page,
      bool? isDismissible,
      bool? isDragable}) {
    // AppConstant.hideNavBar(true, context);
    showModalBottomSheet(
      isDismissible: isDismissible ?? true,
      enableDrag: isDragable ?? false,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
        maxHeight: MediaQuery.of(context).size.height * .93,
      ),
      context: context,
      builder: (context) => page,
    );
  }

  static void customBottomDialog(
      {required BuildContext context,
      num? heightRatio,
      required Widget child}) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
        maxHeight: heightRatio != null
            ? MediaQuery.of(context).size.height * heightRatio
            : MediaQuery.of(context).size.height * 0.95,
      ),
      builder: (BuildContext context) => child,
    );
  }

// static void openCupertinoBottomSheet(context, page) {
//   // Navigator.of(context).push(
//   CupertinoBottomSheetRoute(
//     args: const CupertinoBottomSheetRouteArgs(
//       swipeSettings: SwipeSettings(
//         canCloseBySwipe: true,
//       ),
//     ),
//     builder: (context) {
//       return page;
//     },
//   );
//   // );
// }
}
