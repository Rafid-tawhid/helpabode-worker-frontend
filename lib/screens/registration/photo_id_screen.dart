// class PhotoIdScreen extends StatefulWidget {
//   PhotoIdScreen({
//     required this.isFrontTemp,
//     required this.photoIdLabel,
//     this.frontImageTemp,
//     this.backImageTemp,
//   });
//
//   final isFrontTemp;
//   final photoIdLabel;
//   final frontImageTemp;
//   final backImageTemp;
//
//   @override
//   State<PhotoIdScreen> createState() => _PhotoIdScreenState();
// }
//
// class _PhotoIdScreenState extends State<PhotoIdScreen> {
//   List<CameraDescription> cameras = [];
//   late CameraController cameraController;
//
//   bool isReady = false;
//
//   bool isFront = true;
//
//   File? frontImage;
//   File? backImage;
//
//   startCamera() async {
//     cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//     print('cameras ${cameras}');
//
//     cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//
//     await cameraController.initialize().then((value) {
//       if (!mounted) {
//         print('Inside Mount');
//         print(isReady);
//         return;
//       }
//       setState(() {
//         isReady = true;
//         print('Outside Mount');
//         print(cameraController.value.aspectRatio);
//         print(isReady);
//       });
//     }).catchError((e) {
//       isReady = false;
//       print('Inside Error');
//       print(isReady);
//       print(e);
//     });
//
//     await cameraController.setZoomLevel(1);
//     setState(() {});
//   }
//
//   initializeData() {
//     print('Inside Initialize Data');
//
//     print(bool);
//     if (widget.isFrontTemp == true) {
//       print('Inside If');
//       isFront = widget.isFrontTemp;
//       print(isFront);
//       setState(() {});
//     } else {
//       print('Inside Else');
//       // frontImage = widget.frontImageTemp!;
//       // backImage = widget.backImageTemp!;
//       isFront = widget.isFrontTemp;
//       print(isFront);
//       // print(frontImage);
//       // print(backImage);
//       setState(() {});
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     startCamera();
//     initializeData();
//
//     // cameraIsInitialized = cameraController.initialize();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     cameraController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomAppBar(label: ''),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     isFront == true ? 'Take a photo of the front of your ${widget.photoIdLabel}' : 'Take a photo of the back of your ${widget.photoIdLabel}',
//                     style: text_20_black_600_TextStyle,
//                   ),
//                   SizedBox(
//                     height: 25.h,
//                   ),
//                   Text(
//                     isFront == true ? 'Take a clear photo of the front of your government issued ID.' : 'Take a clear photo of the back of your government issued ID.',
//                     style: textField_18_black_400_TextStyle,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: isReady == true
//                   ? Padding(
//                       padding: const EdgeInsets.all(30.0),
//                       child: Center(
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             AspectRatio(
//                               aspectRatio: 1,
//                               child: CameraPreview(cameraController),
//                             ),
//                             SvgPicture.asset(
//                               isFront == true ? 'assets/svg/Frame 10397.svg' : 'assets/svg/back_mockup_driving_license.svg',
//                               color: dropdownClr.withOpacity(0.3),
//                               height: 200.h,
//                               width: 300.w,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(
//                       color: Colors.black,
//                     ),
//             ),
//             Container(
//               width: double.infinity,
//               height: 177.h,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 35.h,
//                   ),
//                   CustomMaterialButton(
//                     label: 'Take Photo',
//                     buttonColor: buttonClr,
//                     fontColor: buttonFontClr,
//                     funcName: isFront == true
//                         ? () {
//                             cameraController.takePicture().then((file) {
//                               if (mounted) {
//                                 if (file != null) {
//                                   frontImage = File(file.path);
//                                   Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                       builder: (context) => UploadPhotoId(
//                                             isFront: isFront,
//                                             frontImage: frontImage,
//                                             photoIdLabel: widget.photoIdLabel,
//                                           )));
//                                 }
//                               }
//                             });
//
//                             setState(() {
//                               print('PRESSED BUTTON');
//                               // isFront = false;
//                             });
//                           }
//                         : () {
//                             cameraController.takePicture().then((file) {
//                               if (mounted) {
//                                 if (file != null) {
//                                   backImage = File(file.path);
//
//                                   Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                       builder: (context) => UploadPhotoId(
//                                             isFront: isFront,
//                                             photoIdLabel: widget.photoIdLabel,
//                                             frontImage: frontImage,
//                                             backImage: backImage,
//                                           )));
//                                 }
//                               }
//                             });
//
//                             // setState(() {
//                             //   isFront = true;
//                             // });
//                           },
//                     borderRadius: 50.w,
//                   ),
//                   SizedBox(
//                     height: 30.h,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset('assets/svg/download.svg'),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Text(
//                         'Upload Photo of Front ID',
//                         style: text_16_green_500_TextStyle,
//                       ),
//                     ],
//                   ),
//                   InkWell(
//                     onTap: () {
//                       ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
//                         if (mounted) {
//                           if (value != null) {
//                             if (isFront) {
//                               frontImage = File(value!.path);
//                               Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                   builder: (context) => UploadPhotoId(
//                                         isFront: isFront,
//                                         frontImage: frontImage,
//                                         photoIdLabel: widget.photoIdLabel,
//                                       )));
//                               setState(() {
//                                 print('PRESSED BUTTON 2');
//                                 // isFront = false;
//                               });
//                             } else {
//                               backImage = File(value!.path);
//                               Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                   builder: (context) => UploadPhotoId(
//                                         isFront: isFront,
//                                         photoIdLabel: widget.photoIdLabel,
//                                         frontImage: frontImage,
//                                         backImage: backImage,
//                                       )));
//                               setState(() {
//                                 print('PRESSED BUTTON 2');
//                                 // isFront = false;
//                               });
//                             }
//                           }
//                         }
//                       });
//                     },
//                     child: CustomMaterialButton(
//                       label: 'Take Photo',
//                       buttonColor: buttonClr,
//                       fontColor: buttonFontClr,
//                       funcName: isFront == true
//                           ? () {
//                               cameraController.takePicture().then((file) {
//                                 if (mounted) {
//                                   if (file != null) {
//                                     frontImage = File(file.path);
//                                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                         builder: (context) => UploadPhotoId(
//                                               isFront: isFront,
//                                               frontImage: frontImage,
//                                               photoIdLabel: widget.photoIdLabel,
//                                             )));
//                                   }
//                                 }
//                               });
//
//                               setState(() {
//                                 print('PRESSED BUTTON');
//                                 // isFront = false;
//                               });
//                             }
//                           : () {
//                               cameraController.takePicture().then((file) {
//                                 if (mounted) {
//                                   if (file != null) {
//                                     backImage = File(file.path);
//
//                                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                         builder: (context) => UploadPhotoId(
//                                               isFront: isFront,
//                                               photoIdLabel: widget.photoIdLabel,
//                                               frontImage: frontImage,
//                                               backImage: backImage,
//                                             )));
//                                   }
//                                 }
//                               });
//
//                               // setState(() {
//                               //   isFront = true;
//                               // });
//                             },
//                       borderRadius: 50.w,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
