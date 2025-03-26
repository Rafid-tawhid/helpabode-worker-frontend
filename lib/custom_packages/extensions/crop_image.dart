import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

import '../inside_line/mask_for_camera_view_inside_line.dart';
import '../mask_for_camera_view_result.dart';
import 'flutter_to_image_rect.dart';

Future<MaskForCameraViewResult> cropImage(Image image,
    {required ui.Rect flutterBoxRect,
    required ui.Size desiredSize,
    MaskForCameraViewInsideLine? insideLine}) async {
  ui.Rect imageRect = flutterToImageRect(flutterBoxRect, image);

  Image croppedImage = copyCrop(image,
      x: imageRect.left.toInt(),
      y: imageRect.top.toInt(),
      width: imageRect.width.toInt(),
      height: imageRect.height.toInt());

  Image resizedImage =
      copyResize(croppedImage, width: desiredSize.width.toInt());

  List<int> resizedList = encodeJpg(resizedImage);
  Uint8List resizedBytes = Uint8List.fromList(resizedList);

  MaskForCameraViewResult res =
      MaskForCameraViewResult(croppedImage: resizedBytes);

  if (insideLine != null) {
    MaskForCameraViewResult halfRes = await _cropHalfImage(
        croppedImage, insideLine,
        desiredSize: desiredSize);
    res.copyFrom(halfRes);
  }
  return res;
}

Future<MaskForCameraViewResult> _cropHalfImage(
    Image image, MaskForCameraViewInsideLine insideLine,
    {required ui.Size desiredSize}) async {
  double x;
  double y;
  double w;
  double h;

  if (insideLine.direction == null ||
      insideLine.direction == MaskForCameraViewInsideLineDirection.horizontal) {
    y = 0;
    x = 0;
    w = image.width.toDouble();
    h = (image.height / 10) * _position(insideLine.position);
  } else {
    y = 0;
    x = 0;
    w = (image.width / 10) * _position(insideLine.position);
    h = image.height.toDouble();
  }
  Image firstCroppedImage = copyCrop(image,
      x: x.toInt(), y: y.toInt(), width: w.toInt(), height: h.toInt());

  Image resizedfirstCroppedImage =
      copyResize(firstCroppedImage, width: desiredSize.width.toInt());

  List<int> resizedfirstCroppedList = encodeJpg(resizedfirstCroppedImage);
  Uint8List resizedfirstCroppedBytes =
      Uint8List.fromList(resizedfirstCroppedList);

  if (insideLine.direction == null ||
      insideLine.direction == MaskForCameraViewInsideLineDirection.horizontal) {
    y = (image.height / 10) * _position(insideLine.position);
    x = 0;
    w = image.width.toDouble();
    h = image.height - y;
  } else {
    y = 0;
    x = (image.width / 10) * _position(insideLine.position);
    w = image.width - x;
    h = image.height.toDouble();
  }

  Image secondCroppedImage = copyCrop(image,
      x: x.toInt(), y: y.toInt(), width: w.toInt(), height: h.toInt());

  Image resizedsecondCroppedImage =
      copyResize(secondCroppedImage, width: desiredSize.width.toInt());

  List<int> resizedsecondCroppedList = encodeJpg(resizedsecondCroppedImage);
  Uint8List resizedsecondCroppedBytes =
      Uint8List.fromList(resizedsecondCroppedList);

  MaskForCameraViewResult res = MaskForCameraViewResult(
      firstPartImage: resizedfirstCroppedBytes,
      secondPartImage: resizedsecondCroppedBytes);

  return res;
}

int _position(MaskForCameraViewInsideLinePosition? position) {
  int p = 5;
  if (position != null) {
    p = position.index + 1;
  }
  return p;
}
