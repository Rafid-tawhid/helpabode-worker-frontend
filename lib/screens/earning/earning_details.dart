import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/singel_earning_details_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/new_custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../models/custom_earning_details_model.dart';
import '../../provider/user_provider.dart';
import '../../widgets_reuse/bottom_nav_bar.dart';

class EarningDetails extends StatefulWidget {
  CustomEarningDetailsModel info;
  String date;

  EarningDetails(this.info, this.date);

  @override
  State<EarningDetails> createState() => _EarningDetailsState();
}

class _EarningDetailsState extends State<EarningDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const MyBottomNavBar(),
        body: SafeArea(
            child: Consumer<UserProvider>(
          builder: (context, provider, _) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CustomAppBarNew(
                      title:
                          DashboardHelpers.formatDate(widget.info.date ?? ''),
                      iconData: Icons.question_mark),
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
                          '\$${widget.info.amount}',
                          style: interText(28, Colors.black, FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total earnings of this day',
                                    style: interText(
                                        14, Colors.black, FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Help Abode Pay Adjustment',
                                    style: interText(
                                        14, Colors.black, FontWeight.w500),
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
                              '\$${widget.info.amount}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          decoration: BoxDecoration(color: Color(0xfff7f7f7)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your guaranteed earnings for the week of ${widget.info.date} was \$${widget.info.amount}',
                                  style: interText(
                                      16, Colors.black, FontWeight.w500),
                                ),
                                InkWell(
                                  onTap: () {
                                    DashboardHelpers.openUrl(
                                        'https://helpabode.com/privacy-policy.html');
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: myColors.greyServiceBg),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 12),
                                        child: Text(
                                          'Learn More',
                                          style: interText(14, Colors.black,
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Customer tips',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '\$${provider.dateWiseEarningModel!.totalTipAmount}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            )
                          ],
                        ),
                        Container(
                          height: .2,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          color: myColors.greyTxt,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duration',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '${provider.dateWiseEarningModel!.totalWorkHour} hr',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Job Complete',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '${provider.dateWiseEarningModel!.totalOrder}',
                              style:
                                  interText(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 4,
                    color: myColors.devider,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Orders',
                        style: interText(18, Colors.black, FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: .2,
                    color: myColors.greyTxt,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...provider.dateWiseEarningModel!.orderArray!.map(
                    (e) => InkWell(
                      onTap: () async {
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        if (await provider
                            .dateWiseOrderEarningSingel(e.orderTextId ?? '')) {
                          EasyLoading.dismiss();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SingelEarningDetailsScreen(e)));
                        } else {
                          EasyLoading.dismiss();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            DashboardHelpers.formatDate(
                                                e.orderDate ?? ''),
                                            style: interText(16, Colors.black,
                                                FontWeight.w500),
                                          ),
                                          Spacer(),
                                          Text(
                                            '\$${e.amount}',
                                            style: interText(16, Colors.black,
                                                FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Order Id : ${e.orderTextId}',
                                            style: interText(12, Colors.black,
                                                FontWeight.w500),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${DashboardHelpers.getTimeFromDate(e.orderDate)}',
                                            style: interText(12, Colors.black,
                                                FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: .2,
                              color: myColors.greyTxt,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
