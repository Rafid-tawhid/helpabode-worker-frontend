import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../provider/network_provider.dart';

void ShowNoNetworkDialoge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset('assets/png/logos.png'),
              SizedBox(
                height: 40,
              ),
              Text(
                'No Connection',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'No internet connection found check your\nconnection or try again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Consumer<InternetProvider>(
                builder: (context, provider, _) => InkWell(
                  onTap: () async {
                    provider.setNetworkLoading(true);
                    Connectivity().onConnectivityChanged.listen((results) {
                      bool hasInternet = results.isNotEmpty &&
                          results.any((r) => r != ConnectivityResult.none);
                      if (hasInternet) {
                        Navigator.pop(context);
                      }
                    });
                    await Future.delayed(Duration(seconds: 2));
                    provider.setNetworkLoading(false);
                  },
                  child: Container(
                    width: 150,
                    height: 44,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: ShapeDecoration(
                      color: Color(0xFF008951),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        provider.isNetLoading
                            ? Container(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          'Refresh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      });
}

// Future<bool> isNetworkAvailable() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile ||
//       connectivityResult == ConnectivityResult.wifi) {
//     return true;
//   } else {
//     return false;
//   }
// }
