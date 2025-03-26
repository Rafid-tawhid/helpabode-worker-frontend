import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';

Future<ui.Image> createTextImage(String text,
    {double fontSize = 60, Color textColor = Colors.black}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final textStyle = TextStyle(
    color: textColor,
    fontSize: fontSize,
  );
  final textSpan = TextSpan(
    text: text,
    style: textStyle,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();
  final offset = Offset(0, 0);
  textPainter.paint(canvas, offset);

  final picture = recorder.endRecording();
  return picture.toImage(textPainter.width.ceil(), textPainter.height.ceil());
}

Future<Uint8List> convertImageToBytes(ui.Image image) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

Future<ImageProvider> textToImageProvider(String text,
    {double fontSize = 60, Color textColor = Colors.black}) async {
  final image =
      await createTextImage(text, fontSize: fontSize, textColor: textColor);
  final bytes = await convertImageToBytes(image);
  return MemoryImage(bytes);
}
