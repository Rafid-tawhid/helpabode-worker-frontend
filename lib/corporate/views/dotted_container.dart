import 'package:flutter/material.dart';

class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double dashWidth;
  final double dashGap;

  DottedBorderContainer({
    required this.child,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.5,
    this.borderRadius = 6.0,
    this.dashWidth = 8.0,
    this.dashGap = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
        borderColor: borderColor,
        borderWidth: borderWidth,
        borderRadius: borderRadius,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white),
        padding: EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double dashWidth;
  final double dashGap;

  DottedBorderPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final metrics = path.computeMetrics().first;
    double distance = 0.0;

    while (distance < metrics.length) {
      final start =
          metrics.getTangentForOffset(distance)?.position ?? Offset.zero;
      final end =
          metrics.getTangentForOffset(distance + dashWidth)?.position ?? start;
      canvas.drawLine(start, end, paint);
      distance += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(DottedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
