import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/widgets/chart.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/widgets/show_chart_options.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../support/dashboard_support_screen.dart';

class TipsAndRewards extends StatefulWidget {
  const TipsAndRewards({super.key});

  @override
  State<TipsAndRewards> createState() => _TipsAndRewardsState();
}

class _TipsAndRewardsState extends State<TipsAndRewards> {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late UserProvider provider;

  @override
  void initState() {
    provider = Provider.of<UserProvider>(context, listen: false);
    Future.microtask(() {
      provider.getWorkerTipsInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Earning/Rewards',
          style: interText(18, Colors.black, FontWeight.w600),
        ),
        surfaceTintColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardSupportScreen()));
                },
                icon: Icon(
                  Icons.question_mark,
                  size: 20,
                )),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deposits and transfers',
                      style: interText(14, Colors.black, FontWeight.w500),
                    ),
                    Text(
                      'Weekly auto-transfer will initiate on 21/27',
                      style: interText(14, Colors.black, FontWeight.w500),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 10,
                    color: const Color(0xffF6F6F6),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Earnings History',
                      style: interText(18, Colors.black, FontWeight.bold),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ShowChartOptions(
                              type: 'tips',
                              onSelected: (filter, date) {},
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: myColors.greyBtn),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<UserProvider>(
                  builder: (context, pro, _) => SizedBox(
                      height: 200,
                      width: 500,
                      child: pro.tipsChartLoading
                          ? SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(child: CircularProgressIndicator()))
                          : MonthlyEarningsChart(pro.earningChartListData)),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Consumer<UserProvider>(
            builder: (context, provider, _) {
              return provider.workerTipsInfoList.isEmpty
                  ? const Center(
                      child: Text('No data found'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => EarningDetails(provider.workerTipsInfoList[index])));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DashboardHelpers.convertDateTime(provider
                                              .workerTipsInfoList[index]
                                              .orderDate ??
                                          ''),
                                      style: interText(
                                          16, Colors.black, FontWeight.w500),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '\$${provider.workerTipsInfoList[index].tipAmount.toString()}',
                                          style: interText(16, Colors.black,
                                              FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: .5,
                                  color: myColors.greyBtn,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: provider.workerTipsInfoList.length,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
