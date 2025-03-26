import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../provider/user_provider.dart';
import '../../../../widgets_reuse/custom_rounded_button.dart';

class CustomBottomButton extends StatelessWidget {
  final RoundedLoadingButtonController? btnController;
  final String btnText;
  final VoidCallback onpressed;
  bool? isLoading = false;

  CustomBottomButton(
      {this.btnController,
      required this.btnText,
      required this.onpressed,
      this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Consumer<UserProvider>(
          builder: (context, provider, _) =>
              isLoading != null && isLoading == true
                  ? LoadingIndicatorWidget()
                  : CustomRoundedButton(
                      height: 44,
                      label: btnText,
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: onpressed,
                      borderRadius: 8,
                      controller: RoundedLoadingButtonController(),
                    ),
        ),
      ),
    );
  }
}
