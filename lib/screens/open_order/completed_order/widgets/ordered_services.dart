import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/completed_order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/completed_order/widgets/service_attribute.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/circular_image_with_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../misc/constants.dart';
import '../../../../models/completed_order_details_model.dart';

class OrderedServicesInfo extends StatelessWidget {
  final CompletedOrderDetailsModel orderInfo;

  OrderedServicesInfo({required this.orderInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCircleShimmerImage(
              imageUrl: '$urlBase${orderInfo.serviceImage}',
              placeholder: 'images/placeholder.jpg',
              size: 64,
              borderRadius: 8,
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8.0),
            //   child: FadeInImage(
            //     fit: BoxFit.cover,
            //     height: 64,
            //     width: 64,
            //     image: NetworkImage('$urlBase${orderInfo.serviceImage}'),
            //     placeholder: const AssetImage('images/placeholder.jpg'),
            //     imageErrorBuilder: (context, error, stackTrace) {
            //       return Image.asset(
            //         'assets/svg/Selfie.png',
            //         fit: BoxFit.cover,
            //         height: 64,
            //         width: 64,
            //       );
            //     },
            //   ),
            // ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          orderInfo.serviceTitle ?? 'Service Name',
                          style: interText(16, Colors.black, FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          '\$${orderInfo.serviceAmount}',
                          style: interText(16, Colors.black, FontWeight.w600),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Consumer<CompletedOrderProvider>(
                        builder: (context, provider, _) => provider
                                        .completedOrderDetailsList
                                        .first
                                        .servicePlan !=
                                    'Admin Default Plan' &&
                                provider.completedOrderDetailsList.first
                                        .servicePlan !=
                                    'Admin Bundle Plan'
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: myColors.primaryStroke,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  child: Text(
                                    provider.completedOrderDetailsList.first
                                            .servicePlan ??
                                        'Basic',
                                    style: interText(
                                        12, Colors.black, FontWeight.w500),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        ServiceAttribute(
          serviceJsonList: orderInfo.serviceJson ?? [],
          type: orderInfo.servicePlan,
        ),
        SizedBox(
          height: 12,
        ),
      ]),
    );
  }
}
