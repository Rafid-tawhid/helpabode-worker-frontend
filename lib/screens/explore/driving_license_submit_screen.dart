import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/worker_pending_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/pending_licence_show_shimmer_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../corporate/views/text_field.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../provider/user_provider.dart';
import '../../widgets_reuse/custom_rounded_button.dart';
import 'document_screen.dart';

class DrivingLicenseSubmitScreen extends StatefulWidget {
  String? idNo;
  String? date;

  DrivingLicenseSubmitScreen({this.idNo, this.date});

  @override
  State<DrivingLicenseSubmitScreen> createState() =>
      _DrivingLicenseSubmitScreenState();
}

class _DrivingLicenseSubmitScreenState
    extends State<DrivingLicenseSubmitScreen> {
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();
  String? _fronImage;
  String? _backImage;
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();
  final TextEditingController _idCon = TextEditingController();
  final TextEditingController _expDate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDateTime;
  String? selectedDateText;
  String? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idCon.text = widget.idNo ?? '';
    _expDate.text = widget.date ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  'Verify Your\nDocument',
                  style: interText(30, Colors.black, FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffe9e9e9),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Please update your driving license number and expiration date as well.'),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          var wp = context.read<WorkerPendingProvider>();
                          showCustomBottomSheet(context, wp);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 10),
                            child: Text(
                              'Update Info',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Consumer<WorkerPendingProvider>(builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            _fronImage == null
                                ? NetworkImageWithShimmer(
                                    imageUrl:
                                        '${urlBase}${provider.documentUpdateInfoList.first.issueFor![0]}',
                                    placeholder: 'assets/svg/front.svg',
                                    width:
                                        MediaQuery.sizeOf(context).width * .9,
                                    height: 220,
                                    borderRadius: 8,
                                  )
                                : Image.file(
                                    File(_fronImage!),
                                    width:
                                        MediaQuery.sizeOf(context).width * .9,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: InkWell(
                                    onTap: () async {
                                      _showImagePickerOptions(context, 'Front');
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
                            _backImage == null
                                ? NetworkImageWithShimmer(
                                    borderRadius: 8,
                                    imageUrl:
                                        '${urlBase}${provider.documentUpdateInfoList.first.issueFor![1]}',
                                    placeholder: 'assets/svg/back.svg',
                                    width:
                                        MediaQuery.sizeOf(context).width * .9,
                                    height: 220,
                                  )
                                // ?Image.network('${urlBase}${provider.documentUpdateInfoList.first.issueFor![1]}',height: 220,width: MediaQuery.sizeOf(context).width * .9)
                                : Image.file(
                                    File(_backImage!),
                                    width:
                                        MediaQuery.sizeOf(context).width * .9,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: InkWell(
                                    onTap: () async {
                                      _showImagePickerOptions(context, 'Back');
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
                    Consumer<WorkerPendingProvider>(
                      builder: (context, provider, _) {
                        if (_backImage == null && _fronImage == null) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        6), // Change the radius here
                                  ),
                                  elevation: 0,
                                  backgroundColor: Color(0xffe9e9e9)),
                              onPressed: () {
                                print(
                                    '${urlBase}${provider.documentUpdateInfoList.first.issueFor![0]}');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Resubmit',
                                      style: interText(16, Colors.black54,
                                              FontWeight.w600)
                                          .copyWith(letterSpacing: 0),
                                    ),
                                  ),
                                ],
                              ));
                        } else {
                          return RoundedLoadingButton(
                              color: myColors.green,
                              controller: controller,
                              onPressed: () async {
                                controller.start();
                                if (await provider.postWorkerDocumentUpdate(
                                    stage: PendingStatus.photo,
                                    img1: _fronImage == null
                                        ? null
                                        : File(_fronImage!),
                                    img2: _backImage == null
                                        ? null
                                        : File(_backImage!),
                                    id: _idCon.text,
                                    date: _expDate.text)) {
                                  DashboardHelpers.successStopAnimation(
                                      controller);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DocumentScreen()));
                                } else {
                                  DashboardHelpers.errorStopAnimation(
                                      controller);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Upload',
                                      style: interText(
                                          16, Colors.white, FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
    ;
  }

  void _showImagePickerOptions(BuildContext context, String side) {
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
                onTap: () {
                  _pickImage(ImageSource.camera, side);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery, side);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _pickImage(ImageSource source, BuildContext context, String side) async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: source);
  //   if (image != null) {
  //     Navigator.of(context).pop(); // Close the dialog
  //     // Process the picked image
  //     if (side == 'Front') {
  //       setState(() {
  //         _fronImage = image.path;
  //       });
  //     } else {
  //       setState(() {
  //         _backImage = image.path;
  //       });
  //     }
  //   }
  // }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Enter Details'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID No.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _idCon,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(40),
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'[^\w\d]'))
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ID number is required';
                              }
                              if (value.length < 4) {
                                return 'Please provide a valid ID';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'XXXXXXXXXX',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expiration Date',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              DateTime? pickedDate =
                                  await DatePicker.showSimpleDatePicker(
                                context,
                                backgroundColor: Colors.white,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050),
                                dateFormat: "dd-MM-yyyy",
                                locale: DateTimePickerLocale.en_us,
                                looping: true,
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDateTime = pickedDate;
                                  selectedDateText = DateFormat('MM-dd-yyyy')
                                      .format(pickedDate);
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedDateText ?? 'Select Date',
                                    style:
                                        GoogleFonts.roboto(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.date_range_sharp,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.of(context).pop();
                      // Perform any additional actions if needed
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _pickImage(ImageSource pickGalleryImage, String side) async {
    XFile? image;
    final picker = ImagePicker();

    if (pickGalleryImage == ImageSource.gallery) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (side == 'Front') {
        setState(() {
          _fronImage = croppedImage.path;
        });
      } else {
        setState(() {
          _backImage = croppedImage.path;
        });
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

  void showCustomBottomSheet(BuildContext context, WorkerPendingProvider pro) {
    _idCon.text = pro.documentUpdateInfoList.first.photoIdNo ?? '';
    _expDate.text =
        pro.documentUpdateInfoList.first.photoIdExpirationDate ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Update ID number & Expiry date',
                          style: interText(20, Colors.black, FontWeight.w600)
                              .copyWith(letterSpacing: 0)),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _idCon,
                      labelText: 'Id Number',
                      keyboardType: TextInputType.number,
                      fillColor: Colors.grey.shade50,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(11)
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Id Number is required';
                        }
                        if (value.length < 6) {
                          return 'Please provide a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: 'Expiry Date',
                      readOnly: true,
                      ontap: () async {
                        var selectedDate =
                            await DashboardHelpers.selectExpiryDate(context);
                        if (selectedDate != null) {
                          debugPrint('selected date $selectedDate');
                          setState(() {
                            _expDate.text = selectedDate ?? '';
                          });
                        }
                      },
                      controller: _expDate,
                      keyboardType: TextInputType.datetime,
                      fillColor: Colors.grey.shade50,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Consumer<UserProvider>(
                        builder: (context, provider, _) => CustomRoundedButton(
                          height: 44,
                          label: 'Save & Update',
                          buttonColor: myColors.green,
                          fontColor: Colors.white,
                          controller: controller,
                          funcName: () async {
                            if (_formKey.currentState!.validate()) {
                              var provider =
                                  context.read<WorkerPendingProvider>();
                              controller.start();
                              if (await provider.postWorkerDocumentUpdate(
                                  stage: PendingStatus.photo,
                                  img1: _fronImage == null
                                      ? null
                                      : File(_fronImage!),
                                  img2: _backImage == null
                                      ? null
                                      : File(_backImage!),
                                  id: _idCon.text,
                                  date: _expDate.text)) {
                                DashboardHelpers.successStopAnimation(
                                    controller);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DocumentScreen()));
                              } else {
                                DashboardHelpers.errorStopAnimation(controller);
                              }
                            }
                          },
                          borderRadius: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
