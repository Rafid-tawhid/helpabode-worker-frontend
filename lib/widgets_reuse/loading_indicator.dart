import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final double? strokeWidth;
  const LoadingIndicatorWidget(
      {super.key, this.color, this.width, this.height, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: width ?? 52,
          height: height ?? 36,
          child: LoadingIndicator(
            strokeWidth: strokeWidth ?? 6,
            colors: [
              color ?? myColors.green,
            ],
            indicatorType: Indicator.ballBeat,
          )),
    );
  }
}
