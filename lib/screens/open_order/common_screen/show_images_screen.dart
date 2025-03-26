import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../dashboard/dashboard_screen.dart';
import '../completed_order/widgets/service_attribute.dart';
import '../ordered_service_details_screen.dart';
import '../widgets/before_after_image_confirmation_end_order.dart';
import '../widgets/end_job_no_contact_static_screen.dart';

class ShowImageScreeen extends StatelessWidget {
  ShowImageScreeen({required this.type});

  String type;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _bottomBtnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            },
            icon: Icon(Icons.clear),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            provider.tempStatus == 'Before'
                ? Text(
                    'Take before photo',
                    style: interText(18, Colors.black, FontWeight.w700)
                        .copyWith(letterSpacing: 0),
                  )
                : Text(
                    provider.is_chat == true
                        ? 'Contacted Service'
                        : 'No-contact service',
                    style: interText(18, Colors.black, FontWeight.w700)
                        .copyWith(letterSpacing: 0),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Follow the guidelines below to show how you done your job. your photo will be shared with the customer.',
                style: interText(16, Colors.black, FontWeight.w400)
                    .copyWith(letterSpacing: 0),
              ),
            ),
            Expanded(
              child: type == 'camera'
                  ? ListView.builder(
                      itemCount: provider.cameraBeforeImageList.length,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // Set your desired border radius here
                                  border: Border.all(
                                    color: Colors
                                        .white, // Set your border color here
                                    width: 1.0, // Set your border width here
                                  ),
                                ),
                                height: 180.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    provider.cameraBeforeImageList[index],
                                    fit: BoxFit.cover,
                                    width: MediaQuery.sizeOf(context).width,
                                  ),
                                )),
                          ),
                          Positioned(
                            right: 20,
                            top: 20,
                            child: InkWell(
                                onTap: () {
                                  provider.removeImage(
                                      provider.cameraBeforeImageList[index]);
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/close.svg',
                                  width: 20,
                                )),
                          ),
                          if ((index + 1) ==
                              provider.cameraBeforeImageList.length)
                            Positioned(
                              right: 20,
                              bottom: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final image = await ImagePicker().pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 100,
                                    );
                                    if (image != null) {
                                      final imageTemp = File(image.path);
                                      provider.addToCameraList(imageTemp);
                                    }
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        mainAxisSpacing: 5.0, // Spacing between rows
                        crossAxisSpacing: 5.0, // Spacing between columns
                      ),
                      itemCount: provider.cameraBeforeImageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      content: Stack(
                                        children: [
                                          Image.file(
                                            provider
                                                .cameraBeforeImageList[index],
                                            fit: BoxFit.fill,
                                          ),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.close))),
                                        ],
                                      ),
                                    ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                      provider.cameraBeforeImageList[index]),
                                  // Replace 'assets/background_image.jpg' with your image asset path
                                  fit: BoxFit
                                      .cover, // Adjust the BoxFit property as needed
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: InkWell(
                                        onTap: () {
                                          provider.removeImage(provider
                                              .cameraBeforeImageList[index]);
                                        },
                                        child: SvgPicture.asset(
                                            'assets/svg/close.svg')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            provider.cameraBeforeImageList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRoundedButton(
                        label: 'Confirm',
                        buttonColor: myColors.green,
                        fontColor: Colors.white,
                        funcName: () async {
                          if (provider.tempStatus == 'Before') {
                            _bottomBtnController.start();
                            await uploadBeforeImage(context, provider);
                            _bottomBtnController.stop();
                          } else {
                            //this is the code for completing the job
                            var provider = context.read<OrderProvider>();
                            _bottomBtnController.start();
                            await provider.postMultipleImageAfterStartWork(
                                provider.pendingOrderInfoList.first.orderItemId
                                    .toString(),
                                provider.pendingOrderInfoList.first.orderTextId,
                                provider.cameraBeforeImageList);
                            await provider.saveWorkerStatus(
                                provider.pendingOrderInfoList.first.orderTextId,
                                'Completed',
                                textId,
                                provider
                                    .pendingOrderInfoList.first.serviceTextId
                                    .toString(),
                                provider.pendingOrderInfoList.first.orderItemId
                                        .toString() ??
                                    '');
                            //clear image list
                            provider.clearImage();
                            //get order values again
                            await provider.getOpenOrderInfo();
                            //set status
                            provider.setPendingDetailsScreenServiceStatus(
                                JobStatus.completed);
                            provider
                                .mapJobStatusToOrderStatus(JobStatus.completed);
                            provider.getPendingDetailsScreenButtonText(
                                JobStatus.completed);
                            DashboardHelpers.successStopAnimation(
                                _bottomBtnController);
                            //get previous and uploaded image
                            await provider.getUploadedImages(
                                provider.pendingOrderInfoList.first.orderItemId,
                                provider
                                    .pendingOrderInfoList.first.orderTextId);
                            //this is for job complete preview screen

                            //change here march 22
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             BeforeAfterImageAndEndOrder()))

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NoContactServiceScreen(
                                            orderInfo: provider
                                                .pendingOrderInfoList.first)));
                          }
                        },
                        borderRadius: 40,
                        controller: _bottomBtnController),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRoundedButton(
                        label: 'Confirm',
                        buttonColor: myColors.greyBg,
                        fontColor: Colors.white,
                        funcName: () {
                          //  _showBottomSheet(context, provider, orderInfo);
                        },
                        borderRadius: 40,
                        controller: _btnController),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> uploadBeforeImage(
      BuildContext context, OrderProvider provider) async {
    print('BEFORE IMAGES CALLING');
    _btnController.start();
    await provider.postMultipleImageBeforStartWork(
        provider.pendingOrderInfoList.first.orderItemId.toString(),
        provider.pendingOrderInfoList.first.orderTextId,
        provider.cameraBeforeImageList);
    await provider.saveWorkerStatus(
        provider.pendingOrderInfoList.first.orderTextId,
        'JobStarted',
        textId,
        provider.pendingOrderInfoList.first.serviceTextId.toString(),
        provider.pendingOrderInfoList.first.orderItemId.toString() ?? '');

    // //update status
    provider.setPendingDetailsScreenServiceStatus(JobStatus.jobStarted);
    provider.mapJobStatusToOrderStatus(JobStatus.jobStarted);
    provider.getPendingDetailsScreenButtonText(JobStatus.jobStarted);

    //get order values again
    await provider.getOpenOrderInfo();
    //clear image list
    provider.clearImage();

    DashboardHelpers.successStopAnimation(_bottomBtnController);
    Navigator.pop(context);

    var order = provider.pendingOrderInfoList.first;
    order.serviceStatus = 'Job Started';

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderedServiceDetailsScreen(
                  orderTextId: order.orderTextId ?? '',
                  serviceId: order.serviceTextId ?? '', // from pending screen
                )));
  }
}
