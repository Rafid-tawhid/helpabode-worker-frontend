import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';

import '../helper_functions/colors.dart';

//String urlBase = 'http://192.168.1.15:54292/';
//String urlBase = 'http://192.168.1.17:80/'; //askkas mia
String urlBase = 'http://team.dev.helpabode.com:54292/';

String urlMediaRoute = '${urlBase}media/';
int screenWidth = 428;
int screenHeight = 926;
int screenRegWidth = 428;
int screenRegHeight = 841;

functionStringToJson(var response) {
  var output = jsonDecode(response.toString().replaceAll("'", "\""));
  return output;
}

validateFocusNode(FocusNode focusNode, GlobalKey<FormState> formKey) {
  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      formKey.currentState!.validate();
    }
  });
}

Color bgClr = Colors.white;
Color messageClr = const Color(0XFFDEF0E8);
Color tabClr = const Color(0XFFFFFFFF);
//Color textFieldClr = Color(0XFF000000);
Color borderClr = const Color(0XFF535151);
Color dropdownClr = const Color(0XFFF8F9F9);
Color textfieldClr = const Color(0XFFF7F7F7);
Color shiftCardClr = const Color(0XFFF7F7F7);
Color cardClr = const Color(0XFFF8F9FA);
Color buttonClr = const Color(0XFF008951);
Color buttonDisableClr = const Color(0XFFE9E9E9);
Color buttonFontClr = Colors.white;

Color rejectMsgClr = const Color(0XFFFFF1F1);

Color fontClr = const Color(0XFFAAA6A6);
//Color hintClr = Color(0XFFAAA6A6);
Color hintClr = const Color(0XFF535151);

Color otpBoxClr = const Color(0XFF2D2C2C);

Color dashboardTabClr = const Color(0XFFD5E7E0);

Color cardDividerClr = const Color(0XFFD9D9D9);

TextStyle text_12_black_400_TextStyle = GoogleFonts.roboto(
  fontSize: 12.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle textFieldContentTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  textBaseline: TextBaseline.alphabetic,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle textField_black_ContentTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle text_16_black_400_TextStyle = GoogleFonts.inter(
  fontSize: 14,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);
TextStyle text_16_black_500_TextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle text_16_black_600_TextStyle = GoogleFonts.roboto(
  fontSize: 16,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle text_16_black_700_TextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

TextStyle text_16_black_900_TextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.w900,
);

TextStyle text_16_white_400_TextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);

TextStyle text_16_white_500_TextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

TextStyle text_18_black_500_TextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle text_18_green_700_TextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: buttonClr,
  fontWeight: FontWeight.w700,
);

TextStyle text_18_black_700_TextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

TextStyle text_16_green_500_TextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: buttonClr,
  fontWeight: FontWeight.w500,
);

TextStyle text_20_black_600_TextStyle = GoogleFonts.roboto(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle myTxtStyle(double size, FontWeight weight) => GoogleFonts.inter(
      fontSize: size,
      color: Colors.black,
      fontWeight: weight,
    );

TextStyle text_20_white_700_TextStyle = GoogleFonts.roboto(
  fontSize: 20.sp,
  color: Colors.white,
  fontWeight: FontWeight.w700,
);

TextStyle textField_18_black_400_TextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle textField_18_black_600_TextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle textFieldLabelTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle textField_16_black_bold_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle textField_14_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 14.sp,
  color: fontClr,
  fontWeight: FontWeight.w600,
);

TextStyle textField_14_black_500_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 14.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle textField_16_TabTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle textField_16_LabelTextStyle = GoogleFonts.roboto(
  fontSize: CurrentDevice.isAndroid() ? 16 : 20,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

TextStyle textField_16_black_500_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle interText(double size, Color color, FontWeight wgt) =>
    GoogleFonts.inter(
      fontSize: size,
      color: color,
      fontWeight: wgt,
    );

TextStyle textField_24_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 24.sp,
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

TextStyle textField_24_black_900_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 24.sp,
  color: Colors.black,
  fontWeight: FontWeight.w900,
);

TextStyle textField_24_black_400_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 24.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle textField_24_black_600_LabelTextStyle = GoogleFonts.roboto(
  fontSize: 24,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle textField_24_TabTextStyle = GoogleFonts.roboto(
  fontSize: 24.sp,
  color: Colors.black,
  fontWeight: FontWeight.w900,
);

TextStyle appBarTitleTextStyle = GoogleFonts.inter(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

//Requested Service Card
TextStyle cardTitleTextStyle = GoogleFonts.inter(
  fontSize: 14,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle cardLocationTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: borderClr,
  fontWeight: FontWeight.w400,
);

TextStyle cardPriceTextStyle = GoogleFonts.roboto(
  fontSize: 22,
  color: buttonClr,
  fontWeight: FontWeight.w900,
);

TextStyle cardPriceRedTextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: Colors.red,
  fontWeight: FontWeight.w900,
);

TextStyle cardShiftTextStyle = GoogleFonts.roboto(
  fontSize: 16.sp,
  color: fontClr,
  fontWeight: FontWeight.w400,
);

//Upcoming Details Card
TextStyle textField_24_endUserName = GoogleFonts.roboto(
  fontSize: 24.sp,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle textField_30_white = GoogleFonts.roboto(
  fontSize: 30.sp,
  color: buttonFontClr,
  fontWeight: FontWeight.w300,
);
TextStyle textField_30_black_600 = GoogleFonts.roboto(
  fontSize: 30.sp,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle textField_26_white_70_400 = GoogleFonts.roboto(
  fontSize: 26.sp,
  color: Colors.white70,
  fontWeight: FontWeight.w400,
);

TextStyle textField_14_white = GoogleFonts.roboto(
  fontSize: 14.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

//Card of Completed Services
TextStyle cardRatingTextStyle = GoogleFonts.roboto(
  fontSize: 14.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

//No Service Textstyle
TextStyle noServiceTitleTextStyle = GoogleFonts.roboto(
  fontSize: 30.sp,
  color: Colors.black,
  fontWeight: FontWeight.w900,
);
TextStyle noServiceSubtitleTextStyle = GoogleFonts.roboto(
  fontSize: 30.sp,
  color: Colors.black,
  fontWeight: FontWeight.w900,
);

TextStyle noServiceSubtitle_600_TextStyle = GoogleFonts.roboto(
  fontSize: 30.sp,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

// Snack Bar
TextStyle snackBarAcceptTextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: buttonClr,
  fontWeight: FontWeight.w600,
);
TextStyle snackBarRejectTextStyle = GoogleFonts.roboto(
  fontSize: 24.sp,
  color: Colors.red,
  fontWeight: FontWeight.w900,
);
TextStyle snackBarNeutralTextStyle = GoogleFonts.roboto(
  fontSize: 18.sp,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

//TODO: Inter Font Family by Omar
TextStyle profileText = GoogleFonts.inter(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
TextStyle profileEmail =
    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400);
TextStyle editProfile = GoogleFonts.inter(
    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

List<List<String>> service_area_list = [[], []];

//Worker Service Screen
List<String> serviceListWorkerScreen = [];
List<String> serviceListSelectedWorkerScreen = [];

//Hive User Credentials
var userBox;
var textId;
var franchiseTextId;
var employeeType;
var rating;
var token;
var status;
var forgotEmail;

//Password TextFormField
double tffHeight = 50;

class PendingRequested {
  static const Pending_price_configuration = 'ppc100';
  static const Area_not_add = 'ana101';
  static const Pending_Approval = 'pa103';
  static const Approved = 'ap104';
  static const PriceRejected = 'pa105';
  static List<Map<String, dynamic>> safetyOptions = [
    {
      'imagePath': 'assets/png/job_safety.png',
      'title': 'On-the-Job Safety',
      'description':
          'Learn how to stay safe while performing your tasks, including safety gear recommendations and emergency contacts.',
    },
    {
      'imagePath': 'assets/png/driving_safety.png',
      'title': 'Driving Safety',
      'description':
          'Stay safe on the road with our driving tips, including vehicle maintenance checks and safe driving practices.',
    },
    {
      'imagePath': 'assets/png/emergency_procedures.png',
      'title': 'Emergency Procedures',
      'description':
          'Be prepared for any situation. Find out what to do in case of an emergency or accident.',
    },
    {
      'imagePath': 'assets/png/job_safety.png',
      'title': 'Wear Appropriate Gear',
      'description':
          'Always wear the recommended safety gear, including gloves, goggles, and sturdy shoes. Safety first!',
    },
    {
      'imagePath': 'assets/png/job_safety.png',
      'title': 'Know Your Surroundings',
      'description':
          'Familiarize yourself with your work environment. Identify exits, first aid kits, and potential hazards.',
    },
  ];
}

TextStyle latoStyle100Thin = GoogleFonts.roboto(
    fontWeight: FontWeight.w100, fontSize: 14, color: AppColors.black);
TextStyle latoStyle200ExtraLight = GoogleFonts.roboto(
    fontWeight: FontWeight.w200, fontSize: 14, color: AppColors.black);
TextStyle latoStyle300Light = GoogleFonts.roboto(
    fontWeight: FontWeight.w300, fontSize: 14, color: AppColors.black);
TextStyle latoStyle400Regular = GoogleFonts.roboto(
    fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.black);
TextStyle latoStyle500Medium = GoogleFonts.roboto(
    fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.black);
TextStyle latoStyle600SemiBold = GoogleFonts.roboto(
    fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.black);
TextStyle latoStyle700Bold = GoogleFonts.roboto(
    fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.black);
TextStyle latoStyle800ExtraBold = GoogleFonts.roboto(
    fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.black);
TextStyle latoStyle900Black = GoogleFonts.roboto(
    fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.black);
