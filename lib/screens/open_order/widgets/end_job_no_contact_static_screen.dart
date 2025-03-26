import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shimmer/shimmer.dart';
import '../../../auth/helper.dart';
import '../../../chat/chat_provider.dart';
import '../../../chat/views/chat_screen.dart';
import '../../../helper_functions/dashboard_helpers.dart';
import '../../../misc/constants.dart';
import '../../../models/pending_service_details_model.dart';
import '../../../provider/order_provider.dart';
import '../../../widgets_reuse/custom_rounded_button.dart';
import '../../dashboard/dashboard_screen.dart';
import '../common_screen/show_images_screen.dart';
import '../completed_order/widgets/service_attribute.dart';


class NoContactServiceScreen extends StatelessWidget {
  PendingServiceDetailsModel orderInfo;

  NoContactServiceScreen({required this.orderInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<OrderProvider>(
          builder: (context, pro, _) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pro.is_chat == 'Yes' ? 'Contacted service' : "No-contact service",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: myColors.greyBtn, borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              onTap: () async {
                                var cp = context.read<ChatProvider>();
                                var orderProvider = context.read<OrderProvider>();
                                if (await cp.getChat(orderInfo.orderItemId.toString())) {
                                  Helper.toScreen(
                                    context,
                                    ChatScreen(
                                      receiverName: orderProvider.orderedUserData!.endUserName ?? '',
                                      receiverTextId: orderProvider.orderedUserData!.endUserTextId ?? '',
                                      groupTextId: orderProvider.pendingOrderInfoList.first.groupName ?? '',
                                      service: orderProvider.pendingOrderInfoList.first.serviceTitle ?? '',
                                      workerId: orderProvider.pendingOrderInfoList.first.workerTextId ?? '',
                                      orderTimeId: orderProvider.pendingOrderInfoList.first.orderItemId.toString(),
                                      orderTextId: orderProvider.pendingOrderInfoList.first.orderTextId ?? '',
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                                child: Text(
                                  'Chat History',
                                  style: interText(12, Colors.black, FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 12),

                      // Subtitle
                      Text(
                        "Take a photo",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),

                      // Description
                      Text(
                        "Follow the guidelines below to show how you done your job. Your photo will be shared with the customer.",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),

                      SizedBox(height: 16),
                      //pro.afterImages.isEmpty
                      if (false)
                        Column(
                          children: [
                            checklistItem("Clear View", "Ensure the entire room is visible in the photo."),
                            checklistItem("Good Lighting", "Ensure good lighting for a clear picture."),
                            checklistItem("Multiple Angles", "Take multiple shots if necessary."),
                            checklistItem("Details", "Pay attention to specific areas that need work."),
                          ],
                        ),

                      if (pro.beforeImage.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Before photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            // ImageSlider(images: provider.beforeImage, urlBase: urlBase),
                            buildImageList(pro.beforeImage),
                            SizedBox(height: 8),
                          ],
                        ),
                      Container(
                        height: 6,
                        color: myColors.devider,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                      if (pro.afterImages.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text('After photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            buildImageList(pro.afterImages),
                            //ImageSlider(images: provider.afterImages, urlBase: urlBase),
                            SizedBox(height: 20),
                          ],
                        ),

                      // Pushes button to bottom
                    ],
                  ),
                ),
              ),
              // Bottom Button
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  icon: pro.afterImages.isNotEmpty ? null : Icon(Icons.camera_alt, color: Colors.white),
                  label: Text(
                    pro.afterImages.isNotEmpty ? "Complete the job" : "Take After Photo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    if (pro.afterImages.isNotEmpty) {
                      _showJobCompletedSheet(context);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Consumer<OrderProvider>(
                            builder: (context, provider, _) => Container(
                              height: 180,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final image = await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 70,
                                        );

                                        if (image != null) {
                                          final imageTemp = File(image.path);
                                          provider.addToCameraList(imageTemp);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShowImageScreeen(type: 'camera')));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF008951),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: Text(
                                        'Take Photo',
                                        style: interText(16, Colors.white, FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Add spacing between buttons
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        final pickedFiles = await picker.pickMultiImage(
                                          imageQuality: 70,
                                        );
                                        if (pickedFiles.isNotEmpty) {
                                          pickedFiles.forEach((element) {
                                            provider.addToCameraList(File(element.path));
                                          });

                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShowImageScreeen(type: 'gallery')));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFe9e9e9),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: Text(
                                        'Add Photo from Library',
                                        style: interText(16, Colors.black, FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Checklist Widget
  Widget checklistItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Colors.black, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageList(List<String> images) {
    return SizedBox(
      height: 130,
      child: images.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => openImageGallery(images, index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: '${urlBase}${images[index]}',
                        width: 160,
                        height: 130,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 160,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 160,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('No Images Found')),
    );
  }

  void openImageGallery(List<String> images, int index) {
    // You can use a package like 'photo_view' to open full-screen images
    print("Opening image: ${images[index]}");
  }

  void _showJobCompletedSheet(BuildContext context) {
    RoundedLoadingButtonController _bottomBtnController = RoundedLoadingButtonController();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return showJobEndConfirmationAlert(context, _bottomBtnController);
      },
    );
  }

  Container showJobEndConfirmationAlert(BuildContext context, RoundedLoadingButtonController _bottomBtnController) {
    return Container(
      height: MediaQuery.sizeOf(context).height / 1.1,
      child: SingleChildScrollView(
        child: Consumer<OrderProvider>(
            builder: (context, provider, _) => Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            'Job complete!',
                            style: interText(24, Colors.black, FontWeight.w700),
                          ),
                        ),
                      ),
                      //Save Service Area
                      Divider(thickness: 1, color: Color(0xffe9e9e9)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            'Service Details',
                            style: interText(16, Colors.black, FontWeight.w700),
                          ),
                        ),
                      ),
                      Divider(thickness: 1, color: Color(0xffe9e9e9)),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                height: 64,
                                width: 64,
                                image: NetworkImage('$urlBase${provider.pendingOrderInfoList.first.serviceImage}'),
                                placeholder: const AssetImage('images/placeholder.jpg'),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/svg/Selfie.png',
                                    fit: BoxFit.cover,
                                    height: 64,
                                    width: 64,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.pendingOrderInfoList.first.serviceTitle ?? 'Service Name',
                                    style: interText(16, Colors.black, FontWeight.w600),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (provider.pendingOrderInfoList.first.servicePlan != 'Admin Bundle Plan' && provider.pendingOrderInfoList.first.servicePlan != 'Admin Default Plan')
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: myColors.primaryStroke,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                            child: Text(
                                              provider.pendingOrderInfoList.first.servicePlan ?? 'Basic',
                                              style: interText(12, Colors.black, FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      Expanded(child: Container()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                ServiceAttribute(
                                  serviceJsonList: provider.pendingOrderInfoList.first.serviceJson!,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(thickness: 1, color: Color(0xffe9e9e9)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Billing Address : ',
                                              style: interText(16, Colors.black, FontWeight.w600).copyWith(letterSpacing: 0),
                                            ),
                                            Text(
                                              '${provider.pendingOrderInfoList.first.orderDeliveryAddress!.zip}, ${provider.pendingOrderInfoList.first.orderDeliveryAddress!.city} ${provider.pendingOrderInfoList.first.orderDeliveryAddress!.state}' ?? '',
                                              // 'hello world',
                                              style: interText(16, hintClr, FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Locate on map',
                                              style: interText(14, myColors.green, FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(thickness: 1, color: Color(0xffe9e9e9)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Date : ',
                                        style: interText(16, Colors.black, FontWeight.w600).copyWith(letterSpacing: 0),
                                      ),
                                      Consumer<OrderProvider>(
                                        builder: (context, provider, _) => Text(
                                          DashboardHelpers.convertDateTime(provider.pendingOrderInfoList.first.orderDate ?? '') ?? '',
                                          // 'hello world',
                                          style: interText(16, Colors.black, FontWeight.w600).copyWith(letterSpacing: 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(thickness: 1, color: Color(0xffe9e9e9)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Duration', style: interText(16, Colors.black, FontWeight.w600).copyWith(letterSpacing: 0)),
                                      Consumer<OrderProvider>(
                                        builder: (context, provider, _) => Text(
                                          '${DashboardHelpers.convertDecimalToHoursMinutes(double.parse(provider.pendingOrderInfoList.first.workHour.toString()))}',
                                          style: interText(16, Colors.black, FontWeight.w600).copyWith(letterSpacing: 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(thickness: 1, color: Color(0xffe9e9e9)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Bill', style: interText(20, Colors.black, FontWeight.bold).copyWith(letterSpacing: 0)),
                                      Consumer<OrderProvider>(
                                          builder: (context, provider, _) => Text(
                                                '\$${provider.pendingOrderInfoList.first.serviceAmount}',
                                                style: TextStyle(fontSize: 20, color: myColors.green, fontWeight: FontWeight.bold),
                                              )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomRoundedButton(
                          label: 'Close',
                          buttonColor: myColors.green,
                          fontColor: Colors.white,
                          funcName: () async {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                          },
                          borderRadius: 10,
                          controller: _bottomBtnController,
                        ),
                      ),

                      const SizedBox(height: 16.0),
                    ],
                  ),
                )),
      ),
    );
  }
}
