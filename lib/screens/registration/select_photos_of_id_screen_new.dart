import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/selfie_capture_screen_new.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../corporate/individual_team/review_team_members_submitted_documents.dart';

class SelectPhotoIdScreenNew extends StatefulWidget {
  static const String routeName = '/new_photo_id_scren';
  File? front;
  File? back;
  String? form;

  SelectPhotoIdScreenNew({this.front, this.back, this.form});

  @override
  State<SelectPhotoIdScreenNew> createState() => _SelectPhotoIdScreenNewState();
}

class _SelectPhotoIdScreenNewState extends State<SelectPhotoIdScreenNew> {
  String idType = '';
  String idNo = '';
  String expDate = '';
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Accessing query parameters
    Map<String, dynamic>? queryParams =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    idType = DashboardHelpers.selectedId ?? '';
    idNo = DashboardHelpers.idNo ?? '';
    expDate = DashboardHelpers.expDate ?? '';

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(label: ''),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Take Photo of Your ($idType)',
                      style: interText(20, Colors.black, FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Please make sure there’s enough lighting and that the ID lettering is clear before continuing.',
                      style: interText(13, Colors.black, FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Front',
                                  style: text_16_black_600_TextStyle,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: SignInSignUpHelpers.frontImage ==
                                              null
                                          ? SvgPicture.asset(
                                              'assets/svg/front.svg',
                                              width: MediaQuery.sizeOf(context)
                                                      .width -
                                                  40,
                                            )
                                          : Image.file(
                                              SignInSignUpHelpers.frontImage!,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.sizeOf(context)
                                                      .height /
                                                  4,
                                            ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 10,
                                        child: InkWell(
                                            onTap: () async {
                                              _showImagePickerDialog('front');
                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //     builder: (context) => CropCameraImage(
                                              //           isFrontTemp: true,
                                              //           photoIdLabel: idType,
                                              //         )));

                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //     builder: (context) => PhotoIdScreen(
                                              //           isFrontTemp: true,
                                              //           photoIdLabel: idType,
                                              //         )));
                                            },
                                            child: SvgPicture.asset(
                                                'assets/svg/new_camera.svg'))),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Back',
                                  style: text_16_black_600_TextStyle,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: SignInSignUpHelpers.backImage ==
                                              null
                                          ? SvgPicture.asset(
                                              'assets/svg/back.svg',
                                              fit: BoxFit.cover,
                                              width: MediaQuery.sizeOf(context)
                                                      .width -
                                                  40,
                                            )
                                          : Image.file(
                                              SignInSignUpHelpers.backImage!,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.sizeOf(context)
                                                      .height /
                                                  4,
                                            ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 10,
                                        child: InkWell(
                                            onTap: () async {
                                              _showImagePickerDialog('back');
                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //     builder: (context) => CropCameraImage(
                                              //           isFrontTemp: false,
                                              //           photoIdLabel: idType,
                                              //         )));

                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //     builder: (context) => PhotoIdScreen(
                                              //           isFrontTemp: false,
                                              //           photoIdLabel: idType,
                                              //         )));
                                            },
                                            child: SvgPicture.asset(
                                                'assets/svg/new_camera.svg'))),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            (SignInSignUpHelpers.frontImage != null &&
                    SignInSignUpHelpers.backImage != null)
                ? Consumer<UserProvider>(
                    builder: (context, provider, _) => CustomRoundedButton(
                      label: 'Next',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: () async {
                        if (SignInSignUpHelpers.frontImage != null &&
                            SignInSignUpHelpers.backImage != null) {
                          if (widget.form != null) {
                            //check if it is for edit screen or not..
                            if (provider.setEditValueForTeam) {
                              _controller.start();
                              if (await provider.postWorkerPhotoIdUpdate(
                                  idType: idType,
                                  idNo: idNo,
                                  expDate: expDate,
                                  token: token,
                                  urlBase: urlBase,
                                  textId: textId,
                                  frontImagePath:
                                      SignInSignUpHelpers.frontImage!.path,
                                  backImagePath:
                                      SignInSignUpHelpers.backImage!.path)) {
                                if (await provider
                                    .getWorkerProfileDetailsData(textId)) {
                                  DashboardHelpers.successStopAnimation(
                                      _controller);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewTeamMembersSubmittedDocuments()));
                                } else {
                                  DashboardHelpers.errorStopAnimation(
                                      _controller);
                                }
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewTeamMembersSubmittedDocuments()));
                              } else {
                                DashboardHelpers.errorStopAnimation(
                                    _controller);
                              }
                            } else {
                              //for corporation
                              _controller.start();
                              postPhotoId(_controller);
                              _controller.stop();

                              // _controller.start();
                              // if (await provider.postWorkerPhotoIdUpdate(idType: idType, idNo: idNo, expDate: expDate, token: token, urlBase: urlBase, textId: textId, frontImagePath: SignInSignUpHelpers.frontImage!.path, backImagePath: SignInSignUpHelpers.backImage!.path)) {
                              //   DashboardHelpers.successStopAnimation(_controller);
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => SelfieCaptureScreen(
                              //                 form: 'corporate',
                              //               )));
                              //   //Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewTeamMembersSubmittedDocuments()));
                              // } else {
                              //   DashboardHelpers.errorStopAnimation(_controller);
                              // }
                            }
                          } else {
                            postPhotoId(_controller);
                          }
                        } else {
                          DashboardHelpers.showAlert(
                              msg: 'please select both image');
                        }
                      },
                      borderRadius: 8,
                      controller: _controller,
                    ),
                  )
                : CustomRoundedButton(
                    label: 'Next',
                    buttonColor: myColors.greyBtn,
                    fontColor: Colors.black,
                    funcName: () {
                      DashboardHelpers.showAlert(
                          msg: 'please select both image');
                    },
                    borderRadius: 8,
                    controller: _controller,
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerDialog(String side) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                  color: Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(height: 24),
            Text('How would you like to upload',
                style: interText(24, Colors.black, FontWeight.w600)),
            SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xfff6f6f6),
                child: Icon(Icons.camera_alt, color: Colors.black),
              ),
              title: Text(
                'Take Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                pickImage(false, side);
                Navigator.of(context).pop();
              },
            ),
            Divider(height: 1, color: myColors.divider),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xfff6f6f6),
                child: Icon(Icons.photo, color: Colors.black),
              ),
              title: Text(
                'Upload Your ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                pickImage(true, side);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void pickImage(bool pickGalleryImage, String side) async {
    XFile? image;
    final picker = ImagePicker();

    if (pickGalleryImage == true) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (side == 'front') {
        SignInSignUpHelpers.setFrontImage(File(croppedImage.path));
        setState(() {});
      } else {
        SignInSignUpHelpers.setBackImage(File(croppedImage.path));
        setState(() {});
      }
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
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
            aspectRatioLockDimensionSwapEnabled: true,
            aspectRatioLockEnabled: false),
      ],
    );

    return croppedFile!;
  }

  Future<void> postPhotoId(RoundedLoadingButtonController controller) async {
    try {
      print(SignInSignUpHelpers.frontImage!.path);
      print(SignInSignUpHelpers.backImage!.path);
      print('#####____ POST START WORK ____#####');

      _controller.start();

      print(token);

      var header = {
        "Authorization": "Bearer ${token}",
      };

      print(header);

      var request = MultipartRequest(
          'POST', Uri.parse('${urlBase}api/WorkerPhotoIdUpdate'));

      request.fields['photoIdType'] = '${idType}';
      request.fields['workerTextId'] = '${textId}';
      request.fields['workerStatus'] = 'PhotoId Required';
      request.fields['photoIdNo'] = idNo;
      request.fields['photoIdExpirationDate'] = expDate;
      print('SENDING ${request.fields.toString()}');

      request.headers.addAll(header);

      request.files.add(await MultipartFile.fromPath(
          'photoIdData1', SignInSignUpHelpers.frontImage!.path));

      request.files.add(await MultipartFile.fromPath(
          'photoIdData2', SignInSignUpHelpers.backImage!.path));

      print(request.fields.toString());

      var response = await request.send();

      print('Hello World 3');

      print(response.statusCode);
      DashboardHelpers.successStopAnimation(_controller);

      if (response.statusCode == 201) {
        response.stream.transform(utf8.decoder).listen((value) async {
          print(value);
          print(value.runtimeType);
          print(jsonDecode(value)['worker_status']['status']);
          await userBox.put(
              'status', '${jsonDecode(value)['worker_status']['status']}');
          // Clear both photos
          SignInSignUpHelpers.clearImage();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelfieCaptureScreen()));
        });
      } else {
        DashboardHelpers.errorStopAnimation(_controller);
        print(
            'Failed... Error: ${response.stream.transform(utf8.decoder).listen((event) {
          print(event);
          var aa = jsonDecode(event);
          DashboardHelpers.showAlert(
              msg: aa['message'] ?? 'Something went wrong');
        })}');
      }
    } catch (error) {
      print('An error occurred: $error');
      DashboardHelpers.errorStopAnimation(_controller);
    }
  }
}
