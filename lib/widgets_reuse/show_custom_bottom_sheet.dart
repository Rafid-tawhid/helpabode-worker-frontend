import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:provider/provider.dart';

import '../helper_functions/colors.dart';

void showCustomBottomSheet(
  BuildContext context, {
  required String message,
  required String button1Text,
  required VoidCallback button1Function,
  required String button2Text,
  required VoidCallback button2Function,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Consumer<AddNewServiceProvider>(
        builder: (context, provider, _) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 36,
                      color: Color(0xffc40606),
                    ),
                    SizedBox(height: 4),
                    Text('Duplicate Zipcode',
                        textAlign: TextAlign.center,
                        style: interText(22, Colors.black, FontWeight.w600)),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(message,
                    textAlign: TextAlign.left,
                    style: interText(14, Colors.black, FontWeight.w400)),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: button1Function,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: myColors.greyBtn,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              button1Text,
                              style:
                                  interText(16, Colors.black, FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: button2Function,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: provider.showLoadingZipUpdateBtn
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    button2Text,
                                    style: interText(
                                        16, Colors.white, FontWeight.w600),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      );
    },
  );
}
