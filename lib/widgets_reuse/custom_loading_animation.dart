import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class ServiceCustomizationSuccess extends StatefulWidget {
  @override
  State<ServiceCustomizationSuccess> createState() =>
      _ServiceCustomizationSuccessState();
}

class _ServiceCustomizationSuccessState
    extends State<ServiceCustomizationSuccess> with TickerProviderStateMixin {
  AnimationController? controller;
  @override
  void initState() {
    // TODO: implement initState

    setController();
    super.initState();
  }

  setController() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(
        () {
          if (controller?.value != null && controller!.value > 0.99) {
            controller?.stop();
            controller?.dispose();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ScheduleScreen(
            //       service: widget.service,
            //       fromCartEdit: widget.fromCartEdit,
            //       cartItem: widget.cartItem,
            //       previousScheduleDate: widget.previousScheduleDate,
            //       previousSchedulePeriod: widget.previousSchedulePeriod,
            //       previousWorkerTextId: widget.previousWorkerTextId,
            //     ),
            //   ),
            // );
          }

          setState(() {});
        },
      );
    controller?.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(AppConstant.serviceCustomizeSuccessSvg),
              SizedBox(
                height: 44,
              ),
              Text('Customizing your service',
                  style: interText(24, myColors.green, FontWeight.w700)),

              SizedBox(
                height: 50,
              ),
              Container(
                // width: 300,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFAAA6A6),
                  ),
                ),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.white,
                  // minHeight: 20,
                  color: AppColors.primaryColor,
                  value: controller!.value,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Finding your service schedule...',
                style: interText(14, Colors.black, FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
