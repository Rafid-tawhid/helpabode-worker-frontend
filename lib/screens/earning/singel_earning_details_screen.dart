import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/dashboard_helpers.dart';
import '../../misc/constants.dart';
import '../../models/date_wise_earning_model.dart';
import '../../provider/user_provider.dart';
import '../../widgets_reuse/bottom_nav_bar.dart';

class SingelEarningDetailsScreen extends StatelessWidget {
  OrderArray orderArray;

  SingelEarningDetailsScreen(this.orderArray);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const MyBottomNavBar(),
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text(
                DashboardHelpers.formatDate(orderArray.orderDate ?? ''),
                style: interText(15, Colors.black, FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Order Id# ${orderArray.orderTextId}',
                style: interText(13, Colors.black, FontWeight.w600),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: Consumer<UserProvider>(
          builder: (context, provider, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  height: .2,
                  color: myColors.greyTxt,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '\$${orderArray.amount}',
                        style: interText(28, Colors.black, FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Total earnings for this order',
                                  style: interText(
                                      14, Colors.black, FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Help Abode Pay Adjustment',
                                  style: interText(
                                      14, Colors.black, FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Icon(
                                  Icons.info_outline,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                          Text(
                            '\$${orderArray.amount}',
                            style: interText(14, Colors.black, FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        height: .2,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        color: myColors.greyTxt,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Job Completed',
                                  style: interText(
                                      14, Colors.black, FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${provider.workerEarningInfoSingel.length}',
                            style: interText(14, Colors.black, FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Service items',
                                  style: interText(
                                      14, Colors.black, FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${provider.workerEarningInfoSingel.length}',
                            style: interText(14, Colors.black, FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 4,
                  color: myColors.devider,
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Services',
                      style: interText(18, Colors.black, FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: .2,
                  color: myColors.greyTxt,
                ),
                const SizedBox(
                  height: 16,
                ),
                ...provider.workerEarningInfoSingel.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    e.serviceTitle ?? '',
                                    style: interText(
                                        16, Colors.black, FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${e.serviceAmount}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Customer tips',
                                    style: interText(
                                        14, Colors.black, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${e.tipAmount}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Start Time',
                                    style: interText(
                                        14, Colors.black, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${e.scheduledStartTime}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'End Time',
                                    style: interText(
                                        14, Colors.black, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${e.scheduleEndtime}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: .2,
                          color: myColors.greyTxt,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
