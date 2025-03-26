import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../helper_functions/user_helpers.dart';

class ImageSelectionDialog extends StatelessWidget {
  late UserProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<UserProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Select Image Source'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _openCamera(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _openGallery(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    //if (await UserHelpers.requestCameraAndGalleryPermissions(context))
    if (true) {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        CroppedFile image =
            await UserHelpers.cropImages(pickedImage, 'Adjust your photo');
        // await provider.removeImageFile();
        provider.setImageFile(File(image.path));
        provider.upDateButton(true);
        // Handle the image picked from the gallery
      }
    }
  }

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    //if (await UserHelpers.requestCameraAndGalleryPermissions(context))
    if (true) {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        CroppedFile image =
            await UserHelpers.cropImages(pickedImage, 'Adjust your photo');
        // await provider.removeImageFile();
        provider.setImageFile(File(image.path));
        provider.upDateButton(true);
        // Handle the image picked from the gallery
      }
    }
  }
}

void showImageSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ImageSelectionDialog();
    },
  );
}
