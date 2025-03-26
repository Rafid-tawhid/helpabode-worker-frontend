import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_password_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper_functions/signin_signup_helpers.dart';
import '../../misc/constants.dart';
import '../../widgets_reuse/custom_rounded_button.dart';
import '../../widgets_reuse/new_text_formfield.dart';

class SignInScreen3 extends StatefulWidget {
  const SignInScreen3({Key? key}) : super(key: key);
  // final ChromeSafariBrowser browser = new MyChromeSafariBrowser();

  @override
  State<SignInScreen3> createState() => _SignInScreen3State();
}

class _SignInScreen3State extends State<SignInScreen3> {
  final TextEditingController emailTextFormController = TextEditingController();
  final TextEditingController passwordTextFormController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  String emailText = '';
  String passwordText = '';
  String? passwordTitle;

  bool isVisible = false;

  bool isButtonLoading = false;

  bool? isCheckEmail;
  bool? isCheckPassword;

  AnimationController? localAnimationController;

  // late UserProvider provider;
  Color? fillColor;
  bool showErrorBox = false;

  SignInSignUpHelpers signInSignUpHelpers = SignInSignUpHelpers();

  @override
  void dispose() {
    emailTextFormController.dispose();
    passwordTextFormController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initStates
    super.initState();
    isButtonLoading = false;
    getPreviousMail();
    // validateFocusNode(focusNodeEmail, _formEmailKey);
    // validateFocusNode(focusNodePassword, _formPasswordKey);
  }

  @override
  void didChangeDependencies() {
    // provider = Provider.of(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/svg/star.svg"),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Sign in to access services and offers",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: CurrentDevice.isAndroid() ? 14 : 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          color: Colors.white,
          // width: 388.w,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                NewCustomTextField(
                  width: 388.w,
                  height: 44,
                  ontapped: () {
                    setState(() {
                      showErrorBox = false;
                    });
                  },
                  borderRadius: 8.w,
                  focusNode: focusNodeEmail,
                  fieldTextFieldController: emailTextFormController,
                  keyboard: TextInputType.emailAddress,
                  onEditingComplete: () {
                    TextInput.finishAutofillContext();
                  },
                  isCheck: isCheckEmail,
                  funcOnChanged: (value) {
                    setState(() {
                      emailText = value!;
                      showErrorBox = false;
                      if (RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                        setState(() {
                          isCheckEmail = true;
                        });
                      } else {
                        setState(() {
                          isCheckEmail = null;
                        });
                      }

                      print("onChange " + emailText);
                    });
                  },
                  funcValidate: (value, setErrorInfo) {
                    if (value == null || value.isEmpty) {
                      setErrorInfo(true, 'Email is required');

                      //focusNodeEmail.requestFocus();
                      return '';
                    } else if (!RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                      setErrorInfo(true, 'Enter Valid Email');
                      focusNodeEmail.requestFocus();
                      return 'Enter Valid Email';
                    }
                    return null;
                  },
                  hintText: 'Email',
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomPasswordTextField(
                  width: 388.w,
                  height: tffHeight,
                  borderRadius: 8.w,
                  // formKey: _formPasswordKey,
                  focusNode: focusNodePassword,
                  fieldTextFieldController: passwordTextFormController,
                  keyboard: TextInputType.text,
                  isCheck: isCheckPassword,
                  isVisible: isVisible,
                  funcVisible: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  funcOnChanged: (value) {
                    if (value!.length >= 8) {
                      setState(() {
                        isCheckPassword = true;
                        fillColor = null;
                      });
                    } else {
                      setState(() {
                        isCheckPassword = null;
                        fillColor = null;
                      });
                    }
                    passwordText = value;

                    //_formPasswordKey.currentState!.validate();
                    print("onChange " + passwordText);
                  },
                  funcValidate: (value, setErrorInfo) {
                    if (value == null || value.isEmpty) {
                      setErrorInfo(true, 'Password is required');

                      // focusNodePassword.requestFocus();
                      return '';
                    } else if (value.length < 8) {
                      setErrorInfo(
                          true, 'Password must be at least 8 character');
                      focusNodePassword.requestFocus();
                      return '';
                    }
                    return null;
                  },

                  hintText: 'Password (At least 8 characters)',
                ),
                SizedBox(
                  height: 15.h,
                ),
                showErrorBox
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0XFFFFF1F1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.warning,
                                      color: Color(0XFFC40606),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          passwordTitle ?? 'Incorrect Email',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        if (passwordTitle == null)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Text(
                                              'We couldn\'t find any account associated with the email you entered. Please try a different email or sign up.',
                                              style: TextStyle(
                                                  color: Color(0XFF535151),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        if (passwordTitle == null)
                                          InkWell(
                                            onTap: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => RegistrationHandlerScreen4()));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0XFFFF0000),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          17, 17, 26, 0.05),
                                                      blurRadius: 32,
                                                      offset: Offset(0, 8),
                                                    ),
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.05),
                                                      blurRadius: 16,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 26.0,
                                                      vertical: 6),
                                                  child: Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
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
                        ],
                      )
                    : Row(
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
                                fontSize: CurrentDevice.isAndroid() ? 16 : 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: showErrorBox ? 15.h : 40.h,
                ),
                Consumer<UserProvider>(
                    builder: (context, provider, _) => CustomRoundedButton(
                          isLoading: isButtonLoading,
                          buttonColor: buttonClr,
                          fontColor: buttonFontClr,
                          label: "Continue to Sign In",
                          borderRadius: 50.w,
                          funcName: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                passwordTitle = null;
                              });

                              _btnController.start();
                              FocusScope.of(context).unfocus();
                              var output = (await provider.signInApi(
                                  emailTextFormController.text,
                                  passwordTextFormController.text,
                                  context));
                              print('SIGN IN OUTPUT :  ${output['message']}');
                              if (output['result'] == true) {
                                await DashboardHelpers.successStopAnimation(
                                    _btnController);
                                var status = await signInSignUpHelpers
                                        .getString('status') ??
                                    '';
                                //  Provider.of<CorporateProvider>(context, listen: false).setAffiliationList(output['worker_roles']);
                                print('STATUS FINAL ${status}');

                                //get employee type
                                String? empType = await UserHelpers
                                    .getLoginUserEmployeeStatus();
                                debugPrint('value ${empType}');

                                debugPrint(UserHelpers.empType);
                                SignInSignUpHelpers.navigationAfterLogin(
                                    context, status, empType);

                                print('After Dispose');
                              } else {
                                await DashboardHelpers.errorStopAnimation(
                                    _btnController);

                                if (output['message'] ==
                                    'Team member not found') {
                                  setState(() {
                                    showErrorBox = true;
                                  });
                                } else if (output['message'] ==
                                    'Sign In Failed') {
                                  setState(() {
                                    showErrorBox = true;
                                    passwordTitle = 'Incorrect Password';
                                  });
                                } else {
                                  DashboardHelpers.showAlert(
                                      msg: output['message']);
                                }
                              }
                            } else {
                              print('Inside else');
                            }
                          },
                          controller: _btnController,
                        )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getPreviousMail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mail = pref.getString("login_mail");
    String? pass = pref.getString("password");

    if (mail != null && pass != null) {
      setState(() {
        emailTextFormController.text = mail;
        passwordTextFormController.text = pass;
      });
    }
  }
}
