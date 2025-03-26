import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/user_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/signin_signup_helpers.dart';
import '../../misc/constants.dart';
import '../../models/address_verification.dart';
import '../../widgets_reuse/custom_snackbar_message.dart';
import '../../widgets_reuse/custom_text_form_field.dart';
import '../dashboard/account_info_screen.dart';

class ProfileInformation extends StatefulWidget {
  static const String routeName = 'profile_information';

  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final _firstNameKey = GlobalKey<FormState>();
  final _lastNameKey = GlobalKey<FormState>();
  FocusNode _focusNodeFname = FocusNode();
  FocusNode _focusNodeLname = FocusNode();
  final _firstNameCon = TextEditingController();
  final _lastNameCon = TextEditingController();
  final _phoneNoCon = TextEditingController();
  FocusNode focusNodePhone = FocusNode();
  final _formPhoneKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  bool? _isCheckfName;
  bool _switchVal = true;
  bool? _isCheckLName;
  String _fnameText = '';
  String _lnameText = '';
  String phoneText = '';
  String countryCodeText = 'US';
  String countryCodeNumber = '1';
  final TextEditingController phoneTextFormController = TextEditingController();
  late UserProvider provider;
  AnimationController? localAnimationController;
  AddressVerification? address;
  UserModel? user;

  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);

    //set user info
    user = provider.userModel;
    //set user address
    address = provider.addressVerification;

    // provider.getUserFromSharedPref();
    // provider.getUserAddressFromSharedPref();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Account Info',
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: CurrentDevice.isAndroid() ? 18 : 24)),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: provider.btnEnable
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          var profile = {
                            "firstName": _firstNameCon.text.trim(),
                            "lastName": _lastNameCon.text.trim(),
                            "email": provider.userModel.email,
                            "phone": _phoneNoCon.text.trim(),
                            "countryCode": provider.userModel.countryCode
                          };
                          //update user info
                          EasyLoading.show(maskType: EasyLoadingMaskType.black);

                          if (await provider.updateWorkerData(profile)) {
                            EasyLoading.dismiss();
                            showCustomSnackBar(
                              context,
                              'Profile Update Successful',
                              buttonClr,
                              snackBarNeutralTextStyle,
                              localAnimationController,
                            );
                            // provider.getUserLoginInfo();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountScreen()));
                          } else {
                            EasyLoading.dismiss();
                          }
                        }
                      }
                    : null,
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                      color: Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Consumer<UserProvider>(
                        builder: (context, pro, _) => Stack(
                          children: [
                            pro.workerImageString64 == null
                                ? Container(
                                    height: 110,
                                    width:
                                        110, // You can adjust the width as needed
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/png/person2.png',
                                        scale: 1,
                                        fit: BoxFit
                                            .cover, // Ensure the image covers the circular area
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width:
                                        100, // You can adjust the width as needed
                                    child: ClipOval(
                                      child: Image.memory(
                                        pro.workerImageString64!,
                                        scale: 1,
                                        fit: BoxFit
                                            .cover, // Ensure the image covers the circular area
                                      ),
                                    ),
                                  ),
                            Positioned(
                                right: 8,
                                bottom: 0,
                                child: SvgPicture.asset(
                                    'assets/svg/cam_icon.svg')),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'First Name',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              height: 44,
                              enable: false,
                              borderRadius: 8,
                              formKey: _firstNameKey,
                              focusNode: _focusNodeFname,
                              fieldTextFieldController: _firstNameCon,
                              keyboard: TextInputType.text,
                              isCheck: _isCheckfName,
                              funcOnChanged: (value) {
                                setState(() {
                                  _fnameText = value!;
                                  if (value.isEmpty) {
                                    _isCheckfName = true;
                                    _firstNameKey.currentState!.validate();
                                  } else {
                                    _isCheckfName = null;
                                  }
                                  //_formEmailKey.currentState!.validate();
                                  print("onChange " + _fnameText);
                                });
                              },
                              funcValidate: (value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                } else {
                                  return null;
                                }
                              },
                              hintText: provider.userModel.firstName,
                              width: null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Name',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              height: 44,
                              enable: false,
                              borderRadius: 8,
                              formKey: _lastNameKey,
                              focusNode: _focusNodeLname,
                              fieldTextFieldController: _lastNameCon,
                              keyboard: TextInputType.text,
                              isCheck: _isCheckLName,
                              funcOnChanged: (value) {
                                setState(() {
                                  _lnameText = value!;
                                  if (value.isEmpty) {
                                    _isCheckLName = true;
                                    _lastNameKey.currentState!.validate();
                                  } else {
                                    _isCheckLName = null;
                                  }
                                  //_formEmailKey.currentState!.validate();
                                  print("onChange " + _lnameText);
                                });
                              },
                              funcValidate: (value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                } else {
                                  return null;
                                }
                              },
                              hintText: provider.userModel.lastName,
                              width: null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Email Address',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: myColors.greyTxt,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(
                    height: 6,
                  ),
                  CustomTextField(
                    enable: false,
                    height: 44,
                    borderRadius: 8,
                    keyboard: TextInputType.emailAddress,
                    funcOnChanged: (value) {},
                    funcValidate: (value) {
                      return null;
                    },
                    hintText: provider.userModel.email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            height: 6,
                          ),
                          GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: const CountryListThemeData(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  //showPhoneCode: true,
                                  onSelect: (Country country) {
                                    countryCodeText = country.countryCode;
                                    countryCodeNumber = country.phoneCode;
                                    print(country.countryCode);
                                    print(
                                        '$countryCodeText $countryCodeNumber');
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
                                color: textfieldClr,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: textfieldClr,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '+${countryCodeNumber} (${provider.userModel.countryCode})',
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    // color: Colors.red,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: fontClr,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: textFieldLabelTextStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: CustomTextField(
                                borderRadius: 8,
                                enable: false,
                                inputFormat: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                formKey: _formPhoneKey,
                                focusNode: focusNodePhone,
                                fieldTextFieldController:
                                    phoneTextFormController,
                                keyboard: TextInputType.number,
                                hintText: provider.userModel.phone,
                                funcOnChanged: (value) {
                                  setState(() {
                                    phoneText = value!;
                                    //_formPhoneKey.currentState!.validate();
                                    print("onChange " + phoneText);
                                  });
                                },
                                funcValidate: (value) {
                                  if (!RegExp(r"^[0-9]{10}$")
                                          .hasMatch(value!) &&
                                      value.isNotEmpty) {
                                    return 'Enter Valid Phone Number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: myColors.greyBtn,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 26),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'images/lock.svg',
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Change Password",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Save login info',
                    style: TextStyle(color: myColors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.black87, width: 1)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _switchVal = !_switchVal;
                            });
                            print('_switchVal ${_switchVal}');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 14,
                                color:
                                    _switchVal ? Colors.black87 : Colors.white,
                              ),
                              Icon(
                                Icons.circle,
                                color:
                                    _switchVal ? Colors.white : Colors.black87,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        'We save the login info, so you  won’t need to enter it on Android devices',
                        style: TextStyle(color: myColors.grey),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // CustomMaterialButton(
                  //   isLoading: false,
                  //   label: 'Save',
                  //   width: double.infinity,
                  //   buttonColor: buttonClr,
                  //   fontColor: buttonFontClr,
                  //   funcName: (){},
                  //   borderRadius: 50,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
