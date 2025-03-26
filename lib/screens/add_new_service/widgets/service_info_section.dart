import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/models/pending_requested_servicelist.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../widgets_reuse/circular_image_with_shimmer.dart';
import '../../../widgets_reuse/expandable_text.dart';

class ServiceInfoSection extends StatelessWidget {
  const ServiceInfoSection({
    super.key,
    required this.serviceModel,
  });
  final PendingRequestedServiceList serviceModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Consumer<PricingProvider>(
              builder: (context, provider, _) => Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCircleShimmerImage(
                          imageUrl: '$urlBase${serviceModel.image}',
                          placeholder: 'images/placeholder.jpg',
                          size: 72,
                          borderRadius: 4,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceModel.serviceTitle ?? '',
                                  style: interText(
                                      16, AppColors.black, FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: myColors.green, size: 20),
                                      SizedBox(width: 4),
                                      Text(
                                          provider.pricingServiceDetailsinfo!
                                                  .status ??
                                              '',
                                          textAlign: TextAlign.center,
                                          style: interText(12, myColors.green,
                                              FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text(provider
                                          .pricingServiceDetailsinfo!.avgRating
                                          .toString()),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      Icons.thumb_up_alt,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(provider
                                          .pricingServiceDetailsinfo!.totalLike
                                          .toString()),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text('Total orders : ${0}')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
          ExpandText(
            text: serviceModel.shortDescription ?? '',
            maxLines: 3,
            position: true,
          ),
        ],
      ),
    );
  }
}
