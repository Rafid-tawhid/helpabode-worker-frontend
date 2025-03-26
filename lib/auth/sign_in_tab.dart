import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../helper_functions/colors.dart';
import '../helper_functions/signin_signup_helpers.dart';
import '../helper_functions/user_helpers.dart';
import '../misc/constants.dart';
import '../provider/navbar_provider.dart';
import '../widgets_reuse/custom_elevated_button.dart';
import '../widgets_reuse/custom_rounded_button.dart';
import 'auth_screen.dart';
import 'auth_providers.dart';
import 'custom_textfield_min.dart';
import 'helper.dart';

class SignInTab extends StatefulWidget {
  final int index;

  const SignInTab(this.widget, {this.index = 0, super.key});
  final Widget widget;

  @override
  State<SignInTab> createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool secureConfirmPassword = true;
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    // clearToken();
    super.initState();
    getEmail();
  }

  getEmail() async {
    email.text = await DashboardHelpers.getString('login_mail') ?? "";
    password.text = await DashboardHelpers.getString('password') ?? "";
    // print(await SpServices.getString(SpServices.userEmail));
    debugPrint("hello");
  }

  // clearToken() async {
  //   var ap = context.read<AuthProvider>();
  //   await ap.removeUserToken();
  // }

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: CarvedContainerClipper(),
              child: Container(
                  color: Colors.white,
                  // Adjust the height as needed
                  // Replace with your desired container color
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/svg/star.svg"),
                                  SizedBox(width: 8.w),
                                  Text("Sign in to access services and offers",
                                      style: latoStyle500Medium)
                                ]),

                            const SizedBox(height: 20),

                            //TODO: Enter email

                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4)),
                                child: CustomTextFieldMin(
                                  controller: email,
                                  isSaveAutoFillData: true,
                                  inputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.done,
                                  isCancelShadow: true,
                                  isShowBorder: authProvider.myEmailError,
                                  enabledBorderWidth: 1,
                                  enabledBorderColor: Colors.transparent,
                                  isErrorBox: true,
                                  borderRadius: 8,
                                  fillColor: authProvider.myEmailError
                                      ? const Color(0xFFFFF1F1)
                                      : AppColors.boxColor,
                                  focusBorderColor: authProvider.myEmailError
                                      ? AppColors.invalidTextFieldBorderColor
                                      : Colors.black,
                                  focusBorderWidth: 1.5,
                                  onTap: () {
                                    authProvider.setMyEmailError(false);
                                  },
                                  onFieldSubmitted: (value) async {
                                    if (authProvider
                                        .checkEmailError(email.text)) {
                                      FocusScope.of(context).unfocus();
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                  hintText: "Email address",
                                  hintFontSize: 14,
                                  validation: (value) {
                                    return null;
                                  },
                                  onChanged: (value) {
                                    authProvider.setMyEmailError(false);
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            authProvider.myEmailError
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
                                          authProvider.myEmailErrMessage,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors
                                                .invalidTextFieldBorderColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            SizedBox(height: 8.h),
                            //TODO: Enter password

                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4)),
                                child: CustomTextFieldMin(
                                  controller: password,
                                  isSaveAutoFillData: true,
                                  inputType: TextInputType.visiblePassword,
                                  inputAction: TextInputAction.done,
                                  isCancelShadow: true,
                                  isShowSuffixIcon: true,
                                  isShowSuffixWidget: true,
                                  isPassword: secureConfirmPassword,
                                  isShowBorder: authProvider.myPasswordError,
                                  enabledBorderWidth: 1,
                                  enabledBorderColor: Colors.transparent,
                                  isErrorBox: true,
                                  borderRadius: 8,
                                  fillColor: authProvider.myPasswordError
                                      ? const Color(0xFFFFF1F1)
                                      : AppColors.boxColor,
                                  focusBorderColor: authProvider.myPasswordError
                                      ? AppColors.invalidTextFieldBorderColor
                                      : Colors.black,
                                  focusBorderWidth: 1.5,
                                  onTap: () {
                                    authProvider.setMyPasswordError(false);
                                  },
                                  onFieldSubmitted: (value) async {
                                    if (authProvider
                                        .checkPasswordError(password.text)) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  hintText: "Password",
                                  hintFontSize: 14,
                                  validation: (value) {
                                    return null;
                                  },
                                  suffixWidget: securePassWidget(
                                      secureConfirmPassword, () {
                                    setState(() {
                                      secureConfirmPassword =
                                          !secureConfirmPassword;
                                    });
                                  }),
                                  onChanged: (value) {
                                    authProvider.setMyPasswordError(false);
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            authProvider.myPasswordError
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
                                          authProvider.myPasswordErrMessage,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors
                                                .invalidTextFieldBorderColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            if (authProvider.mySignUpErrorBox)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.lightRed),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.warning,
                                                color: Color(0XFFC40606),
                                              ),
                                            ),
                                            Text("Incorrect Email",
                                                style: latoStyle600SemiBold
                                                    .copyWith(fontSize: 16))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text(
                                            "We couldn't find any account associated with the email you entered. Please try a different email or sign up.",
                                            style: latoStyle400Regular.copyWith(
                                                fontSize: 14)),
                                      ),
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 50),
                                        child: CustomElevatedButton(
                                          horizontalPadding: 12,
                                          title: 'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          color: AppColors.redColor,
                                          elevation: 2,
                                          verticlaPadding: 0,
                                          onPressed: () async {
                                            var tabControllerProvider = context
                                                .read<TabControllerProvider>();
                                            await tabControllerProvider
                                                .loginTabControl(1);
                                            Helper.toScreen(
                                                context, const LoginScreen());
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                    ],
                                  ),
                                ),
                              )
                            else if (authProvider.myPasswordErrorBox)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0XFFFFF1F1),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: AppColors
                                              .invalidTextFieldBorderColor,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Incorrect Password',
                                          style: interText(14, Colors.black,
                                              FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            SizedBox(
                              height: email.text.isNotEmpty &&
                                      !authProvider.rongMail &&
                                      authProvider.incorrectemail &&
                                      !FocusScope.of(context).hasFocus
                                  ? 36
                                  : 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Forgot Password");
                                    // context.push(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                                    context.pushNamed('forgot_password');
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0XFF008951),
                                      fontSize:
                                          CurrentDevice.isAndroid() ? 16 : 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CustomRoundedButton(
                                buttonColor: buttonClr,
                                fontColor: buttonFontClr,
                                label: "Continue to Sign In",
                                borderRadius: 50.w,
                                funcName: () async {
                                  bool emailError =
                                      authProvider.checkEmailError(email.text);
                                  bool passwordError = authProvider
                                      .checkPasswordError(password.text);
                                  bool checked = emailError && passwordError;
                                  if (checked) {
                                    SignInSignUpHelpers signInSignUpHelpers =
                                        SignInSignUpHelpers();
                                    _btnController.start();
                                    FocusScope.of(context).unfocus();
                                    var provider = context.read<UserProvider>();
                                    var output = await provider.signInApi(
                                      email.text,
                                      password.text,
                                      context,
                                    );
                                    print(
                                        'SIGN IN OUTPUT: ${output['message']}');
                                    if (output['result'] == true) {
                                      await DashboardHelpers
                                          .successStopAnimation(_btnController);
                                      String status = await signInSignUpHelpers
                                              .getString('status') ??
                                          '';
                                      String? empType = await UserHelpers
                                          .getLoginUserEmployeeStatus();
                                      debugPrint(
                                          'Status: $status, Employee Type: $empType');
                                      SignInSignUpHelpers.navigationAfterLogin(
                                          context, status, empType);
                                    } else {
                                      await DashboardHelpers.errorStopAnimation(
                                          _btnController);
                                      if (output['message'] ==
                                          'Team member not found') {
                                        authProvider.showSignUpErrorBox(true);
                                      } else if (output['message'] ==
                                          'Sign In Failed') {
                                        authProvider.showPasswordErrorBox(true);
                                      } else {
                                        DashboardHelpers.showAlert(
                                            msg: output['message']);
                                      }
                                    }
                                  }
                                },
                                controller: _btnController,
                              ),
                            ),
                            SizedBox(height: 27.h),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Padding securePassWidget(bool secure, Function change) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
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

class CarvedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 30); // Move to top-left starting point
    path.lineTo(0, size.height); // Draw left edge
    path.lineTo(size.width, size.height); // Draw bottom edge
    path.lineTo(size.width, 30); // Draw right edge
    path.quadraticBezierTo(
        size.width, 0, size.width - 30, 0); // Carve top-right corner
    path.lineTo(30, 0); // Draw top edge
    path.quadraticBezierTo(0, 0, 0, 30); // Carve top-left corner
    path.close(); // Complete the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
