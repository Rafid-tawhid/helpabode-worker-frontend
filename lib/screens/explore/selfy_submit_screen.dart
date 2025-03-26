import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/explore/document_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../provider/worker_pending_provider.dart';
import '../../widgets_reuse/circular_image_with_shimmer.dart';

class SelfieUploadScreen extends StatefulWidget {
  const SelfieUploadScreen({super.key});

  @override
  State<SelfieUploadScreen> createState() => _SelfieUploadScreenState();
}

class _SelfieUploadScreenState extends State<SelfieUploadScreen> {
  String? _selfyImage;
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                CustomAppBar(label: ''),
                Text(
                  'Profile Photo',
                  style: interText(20, Colors.black, FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<WorkerPendingProvider>(
                  builder: (context, provider, _) {
                    if (_selfyImage != null) {
                      return Center(
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: ClipOval(
                            child: Image.file(
                              File(_selfyImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CustomCircleShimmerImage(
                          imageUrl:
                              '$urlBase${provider.documentUpdateInfoList.first.issueFor![0]}', // Replace with your actual image URL
                          placeholder: 'assets/png/person2.png',
                          size: 300,
                        ),
                      );
                    }
                  },
                ),
              ],
            )),
            Consumer<WorkerPendingProvider>(
              builder: (context, provider, _) => InkWell(
                onTap: () {
                  _showImagePickerOptions(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 388,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Color(0xFFE9E9E9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Resubmit',
                          style: TextStyle(
                            color: Color(0xFF636366),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                            letterSpacing: 0.54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_selfyImage != null)
              Consumer<WorkerPendingProvider>(
                builder: (context, provider, _) => RoundedLoadingButton(
                    color: myColors.green,
                    controller: controller,
                    successColor: myColors.green,
                    onPressed: () async {
                      controller.start();
                      if (await provider.postWorkerDocumentUpdate(
                          stage: PendingStatus.selfy,
                          selfie: File(_selfyImage!))) {
                        DashboardHelpers.successStopAnimation(controller);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentScreen()));
                      } else {
                        DashboardHelpers.errorStopAnimation(controller);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Submit',
                            style: interText(16, Colors.white, FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
              ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick an image'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  //_pickImage(ImageSource.camera, context);
                  XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      preferredCameraDevice: Platform.isAndroid
                          ? CameraDevice.rear
                          : CameraDevice.rear,
                      imageQuality: 60);
                  if (image != null) {
                    Navigator.pop(context);
                    setState(() {
                      _selfyImage = image.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () async {
                  XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 60);
                  if (image != null) {
                    Navigator.pop(context);
                    setState(() {
                      _selfyImage = image.path;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _pickImage(ImageSource source, BuildContext context) async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //     source: source,
  //     preferredCameraDevice: Platform.isAndroid ? CameraDevice.rear : CameraDevice.front,
  //   );
  //
  //   if (image != null) {
  //     Navigator.of(context).pop(); // Close the dialog
  //     // Process the picked image
  //     setState(() {
  //       _selfyImage = image.path;
  //     });
  //   }
  // }
}

// class CircularImage extends StatelessWidget {
//   final String imageUrl;
//   final double size;
//   final String placeholder;
//
//   CircularImage({
//     required this.imageUrl,
//     required this.size,
//     required this.placeholder,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipOval(
//       child: SizedBox(
//         width: size,
//         height: size,
//         child: FadeInImage.assetNetwork(
//           placeholder: placeholder,
//           image: imageUrl,
//           fit: BoxFit.cover,
//           imageErrorBuilder: (context, error, stackTrace) {
//             return Image.asset(
//               placeholder,
//               fit: BoxFit.cover,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
