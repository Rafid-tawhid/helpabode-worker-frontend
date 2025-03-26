import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/corporate/individual_team/member_account_screen.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/screens/profile/set_new_password.dart';
import 'package:provider/provider.dart';

import '../../launcher_screen.dart';
import '../../misc/constants.dart';
import '../../provider/navbar_provider.dart';
import '../../provider/user_provider.dart';
import '../../widgets_reuse/circular_cached_image.dart';
import '../../widgets_reuse/custom_snackbar_message.dart';
import '../../widgets_reuse/new_text_formfield.dart';
import '../../widgets_reuse/show_image_chose_popup.dart';
import '../dashboard/account_info_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = 'profile_edit';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCon = TextEditingController();
  final _lastNameCon = TextEditingController();
  final _phoneNoCon = TextEditingController();
  final _add1Con = TextEditingController();
  final _add2Con = TextEditingController();
  final _zipCon = TextEditingController();
  final _cityCon = TextEditingController();

  FocusNode _fnameNode = FocusNode();
  FocusNode _lnameNode = FocusNode();
  FocusNode _add1Node = FocusNode();
  FocusNode _cityNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _zipNode = FocusNode();
  bool? _isCheckfName;
  bool? _isCheckLName;
  String _fnameText = '';
  String _lnameText = '';
  String phoneText = '';
  String add1Text = '';
  String add2Text = '';

  // String? stateText;
  String stateText = 'California';
  String cityText = '';
  String zipText = '';
  String countryCodeText = 'US';
  String countryCodeNumber = '1';

  // String? _dob;

  late UserProvider provider;
  bool callOnce = true;
  String? stateValue;
  AnimationController? localAnimationController;
  String profileImage = '';

  @override
  void dispose() {
    _fnameNode.dispose();
    _lnameNode.dispose();
    _add1Node.dispose();
    _cityNode.dispose();
    _zipNode.dispose();
    _phoneNode.dispose();
    _firstNameCon.dispose();
    _lastNameCon.dispose();
    _phoneNoCon.dispose();
    _add1Con.dispose();
    _add2Con.dispose();
    _zipCon.dispose();
    _cityCon.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (callOnce) {
      provider = Provider.of<UserProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.getUserFromProvider();
        provider.getUserAddressFromSharedPref();
      });

      _firstNameCon.text = provider.userModel.firstName ?? '';
      _lastNameCon.text = provider.userModel.lastName ?? '';
      _phoneNoCon.text = provider.userModel.phone ?? '';
      _add1Con.text = provider.addressVerification.addressLine1Data ?? '';
      _add2Con.text = provider.addressVerification.addressLine2Data ?? '';
      _zipCon.text = provider.addressVerification.zipData ?? '';
      _cityCon.text = provider.addressVerification.cityData ?? '';
      callToDisableButton();
      callOnce = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Account Info',
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: CurrentDevice.isAndroid() ? 16 : 22)),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            Consumer<UserProvider>(
              builder: (context, provider, _) => InkWell(
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
                            var data = context.read<UserProvider>();
                            debugPrint('usermodel ${data.userModel.toJson()}');
                            data.setUserInfo(
                                _firstNameCon.text.trim(),
                                _lastNameCon.text.trim(),
                                _phoneNoCon.text.trim());

                            showCustomSnackBar(
                              context,
                              'Profile Update Successful',
                              buttonClr,
                              snackBarNeutralTextStyle,
                              localAnimationController,
                            );
                            // provider.getUserLoginInfo();

                            if (UserHelpers.empType ==
                                UserHelpers.empTypeUnderProvider) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MemberAccountScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountScreen()));
                            }
                          } else {
                            EasyLoading.dismiss();
                          }
                        }
                      }
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: provider.btnEnable
                              ? myColors.greyBtn
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12),
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: provider.btnEnable
                                  ? Colors.black87
                                  : myColors.greyBtn,
                              fontSize: CurrentDevice.isAndroid() ? 14 : 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: Consumer<UserProvider>(
          builder: (context, provider, _) => SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'account',
                            child: Container(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Consumer<UserProvider>(
                                      builder: (context, pro, _) => provider
                                                  .selfyImage ==
                                              null
                                          ? CircularProfileImage(
                                              pro.userImageUrl,
                                              pro.userModel.firstName ?? '',
                                              pro.userModel.lastName ?? '',
                                              myColors.primaryColor,
                                              110,
                                            )
                                          : Container(
                                              height: 110,
                                              width:
                                                  110, // You can adjust the width as needed
                                              child: ClipOval(
                                                  child: Image.file(
                                                File(provider.selfyImage!.path),
                                                fit: BoxFit.cover,
                                              )),
                                            )),
                                  Positioned(
                                      right: 8,
                                      bottom: 0,
                                      child: InkWell(
                                          onTap: () {
                                            showImageSelectionDialog(context);
                                          },
                                          child: SvgPicture.asset(
                                              'assets/svg/cam_icon.svg'))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    NewCustomTextField(
                                      height: 44,
                                      enable: true,
                                      borderRadius: 8,
                                      focusNode: _fnameNode,
                                      fieldTextFieldController: _firstNameCon,
                                      keyboard: TextInputType.text,
                                      isCheck: _isCheckfName,
                                      funcOnChanged: (value) {
                                        setState(() {
                                          _fnameText = value!;
                                          if (value.isEmpty) {
                                            _isCheckfName = null;
                                          } else {
                                            _isCheckfName = true;
                                          }
                                          //_formEmailKey.currentState!.validate();
                                          print("onChange " + _fnameText);
                                        });
                                        calltoChangeUpdateButton(
                                            value,
                                            _lastNameCon.text,
                                            _phoneNoCon.text,
                                            _add1Con.text,
                                            _add2Con.text,
                                            stateText,
                                            _zipCon.text,
                                            _cityCon.text);
                                      },
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null || value.isEmpty) {
                                          setErrorInfo(true, 'Required');
                                          _fnameNode.requestFocus();
                                          return '';
                                        } // Reset error info if validation passes
                                        return null;
                                      },
                                      hintText: 'First Name',
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
                                    NewCustomTextField(
                                      height: 44,
                                      enable: true,
                                      borderRadius: 8,
                                      focusNode: _lnameNode,
                                      fieldTextFieldController: _lastNameCon,
                                      keyboard: TextInputType.text,
                                      isCheck: _isCheckLName,
                                      funcOnChanged: (value) {
                                        setState(() {
                                          _lnameText = value!;
                                          if (value.isEmpty) {
                                            _isCheckLName = null;
                                          } else {
                                            _isCheckLName = true;
                                          }
                                          //_formEmailKey.currentState!.validate();
                                          print("onChange " + _lnameText);
                                        });
                                        calltoChangeUpdateButton(
                                            _firstNameCon.text,
                                            value,
                                            _phoneNoCon.text,
                                            _add1Con.text,
                                            _add2Con.text,
                                            stateText,
                                            _zipCon.text,
                                            _cityCon.text);
                                      },
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null || value.isEmpty) {
                                          setErrorInfo(true, 'Required');
                                          _lnameNode.requestFocus();
                                          return 'Required';
                                        } // Reset error info if validation passes
                                        return null;
                                      },
                                      hintText: 'Last Name',
                                      width: null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
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
                          NewCustomTextField(
                            enable: false,
                            height: 44,
                            borderRadius: 8,
                            keyboard: TextInputType.emailAddress,
                            funcOnChanged: (value) {},
                            funcValidate: (value, setErrorInfo) {
                              return null;
                            },
                            hintText: provider.userModel.email,
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          // Text('Date of Birth',
                          //     style: GoogleFonts.inter(
                          //       fontSize: 16,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w600,
                          //     )),
                          //
                          // const SizedBox(
                          //   height: 6,
                          // ),
                          // InkWell(
                          //   onTap: () async {
                          //     _showDobPicker();
                          //   },
                          //   child: Container(
                          //     height: 44,
                          //     alignment: Alignment.centerLeft,
                          //     decoration: BoxDecoration(color: myColors.greyBg, borderRadius: BorderRadius.circular(8)),
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(left: 16.0, right: 10),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             _dob ?? 'dd-mm-yyyy',
                          //             style: interText(14, Colors.black, FontWeight.normal),
                          //           ),
                          //           IconButton(
                          //               onPressed: () async {
                          //                 _showDobPicker();
                          //               },
                          //               icon: Icon(
                          //                 Icons.calendar_month,
                          //                 color: myColors.grey,
                          //               ))
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Country',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showCountryPicker(
                                          context: context,
                                          countryListTheme:
                                              const CountryListThemeData(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20))),
                                          //showPhoneCode: true,
                                          onSelect: (Country country) {
                                            countryCodeText =
                                                country.countryCode;
                                            countryCodeNumber =
                                                country.phoneCode;
                                            print(country.countryCode);
                                            print(
                                                '$countryCodeText $countryCodeNumber');
                                            setState(() {});
                                          });
                                    },
                                    child: Container(
                                      //height: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 11),
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
                                            '+$countryCodeNumber ($countryCodeText)',
                                            style: GoogleFonts.inter(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: fontClr,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      child: NewCustomTextField(
                                        borderRadius: 8,
                                        enable: true,
                                        focusNode: _phoneNode,
                                        inputFormat: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        fieldTextFieldController: _phoneNoCon,
                                        keyboard: TextInputType.number,
                                        hintText: "Phone Number",
                                        funcOnChanged: (value) {
                                          setState(() {
                                            phoneText = value!;
                                            //_formPhoneKey.currentState!.validate();
                                            print("onChange " + phoneText);
                                          });

                                          calltoChangeUpdateButton(
                                              _firstNameCon.text,
                                              _lastNameCon.text,
                                              value,
                                              _add1Con.text,
                                              _add2Con.text,
                                              stateText,
                                              _zipCon.text,
                                              _cityCon.text);
                                        },
                                        funcValidate: (value, setErrorInfo) {
                                          if (!RegExp(r"^[0-9]{10}$")
                                                  .hasMatch(value!) &&
                                              value.isNotEmpty) {
                                            _phoneNode.requestFocus();
                                            setErrorInfo(true,
                                                'Enter Valid Phone Number');
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
                            height: 24,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: myColors.greyBtn,
                                  borderRadius: BorderRadius.circular(36)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 24),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'images/lock.svg',
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text("Change Password",
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Divider(
                            height: 0.3,
                            color: myColors.primaryStroke,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          InkWell(
                            onTap: () async {
                              SignInSignUpHelpers sp = SignInSignUpHelpers();
                              sp.remove('user');
                              sp.remove('textId');
                              sp.remove('address');
                              sp.remove('status');
                              sp.remove('token');
                              var pp = context.read<TabControllerProvider>();
                              pp.updateNavBarAtInitialStage(context, 0);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LauncherScreen()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: myColors.greyBtn,
                                  borderRadius: BorderRadius.circular(36)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 24),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/log-out.svg',
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text("Logout",
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          //  CustomMaterialButton(
                          //   isLoading: false,
                          //   label: 'Save',
                          //   width: double.infinity,
                          //   buttonColor: btnEnable?buttonClr:buttonDisableClr,
                          //   fontColor: btnEnable?buttonFontClr:Colors.black87,
                          //   funcName:(){
                          //
                          //   },
                          //   borderRadius: 50,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void calltoChangeUpdateButton(String? fname, String? lname, String? phone,
      String? add1, String? add2, String? state, String? zip, String? city) {
    var provider = context.read<UserProvider>();
    print(
        'PROVIDER : ${provider.userModel.firstName} - PROVIDER :${provider.userModel.lastName} - PROVIDER : ${provider.userModel.phone} -PROVIDER : ${provider.addressVerification.zipData} -PROVIDER : ${provider.addressVerification.cityData}');

    if (fname != provider.userModel.firstName ||
        lname != provider.userModel.lastName ||
        phone != provider.userModel.phone ||
        add1 != provider.addressVerification.addressLine1Data ||
        add2 != provider.addressVerification.addressLine2Data ||
        state != provider.addressVerification.stateData ||
        city != provider.addressVerification.cityData ||
        zip != provider.addressVerification.zipData) {
      provider.upDateButton(true);
    } else {
      provider.upDateButton(false);
    }
  }

  void callToDisableButton() async {
    await Provider.of<UserProvider>(context).upDateButton(false);
  }
}
