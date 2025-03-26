import 'package:flutter/material.dart';

class ReversedTrianglePainter extends CustomPainter {
  int index;
  int selectedIndex;
  ReversedTrianglePainter(this.index, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = index == selectedIndex ? Colors.white : Color(0xFF1A9562)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = index == selectedIndex ? Colors.white : Color(0xFF1A9562)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
