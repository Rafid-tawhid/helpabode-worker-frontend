import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class ConfirmBottomSheet extends StatelessWidget {
  String message;
  String? message2;
  Widget icon;
  String btn1;
  Function() btn1Fun;
  Function() btn2Fun;
  String btn2;

  ConfirmBottomSheet(
      {required this.message,
      required this.icon,
      required this.btn1,
      required this.btn2,
      required this.btn1Fun,
      required this.btn2Fun,
      this.message2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon, // Relevant icon
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: interText(18, Colors.black, FontWeight.w500)
                  .copyWith(letterSpacing: 0),
            ),
          ),
          if (message2 != null)
            Text(
              message2.toString(),
              style: TextStyle(fontSize: 18),
            ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: btn2Fun,
                    style: ElevatedButton.styleFrom(
                        elevation: 0, backgroundColor: Color(0xffe9e9e9)),
                    child: Text(btn2,
                        style: interText(16, Colors.black, FontWeight.w600)),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: btn1Fun,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: myColors.green, elevation: 0),
                    child: Text(btn1,
                        style: interText(16, Colors.white, FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
