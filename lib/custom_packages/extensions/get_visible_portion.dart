import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:image/image.dart';

import 'flutter_to_image_size.dart';

Future<Image?> getVisiblePortion(File imageFile,
    {required ui.Size flutterScreenSize}) async {
  Uint8List imageBytes = await imageFile.readAsBytes();

  Image? image = decodeImage(imageBytes);

  if (image == null) {
    return null;
  }

  ui.Size screenRectInimageSize = flutterToImageSize(flutterScreenSize, image);

  int y = (image.height ~/ 2) - (screenRectInimageSize.height ~/ 2);
  int x = (image.width ~/ 2) - (screenRectInimageSize.width ~/ 2);

  Image croppedImage = copyCrop(
    image,
    x: x > 0 ? x : 0,
    y: y > 0 ? y : 0,
    width: screenRectInimageSize.width.toInt(),
    height: screenRectInimageSize.height.toInt(),
  );

  return croppedImage;
}
