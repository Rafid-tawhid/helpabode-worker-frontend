import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/photo_id_upload_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:image_picker/image_picker.dart';

class PhotoIdScreen extends StatefulWidget {
  PhotoIdScreen({
    required this.isFrontTemp,
    required this.photoIdLabel,
    this.frontImageTemp,
    this.backImageTemp,
  });

  final isFrontTemp;
  final photoIdLabel;
  final frontImageTemp;
  final backImageTemp;

  @override
  State<PhotoIdScreen> createState() => _PhotoIdScreenState();
}

class _PhotoIdScreenState extends State<PhotoIdScreen> {
  List<CameraDescription> cameras = [];
  late CameraController cameraController;

  bool isReady = false;

  bool isFront = true;

  File? frontImage;
  File? backImage;

  startCamera() async {
    cameras = await availableCameras();

    print('cameras ${cameras}');

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        print('Inside Mount');
        print(isReady);
        return;
      }
      setState(() {
        isReady = true;
        print('Outside Mount');
        print(cameraController.value.aspectRatio);
        print(isReady);
      });
    }).catchError((e) {
      isReady = false;
      print('Inside Error');
      print(isReady);
      print(e);
    });

    await cameraController.setZoomLevel(1);
    setState(() {});
  }

  initializeData() {
    print('Inside Initialize Data');

    print(bool);
    if (widget.isFrontTemp == true) {
      print('Inside If');
      isFront = widget.isFrontTemp;
      print(isFront);
      setState(() {});
    } else {
      print('Inside Else');
      frontImage = widget.frontImageTemp!;
      // backImage = widget.backImageTemp!;
      isFront = widget.isFrontTemp;
      print(isFront);
      // print(frontImage);
      // print(backImage);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    startCamera();
    initializeData();

    // cameraIsInitialized = cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            isReady == true
                ? Transform.scale(
                    // scale: cameraController.value.aspectRatio / ((MediaQuery.of(context).size.width / MediaQuery.of(context).size.height) * (926 / 487)),
                    scale: cameraController.value.aspectRatio /
                        ((MediaQuery.of(context).size.width /
                                MediaQuery.of(context).size.height) *
                            (1.9)),
                    // scale: cameraController.value.aspectRatio / (388.w / 487.h),
                    // scaleX: 388.w,
                    // scaleY: 487.h,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1 / cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.black,
                  ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(label: ''),
            ),
            Positioned(
              top: 80.h,
              left: 0,
              child: Container(
                width: 21.w,
                height: 842.h,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 80.h,
              right: 0,
              child: Container(
                width: 21.w,
                height: 842.h,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 78.h,
              right: 20.w,
              left: 20.w,
              child: Container(
                width: double.infinity,
                height: 177.h,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      isFront == true
                          ? 'Take a photo of the front of yourA ${widget.photoIdLabel}'
                          : 'Take a photo of the back of your ${widget.photoIdLabel}',
                      style: text_20_black_600_TextStyle,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      isFront == true
                          ? 'Take a clear photo of the front of your government issued ID.'
                          : 'Take a clear photo of the back of your government issued ID.',
                      style: textField_18_black_400_TextStyle,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 20.w,
              left: 20.w,
              child: Container(
                width: double.infinity,
                height: 177.h,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.h,
                    ),
                    CustomMaterialButton(
                      label: 'Take Photo',
                      buttonColor: buttonClr,
                      fontColor: buttonFontClr,
                      funcName: isFront == true
                          ? () {
                              cameraController.takePicture().then((file) {
                                if (mounted) {
                                  frontImage = File(file.path);

                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => UploadPhotoId(
                                                isFront: isFront,
                                                frontImage: frontImage,
                                                photoIdLabel:
                                                    widget.photoIdLabel,
                                              )));

                                  ///
                                  // context.pushNamed('photo_id_upload', queryParameters: {
                                  //   'isFrontTemp': isFront,
                                  //   'photoIdLabel': widget.photoIdLabel,
                                  //   'frontImage': frontImage,
                                  // });
                                }
                              });

                              setState(() {
                                print('PRESSED BUTTON');
                                // isFront = false;
                              });
                            }
                          : () {
                              cameraController.takePicture().then((file) {
                                if (mounted) {
                                  backImage = File(file.path);

                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => UploadPhotoId(
                                                isFront: isFront,
                                                photoIdLabel:
                                                    widget.photoIdLabel,
                                                frontImage: frontImage,
                                                backImage: backImage,
                                              )));

                                  ///
                                  // context.pushNamed('photo_id_upload', queryParameters: {
                                  //   'isFrontTemp': isFront,
                                  //   'photoIdLabel': widget.photoIdLabel,
                                  //   'frontImage': frontImage,
                                  //   'backImage': backImage,
                                  // });
                                }
                              });

                              // setState(() {
                              //   isFront = true;
                              // });
                            },
                      borderRadius: 50.w,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    InkWell(
                      onTap: () {
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          if (mounted) {
                            if (value != null) {
                              frontImage = File(value.path);

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => UploadPhotoId(
                                            isFront: isFront,
                                            frontImage: frontImage,
                                            photoIdLabel: widget.photoIdLabel,
                                          )));
                            }
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/download.svg'),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Upload Photo of Front ID',
                            style: text_16_green_500_TextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.w,
              right: 20.w,
              top: 320.h,
              child: SvgPicture.asset(
                isFront == true
                    ? 'assets/svg/Frame 10397.svg'
                    : 'assets/svg/back_mockup_driving_license.svg',
                color: dropdownClr.withOpacity(0.3),
                height: 200.h,
                width: 300.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
