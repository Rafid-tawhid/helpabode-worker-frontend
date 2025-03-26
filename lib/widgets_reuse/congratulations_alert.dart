import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';

import '../auth/auth_screen.dart';

class CongratulationsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/svg/congo.svg'),
            SizedBox(height: 20.0),
            Text(
              'Congratulations !',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Verification Complete! Your provider account has been successfully verified.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            CustomMaterialButton(
              label: 'Login',
              buttonColor: myColors.green,
              fontColor: Colors.white,
              funcName: () {
                //set to login screen

                // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationHandlerScreen4()));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                // Navigator.pop(context);
              },
              borderRadius: 40,
            )
          ],
        ),
      ),
    );
  }
}
