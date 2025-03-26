import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class UserHelpers {
  static String empTypeUnderProvider = 'Under Provider';
  static String empTypeCorporate = 'Corporate';
  static String empTypeCorporateMember = 'Corporate Member';
  static String empTypeUnderProviderReview = 'Documents Submitted';
  static String empTypeIndividualProvider = 'Individual';
  static String invitedEmployeeStatus = 'Processing';
  static String empStatusVerified = 'Verified';
  static String empType = '';

  static Future<CroppedFile> cropImages(XFile image, String message) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Your Selfie',
          toolbarColor: myColors.green,
          statusBarColor: myColors.green,
          cropFrameColor: myColors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: message,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );

    return croppedFile!;
  }

  static Future<bool> requestCameraAndGalleryPermissions(
      BuildContext context) async {
    // Request camera permission
    PermissionStatus cameraPermission = await Permission.camera.request();
    if (cameraPermission.isDenied || cameraPermission.isPermanentlyDenied) {
      await _showPermissionDialog(context, 'Camera');
      return false;
    }

    // Request storage permission for Android
    PermissionStatus storagePermission = await Permission.storage.request();
    if (storagePermission.isDenied || storagePermission.isPermanentlyDenied) {
      await _showPermissionDialog(context, 'Gallery');
      return false;
    }

    // Request photos permission for iOS
    PermissionStatus photosPermission = await Permission.photos.request();
    if (photosPermission.isDenied || photosPermission.isPermanentlyDenied) {
      await _showPermissionDialog(context, 'Gallery');
      return false;
    }

    return true;
  }

  static Future<void> _showPermissionDialog(
      BuildContext context, String permission) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permission Permission Required'),
          content: Text(
              'This app needs $permission access to continue. Please grant the permission in settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<String?> getLoginUserEmployeeStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    empType = preferences.getString('employeeType') ?? '';

    debugPrint('GET USER ${empType}');

    return preferences.getString('employeeType');
  }

  static bool isEmpTypeUnderProvider() => empType == empTypeUnderProvider;
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);
  @override
  String get name => '2x3 (customized)';
}

class SlideLeftToRight extends PageRouteBuilder {
  final Widget page;
  SlideLeftToRight({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    // Remove any existing hyphens to avoid conflicts
    text = text.replaceAll('-', '');

    if (text.length > 4 && text.length <= 6) {
      // Insert hyphen after the year (YYYY-)
      text = '${text.substring(0, 4)}-${text.substring(4)}';
    } else if (text.length > 6) {
      // Insert hyphen after the month (YYYY-MM-)
      text =
          '${text.substring(0, 4)}-${text.substring(4, 6)}-${text.substring(6)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
