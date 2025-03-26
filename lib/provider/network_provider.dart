import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../widgets_reuse/network_dialoge.dart';

class InternetProvider extends ChangeNotifier {
  bool _isConnected = true;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  bool get isConnected => _isConnected;

  void startListening(BuildContext context) {
    _checkInternet(context);
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      bool hasInternet = results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);
      if (!hasInternet) {
        ShowNoNetworkDialoge(context);
        //_showNoInternetDialog(context);
      }
      _isConnected = hasInternet;
      notifyListeners();
    });
  }

  Future<void> _checkInternet(BuildContext context) async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    bool hasInternet =
        result.isNotEmpty && result.any((r) => r != ConnectivityResult.none);
    _isConnected = hasInternet;
    if (!hasInternet) {
      //  _showNoInternetDialog(context);
      ShowNoNetworkDialoge(context);
    }
    notifyListeners();
  }

  // void _showNoInternetDialog(BuildContext context) {
  //   if (!_dialogShowing) {
  //     _dialogShowing = true;
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => AlertDialog(
  //         title: Text("No Internet"),
  //         content: Text("You are not connected to the internet. Please check your connection."),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _dialogShowing = false;
  //             },
  //             child: Text("OK"),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  void _dismissDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool _isNetLoading = false;
  bool get isNetLoading => _isNetLoading;

  void setNetworkLoading(bool bool) {
    _isNetLoading = bool;
    notifyListeners();
  }
}
