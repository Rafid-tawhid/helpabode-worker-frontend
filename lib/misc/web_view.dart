// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class MyChromeSafariBrowser extends ChromeSafariBrowser {
//   @override
//   void onOpened() {
//     print("ChromeSafari browser opened");
//   }
//
//   @override
//   void onCompletedInitialLoad() {
//     print("ChromeSafari browser initial load completed");
//   }
//
//   @override
//   void onClosed() {
//     print("ChromeSafari browser closed");
//   }
// }
//
// class MyInAppBrowser extends InAppBrowser {
//   @override
//   Future onBrowserCreated() async {
//     print("Browser Created!");
//   }
//
//   @override
//   Future onLoadStart(url) async {
//     print("Started $url");
//   }
//
//   @override
//   Future onLoadStop(url) async {
//     print("Stopped $url");
//   }
//
//   // @override
//   // void onReceivedError(WebResourceRequest request, WebResourceError error) {
//   //   print("Can't load ${request.url}.. Error: ${error.description}");
//   // }
//
//   @override
//   void onProgressChanged(progress) {
//     print("Progress: $progress");
//   }
//
//   @override
//   void onExit() {
//     print("Browser closed!");
//   }
// }
