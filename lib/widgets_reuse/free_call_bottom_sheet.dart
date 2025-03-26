import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';

import '../../misc/constants.dart';
import '../models/corporate_team_member_model.dart';

class CallSupportScreen extends StatelessWidget {
  TeamMemberModel? model;

  CallSupportScreen({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 24),
                width: 24,
                height: 4,
                decoration: ShapeDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            Text(
              model == null
                  ? 'Prefer to talk? Give us a call and speak directly with a support agent.'
                  : 'Prefer to talk ${model!.firstName} ?',
              style: interText(18, Colors.black, FontWeight.w600)
                  .copyWith(letterSpacing: 0),
            ),
            SizedBox(height: 24),
            if (model == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Not calling from +1 765 238 9008',
                    style: interText(16, Color(0xff636366), FontWeight.w400),
                  ),
                  Text(
                    'Edit',
                    style: interText(16, myColors.green, FontWeight.w500),
                  ),
                ],
              ),
            if (model == null) SizedBox(height: 20),
            InkWell(
              onTap: () {
                DashboardHelpers.makePhoneCall(
                    model == null ? '+16283337630' : '+${model!.phone}');
              },
              child: Container(
                width: 388,
                height: 48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                decoration: ShapeDecoration(
                  color: Color(0xFF008951),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      model == null ? '+16283337630' : '${model!.phone}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      ConfirmationBottomSheet(phoneNumber: '+16283337630'),
                );
              },
              child: Container(
                width: 388,
                height: 48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                decoration: ShapeDecoration(
                  color: Color(0xFFE9E9E9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Icon(Icons.call),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Free Call',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Carrier rates may apply',
              style: interText(14, Color(0xff636366), FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmationBottomSheet extends StatelessWidget {
  final String phoneNumber;

  ConfirmationBottomSheet({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                width: 24,
                height: 4,
                decoration: ShapeDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            Text(
              'Are you sure you want to call Support?',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff636366)),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 24),
            Text(
              'Calling: $phoneNumber',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  DashboardHelpers.showAlert(msg: 'Need to configure');
                  // Close the BottomSheet
                  // Add logic to initiate the call here
                },
                child: Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: myColors.green,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the BottomSheet
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  elevation: 0),
            ),
          ],
        ),
      ),
    );
  }
}
