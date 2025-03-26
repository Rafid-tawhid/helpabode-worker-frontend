import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';

class PreferedHeader extends StatelessWidget {
  const PreferedHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 2,
          offset: Offset(0, 3),
          spreadRadius: 0,
        )
        // BoxShadow(
        //   color: Colors.black.withOpacity(0.1),
        //   spreadRadius: 0,
        //   blurRadius: 2,
        //   offset: Offset(0, 2), // This creates a bottom shadow
        // ),
      ]),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Preferred Service Areas',
                    style: textField_16_black_bold_LabelTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularStepProgressIndicator(
                    totalSteps: 3,
                    currentStep: 2,
                    stepSize: 5,
                    selectedColor: myColors.green,
                    width: 60.h,
                    removeRoundedCapExtraAngle: true,
                    height: 60.h,
                    roundedCap: (_, isSelected) => isSelected,
                  ),
                  const Text(
                    '2/3',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
