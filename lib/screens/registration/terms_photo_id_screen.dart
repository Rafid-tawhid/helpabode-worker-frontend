// class TermsPhotoIdScreen extends StatefulWidget {
//   TermsPhotoIdScreen({required this.photoIdLabel});
//   String photoIdLabel;
//
//   @override
//   State<TermsPhotoIdScreen> createState() => _TermsPhotoIdScreenState();
// }
//
// class _TermsPhotoIdScreenState extends State<TermsPhotoIdScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             CustomAppBar(label: ''),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 20.w),
//               color: Colors.white,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 25.h,
//                   ),
//                   Text(
//                     'Scan your ${widget.photoIdLabel}',
//                     style: textField_24_black_600_LabelTextStyle,
//                   ),
//                   SizedBox(
//                     height: 25.h,
//                   ),
//                   Text(
//                     'We’ll verify your identity',
//                     style: textField_18_black_400_TextStyle,
//                   ),
//                   SizedBox(
//                     height: 25.h,
//                   ),
//                   InkWell(
//                       onTap: () {
//                         DashboardHelpers.launchUrl('https://helpabode.com/privacy-policy.html');
//                       },
//                       child: RichText(text: TextSpan(style: textField_16_TabTextStyle, text: 'By continuing, you agree that your biometric data will be collected and stored by Team Abode or its vendors for purposes of identity verification. Your data will be permanently deleted from the system after it is no longer necessary.', children: [TextSpan(text: ' For more information, please see our Privacy Policy', style: TextStyle(color: myColors.green))]))),
//                   SizedBox(
//                     height: 45.h,
//                   ),
//                   CustomMaterialButton(
//                     label: 'Continue',
//                     buttonColor: buttonClr,
//                     fontColor: buttonFontClr,
//                     funcName: () {
//                       print('Before Continue Clicked');
//                       Navigator.of(context).pop();
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => PhotoIdScreen(
//                                 isFrontTemp: true,
//                                 photoIdLabel: widget.photoIdLabel,
//                               )));
//                       print('After Continue Clicked');
//                     },
//                     borderRadius: 50.w,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
