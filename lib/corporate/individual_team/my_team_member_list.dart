import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/custom_bottom_button.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../misc/constants.dart';
import '../views/text_field.dart';
import 'add_new_member_individual.dart';

class MyTeamMemberList extends StatefulWidget {
  const MyTeamMemberList({super.key});

  @override
  State<MyTeamMemberList> createState() => _MyTeamMemberListState();
}

class _MyTeamMemberListState extends State<MyTeamMemberList> {
  late Future<bool> _future;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fnameCon = TextEditingController();
  TextEditingController lnameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  String role = 'Owner/Corporate Officer';
  String countryCodeText = '';
  String countryCodeNumber = '';
  FocusNode focusNodePhone = FocusNode();
  List<String> corporateTeamList = [
    'Owner/Corporate Officer',
    'Administrator',
    'Manager'
  ];
  final TextEditingController phoneTextFormController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void dispose() {
    // TODO: implement dispose
    fnameCon.dispose();
    lnameCon.dispose();
    emailCon.dispose();
    phoneTextFormController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    countryCodeText = 'US';
    countryCodeNumber = '1';
    CorporateProvider cp = context.read<CorporateProvider>();
    _future = Provider.of<UserProvider>(context, listen: false)
        .addNewMemberToIndividual(null, cp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Consumer<UserProvider>(
              builder: (context, pro, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      pro.addIndividualUserModelList.length > 0
                          ? 'My Teams'
                          : 'Add team member',
                      style: interText(22, Colors.black, FontWeight.bold),
                    ),
                    if (!pro.addIndividualUserModelList.isEmpty)
                      SizedBox(
                        width: 128,
                        height: 40,
                        child: RoundedLoadingButton(
                          controller: _btnController,
                          color: myColors.green,
                          animateOnTap: false,
                          onPressed: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        AddTeamMembersDashboard()));
                          },
                          child: pro.addIndividualUserModelList.length > 0
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset('assets/svg/add_icon.svg'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Invite Team',
                                        style: interText(
                                            14, Colors.white, FontWeight.w500)),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.save_alt,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: myColors.green,
                    //       borderRadius: BorderRadius.circular(40)
                    //   ),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       if (pro.addIndividualUserModelList.length > 0) {
                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMembersDashboard()));
                    //       } else {
                    //         if (_formKey.currentState!.validate()) {
                    //           var data = {"firstName": fnameCon.text.trim(), "lastName": lnameCon.text.trim(), "email": emailCon.text.trim(), "phone": phoneTextFormController.text.trim(), "countryCode": countryCodeText};
                    //           FocusScope.of(context).unfocus();
                    //           _btnController.start();
                    //           await pro.addNewMemberToIndividual(data);
                    //           _btnController.stop();
                    //         }
                    //       }
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 10),
                    //       child: pro.addIndividualUserModelList.length>0?Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           SvgPicture.asset('assets/svg/add_icon.svg'),
                    //           SizedBox(width: 4,),
                    //           Text('Add Member',style: TextStyle(color: Colors.white,fontSize: 12),),
                    //         ],
                    //       ):
                    //       Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(Icons.save_alt,color: Colors.white,size: 18,),
                    //           SizedBox(width: 4,),
                    //           Text('Save',style: TextStyle(color: Colors.white,fontSize: 14),),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<UserProvider>(
                  builder: (context, provider, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(
                                  color: myColors.green,
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return buildMemberList(context, provider);
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return Center(
                              child: Text('Nothing'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer<UserProvider>(
                builder: (context, pro, _) =>
                    pro.addIndividualUserModelList.isEmpty
                        ? CustomBottomButton(
                            btnText: 'Save & Next',
                            onpressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var data = {
                                  "firstName": fnameCon.text.trim(),
                                  "lastName": lnameCon.text.trim(),
                                  "email": emailCon.text.trim(),
                                  "designationTextId": role,
                                  "phone": phoneTextFormController.text.trim(),
                                  "countryCode": countryCodeText
                                };
                                FocusScope.of(context).unfocus();
                                _btnController.start();
                                await pro.addNewMemberToIndividual(data, null);
                                _btnController.stop();
                              }
                            },
                            btnController: _btnController,
                          )
                        : SizedBox.shrink())
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 12),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       // border: Border(top: BorderSide(color: AppColors.grey)),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Color(0x0C000000),
            //           blurRadius: 8,
            //           offset: Offset(0, -4),
            //           spreadRadius: 0,
            //         )
            //       ]),
            //   child: Consumer<UserProvider>(builder: (context, provider, _) => CustomRoundedButton(
            //             height: 44,
            //             label: provider.addIndividualUserModelList.length > 0 ? 'Add another member' : 'Add Member',
            //             buttonColor: myColors.green,
            //             fontColor: Colors.white,
            //             funcName: () async {
            //               if (provider.addIndividualUserModelList.length > 0) {
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMembersDashboard()));
            //               } else {
            //                 if (_formKey.currentState!.validate()) {
            //                   var data = {"firstName": fnameCon.text.trim(), "lastName": lnameCon.text.trim(), "email": emailCon.text.trim(), "phone": phoneTextFormController.text.trim(), "countryCode": countryCodeText};
            //
            //                   FocusScope.of(context).unfocus();
            //                   _btnController.start();
            //                   await provider.addNewMemberToIndividual(data);
            //                   _btnController.stop();
            //                 }
            //               }
            //             },
            //             borderRadius: 8,
            //             controller: _btnController,
            //           )),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildMemberList(BuildContext context, UserProvider provider) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          provider.addIndividualUserModelList.isNotEmpty
              ? GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.addIndividualUserModelList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust the number of columns as needed
                    childAspectRatio:
                        3.4 / 4.6, // Adjust the aspect ratio as needed
                    mainAxisSpacing:
                        10, // Adjust spacing between rows as needed
                    crossAxisSpacing:
                        10, // Adjust spacing between columns as needed
                  ),
                  itemBuilder: (context, index) {
                    final member = provider.addIndividualUserModelList[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: myColors.divider, width: 1)),
                      ),
                      child: GridTile(
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8, bottom: 8),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x0C11111A),
                                  blurRadius: 32,
                                  offset: Offset(0, 8),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Color(0x0C11111A),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 140.h,
                                      width: 160,
                                      alignment: Alignment.center,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0x0C11111A),
                                            blurRadius: 32,
                                            offset: Offset(0, 8),
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Color(0x0C000000),
                                            blurRadius: 16,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          '${urlBase}${member.profileImage}',
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Container(
                                                height: 130,
                                                width: 150,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  DashboardHelpers
                                                      .getFirstCharacterCombinationName(
                                                          member.firstName ??
                                                              '',
                                                          '${member.lastName}'),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: myColors.green),
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              height: 130,
                                              width: 150,
                                              alignment: Alignment.center,
                                              child: Text(
                                                DashboardHelpers
                                                    .getFirstCharacterCombinationName(
                                                        member.firstName ?? '',
                                                        '${member.lastName}'),
                                                style: TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 6,
                                      left: 6,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: member.status ==
                                                        'Documents Submitted' ||
                                                    member.status == 'Verified'
                                                ? Color(0xffc3e6cb)
                                                : Color(0xFFFAA71A)),
                                        child: Text(
                                          member.status == 'Documents Submitted'
                                              ? 'Document Submitted'
                                              : DashboardHelpers.truncateString(
                                                      member.status ?? '',
                                                      18) ??
                                                  '',
                                          style: interText(
                                              12,
                                              Color(0xff1b5e20),
                                              FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: member.status == 'Verified'
                                            ? myColors.green
                                            : Colors.red,
                                        size: 12,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        DashboardHelpers.truncateString(
                                            '${member.firstName} ${member.lastName}',
                                            14),
                                        style: interText(
                                            14, Colors.black, FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(member.email ?? '')
                              ],
                            ),
                          ),
                          onTap: () async {
                            // debugPrint('UserHelpers.invitedEmployeeStatus ${UserHelpers.invitedEmployeeStatus}');
                            // debugPrint('member.status ${member.status}');
                            //
                            // if (member.status == 'Verified' || member.status == 'Processing') {
                            //   EasyLoading.dismiss();
                            //   var cp = context.read<CorporateProvider>();
                            //   EasyLoading.show(maskType: EasyLoadingMaskType.black);
                            //   //have to different for individual
                            //   if(await cp.getMemberDetailsData(member)){
                            //     Navigator.push(
                            //         context,
                            //         CupertinoPageRoute(
                            //             builder: (context) => VerifiedMemberDetails(
                            //               member: member,
                            //             )));
                            //   }
                            //   EasyLoading.dismiss();
                            //
                            // } else if (member.status == 'Documents Submitted') {
                            //   EasyLoading.show(maskType: EasyLoadingMaskType.black);
                            //   if (await provider.getWorkerProfileDetailsData(member.textId)) {
                            //     EasyLoading.dismiss();
                            //     Navigator.push(context, CupertinoPageRoute(builder: (context) => ReviewTeamMembersSubmittedDocuments(empStatus: member.status ?? '')));
                            //   } else {
                            //     EasyLoading.dismiss();
                            //   }
                            // } else {
                            //   // EasyLoading.dismiss();
                            // }
                            var cp = context.read<CorporateProvider>();
                            DashboardHelpers.handleMemberAction(
                                context: context,
                                member: member,
                                corporateProvider: cp,
                                provider: provider);
                          },
                        ),
                      ),
                    );
                  },
                )
              : buildFormToAddMember(),
        ],
      ),
    );
  }

  Column buildFormToAddMember() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<UserProvider>(
          builder: (context, provider, _) => Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade50,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name',
                                style: text_16_black_600_TextStyle,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              CustomTextFormField(
                                hintText: 'Enter first Name',
                                controller: fnameCon,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter first name';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Name',
                                style: text_16_black_600_TextStyle,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              CustomTextFormField(
                                hintText: 'Enter last Name',
                                controller: lnameCon,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter last name';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Phone Number',
                        style: text_16_black_600_TextStyle,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //show picker
                                  showCountryPicker(
                                      context: context,
                                      countryListTheme: CountryListThemeData(
                                        flagSize: 20,

                                        backgroundColor: Colors.white,
                                        searchTextStyle:
                                            TextStyle(color: Colors.black),
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                        bottomSheetHeight: 500,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        //Optional. Styles the search field.

                                        inputDecoration: InputDecoration(
                                          fillColor: Color(0xFFE9E9E9),
                                          filled: true,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 0),
                                          hintText: 'Start typing to search',
                                          // prefixIcon: const Icon(Icons.search),
                                          prefixIcon: Container(
                                            margin: EdgeInsets.only(
                                                right: 12, left: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                // Handle icon click here
                                                print('Icon clicked');
                                              },
                                              child: const CircleAvatar(
                                                radius: 16,
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black,
                                                  size: 24,
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: const BorderSide(
                                              width: 1.5,
                                              color: Colors.black,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onSelect: (
                                        Country country,
                                      ) {
                                        countryCodeText = country.countryCode;
                                        countryCodeNumber = country.phoneCode;
                                        print(country.countryCode);
                                        setState(() {});
                                      });
                                },
                                child: Container(
                                  //height: double.maxFinite,
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                  // padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                  // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                  //EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: textfieldClr,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          '+${countryCodeNumber} (${countryCodeText}) ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        // fill: 1,
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextFormField(
                                  hintText: 'Phone Number',
                                  controller: phoneTextFormController,
                                  keyboardType: TextInputType.number,
                                  textInputFormatter: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  // funcOnChanged: (value) {
                                  //   setState(() {
                                  //     phoneText = value!;
                                  //     if (RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                                  //       isCheckPhone = true;
                                  //       // _formPhoneKey.currentState!.validate();
                                  //     } else {
                                  //       isCheckPhone = null;
                                  //     }
                                  //     //_formPhoneKey.currentState!.validate();
                                  //     print("onChange " + phoneText);
                                  //   });
                                  // },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      //setErrorInfo(true, 'Phone number is required');
                                      //focusNodePhone.requestFocus();
                                      return 'Phone number is required';
                                    }
                                    if (value.length != 10) {
                                      // setErrorInfo(true, 'Please provide a valid number');
                                      //focusNodePhone.requestFocus();
                                      return 'Please provide a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Member Email',
                        style: text_16_black_600_TextStyle,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomTextFormField(
                        hintText: 'Enter member email',
                        controller: emailCon,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      if (UserHelpers.empType == UserHelpers.empTypeCorporate)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Member Role',
                              style: text_16_black_600_TextStyle,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Role',
                                  style: TextStyle(
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                    color: myColors.greyTxt,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: corporateTeamList
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: role,
                                onChanged: (value) async {
                                  setState(() {
                                    role = value ?? '';
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 58.h,
                                  // width: 160,
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  elevation: 0,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: textfieldClr,
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: WidgetStateProperty.all(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TopInviteSection extends StatelessWidget {
  const TopInviteSection({
    super.key,
    required RoundedLoadingButtonController btnController,
    required GlobalKey<FormState> formKey,
    required this.fnameCon,
    required this.lnameCon,
    required this.emailCon,
    required this.role,
    required this.phoneTextFormController,
    required this.countryCodeText,
  })  : _btnController = btnController,
        _formKey = formKey;

  final RoundedLoadingButtonController _btnController;
  final GlobalKey<FormState> _formKey;
  final TextEditingController fnameCon;
  final TextEditingController lnameCon;
  final TextEditingController emailCon;
  final TextEditingController phoneTextFormController;
  final String countryCodeText;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Consumer<UserProvider>(
          builder: (context, pro, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  pro.addIndividualUserModelList.length > 0
                      ? 'My Teams'
                      : 'Add team member',
                  style: interText(22, Colors.black, FontWeight.bold),
                ),
                SizedBox(
                  width: 128,
                  height: 40,
                  child: RoundedLoadingButton(
                    controller: _btnController,
                    color: myColors.green,
                    animateOnTap: false,
                    onPressed: () async {
                      if (pro.addIndividualUserModelList.length > 0) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    AddTeamMembersDashboard()));
                      } else {
                        if (_formKey.currentState!.validate()) {
                          var data = {
                            "firstName": fnameCon.text.trim(),
                            "lastName": lnameCon.text.trim(),
                            "email": emailCon.text.trim(),
                            "phone": phoneTextFormController.text.trim(),
                            "countryCode": countryCodeText,
                            "role": role,
                          };
                          FocusScope.of(context).unfocus();
                          _btnController.start();
                          await pro.addNewMemberToIndividual(data, null);
                          _btnController.stop();
                        }
                      }
                    },
                    child: pro.addIndividualUserModelList.length > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset('assets/svg/add_icon.svg'),
                              SizedBox(
                                width: 4,
                              ),
                              Text('Invite Team',
                                  style: interText(
                                      14, Colors.white, FontWeight.w500)),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.save_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class CorporateTeamsWidget extends StatelessWidget {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserProvider>(
        builder: (context, pro, _) => pro.addIndividualUserModelList.length > 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'My Teams',
                          style: interText(22, Colors.black, FontWeight.bold),
                        ),
                        SizedBox(
                          width: 128,
                          height: 40,
                          child: RoundedLoadingButton(
                            controller: _btnController,
                            color: myColors.green,
                            animateOnTap: false,
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          AddTeamMembersDashboard()));
                            },
                            child: pro.addIndividualUserModelList.length > 0
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svg/add_icon.svg'),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text('Invite Team',
                                          style: interText(14, Colors.white,
                                              FontWeight.w500)),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.save_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2, // Number of tabs
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width /
                                  2, // Half screen width
                              child: TabBar(
                                dividerColor: Colors.white,
                                tabs: [
                                  Tab(text: "Member"),
                                  Tab(text: "Invitation"),
                                ],
                                indicatorColor: myColors.green,
                                labelColor: myColors.green,
                                unselectedLabelColor: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                CorporateTeamMemberListWidget(),
                                Center(child: Text("Search Screen")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : AddTeamMembersDashboard(),
      ),
    );
  }
}

class CorporateTeamMemberListWidget extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
          child: Row(
            children: [
              // Search Field
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search...",
                    filled: true,
                    // Enables the background color
                    fillColor: Colors.white,
                    // Sets the background color to white
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade50),
                      // Default grey border
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Adds rounded corners
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade50),
                      // Grey border when not focused
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      // Black border when focused
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(left: 8),
                child: DropdownButton<String>(
                  value: "Filter",
                  // Default value
                  items: [
                    DropdownMenuItem(
                      value: "Filter",
                      child: Text("Filter"),
                    ),
                    DropdownMenuItem(
                      value: "Option 1",
                      child: Text("Option 1"),
                    ),
                    DropdownMenuItem(
                      value: "Option 2",
                      child: Text("Option 2"),
                    ),
                  ],
                  onChanged: (value) {
                    print("Selected: $value");
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  underline: Container(),
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust the number of columns as needed
              childAspectRatio: 4 / 5.3, // Adjust the aspect ratio as needed
              mainAxisSpacing: 10, // Adjust spacing between rows as needed
              crossAxisSpacing: 10, // Adjust spacing between columns as needed
            ),
            itemBuilder: (context, index) {
              // final member = provider.addIndividualUserModelList[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: myColors.divider, width: 1)),
                ),
                child: GridTile(
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 8),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x0C11111A),
                            blurRadius: 32,
                            offset: Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x0C11111A),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 140.h,
                                width: 160,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x0C11111A),
                                      blurRadius: 32,
                                      offset: Offset(0, 8),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Color(0x0C000000),
                                      blurRadius: 16,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '${urlBase}',
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Container(
                                          height: 130,
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Rafid Tawhid',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: myColors.green),
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        height: 130,
                                        width: 150,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Rafid',
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 6,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffc3e6cb),
                                  ),
                                  child: Text(
                                    'Document Submitted',
                                    style: interText(
                                        12, Color(0xff1b5e20), FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: myColors.green,
                                  size: 12,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Expanded(
                          //         child: Container(
                          //       width: 40.0,
                          //       height: 40.0,
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Color(0xFFF6F6F6), // Background color of the circle
                          //       ),
                          //       child: Icon(
                          //         Icons.cleaning_services,
                          //         color: Colors.grey, // Color of the call icon
                          //         size: 20.0, // Size of the call icon
                          //       ),
                          //     )),
                          //     Expanded(
                          //         child: Container(
                          //       width: 40.0,
                          //       height: 40.0,
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Color(0xFFF6F6F6), // Background color of the circle
                          //       ),
                          //       child: Icon(
                          //         Icons.call,
                          //         color: Colors.grey, // Color of the call icon
                          //         size: 20.0, // Size of the call icon
                          //       ),
                          //     )),
                          //     Expanded(
                          //         child: Container(
                          //       width: 40.0,
                          //       height: 40.0,
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Color(0xFFF6F6F6), // Background color of the circle
                          //       ),
                          //       child: Icon(
                          //         Icons.message,
                          //         color: Colors.grey, // Color of the call icon
                          //         size: 20.0, // Size of the call icon
                          //       ),
                          //     )),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    onTap: () async {},
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
