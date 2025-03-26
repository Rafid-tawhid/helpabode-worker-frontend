import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'cropped_image.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _MainPageState();
}

class _MainPageState extends State<CameraScreen> {
  void pickImage(bool pickGalleryImage) async {
    XFile? image;
    final picker = ImagePicker();

    if (pickGalleryImage == true) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => CroppedImage(
                image: croppedImage,
              )),
        ),
      );
    }
  }

  Future<CroppedFile> cropImages(XFile image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Photo of Your ID',
          toolbarColor: myColors.green,
          statusBarColor: myColors.green,
          cropFrameColor: myColors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Adjust Photo of Your ID',
        ),
      ],
    );

    return croppedFile!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Cropper'),
        centerTitle: true,
        backgroundColor: myColors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              color: Colors.deepOrange,
              textColor: Colors.white,
              padding: const EdgeInsets.all(20),
              onPressed: () {
                pickImage(true);
              },
              child: const Text('Pick Gallery Images'),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: myColors.green,
              textColor: Colors.white,
              padding: const EdgeInsets.all(20),
              onPressed: () {
                pickImage(false);
              },
              child: const Text('Capture Camera Images'),
            ),
          ],
        ),
      ),
    );
  }
}
