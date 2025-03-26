import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helper_functions/colors.dart';
import '../widgets_reuse/custom_elevated_button.dart';
import '../widgets_reuse/loading_indicator.dart';
import 'auth_screen.dart';
import 'auth_providers.dart';
import 'custom_textfield_min.dart';
import 'helper.dart';

class PasswordEnterScreen extends StatefulWidget {
  const PasswordEnterScreen({super.key, required this.email});
  final String email;

  @override
  State<PasswordEnterScreen> createState() => _PasswordEnterScreenState();
}

class _PasswordEnterScreenState extends State<PasswordEnterScreen> {
  FocusNode passwordFocus = FocusNode();
  bool secureConfirmPassword = true;
  bool editStart = false;
  bool invalidPassword = false;

  // bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    setLoading();
  }

  setLoading() {
    var ap = context.read<AuthProvider>();
    Future.microtask(() {
      ap.setLoading(false);
      // ap.setPasswordText(null);
      // ap.setConfirmPasswordText(null);
    });
  }

  @override
  void dispose() {
    // _isDisposed = true; // Set the flag to true when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                color: AppColors.ligthGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/star.svg"),
                    SizedBox(width: 8.w),
                    Text(
                      "Sign in to access services and offers",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Password",
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4)),
                  child: CustomTextFieldMin(
                    controller: authProvider.confirmPassword,
                    focusNode: passwordFocus,
                    isShowSuffixIcon: true,
                    // enabledBorderColor: Colors.transparent,

                    isPassword: secureConfirmPassword,
                    borderRadius: 8,
                    // fillColor: Color(0xFFF7F7F7),
                    fillColor: (authProvider.confirmPassword.text.isEmpty ||
                                invalidPassword) &&
                            editStart &&
                            !FocusScope.of(context).hasFocus
                        ? AppColors.invalidTextFieldColor
                        : Color(0xFFF6F6F6),
                    focusBorderColor: Colors.black,
                    focusBorderWidth: 1.5,
                    isShowBorder: (authProvider.confirmPassword.text.isEmpty ||
                            invalidPassword) &&
                        editStart &&
                        !FocusScope.of(context).hasFocus,
                    enabledBorderWidth: 1,
                    isErrorBox: true,
                    enabledBorderColor:
                        (authProvider.confirmPassword.text.isEmpty ||
                                    invalidPassword) &&
                                editStart &&
                                !FocusScope.of(context).hasFocus
                            ? AppColors.invalidTextFieldBorderColor
                            : Colors.transparent,
                    hintText: "Enter your password",
                    hintFontSize: 14,
                    inputType: TextInputType.text,
                    // isIcon: false,
                    isShowSuffixWidget: true,
                    onChanged: (value) {
                      // authProvider.setConfirmPasswordText(value!);
                      authProvider.setPasswordText(value!);

                      return null;
                    },
                    suffixWidget: authProvider.passwordText.isNotEmpty
                        ? securePassWidget(secureConfirmPassword, () {
                            setState(() {
                              secureConfirmPassword = !secureConfirmPassword;
                            });
                          })
                        : null,
                    inputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      setState(() {
                        editStart = true;
                        invalidPassword = false;
                      });
                      FocusScope.of(context).unfocus();

                      if (authProvider.confirmPassword.text.isNotEmpty) {
                        // authProvider
                        //     .signInEmailPassword(widget.email.toString(),
                        //     authProvider.confirmPassword.text)
                        //     .then(
                        //       (value) {
                        //     if (value.status == true) {
                        //       Fluttertoast.showToast(
                        //           gravity: ToastGravity.TOP,
                        //           msg: value.message);
                        //
                        //       Helper.nextScreenCloseOthers(
                        //         context,
                        //         DashboardScreen(),
                        //       );
                        //     } else {
                        //       invalidPassword = true;
                        //       Fluttertoast.showToast(
                        //           gravity: ToastGravity.TOP,
                        //           msg: value.message);
                        //     }
                        //   },
                        // );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              (authProvider.confirmPassword.text.isEmpty || invalidPassword) &&
                      editStart &&
                      !FocusScope.of(context).hasFocus
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          SvgPicture.asset(
                            "assets/svg/validation_icon.svg",
                            width: 12,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            authProvider.confirmPassword.text.isEmpty
                                ? "Password is required"
                                : invalidPassword
                                    ? "Password incorrect"
                                    : '',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.invalidTextFieldBorderColor,
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: 16),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      authProvider.changeErrorStatus(false);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ForgetPasswordScreen(
                      //       email: widget.email,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text(
                      "Forgot your password?",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF008951),
                      ),
                      // style: interStyle16_500.copyWith(
                      //     color: AppColors.primaryColor),
                    ),
                  )),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text.rich(
                  TextSpan(
                    text:
                        " Enter your password to complete logging into your account with ",
                    children: [
                      TextSpan(
                        text: widget.email,
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      TextSpan(
                        text: "(Switch)",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Helper.toScreen(context, const LoginScreen());
                          },
                      ),
                    ],
                  ),
                  style: TextStyle(color: Color(0xFF535151)),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomElevatedButton(
                    title: 'Sign In',
                    verticlaPadding: authProvider.isLoading ? 0 : 13,
                    widget: authProvider.isLoading
                        ? SizedBox(
                            height: 48,
                            child: LoadingIndicatorWidget(
                              color: Colors.white,
                            ),
                          )
                        : null,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    onPressed: () async {
                      setState(() {
                        editStart = true;
                        invalidPassword = false;
                      });
                      FocusScope.of(context).unfocus();
                      //
                      // if (authProvider.confirmPassword.text.isNotEmpty &&
                      //     !authProvider.isLoading) {
                      //   try {
                      //     authProvider
                      //         .signInEmailPassword(widget.email.toString(),
                      //         authProvider.confirmPassword.text)
                      //         .then(
                      //           (value) async {
                      //         if (value.status == true) {
                      //           Fluttertoast.showToast(
                      //             gravity: ToastGravity.TOP,
                      //             msg: value.message.toString(),
                      //           );
                      //
                      //           // hcp.getHouseConfiguration().then((value) {
                      //           //   if (value.length == 0) {
                      //           //     debugPrint(
                      //           //         '----House Config Length----${value.length}');
                      //
                      //           Helper.nextScreenCloseOthers(
                      //             context,
                      //             DashboardScreen(),
                      //             // authProvider.isFirstTimeInDashboard
                      //             //     ? DashboardScreen()
                      //             //     : HomeScreen(
                      //             //         fromAddress: false,
                      //             //       ),
                      //           );
                      //
                      //           //   } else {
                      //           //     Helper.toScreen(
                      //           //         context, HouseConfiguration());
                      //           //   }
                      //           // });
                      //         } else {
                      //           invalidPassword = true;
                      //           Fluttertoast.showToast(
                      //             gravity: ToastGravity.TOP,
                      //             msg: value.message.toString(),
                      //           );
                      //         }
                      //       },
                      //     );
                      //   } catch (e) {
                      //     authProvider.setLoading(false);
                      //     Fluttertoast.showToast(msg: e.toString());
                      //   }
                      // }
                    },
                  ),
                ),
              ),
              SizedBox(height: 26),
              Center(
                child: authProvider.isOtpSend
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Please wait",
                            style: TextStyle(
                              color: Color(0xFF008951),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            height: 12,
                            child: LoadingIndicatorWidget(
                              width: 20,
                            ),
                          )
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.only(
                          bottom: 2, // Space between underline and text
                        ),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: AppColors.primaryColor,
                          width: .7, // Underline thickness
                        ))),
                        child: InkWell(
                          onTap: () {
                            if (!authProvider.isOtpSend) {
                              debugPrint(
                                  "-----------boss I get email------${widget.email},");
                              //
                              authProvider.onTimeOtpSend(
                                widget.email.toString(),
                                false,
                                (bool status, bool resendExist,
                                    String message) async {
                                  if (status) {
                                    Fluttertoast.showToast(msg: message);
                                    setState(() {
                                      passCodeClicked = true;
                                    });
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => OtpVerifyScreen(
                                    //       fromForgetPassword: false,
                                    //       email: widget.email.toString(),
                                    //     ),
                                    //   ),
                                    // );
                                    setState(() {
                                      passCodeClicked = false;
                                    });
                                  } else {
                                    Fluttertoast.showToast(msg: message);
                                    authProvider.setOtpSendStatus(false);
                                    setState(() {
                                      passCodeClicked = false;
                                    });
                                  }
                                },
                              );
                            }
                          },
                          child: Text(
                            "Use one time passcode instead",
                            style: TextStyle(
                              color: Color(0xFF008951),
                            ),
                          ),
                        ),
                      ),
              ),
              // Visibility(
              //   visible: passCodeClicked,
              //   child: SizedBox(
              //     height: 200,
              //     child: Center(
              //       child: CircularProgressIndicator(),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool passCodeClicked = false;

  Padding securePassWidget(bool secure, Function change) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          change();
        },
        child: Text(
          secureConfirmPassword ? 'Show' : 'Hide',
          style: TextStyle(),
        ),
      ),
    );
  }
}
