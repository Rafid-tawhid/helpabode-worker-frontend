import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/corporate/individual_team/widgets/address_info_bottom_sheet.dart';
import 'package:help_abode_worker_app_ver_2/corporate/individual_team/widgets/personal_info_bottom_sheet.dart';
import 'package:help_abode_worker_app_ver_2/corporate/individual_team/widgets/selfie_widget_edit_screen.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../misc/constants.dart';
import '../../../../provider/working_service_provider.dart';
import '../../../../widgets_reuse/custom_rounded_button.dart';
import '../../screens/registration/pending_registration_screen.dart';
import '../../screens/registration/select_idcard_type_screen.dart';
import '../../widgets_reuse/circular_image.dart';

// class Item {
//   Item({
//     required this.header,
//     required this.body,
//   });
//
//   final String header;
//   final String body;
// }

class ReviewTeamMembersSubmittedDocuments extends StatefulWidget {
  final String? empStatus;

  ReviewTeamMembersSubmittedDocuments({this.empStatus});

  @override
  State<ReviewTeamMembersSubmittedDocuments> createState() =>
      _ReviewTeamMembersSubmittedDocumentsState();
}

class _ReviewTeamMembersSubmittedDocumentsState
    extends State<ReviewTeamMembersSubmittedDocuments> {
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();
  bool check1 = false;
  bool check2 = false;
  bool personal = false;
  bool address = false;
  bool verification = false;
  late UserProvider userProvider;
  String loggedUserEmpType = '';
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // set the status bar color here
      statusBarIconBrightness: Brightness.dark, // set the icon brightness
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of(context, listen: false);
      loggedUserEmpType = DashboardHelpers.userModel!.employeeType ?? '';
      _scrollController.addListener(_onScroll);
      userProvider.showTitle(false);
      debugPrint('loggedUserEmpType ${widget.empStatus}');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Consumer<UserProvider>(
          builder: (context, pro, _) => pro.showTitleM
              ? Text(
                  'Review member details',
                  style: interText(
                    20,
                    Colors.black,
                    FontWeight.w700,
                  ),
                )
              : Text(''),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) => Stack(
            children: [
              ListView(
                controller: _scrollController,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Review team member details',
                      textAlign: TextAlign.left,
                      style: interText(
                        24,
                        Colors.black,
                        FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text(
                        loggedUserEmpType == UserHelpers.empTypeUnderProvider ||
                                loggedUserEmpType ==
                                    UserHelpers.empTypeCorporateMember
                            ? 'Please review your entered details before finalizing the registration.'
                            : 'Please review the details entered by your team member before finalizing the registration.',
                        style: interText(16, myColors.greyTxt, FontWeight.w400)
                            .copyWith(letterSpacing: 0)),
                  ),
                  Column(
                    children: [
                      if (provider.teamUserModel.employeeType ==
                              UserHelpers.empTypeUnderProvider ||
                          provider.teamUserModel.employeeType ==
                              UserHelpers.empTypeCorporateMember)
                        Consumer<UserProvider>(
                            builder: (context, provider, _) =>
                                CircularImageDisplay(
                                  imageUrl:
                                      '${urlBase}${provider.teamImageUrl}',
                                  firstName:
                                      provider.teamUserModel.firstName ?? '',
                                  lastName:
                                      provider.teamUserModel.lastName ?? '',
                                  email: provider.teamUserModel.email ?? '',
                                  size: 160,
                                  nameStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  emailStyle: TextStyle(
                                      fontSize: 14,
                                      color: myColors.greyTxt,
                                      fontWeight: FontWeight.w400),
                                )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          height: 2,
                          color: myColors.devider,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            getTypeColor(widget.empStatus ?? '')
                                                ? myColors.grey
                                                : myColors.green,
                                        width: 2),
                                  ),
                                  child: getTypeColor(widget.empStatus)
                                      ? Text(
                                          '1',
                                          style: interText(16, Colors.black,
                                              FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: myColors.green,
                                          size: 18,
                                        ))),
                          Expanded(
                              child: Text(
                            'Personal information',
                            style: interText(16, Colors.black, FontWeight.w600),
                          )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                personal = !personal;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(personal
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up),
                            ),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      personal == false
                          ? SizedBox(
                              height: loggedUserEmpType ==
                                          UserHelpers.empTypeUnderProvider ||
                                      loggedUserEmpType ==
                                          UserHelpers.empTypeCorporateMember
                                  ? 160
                                  : 100,
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.transparent,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 2,
                                          color: getTypeColor(
                                                  widget.empStatus ?? '')
                                              ? myColors.grey
                                              : myColors.green)
                                    ],
                                    alignment: Alignment.center,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          // Group text rows
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    'First Name : ${provider.teamUserModel.firstName}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Last Name : ${provider.teamUserModel.lastName}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Email : ${provider.teamUserModel.email}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Phone number : ${provider.teamUserModel.phone}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (loggedUserEmpType ==
                                                UserHelpers
                                                    .empTypeUnderProvider ||
                                            loggedUserEmpType ==
                                                UserHelpers
                                                    .empTypeCorporateMember)
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                // Action row
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      debugPrint(provider
                                                          .teamUserModel
                                                          .employeeType);
                                                      debugPrint(UserHelpers
                                                          .empTypeUnderProvider);
                                                      personalInformationModalBottomSheet(
                                                          context,
                                                          provider
                                                              .teamUserModel);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              myColors.greyBtn,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 6.0,
                                                                horizontal: 16),
                                                        child: Text(
                                                          'Edit Info',
                                                          style: interText(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: Text(''))
                                                  // Optional spacer for alignment
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 16,
                              alignment: Alignment.center,
                              child: Container(
                                height: 1,
                                color: myColors.devider,
                              ),
                            ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            getTypeColor(widget.empStatus ?? '')
                                                ? myColors.grey
                                                : myColors.green,
                                        width: 2)),
                                child: getTypeColor(widget.empStatus ?? '')
                                    ? Text(
                                        '2',
                                        style: interText(
                                            16, Colors.black, FontWeight.w500),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: myColors.green,
                                        size: 18,
                                      ),
                              )),
                          Expanded(
                              child: Text(
                            'Address',
                            style: interText(16, Colors.black, FontWeight.w600),
                          )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                address = !address;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(address
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up),
                            ),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      address == false
                          ? SizedBox(
                              height: loggedUserEmpType ==
                                          UserHelpers.empTypeUnderProvider ||
                                      loggedUserEmpType ==
                                          UserHelpers.empTypeCorporateMember
                                  ? 174.h
                                  : 132.h,
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.transparent,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 2,
                                          color: getTypeColor(
                                                  widget.empStatus ?? '')
                                              ? myColors.grey
                                              : myColors.green)
                                    ],
                                    alignment: Alignment.center,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          // Group text rows
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    'Address Line 1 : ${provider.teanAddressVerification.addressLine1Data}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            if (provider.teanAddressVerification
                                                    .addressLine2Data !=
                                                '')
                                              Row(
                                                children: [
                                                  Text(
                                                      'Address Line 2 : ${provider.teanAddressVerification.addressLine2Data}',
                                                      style: interText(
                                                              14,
                                                              Color(0xff535151),
                                                              FontWeight.w500)
                                                          .copyWith(
                                                              letterSpacing: 0))
                                                ],
                                              ),
                                            Row(
                                              children: [
                                                Text(
                                                    'State : ${provider.teanAddressVerification.stateData}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'City : ${provider.teanAddressVerification.cityData}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Zip code : ${provider.teanAddressVerification.zipData}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (loggedUserEmpType ==
                                                UserHelpers
                                                    .empTypeUnderProvider ||
                                            loggedUserEmpType ==
                                                UserHelpers
                                                    .empTypeCorporateMember)
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                // Action row
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: myColors.greyBtn,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        WorkingServiceProvider
                                                            pro;
                                                        pro = Provider.of<
                                                                WorkingServiceProvider>(
                                                            context,
                                                            listen: false);
                                                        EasyLoading.show(
                                                            maskType:
                                                                EasyLoadingMaskType
                                                                    .black);
                                                        await pro
                                                            .getStateByIsoCode();
                                                        EasyLoading.dismiss();
                                                        addressInformationModalBottomSheet(
                                                            context,
                                                            provider
                                                                .teanAddressVerification);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 6.0,
                                                                horizontal: 16),
                                                        child: Text(
                                                          'Edit Address',
                                                          style: interText(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: Text(''))
                                                  // Optional spacer for alignment
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 16,
                              alignment: Alignment.center,
                              child: Container(
                                height: 1,
                                color: myColors.devider,
                              ),
                            ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            getTypeColor(widget.empStatus ?? '')
                                                ? myColors.grey
                                                : myColors.green,
                                        width: 2)),
                                child: getTypeColor(widget.empStatus ?? '')
                                    ? Text(
                                        '3',
                                        style: interText(
                                            16, Colors.black, FontWeight.w500),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: myColors.green,
                                        size: 18,
                                      ),
                              )),
                          Expanded(
                              child: Text(
                            'Verification Documents',
                            style: interText(16, Colors.black, FontWeight.w600),
                          )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                verification = !verification;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(verification
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up),
                            ),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      verification == false
                          ? SizedBox(
                              height: loggedUserEmpType ==
                                          UserHelpers.empTypeUnderProvider ||
                                      loggedUserEmpType ==
                                          UserHelpers.empTypeCorporateMember
                                  ? 220
                                  : 180,
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.transparent,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: Container(
                                            width: 2,
                                            color: getTypeColor(
                                                    widget.empStatus ?? '')
                                                ? Colors.transparent
                                                : Colors.transparent),
                                      )
                                    ],
                                    alignment: Alignment.center,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    'Photo Id : ${provider.teamUserModel.photoIdType}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ShowPhotoIdAlert(
                                                            loggedUserEmpType:
                                                                loggedUserEmpType);
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12.0),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                myColors.greyBg,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 6.0,
                                                                  horizontal:
                                                                      10),
                                                          child: Text(
                                                            'View',
                                                            style: TextStyle(
                                                                color: myColors
                                                                    .green),
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Text('Selfie : Submitted',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            16),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Selfie',
                                                                      style: interText(
                                                                          16,
                                                                          Colors
                                                                              .black,
                                                                          FontWeight
                                                                              .w600),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Image
                                                                    .network(
                                                                  '${urlBase}${provider.teamImageUrl}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 200,
                                                                  width: 300,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    } else {
                                                                      return Stack(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                200,
                                                                            width:
                                                                                300,
                                                                            child:
                                                                                Image.asset(
                                                                              'images/placeholder.jpg',
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          CircularProgressIndicator()
                                                                        ],
                                                                      );
                                                                    }
                                                                  },
                                                                  errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          error,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    return Container(
                                                                      height:
                                                                          200,
                                                                      width:
                                                                          300,
                                                                      color: Colors
                                                                          .grey,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            50,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              if (loggedUserEmpType ==
                                                                      UserHelpers
                                                                          .empTypeUnderProvider ||
                                                                  loggedUserEmpType ==
                                                                      UserHelpers
                                                                          .empTypeCorporateMember)
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          // Add your edit functionality here

                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => SelfieWidgetEditScreen()));

                                                                          // Navigator.pop(context); // Close the dialog
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.edit,
                                                                              color: Colors.white,
                                                                            ),
                                                                            Text(
                                                                              'Edit',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ],
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                myColors.green),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                myColors.green),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context); // Close the dialog
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Close',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12.0),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                myColors.greyBg,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 6.0,
                                                                  horizontal:
                                                                      10),
                                                          child: Text(
                                                            'View',
                                                            style: TextStyle(
                                                                color: myColors
                                                                    .green),
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${provider.teamUserModel.photoIdType} No : ${provider.teamUserModel.photoIdNo}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    'Expiry Date : ${provider.teamUserModel.photoIdExpirationDate}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'SSN : ${provider.teamUserModel.ssn}',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Container(
                                                height: 1,
                                                color: myColors.devider),
                                            if (loggedUserEmpType !=
                                                    UserHelpers
                                                        .empTypeUnderProvider ||
                                                loggedUserEmpType ==
                                                    UserHelpers
                                                        .empTypeCorporateMember)
                                              SizedBox(
                                                height: 20,
                                              )
                                          ],
                                        ),
                                        if (loggedUserEmpType ==
                                                UserHelpers
                                                    .empTypeUnderProvider ||
                                            loggedUserEmpType ==
                                                UserHelpers
                                                    .empTypeCorporateMember)
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                // Action row
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      provider
                                                          .setEditValue(true);

                                                      //set uploaded image to photo id screen
                                                      EasyLoading.show(
                                                          maskType:
                                                              EasyLoadingMaskType
                                                                  .black);
                                                      await SignInSignUpHelpers
                                                          .convertUrlImageToFile(
                                                              '${urlBase}${provider.photoId1}',
                                                              'front');
                                                      await SignInSignUpHelpers
                                                          .convertUrlImageToFile(
                                                              '${urlBase}${provider.photoId2}',
                                                              'back');
                                                      EasyLoading.dismiss();

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SelectIdCardTypeScreen(
                                                                    from:
                                                                        'corporate',
                                                                    hasPreviousData:
                                                                        true,
                                                                    cardNo: provider
                                                                        .teamUserModel
                                                                        .photoIdNo,
                                                                    prevDate: provider
                                                                        .teamUserModel
                                                                        .photoIdExpirationDate,
                                                                    cardType: provider
                                                                        .teamUserModel
                                                                        .photoIdType,
                                                                  )));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              myColors.greyBtn,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 6.0,
                                                                horizontal: 16),
                                                        child: Text(
                                                          'Edit Documents',
                                                          style: interText(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: Text(''))
                                                  // Optional spacer for alignment
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 16,
                              alignment: Alignment.center,
                              child: Container(
                                height: 1,
                                color: myColors.devider,
                              ),
                            ),
                      loggedUserEmpType == UserHelpers.empTypeUnderProvider ||
                              loggedUserEmpType ==
                                  UserHelpers.empTypeCorporateMember
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey, width: 2)),
                                    child: Text('4',
                                        style: interText(
                                            14, Colors.black, FontWeight.w600)),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  'Complete your sign up',
                                  style: interText(
                                      16, Colors.black, FontWeight.w600),
                                )),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.empStatus ==
                                    UserHelpers.empTypeUnderProviderReview)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4),
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            activeColor: myColors.green,
                                            value: check1,
                                            onChanged: (val) {
                                              setState(() {
                                                check1 = !check1;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  check1 = !check1;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    'I acknowledge that all information provided is true and accurate to the best of my knowledge. I understand that any falsification or misrepresentation of information may result in disciplinary action, up to and including termination of account.',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w400)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                              )))
                                    ],
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (widget.empStatus ==
                                    UserHelpers.empTypeUnderProviderReview)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4),
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            activeColor: myColors.green,
                                            value: check2,
                                            onChanged: (val) {
                                              setState(() {
                                                check2 = !check2;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            check2 = !check2;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: [
                                                TextSpan(
                                                    text:
                                                        'I hereby confirm that ',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w400)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                                TextSpan(
                                                  text:
                                                      '${provider.teamUserModel.firstName} ${provider.teamUserModel.lastName} ',
                                                  style: interText(
                                                    14,
                                                    myColors.green,
                                                    FontWeight.w600,
                                                  ).copyWith(letterSpacing: 0),
                                                ),
                                                TextSpan(
                                                    text:
                                                        'is authorized to work. This authorization is in compliance with all relevant employment laws and regulations.',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w400)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                                TextSpan(
                                                  text:
                                                      ' ${provider.teamUserModel.firstName} ${provider.teamUserModel.lastName} ',
                                                  style: interText(
                                                    14,
                                                    myColors.green,
                                                    FontWeight.w600,
                                                  ).copyWith(letterSpacing: 0),
                                                ),
                                                TextSpan(
                                                    text:
                                                        'has successfully completed all necessary documentation and verification processes required to legally work in ',
                                                    style: interText(
                                                            14,
                                                            Color(0xff535151),
                                                            FontWeight.w400)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                                TextSpan(
                                                  text:
                                                      '${provider.teamUserModel.countryName}',
                                                  style: interText(
                                                    14,
                                                    myColors.green,
                                                    FontWeight.w600,
                                                  ).copyWith(letterSpacing: 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
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
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Consumer<UserProvider>(
                        builder: (context, provider, _) => CustomRoundedButton(
                          height: 44,
                          label: loggedUserEmpType ==
                                      UserHelpers.empTypeUnderProvider ||
                                  loggedUserEmpType ==
                                      UserHelpers.empTypeCorporateMember
                              ? 'Confirm'
                              : 'Submit Document',
                          buttonColor: myColors.green,
                          fontColor: Colors.white,
                          funcName: loggedUserEmpType ==
                                      UserHelpers.empTypeUnderProvider ||
                                  loggedUserEmpType ==
                                      UserHelpers.empTypeCorporateMember
                              ? () async {
                                  userProvider.setAjiraStatus(
                                      UserHelpers.empTypeUnderProvider);
                                  setState(() {});
                                  controller.start();
                                  await provider
                                      .submitAcknowledgementCheckbox();
                                  controller.stop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingRegistrationProcess()));
                                }
                              : (check1 == true && check2 == true)
                                  ? () async {
                                      //changed feb 10
                                      // userProvider.setAjiraStatus(UserHelpers.empTypeUnderProvider);
                                      setState(() {});
                                      //update checkbox
                                      DashboardHelpers.showAlert(
                                          msg: 'Member Verified Successfully');
                                      await userProvider
                                          .submitPendingMemberDetailsInfoCheckbox(
                                              userProvider
                                                      .teamUserModel.textId ??
                                                  '');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardScreen()));
                                    }
                                  : null,
                          borderRadius: 8,
                          controller: controller,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getLoginUserEmployeeStatus() async {
    loggedUserEmpType = DashboardHelpers.userModel!.employeeType ?? '';
    debugPrint('GET USER EMP TYPE${loggedUserEmpType}');
    debugPrint('GET USER ${UserHelpers.empTypeUnderProvider}');
    setState(() {});
  }

  void _onScroll() {
    // Check how far the user has scrolled
    var up = context.read<UserProvider>();
    if (_scrollController.position.maxScrollExtent > 0) {
      double scrollPosition = _scrollController.position.pixels;
      double maxScroll = _scrollController.position.maxScrollExtent;

      // If the user scrolls 10% from the bottom, show the title
      if (scrollPosition >= maxScroll * 0.1) {
        up.showTitle(true);
      } else {
        up.showTitle(false);
      }
    }
  }

  bool getTypeColor(String? empStatus) {
    if (check1 == true && check2 == true) {
      return false;
    } else if (empStatus != 'Documents Submitted') {
      return false;
    } else {
      return true;
    }
  }
}

class ShowPhotoIdAlert extends StatelessWidget {
  const ShowPhotoIdAlert({
    super.key,
    required this.loggedUserEmpType,
  });

  final String loggedUserEmpType;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, provider, _) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${provider.teamUserModel.photoIdType}',
                        style: interText(16, Colors.black, FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Front Image',
                        style: interText(14, myColors.greyTxt, FontWeight.w500)
                            .copyWith(letterSpacing: 0)),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      '${urlBase}${provider.photoId1}',
                      fit: BoxFit.cover,
                      height: 188,
                      width: 300,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 188,
                                width: 300,
                                child: Image.asset(
                                  'images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              CircularProgressIndicator()
                            ],
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          height: 188,
                          width: 300,
                          color: Colors.grey,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Back Image',
                        style: interText(14, myColors.greyTxt, FontWeight.w500)
                            .copyWith(letterSpacing: 0)),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      '${urlBase}${provider.photoId2}',
                      fit: BoxFit.cover,
                      height: 188,
                      width: 300,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: 300,
                                child: Image.asset(
                                  'images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              CircularProgressIndicator()
                            ],
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          height: 188,
                          width: 300,
                          color: Colors.grey,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  if (loggedUserEmpType == UserHelpers.empTypeUnderProvider ||
                      loggedUserEmpType == UserHelpers.empTypeCorporateMember)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              //set a value for edit screen
                              provider.setEditValue(true);
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black);
                              await SignInSignUpHelpers.convertUrlImageToFile(
                                  '${urlBase}${provider.photoId1}', 'front');
                              await SignInSignUpHelpers.convertUrlImageToFile(
                                  '${urlBase}${provider.photoId2}', 'back');
                              EasyLoading.dismiss();

                              //set previous value
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectIdCardTypeScreen(
                                            from: 'corporate',
                                            hasPreviousData: true,
                                            cardNo: provider
                                                .teamUserModel.photoIdNo,
                                            prevDate: provider.teamUserModel
                                                .photoIdExpirationDate,
                                            cardType: provider
                                                .teamUserModel.photoIdType,
                                          )));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                              mainAxisSize: MainAxisSize.min,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myColors.green),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myColors.green),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ));
  }
}
