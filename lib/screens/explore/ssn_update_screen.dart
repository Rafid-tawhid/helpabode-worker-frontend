import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/worker_pending_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/explore/document_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../helper_functions/dashboard_helpers.dart';
import '../../misc/constants.dart';
import '../../widgets_reuse/custom_appbar.dart';
import '../../widgets_reuse/custom_text_form_field.dart';
import '../registration/ssn_id_screen_2.dart';

class SsnUpdateDocument extends StatefulWidget {
  @override
  State<SsnUpdateDocument> createState() => _SsnUpdateDocumentState();
}

class _SsnUpdateDocumentState extends State<SsnUpdateDocument> {
  final _formSSNKey = GlobalKey<FormState>();
  FocusNode focusNodeSSN = FocusNode();
  var isCheckSSN = null;
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();
  var isButtonLoading = false;
  final TextEditingController ssnTextFormController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgClr,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(label: ''),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'SSN ',
                      style: text_20_black_600_TextStyle,
                      children: [
                        TextSpan(
                          text: '(Your Social Security Number)',
                          style: textField_16_TabTextStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  CustomTextField(
                    width: 388,
                    borderRadius: 8,
                    formKey: _formSSNKey,
                    fieldTextFieldController: ssnTextFormController,
                    keyboard: TextInputType.number,
                    inputFormat: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(11),
                      CustomHyphenInputFormatter(),
                      // FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
                    ],
                    funcOnChanged: (value) {},
                    funcValidate: (value) {
                      if (value!.trim().isEmpty) {
                        return 'SSN is Required';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Enter SSN',
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Text(
                    'To continue enter your Social Security Number',
                    style: text_16_black_400_TextStyle,
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Consumer<WorkerPendingProvider>(
                    builder: (context, provider, _) => RoundedLoadingButton(
                        color: myColors.green,
                        controller: controller,
                        successColor: myColors.green,
                        onPressed: () async {
                          if (_formSSNKey.currentState!.validate()) {
                            controller.start();
                            if (await await provider.postWorkerDocumentUpdate(
                                stage: PendingStatus.ssn,
                                ssn: ssnTextFormController.text.trim())) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DocumentScreen()));
                            }
                            DashboardHelpers.successStopAnimation(controller);
                          } else {
                            print('SSN Failed');
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Next',
                                style: interText(
                                    16, Colors.white, FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
