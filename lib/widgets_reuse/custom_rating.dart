import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRating extends StatelessWidget {
  CustomRating(
      {required this.tempRating,
      required this.thresholdRating,
      required this.onTap});

  int tempRating;
  int thresholdRating;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          'assets/svg/grey_star_2.svg',
          color: tempRating >= thresholdRating
              ? Color(0XFFFECD04)
              : Color(0XFFD5CFCF),
        ));
  }
}
