import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/colors.dart';
import '../../widgets_reuse/custom_elevated_button.dart';
import '../../widgets_reuse/custom_text_field_M.dart';

class ChangePasswordScreenNew extends StatefulWidget {
  const ChangePasswordScreenNew({super.key});

  @override
  State<ChangePasswordScreenNew> createState() =>
      _ChangePasswordScreenNewState();
}

class _ChangePasswordScreenNewState extends State<ChangePasswordScreenNew> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers and Focus Nodes
  TextEditingController oldPass = TextEditingController();

  TextEditingController newPass = TextEditingController();

  TextEditingController confirmPass = TextEditingController();

  FocusNode oldPassFocusNode = FocusNode();

  FocusNode newPassFocusNode = FocusNode();

  FocusNode confirmPassFocusNode = FocusNode();

  AnimationController? localAnimationController;
  bool _isLoading = false;
  late UserProvider provider;
  String oldPassText = '';
  String confirmText = '';
  String newText = '';
  bool oldPassShow = false;
  bool newPassShow = false;
  bool confirmPassShow = false;

  // Future<void> changePasswordHandle() async {
  //   //FocusScope.of(context).unfocus();
  //   var authProvider = context.read<UserProvider>();
  //   if (_formKey.currentState!.validate() && oldPass.text.isNotEmpty) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     authProvider.clearApiStatus();
  //     await authProvider.changeUserPassword(context, {
  //       'textId': textId,
  //       'oldPassword': oldPass.text,
  //       'newPassword': confirmPass.text,
  //     }).then((value) {
  //       debugPrint('Final Response: ${value}');
  //       if (value) {
  //         // Navigator.pop(context);
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         if (!_isLoading) {
  //           if (authProvider.apiStatusCode == 200) {
  //             // ignore: use_build_context_synchronously
  //
  //             showCustomSnackBar(
  //               context,
  //               authProvider.apiStatusString,
  //               Colors.black,
  //               snackBarNeutralTextStyle,
  //               localAnimationController,
  //             );
  //
  //             Navigator.pop(context);
  //           } else {
  //             // ignore: use_build_context_synchronously
  //             _showBottomDialog(context, authProvider.apiStatusString);
  //             // Fluttertoast.showToast(msg: authProvider.apiStatusString);
  //           }
  //         }
  //       } else {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         _showBottomDialog(context, authProvider.apiStatusString);
  //       }
  //     });
  //   }
  // }

  void _showBottomDialog(BuildContext context, String status) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.only(top: 8, bottom: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Whoops',
                  style: interText(16, Colors.black, FontWeight.w600),
                ),
              ),
              Text(
                'Invalid Argument: $status',
                style: interText(16, Colors.black, FontWeight.w400),
              ),
              SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  color: Color(0xFFE9E9E9),
                  style: interText(18, Colors.black, FontWeight.w600),
                  verticlaPadding: 13,
                  title: 'Ok',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context); // Close the bottom sheet
              //   },
              //   child: Text('Close'),
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    oldPassFocusNode.addListener(() {
      if (!oldPassFocusNode.hasFocus) {
        onFocusOut(1);
      }
    });
    newPassFocusNode.addListener(() {
      if (!newPassFocusNode.hasFocus) {
        onFocusOut(2);
      }
    });
    confirmPassFocusNode.addListener(() {
      if (!confirmPassFocusNode.hasFocus) {
        onFocusOut(3);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    oldPassFocusNode.dispose();
    newPassFocusNode.dispose();
    confirmPassFocusNode.dispose();
    oldPass.dispose();
    newPass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  void onFocusOut(int textFieldNumber) {
    print("Focus lost from TextField $textFieldNumber");
    //old
    if (textFieldNumber == 1) {
      setState(() {
        newPassShow = false;
        confirmPassShow = false;
      });
      if (oldPass.text.trim() == '') {
        setState(() {
          oldPassShow = true;
          oldPassText = 'Your old password can not be empty';
        });
      } else if (oldPass.text.trim().length < 8) {
        setState(() {
          oldPassShow = true;
          oldPassText = 'Old password must be more than 8 character';
        });
      } else {
        oldPassShow = false;
      }
    }
    if (textFieldNumber == 2) {
      setState(() {
        oldPassShow = false;
        confirmPassShow = false;
      });
      if (newPass.text.trim() == '') {
        setState(() {
          newPassShow = true;
          newText = 'New password is required';
        });
      } else if (newPass.text.trim().length < 8) {
        setState(() {
          newPassShow = true;
          newText = 'New password must be more than 8 character';
        });
      } else {
        newPassShow = false;
      }
    }
    if (textFieldNumber == 3) {
      setState(() {
        oldPassShow = false;
        newPassShow = false;
      });
      if (confirmPass.text.trim() == '') {
        setState(() {
          confirmPassShow = true;
          confirmText = 'Confirm password is required';
        });
      } else if (confirmPass.text.trim().length < 8) {
        setState(() {
          confirmPassShow = true;
          confirmText = 'Confirm password must be more than 8 character';
        });
      } else {
        confirmPassShow = false;
      }
    }
    // Call your method here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Set New Password',
          style: interText(16, Colors.black, FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<UserProvider>(
          builder: (context, provider, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fieldLabel('Old Password'),
              CustomTextField2(
                focusNode: oldPassFocusNode,
                fontSize: 16,
                verticalSize: 14,
                horizontalSize: 12,
                isSearch: false,
                onChanged: (value) {
                  return null;
                },
                validation: (value) {
                  return null;
                },
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(newPassFocusNode);
                },
                borderRadius: 8,
                isIcon: true,
                fillColor: oldPassShow
                    ? AppColors.invalidTextFieldColor
                    : Color(0xFFF6F6F6),
                focusBorderColor: Colors.black,
                focusBorderWidth: 1.5,
                isShowBorder: oldPassShow,
                enabledBorderWidth: 1,
                isErrorBox: true,
                enabledBorderColor: oldPassShow
                    ? AppColors.invalidTextFieldBorderColor
                    : Colors.transparent,
                hintText: '',
                inputType: TextInputType.text,
                isPassword: secureOldPassword,
                showPrefixWidget: true,
                isShowPrefixIcon: true,
                prefixWidget: prefixWidget(),
              ),
              const SizedBox(
                height: 8,
              ),
              if (oldPassShow)
                Row(
                  children: [
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      "assets/svg/validation_icon.svg",
                      height: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${oldPassText}",
                      style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              fieldLabel('New Password'),
              CustomTextField2(
                controller: newPass,
                focusNode: newPassFocusNode,
                fontSize: 16,
                verticalSize: 14,
                horizontalSize: 0,
                onChanged: (value) {
                  provider.checkOldAndNewPassword(
                      value, confirmPass.text.trim());
                  return null;
                },
                validation: (value) {
                  return null;
                },
                borderRadius: 8,
                isIcon: true,
                fillColor: newPassShow
                    ? AppColors.invalidTextFieldColor
                    : Color(0xFFF6F6F6),
                focusBorderColor: Colors.black,
                focusBorderWidth: 1.5,
                isShowBorder: newPassShow,
                enabledBorderWidth: 1,
                isErrorBox: true,
                enabledBorderColor: newPassShow
                    ? AppColors.invalidTextFieldBorderColor
                    : Colors.transparent,
                hintText: "",
                hintFontSize: 14,
                inputType: TextInputType.text,
                isPassword: secureNewPassword,
                showPrefixWidget: true,
                isShowPrefixIcon: true,
                prefixWidget: prefixWidget(),
              ),
              SizedBox(
                height: 8,
              ),
              if (newPassShow)
                Row(
                  children: [
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      "assets/svg/validation_icon.svg",
                      height: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      newText,
                      style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              fieldLabel('Confirm New Password'),
              CustomTextField2(
                controller: confirmPass,
                focusNode: confirmPassFocusNode,
                fontSize: 16,
                verticalSize: 14,
                horizontalSize: 12,
                isSearch: false,
                onChanged: (value) {
                  provider.checkOldAndNewPassword(newPass.text.trim(), value);
                  return null;
                },
                validation: (value) {
                  return null;
                },
                borderRadius: 8,
                isIcon: true,
                fillColor: confirmPassShow
                    ? AppColors.invalidTextFieldColor
                    : Color(0xFFF6F6F6),
                focusBorderColor: Colors.black,
                focusBorderWidth: 1.5,
                isShowBorder: confirmPassShow,
                enabledBorderWidth: 1,
                isErrorBox: true,
                enabledBorderColor: confirmPassShow
                    ? AppColors.invalidTextFieldBorderColor
                    : Colors.transparent,
                hintText: "",
                inputType: TextInputType.text,
                isPassword: secureConfirmPassword,
                showPrefixWidget: true,
                isShowPrefixIcon: true,
                prefixWidget: prefixWidget(),
                inputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 8,
              ),
              if (confirmPassShow)
                Row(
                  children: [
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      "assets/svg/validation_icon.svg",
                      height: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      confirmText,
                      style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                //  _isLoading ? Center(child: CircularProgressIndicator()) : Container()
                child: CustomElevatedButton(
                  verticlaPadding: 14,
                  color: provider.passwordCheck ? null : Color(0xFFE9E9E9),
                  widget: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  title: 'Change my password',
                  style: GoogleFonts.inter(
                      color: provider.passwordCheck
                          ? Colors.white
                          : Color(0xFF535151)),
                  onPressed: provider.passwordCheck
                      ? () {
                          //changePasswordHandle();
                          // if (newPassValid && oldPassValid && confirmPassValid) {
                          // editStart1 && editStart2 && editStart3 && oldPassValid && newPassValid && confirmPassValid && provider.passwordCheck ? changePasswordHandle() : _formKey.currentState!.validate();
                          // }
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding securePassWidget(bool secure, Function change) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          change();
        },
        // child: Text(secureConfirmPassword ? 'Show' : 'Hide'),
        child: Icon(
          secure ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
          color: const Color(0xFF535151),
          size: 22,
        ),
      ),
    );
  }

  bool secureOldPassword = true;
  bool secureNewPassword = true;
  bool secureConfirmPassword = true;

  Padding prefixWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: SvgPicture.asset(
        'assets/svg/lock1.svg',
      ),
    );
  }

  Padding fieldLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: interText(16, Colors.black, FontWeight.w600),
      ),
    );
  }
}
