import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/dotted_container.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/dropdown.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/text_field.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_review_data_model.dart';
import 'package:help_abode_worker_app_ver_2/models/state_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_back_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../provider/working_service_provider.dart';
import '../../../widgets_reuse/custom_rounded_button.dart';
import '../screens/registration/pending_registration_screen.dart';
import 'corporate_category_selection_expandable.dart';
import 'corporate_review_details_tracker.dart';

class CorporateDocuments extends StatefulWidget {
  CorporateReviewDataModel? corporateReviewDataModel;
  String? from;
  CorporateDocuments({this.corporateReviewDataModel, this.from});

  @override
  State<CorporateDocuments> createState() => _CorporateDocumentsState();
}

class _CorporateDocumentsState extends State<CorporateDocuments> {
  File? selelctedFile;
  File? selelctedFile2;
  TextEditingController _entityCon = TextEditingController();
  TextEditingController _taxIdCon = TextEditingController();
  StateModel? selectedState;
  StateModel? selectedState2;
  bool showAdd1StateError = false;
  bool showAdd2StateError = false;
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _entityCon.dispose();
    _taxIdCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var up = context.read<WorkingServiceProvider>();
    up.getStateByIsoCode().then((v) {
      if (widget.corporateReviewDataModel != null) {
        Future.microtask(() {
          setValueToEdit(widget.corporateReviewDataModel!);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  MyCustomBackButton(onPressed: () {
                    Navigator.pop(context);
                  })
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: myColors.green,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Corporation \nDocumentation',
                          style: interText(24, Colors.black, FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade50,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 24.0),
                                        InkWell(
                                          onTap: () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'png',
                                                'jpg',
                                                'pdf',
                                                'doc',
                                                'docx'
                                              ],
                                            );
                                            if (result != null) {
                                              setState(() {
                                                selelctedFile = File(
                                                    result.files.single.path!);
                                              });
                                            } else {
                                              // User canceled the picker
                                            }
                                          },
                                          child: DottedBorderContainer(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: SvgPicture.asset(
                                                            'assets/svg/upload_icon.svg')),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: myColors.greyBg),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  selelctedFile == null
                                                      ? Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Upload Article of Incorporation',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: interText(
                                                                    14,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                              Text(
                                                                'Click or drag to upload',
                                                                style: interText(
                                                                    12,
                                                                    myColors
                                                                        .green,
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Expanded(
                                                          child: Text(selelctedFile!
                                                                      .path
                                                                      .length >
                                                                  40
                                                              ? selelctedFile!
                                                                  .path
                                                                  .substring(selelctedFile!
                                                                          .path
                                                                          .length -
                                                                      40)
                                                              : selelctedFile!
                                                                  .path))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'Entity No',
                                          style: interText(14, Colors.black,
                                              FontWeight.w600),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: CustomTextFormField(
                                            hintText: 'Entity No',
                                            controller: _entityCon,
                                            textInputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z0-9\s.,]')),
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter entity';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'State',
                                          style: interText(14, Colors.black,
                                              FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Consumer<WorkingServiceProvider>(
                                          builder: (context, pro, _) => Row(
                                            children: [
                                              Expanded(
                                                child: CustomDropdown(
                                                  items: pro.stateModelList,
                                                  selectedItem: selectedState,
                                                  hint: 'Select State',
                                                  errorMessage:
                                                      'Please select state',
                                                  isError: showAdd1StateError,
                                                  itemLabel:
                                                      (StateModel item) =>
                                                          item.title ?? '',
                                                  onChanged: (StateModel?
                                                      value) async {
                                                    print(
                                                        'Selected State: ${value?.title}');
                                                    setState(() {
                                                      selectedState = value;
                                                      showAdd1StateError =
                                                          false;
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please select an item';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    ' Article of Corporation  ',
                                    style: interText(
                                        18, Colors.black, FontWeight.w500),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade50,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 24.0),
                                        InkWell(
                                          onTap: () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'png',
                                                'jpg',
                                                'pdf',
                                                'doc',
                                                'docx'
                                              ],
                                            );
                                            if (result != null) {
                                              setState(() {
                                                selelctedFile2 = File(
                                                    result.files.single.path!);
                                              });
                                            } else {
                                              // User canceled the picker
                                            }
                                          },
                                          child: DottedBorderContainer(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: SvgPicture.asset(
                                                            'assets/svg/upload_icon.svg')),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: myColors.greyBg),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  selelctedFile2 == null
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'State sales tax certificate       ',
                                                              style: interText(
                                                                  14,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                            Text(
                                                              'Click or drag to upload',
                                                              style: interText(
                                                                  12,
                                                                  myColors
                                                                      .green,
                                                                  FontWeight
                                                                      .w400),
                                                            ),
                                                          ],
                                                        )
                                                      : Expanded(
                                                          child: Text(selelctedFile2!
                                                                      .path
                                                                      .length >
                                                                  40
                                                              ? selelctedFile2!
                                                                  .path
                                                                  .substring(selelctedFile2!
                                                                          .path
                                                                          .length -
                                                                      40)
                                                              : selelctedFile2!
                                                                  .path))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'State Sales Tax Id',
                                          style: interText(14, Colors.black,
                                              FontWeight.w600),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: CustomTextFormField(
                                            hintText: 'State Sales Tax Id',
                                            controller: _taxIdCon,
                                            textInputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z0-9\s.,]')),
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter entity';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'State',
                                          style: interText(14, Colors.black,
                                              FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Consumer<WorkingServiceProvider>(
                                          builder: (context, pro, _) => Row(
                                            children: [
                                              Expanded(
                                                child: CustomDropdown(
                                                  items: pro.stateModelList,
                                                  selectedItem: selectedState2,
                                                  hint: 'Select State',
                                                  errorMessage:
                                                      'Please select state',
                                                  isError: showAdd2StateError,
                                                  itemLabel:
                                                      (StateModel item) =>
                                                          item.title ?? '',
                                                  onChanged: (StateModel?
                                                      value) async {
                                                    print(
                                                        'Selected State: ${value?.title}');
                                                    setState(() {
                                                      selectedState2 = value;
                                                      showAdd2StateError =
                                                          false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    ' State Sales Tax Certificate ',
                                    style: interText(
                                        18, Colors.black, FontWeight.w500),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
              Consumer<CorporateProvider>(
                  builder: (context, provider, _) => Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border(top: BorderSide(color: AppColors.grey)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0C000000),
                                blurRadius: 8,
                                offset: Offset(0, -4),
                                spreadRadius: 0,
                              )
                            ]),
                        child: CustomRoundedButton(
                            height: 50.h,
                            width: 388.w,
                            controller: _controller,
                            label: 'Save & Next',
                            buttonColor: myColors.green,
                            fontColor: Colors.white,
                            funcName: provider.isLoadingAll
                                ? null
                                : () async {
                                    if (selectedState == null) {
                                      setState(() {
                                        showAdd1StateError = true;
                                      });
                                    }
                                    if (selectedState2 == null) {
                                      setState(() {
                                        showAdd2StateError = true;
                                      });
                                    }
                                    if (formKey.currentState!.validate()) {
                                      if (selelctedFile == null) {
                                        DashboardHelpers.showAlert(
                                            msg:
                                                'Please Upload Article of Incorporation');
                                        return;
                                      }
                                      if (selelctedFile2 == null) {
                                        DashboardHelpers.showAlert(
                                            msg:
                                                'Please Upload Sales Tax Certificate');
                                        return;
                                      }
                                      _controller.start();
                                      await provider.uploadCorporateDocs(
                                          selelctedFile!,
                                          _entityCon.text.trim(),
                                          selectedState!.textId ?? '',
                                          selelctedFile2!,
                                          _taxIdCon.text.trim(),
                                          selectedState2!.textId ?? '');
                                      _controller.stop();

                                      if (widget.corporateReviewDataModel !=
                                          null) {
                                        if (widget.from == 'processing') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PendingRegistrationProcess()));
                                        } else {
                                          //edit
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CorporateReviewDetailsTracker()));
                                        }
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CorporateServiceSelectionExpandable()));
                                      }
                                    }

                                    // await provider.uploadCorporateDocs(selelctedFile, _entityCon.text,selectedState,);
                                    //
                                    // if (provider.errorMessage.isNotEmpty) {
                                    //   // Show error message
                                    //   print(provider.errorMessage);
                                    // } else if (provider.response != null) {
                                    //   // Show success message or perform any other UI action
                                    //   print('Success: ${provider.response}');
                                    // }
                                  },
                            borderRadius: 8),
                      ))
            ],
          ),
        ),
      ),
    );
  }

  void setValueToEdit(CorporateReviewDataModel data) {
    var cp = context.read<WorkingServiceProvider>();
    var list = cp.stateModelList;
    setState(() {
      _entityCon.text = widget.corporateReviewDataModel!.entityNo ?? '';

      try {
        selectedState = list.firstWhere((e) =>
            e.textId == widget.corporateReviewDataModel!.articleStateTextId);
      } catch (e) {
        selectedState = null; // Set to null if not found
        debugPrint("Error finding articleStateTextId: $e");
      }

      try {
        selectedState2 = list.firstWhere((e) =>
            e.textId == widget.corporateReviewDataModel!.salesStateTextId);
      } catch (e) {
        selectedState2 = null; // Set to null if not found
        debugPrint("Error finding salesStateTextId: $e");
      }

      _taxIdCon.text = widget.corporateReviewDataModel!.salesStateTaxId ?? '';
    });

    debugPrint(selectedState?.title ?? "selectedState is null");
    debugPrint(selectedState2?.title ?? "selectedState2 is null");
  }
}
