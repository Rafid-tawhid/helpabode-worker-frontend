import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../custom_packages/extensions/custom_material_button.dart';
import '../../misc/constants.dart';

class SelfieCaptureScreen extends StatefulWidget {
  String? form;

  SelfieCaptureScreen({this.form});

  @override
  _SelfieCaptureScreenState createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  CameraDescription firstCamera = CameraDescription(
      name: 'Front',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 1);
  bool showLoading = false;
  String? imagePath;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    getAvailableCam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                // image: selfieImage == null ? AssetImage('assets/svg/Selfie.png') : FileImage(selfieImage!),
                image: imagePath == null
                    ? const AssetImage('assets/png/person2.png')
                    : FileImage(File(imagePath!)) as ImageProvider,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            imagePath == null ? 'Take Your Photo' : 'Check Your Photo',
            style: interText(28, Colors.black, FontWeight.w700),
          ),
          SizedBox(
            height: 24,
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
                SizedBox(height: 20),
                CustomMaterialButton(
                  isLoading: showLoading,
                  height: 54,
                  label: imagePath == null ? 'Take Photo' : 'Save & Continue',
                  buttonColor: buttonClr,
                  fontColor: buttonFontClr,
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
                      //upload to database
                      postSelfie(imagePath!);
                      // if (widget.form != null) {
                      //   curInd = 0;
                      //   context.pushNamed('home');
                      // } else {
                      //   postSelfie(imagePath!);
                      // }
                    }
                  },
                  borderRadius: 50,
                ),
                SizedBox(height: 10),
                CustomMaterialButton(
                  isLoading: false,
                  height: 54.h,
                  label: imagePath == null ? 'Upload Photo' : 'Retake',
                  buttonColor: myColors.greyBg,
                  fontColor: Colors.black,
                  funcName: () async {
                    if (imagePath == null) {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        final result = await cropImageGallary(image);
                        if (result.path.isNotEmpty) {
                          setState(() {
                            imagePath = result.path;
                          });
                        }
                      }
                    } else {
                      //for retake
                      setState(() {
                        imagePath = null;
                      });
                    }
                  },
                  borderRadius: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postSelfie(String image) async {
    setState(() {
      showLoading = true;
    });

    try {
      print('#####____ POST SELFY WORK ____##### ${userBox.get('status')}');

      var header = {
        "Authorization": "Bearer ${token}",
      };

      print(header);

      // If selfie is for invited member

      var request = MultipartRequest(
          'POST', Uri.parse('${urlBase}api/WorkerSelfieUpdate'));

      request.fields['workerTextId'] = '${textId}';
      request.fields['workerStatus'] = 'Selfie Required'; // Changed in Aug 5
      request.headers.addAll(header);
      request.files.add(await MultipartFile.fromPath('selfieData', image));

      print('Hello World 2');
      print('${userBox.get('status')}');
      print('${userBox.get('textId')}');

      var response = await request.send();

      setState(() {
        showLoading = false;
      });

      print('Response Data ${response.statusCode}');
      print(response.statusCode);
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) async {
          try {
            print(value);
            print(value.runtimeType);
            var jsonResponse = jsonDecode(value);
            var newStatus = jsonResponse['worker_status']['status'];
            await userBox.put('status', '$newStatus');
          } catch (e) {
            print('Error decoding response: $e');
          }
        });

        print(response);
        print('Image uploaded');
        // Go to next page, skip one page before
        print(userBox.get('textId'));
        print(userBox.get('status'));
        context.pushNamed(
          'ssn',
          pathParameters: {
            'workerTextId': '${userBox.get('textId')}',
            'workerStatus': '${userBox.get('status')}',
          },
        );
      } else {
        String responseBody =
            await response.stream.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        DashboardHelpers.showAlert(
            msg: '${data['message'] ?? 'Something went wrong'}');
        print('Failed with status code: ${response.statusCode}');
        print('Response Body: ${data}');
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        showLoading = false;
      });

      DashboardHelpers.showAlert(msg: 'Something went wrong');
    }
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
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 5),
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

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      // Take the picture and get the file where it is saved.
      final XFile image = await _controller.takePicture();

      //send to crop image
      CroppedFile cropped = await cropImages(image);

      // Return the path of the image file.
      Navigator.pop(context, cropped.path);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: CameraPreview(_controller)),
                  Expanded(
                      child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      color: Colors.black,
                      // Adjust padding as needed
                      child: IconButton(
                        onPressed: _takePicture,
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<CroppedFile> cropImages(XFile image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 5),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Your Selfie',
          toolbarColor: myColors.green,
          statusBarColor: myColors.green,
          cropFrameColor: myColors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
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
