import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/select_photos_of_id_screen_new.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:http/http.dart';

import 'crop_camera.dart';

class UploadPhotoId extends StatefulWidget {
  UploadPhotoId({
    required this.isFront,
    this.frontImage,
    required this.photoIdLabel,
    this.backImage,
  });
  final isFront;
  final frontImage;
  final photoIdLabel;
  final backImage;

  @override
  State<UploadPhotoId> createState() => _UploadPhotoIdState();
}

class _UploadPhotoIdState extends State<UploadPhotoId> {
  bool isButtonLoading = false;

  Future postPhotoId() async {
    print('#####____ POST MULTIPLE IMAGE ____#####');

    var header = {
      "Authorization": "Bearer ${token}",
    };

    print(header);

    var request = MultipartRequest(
        'POST', Uri.parse('${urlBase}api/WorkerPhotoIdUpdate'));

    request.fields['photoIdType'] = '${widget.photoIdLabel}';
    request.fields['workerTextId'] = '${userBox.get('textId')}';
    request.fields['workerStatus'] = '${userBox.get('status')}';

    request.headers.addAll(header);

    request.files.add(
        await MultipartFile.fromPath('photoIdData1', widget.frontImage!.path));

    request.files.add(
        await MultipartFile.fromPath('photoIdData2', widget.backImage!.path));

    print('Hello World 2');

    var response = await request.send();

    print('Hello World 3');

    // print(response.stream.toString());

    print(response.statusCode);

    if (response.statusCode == 201) {
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        print(value.runtimeType);
        print(jsonDecode(value)['worker_status']['status']);
        await userBox.put(
            'status', '${jsonDecode(value)['worker_status']['status']}');
      });
      print(response);
      print('image uploaded');
    } else {
      print('Error : ${response}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('THIS IS FRONT ${widget.isFront} ${widget.photoIdLabel}');
    print(widget.frontImage);
    print('THIS IS back ${widget.isFront}');
    print(widget.backImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(label: ''),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Check your photo',
                        style: textField_30_black_600,
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Please make sure there’s enough lighting and that ID is clear before continuining.',
                      style: textField_18_black_400_TextStyle,
                      // textAlign: TextAlign.,
                    ),
                    SizedBox(
                      height: 45.h,
                    ),
                    Expanded(
                      child: Image.file(
                        // height: 400.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        widget.isFront == true
                            ? widget.frontImage as File
                            : widget.backImage as File,
                      ),
                    ),
                    SizedBox(
                      height: 54.h,
                    ),
                    CustomMaterialButton(
                      isLoading: isButtonLoading,
                      label: 'Use This Photo',
                      buttonColor: buttonClr,
                      fontColor: buttonFontClr,
                      funcName: widget.isFront == true
                          ? () {
                              print(
                                  'Clicked Front = True ${widget.frontImage}');
                              // context.pushNamed(SelectPhotoIdScreenNew.routeName, queryParameters: {'frontImg': widget.frontImage.toString()});
                              //set front Image
                              SignInSignUpHelpers.setFrontImage(
                                  widget.frontImage);

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectPhotoIdScreenNew(
                                            front: widget.frontImage,
                                            back: widget.backImage,
                                          )));
                            }
                          : () async {
                              //set back Image
                              SignInSignUpHelpers.setBackImage(
                                  widget.backImage);

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectPhotoIdScreenNew(
                                            front: widget.frontImage,
                                            back: widget.backImage,
                                          )));

                              // context.pushNamed('selfie_capture');
                            },
                      borderRadius: 50.w,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    CustomMaterialButton(
                      label: 'Retake',
                      buttonColor: buttonDisableClr,
                      fontColor: Colors.black,
                      funcName: widget.isFront == true
                          ? () {
                              // Navigator.of(context).pushReplacement(MaterialPageRoute(
                              //     builder: (context) => PhotoIdScreen(
                              //           isFrontTemp: true,
                              //           photoIdLabel: widget.photoIdLabel,
                              //         )));

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CropCameraImage(
                                        isFrontTemp: true,
                                        photoIdLabel: widget.photoIdLabel,
                                      )));
                            }
                          : () {
                              // Navigator.of(context).pushReplacement(MaterialPageRoute(
                              //     builder: (context) => PhotoIdScreen(
                              //           isFrontTemp: false,
                              //           frontImageTemp: widget.frontImage,
                              //           photoIdLabel: widget.photoIdLabel,
                              //         )));

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CropCameraImage(
                                        isFrontTemp: false,
                                        photoIdLabel: widget.photoIdLabel,
                                      )));
                            },
                      borderRadius: 50.w,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
