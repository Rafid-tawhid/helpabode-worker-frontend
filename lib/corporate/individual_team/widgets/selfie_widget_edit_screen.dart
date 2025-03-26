import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../../../helper_functions/colors.dart';
import '../../../../../misc/constants.dart';
import '../../../screens/registration/selfie_capture_screen_new.dart';
import '../review_team_members_submitted_documents.dart';

class SelfieWidgetEditScreen extends StatefulWidget {
  @override
  State<SelfieWidgetEditScreen> createState() => _SelfieWidgetEditScreenState();
}

class _SelfieWidgetEditScreenState extends State<SelfieWidgetEditScreen> {
  bool showLoading = false;
  String? imagePath;
  late CameraDescription firstCamera;
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();
  RoundedLoadingButtonController _controller2 =
      RoundedLoadingButtonController();
  @override
  void initState() {
    getAvailableCam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Update Your Selfie'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: imagePath == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${urlBase}${provider.teamImageUrl}',
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              height: 150,
                              width: 150,
                              child: Image.asset(
                                'images/placeholder.jpg',
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey,
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 120,
                      width: 120,
                      child: Image.file(
                        File(imagePath ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            SizedBox(
              height: 45.h,
            ),
            Text(
              imagePath == null ? 'Take Your Photo' : 'Check Your Photo',
              style: textField_30_black_600,
            ),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please make sure there’s enough lighting and that the photo is clear before continuing.',
                    style: textField_18_black_400_TextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (imagePath != null)
                    CustomRoundedButton(
                        label: 'Retake Photo',
                        buttonColor: myColors.greyBtn,
                        fontColor: Colors.black,
                        funcName: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TakePictureScreen(camera: firstCamera),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              imagePath = result;
                            });
                          }
                        },
                        borderRadius: 50,
                        controller: _controller2),
                  SizedBox(height: 20),
                  CustomRoundedButton(
                      label: imagePath == null ? 'Take Photo' : 'Upload Photo',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: () async {
                        if (imagePath == null) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TakePictureScreen(camera: firstCamera),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              imagePath = result;
                            });
                          }
                        } else {
                          _controller.start();
                          if (await provider.postSelfie(imagePath ?? '')) {
                            _controller.stop();
                            if (await provider
                                .getWorkerProfileDetailsData(textId)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReviewTeamMembersSubmittedDocuments()));
                            }
                          } else {
                            _controller.stop();
                          }
                        }
                      },
                      borderRadius: 50,
                      controller: _controller)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAvailableCam() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
  }

  Future<CroppedFile> cropImageGallary(XFile image) async {
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
          title: 'Adjust Your Selfie',
        ),
      ],
    );
    return croppedFile!;
  }
}
