import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double dotSpacing;
  final double dotWidth;
  final double dotHeight;
  final Color dotColor;

  DottedLine({
    this.dotSpacing = 4.0,
    this.dotHeight = 2,
    this.dotWidth = 4,
    this.dotColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate how many dots fit in the available width
    final screenWidth = MediaQuery.of(context).size.width;
    final numberOfDots = (screenWidth / (dotWidth + dotSpacing)).floor();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(numberOfDots, (index) {
        return Container(
          width: dotWidth,
          height: dotHeight,
          decoration: BoxDecoration(
            color: dotColor,
          ),
        );
      }),
    );
  }
}
