import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color activeTrackColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.white,
    this.activeTrackColor = Colors.black,
    this.inactiveThumbColor = Colors.white,
    this.inactiveTrackColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        width: 60,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? activeTrackColor : inactiveTrackColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? activeColor : inactiveThumbColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
