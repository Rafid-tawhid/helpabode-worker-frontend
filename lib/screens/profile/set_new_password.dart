import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/colors.dart';
import '../../widgets_reuse/custom_elevated_button.dart';
import '../../widgets_reuse/custom_snackbar_message.dart';
import '../../widgets_reuse/custom_text_field_M.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
  Future<void> changePasswordHandle() async {
    FocusScope.of(context).unfocus();
    var authProvider = context.read<UserProvider>();
    if (_formKey.currentState!.validate() && oldPass.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      authProvider.clearApiStatus();
      await authProvider.changeUserPassword(context, {
        'textId': textId,
        'oldPassword': oldPass.text,
        'newPassword': confirmPass.text,
      }).then((value) {
        debugPrint('Final Response: ${value}');
        if (value) {
          // Navigator.pop(context);
          setState(() {
            _isLoading = false;
          });
          if (!_isLoading) {
            if (authProvider.apiStatusCode == 200) {
              // ignore: use_build_context_synchronously

              showCustomSnackBar(
                context,
                authProvider.apiStatusString,
                Colors.black,
                snackBarNeutralTextStyle,
                localAnimationController,
              );

              Navigator.pop(context);
            } else {
              // ignore: use_build_context_synchronously
              _showBottomDialog(context, authProvider.apiStatusString);
              // Fluttertoast.showToast(msg: authProvider.apiStatusString);
            }
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          _showBottomDialog(context, authProvider.apiStatusString);
        }
      });
    }
  }

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
          child: SingleChildScrollView(
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
          ),
        );
      },
    );
  }

  bool oldPassValid = true;
  bool newPassValid = true;
  bool confirmPassValid = true;
  bool editStart1 = false;
  bool editStart2 = false;
  bool editStart3 = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = context.read<UserProvider>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
            // bottomNavigationBar: CustomBottomNavBar(
            //   isHomePage: false,
            // ),
            key: _scaffoldKey,
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
              child: Column(
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
                      oldPass.text = value!;
                      setState(() {
                        editStart1 = true;
                      });
                      if (oldPass.text.isEmpty) {
                        setState(() {
                          oldPassValid = false;
                        });
                        return null;
                      } else {
                        setState(() {
                          oldPassValid = true;
                        });
                      }

                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(newPassFocusNode);
                    },
                    validation: (value) {
                      if (oldPass.text.isEmpty) {
                        setState(() {
                          oldPassValid = false;
                        });
                        return null;
                      } else {
                        setState(() {
                          oldPassValid = true;
                        });
                      }
                      return null;
                    },
                    borderRadius: 8,
                    isIcon: true,
                    // fillColor:
                    //     !oldPassValid ? Color(0xFFFFF1F1) : Color(0xFFF6F6F6),
                    // isShowBorder: !oldPassValid,
                    // enabledBorderWidth: 1,
                    // isErrorBox: true,
                    // enabledBorderColor: Colors.white,
                    fillColor: !oldPassFocusNode.hasFocus && !oldPassValid
                        ? AppColors.invalidTextFieldColor
                        : Color(0xFFF6F6F6),
                    focusBorderColor: Colors.black,
                    focusBorderWidth: 1.5,
                    isShowBorder: !oldPassFocusNode.hasFocus && !oldPassValid,
                    enabledBorderWidth: 1,
                    isErrorBox: true,
                    enabledBorderColor:
                        !oldPassFocusNode.hasFocus && !oldPassValid
                            ? AppColors.invalidTextFieldBorderColor
                            : Colors.transparent,

                    hintText: '',
                    // hintText: "Old Password",
                    // hintFontSize: 14,
                    inputType: TextInputType.text,
                    isPassword: secureOldPassword,
                    showPrefixWidget: true,
                    isShowPrefixIcon: true,
                    prefixWidget: prefixWidget(),
                    // isShowSuffixWidget: true,
                    // suffixWidget: oldPass.text.isNotEmpty
                    //     ? securePassWidget(
                    //         secureOldPassword,
                    //         () {
                    //           setState(() {
                    //             secureOldPassword = !secureOldPassword;
                    //           });
                    //         },
                    //       )
                    //     : null,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  !oldPassValid && !oldPassFocusNode.hasFocus
                      ? Row(
                          children: [
                            const SizedBox(width: 2),
                            SvgPicture.asset(
                              "assets/svg/validation_icon.svg",
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Your old password can not be empty",
                              style: GoogleFonts.lato(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  fieldLabel('New Password'),
                  CustomTextField2(
                    controller: newPass,
                    focusNode: newPassFocusNode,
                    fontSize: 16,
                    verticalSize: 14,
                    horizontalSize: 0,
                    isSearch: false,
                    onChanged: (value) {
                      setState(() {
                        editStart2 = true;
                      });
                      if (newPass.text.trim().isEmpty ||
                          newPass.text.length < 8) {
                        setState(() {
                          newPassValid = false;
                        });

                        return 'null';
                      } else {
                        setState(() {
                          newPassValid = true;
                        });
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(confirmPassFocusNode);
                    },
                    validation: (value) {
                      if (editStart2 &&
                          (newPass.text.trim().isEmpty ||
                              newPass.text.length < 8)) {
                        setState(() {
                          newPassValid = false;
                        });
                        if (oldPassValid &&
                            authProvider.apiStatusString.isEmpty) {
                          // _showBottomDialog(context, 'sdfjs');
                        }
                        return null;
                      } else {
                        setState(() {
                          newPassValid = true;
                        });
                      }
                      return null;
                    },
                    borderRadius: 8,
                    isIcon: true,
                    fillColor: !newPassFocusNode.hasFocus &&
                            !newPassValid &&
                            oldPassValid
                        ? AppColors.invalidTextFieldColor
                        : Color(0xFFF6F6F6),
                    focusBorderColor: Colors.black,
                    focusBorderWidth: 1.5,
                    isShowBorder: !newPassFocusNode.hasFocus &&
                        !newPassValid &&
                        oldPassValid,
                    enabledBorderWidth: 1,
                    isErrorBox: true,
                    enabledBorderColor: !newPassFocusNode.hasFocus &&
                            !newPassValid &&
                            oldPassValid
                        ? AppColors.invalidTextFieldBorderColor
                        : Colors.transparent,

                    hintText: "",
                    hintFontSize: 14,
                    inputType: TextInputType.text,
                    isPassword: secureNewPassword,
                    showPrefixWidget: true,
                    isShowPrefixIcon: true,
                    prefixWidget: prefixWidget(),
                    // isShowSuffixWidget: true,
                    // suffixWidget: newPass.text.isNotEmpty
                    //     ? securePassWidget(
                    //         secureNewPassword,
                    //         () {
                    //           setState(() {
                    //             secureNewPassword = !secureNewPassword;
                    //           });
                    //         },
                    //       )
                    //     : null,
                  ),
                  SizedBox(
                    height: !newPassFocusNode.hasFocus &&
                            !newPassValid &&
                            oldPassValid
                        ? 8
                        : 0,
                  ),
                  !newPassFocusNode.hasFocus && !newPassValid && oldPassValid
                      ? Row(
                          children: [
                            const SizedBox(width: 2),
                            SvgPicture.asset(
                              "assets/svg/validation_icon.svg",
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              newPass.text.isEmpty
                                  ? "Your new password can not be empty"
                                  : newPass.text.length < 8
                                      ? 'Password must be minimum 8 character'
                                      : 'Invalid new password',
                              style: GoogleFonts.lato(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  fieldLabel('Confirm New Password'),
                  CustomTextField2(
                    controller: confirmPass,
                    focusNode: confirmPassFocusNode,
                    fontSize: 16,
                    verticalSize: 14,
                    horizontalSize: 12,
                    isSearch: false,
                    onChanged: (value) {
                      setState(() {
                        editStart3 = true;
                      });

                      if (confirmPass.text.trim().isEmpty ||
                          confirmPass.text.length < 8 ||
                          confirmPass.text.trim() != newPass.text.trim()) {
                        setState(() {
                          confirmPassValid = false;
                        });
                        return null;
                      } else {
                        setState(() {
                          confirmPassValid = true;
                        });
                      }
                      return null;
                      // try {
                      //   setState(() {});
                      //   print("---------------sdfslfklds______");
                      // } catch (e) {
                      //   Fluttertoast.showToast(msg: 'msg');
                      // }

                      // return null;
                    },
                    onFieldSubmitted: (value) {
                      editStart1 &&
                              editStart2 &&
                              editStart3 &&
                              oldPassValid &&
                              newPassValid &&
                              confirmPassValid
                          ? changePasswordHandle()
                          : _formKey.currentState!.validate();
                      // FocusScope.of(context).unfocus();
                    },
                    validation: (value) {
                      if (editStart2 &&
                          (confirmPass.text.trim().isEmpty ||
                              confirmPass.text.length < 8 ||
                              confirmPass.text.trim() != newPass.text.trim())) {
                        setState(() {
                          confirmPassValid = false;
                        });
                      } else {
                        setState(() {
                          confirmPassValid = true;
                        });
                      }
                      return null;
                    },
                    borderRadius: 8,
                    isIcon: true,
                    fillColor: !confirmPassFocusNode.hasFocus &&
                            !confirmPassValid &&
                            oldPassValid &&
                            newPassValid
                        ? AppColors.invalidTextFieldColor
                        : Color(0xFFF6F6F6),
                    focusBorderColor: Colors.black,
                    focusBorderWidth: 1.5,
                    isShowBorder: !confirmPassFocusNode.hasFocus &&
                        !confirmPassValid &&
                        oldPassValid &&
                        newPassValid,
                    enabledBorderWidth: 1,
                    isErrorBox: true,
                    enabledBorderColor: !confirmPassFocusNode.hasFocus &&
                            !confirmPassValid &&
                            oldPassValid &&
                            newPassValid
                        ? AppColors.invalidTextFieldBorderColor
                        : Colors.transparent,
                    hintText: "",
                    inputType: TextInputType.text,
                    isPassword: secureConfirmPassword,
                    showPrefixWidget: true,
                    isShowPrefixIcon: true,
                    prefixWidget: prefixWidget(),
                    inputAction: TextInputAction.done,
                    // isShowSuffixWidget: true,
                    // suffixWidget: confirmPass.text.isNotEmpty
                    //     ? securePassWidget(secureConfirmPassword, () {
                    //         setState(() {
                    //           secureConfirmPassword = !secureConfirmPassword;
                    //         });
                    //       })
                    //     : null,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  !confirmPassFocusNode.hasFocus &&
                          !confirmPassValid &&
                          oldPassValid &&
                          newPassValid
                      ? Row(
                          children: [
                            const SizedBox(width: 2),
                            SvgPicture.asset(
                              "assets/svg/validation_icon.svg",
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              confirmPass.text.trim() != newPass.text.trim()
                                  ? 'These two fields don’t match'
                                  : confirmPass.text.isEmpty
                                      ? "Your confirm password can not be empty"
                                      : confirmPass.text.length < 8
                                          ? 'Password must be minimum 8 character'
                                          : 'Invalid confirm password',
                              style: GoogleFonts.lato(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  const Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    //  _isLoading ? Center(child: CircularProgressIndicator()) : Container()
                    child: CustomElevatedButton(
                      verticlaPadding: 14,
                      color: editStart1 &&
                              editStart2 &&
                              editStart3 &&
                              oldPassValid &&
                              newPassValid &&
                              confirmPassValid
                          ? null
                          : Color(0xFFE9E9E9),
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
                          color: editStart1 &&
                                  editStart2 &&
                                  editStart3 &&
                                  oldPassValid &&
                                  newPassValid &&
                                  confirmPassValid
                              ? Colors.white
                              : Color(0xFF535151)),
                      onPressed: () {
                        // if (newPassValid && oldPassValid && confirmPassValid) {
                        editStart1 &&
                                editStart2 &&
                                editStart3 &&
                                oldPassValid &&
                                newPassValid &&
                                confirmPassValid
                            ? changePasswordHandle()
                            : _formKey.currentState!.validate();
                        // }
                      },
                    ),
                  ),
                ],
              ),
            )),
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
