import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomCircularTabDay extends StatelessWidget {
  const CustomCircularTabDay({
    super.key,
    required this.flagDay,
    required this.day,
    required this.onTap,
  });

  final String flagDay;
  final String day;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: flagDay == day ? buttonClr : Colors.white,
        foregroundColor: flagDay == day ? Colors.white : Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(day.substring(0, 3)),
        ),
      ),
    );
  }
}
