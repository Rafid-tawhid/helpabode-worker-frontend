import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/photo_id_upload_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../custom_packages/mask_for_camera_view.dart';
import '../../custom_packages/mask_for_camera_view_result.dart';
import '../../misc/constants.dart';

late List<CameraDescription> cameras;

class CropCameraImage extends StatefulWidget {
  CropCameraImage({
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
  _CropCameraImageState createState() => _CropCameraImageState();
}

class _CropCameraImageState extends State<CropCameraImage> {
  bool isReady = false;

  bool isFront = true;

  File? frontImage;
  File? backImage;

  @override
  void initState() {
    initializeData();
    super.initState();
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
      // frontImage = widget.frontImageTemp!;
      // backImage = widget.backImageTemp!;
      isFront = widget.isFrontTemp;
      print(isFront);
      // print(frontImage);
      // print(backImage);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          //this is custom widget may be problem if any update
          Expanded(
            child: MaskForCameraView(
                visiblePopButton: true,
                title: isFront == true
                    ? 'Take a photo of the front of your ${widget.photoIdLabel}'
                    : 'Take a photo of the back of your ${widget.photoIdLabel}',
                // subTitle: isFront == true ? 'Take a clear photo of the front of your government issued ID.' : 'Take a clear photo of the back of your government issued ID.',
                boxBorderWidth: 2.8,
                cameraDescription: cameras.first,
                onTake: (MaskForCameraViewResult? res) async {
                  if (res != null) {
                    if (widget.isFrontTemp) {
                      var maxImage = await compressImage(res.croppedImage!);
                      var frontImage = await saveUint8ListAsFile(maxImage);
                      if (frontImage != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => UploadPhotoId(
                                  isFront: isFront,
                                  frontImage: frontImage,
                                  photoIdLabel: widget.photoIdLabel,
                                )));
                      }
                    } else {
                      var maxImage = await compressImage(res.croppedImage!);
                      var backImg = await saveUint8ListAsFile(maxImage);
                      if (backImg != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => UploadPhotoId(
                                  isFront: isFront,
                                  photoIdLabel: widget.photoIdLabel,
                                  backImage: backImg,
                                )));
                      }
                    }
                  }
                  // res.croppedImage is cropped image, you can use it.
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: InkWell(
              onTap: () {
                ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((value) {
                  if (mounted) {
                    if (value != null) {
                      if (isFront) {
                        frontImage = File(value.path);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => UploadPhotoId(
                                  isFront: isFront,
                                  frontImage: frontImage,
                                  photoIdLabel: widget.photoIdLabel,
                                )));
                        setState(() {
                          print('PRESSED BUTTON 2');
                          // isFront = false;
                        });
                      } else {
                        backImage = File(value.path);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => UploadPhotoId(
                                  isFront: isFront,
                                  photoIdLabel: widget.photoIdLabel,
                                  frontImage: frontImage,
                                  backImage: backImage,
                                )));
                        setState(() {
                          print('PRESSED BUTTON 2');
                          // isFront = false;
                        });
                      }
                    }
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svg/download.svg'),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Upload Photo of Front ID',
                      style: text_16_green_500_TextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  // Define a function to compress the image
  Future<Uint8List> compressImage(Uint8List imageData) async {
    // Compress the image with a higher quality
    List<int> compressedData = await FlutterImageCompress.compressWithList(
      imageData,
      minHeight: 1920, // Set the minimum height of the image
      minWidth: 1080, // Set the minimum width of the image
      quality: 90, // Set the quality of the compressed image (0 - 100)
    );

    // Use the compressedData as needed
    // For example, you can assign it to your croppedImage variable
    return Uint8List.fromList(compressedData);
  }
}

// Future<File> saveUint8ListAsFile(Uint8List uint8List) async {
//   Uint8List imageInUnit8List = uint8List; // store unit8List image here ;
//   final tempDir = await getTemporaryDirectory();
//   File file = await File('${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}image.png').create();
//   file.writeAsBytesSync(imageInUnit8List);
//   return file;
// }
Future<File?> saveUint8ListAsFile(Uint8List myUint8List) async {
  // Request permission to access the device's temporary directory
  var status = await Permission.storage.request();
  // if (status != PermissionStatus.granted) {
  //   // Permission not granted, handle accordingly (e.g., show a message to the user)
  //   print('Permission denied for accessing temporary directory');
  //   return null;
  // }

  // Permission granted, proceed to access the temporary directory
  final tempDir = await getTemporaryDirectory();
  String filePath = generateUniqueFilePath(tempDir.path, 'jpg');

  File? result = await uint8ListToFile(myUint8List, filePath);

  if (result != null) {
    print('Conversion successful. File created at: ${result.path}');
    // Do something with the File.
  } else {
    print('Conversion failed.');
  }

  return result;
}

Future<File?> uint8ListToFile(Uint8List uint8List, String filePath) async {
  try {
    File file = File(filePath);
    await file.create(recursive: true); // Ensure directory existence
    await file.writeAsBytes(uint8List);
    return file;
  } catch (e) {
    print("Error converting Uint8List to file: $e");
    return null;
  }
}

String generateUniqueFilePath(String directoryPath, String extension) {
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String randomPart = Random().nextInt(999999).toString().padLeft(6, '0');
  return '$directoryPath/$timestamp-$randomPart.$extension';
}

class MyImageView extends StatelessWidget {
  const MyImageView({Key? key, required this.imageBytes}) : super(key: key);
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: SizedBox(
        width: double.infinity,
        child: Image.memory(imageBytes),
      ),
    );
  }
}
