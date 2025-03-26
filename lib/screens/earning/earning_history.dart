import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/custom_earning_details_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/widgets/chart.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/widgets/payout_method_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/widgets/show_chart_options.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../provider/navbar_provider.dart';
import '../support/dashboard_support_screen.dart';
import 'deposit_and_transfer_screen.dart';
import 'earning_details.dart';

class EarningHistoryScreen extends StatefulWidget {
  const EarningHistoryScreen({super.key});

  @override
  State<EarningHistoryScreen> createState() => _EarningHistoryScreenState();
}

class _EarningHistoryScreenState extends State<EarningHistoryScreen> {
  late UserProvider pro;
  String filterData = 'Last 30 days';
  String selectedDate = '2025';

  @override
  void initState() {
    pro = Provider.of<UserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callEarningHistory(pro);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            'Earning',
            style: interText(18, Colors.black, FontWeight.w700),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                var pp = context.read<TabControllerProvider>();
                pp.updateNavBarAtInitialStage(context, 0);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
              icon: Icon(
                Icons.home,
                size: 24,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardSupportScreen()));
                },
                icon: Icon(
                  Icons.help_outline,
                  size: 24,
                )),
          )
        ],
        surfaceTintColor: Colors.white, // Make the app bar transparent
        elevation: 0, // Remove app bar shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const CustomAppBarNew(title: 'Earning History', iconData: Icons.question_mark),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: .2,
                  color: myColors.greyTxt,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ShowChartOptions(
                                      type: 'earning',
                                      selectFillterd: filterData,
                                      onSelected: (filter, date) {
                                        setState(() {
                                          filterData = filter;
                                          selectedDate = date;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$filterData',
                                    style: interText(
                                        14, Colors.black, FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down_outlined)
                                ],
                              ),
                            ),
                            padding: EdgeInsets.only(
                                left: 16, right: 8, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              color: myColors.greyBtn,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Text(
                              DashboardHelpers.formatDateRange(selectedDate) ??
                                  getLast30DaysRange(),
                              style:
                                  interText(14, Colors.black, FontWeight.w500))
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${filterData} earnings',
                        style: interText(15, Colors.black, FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Consumer<UserProvider>(
                            builder: (context, provider, _) => Text(
                              '\$${provider.totalAmountSummary}',
                              style:
                                  interText(24, Colors.black, FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${pro.jobCompleted} jobs completed, \$${pro.avg_amount} average tip amount',
                        style: interText(14, myColors.grey, FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4,
                  color: Color(0xfff6f6f6),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  DepositAndTransferScreen()));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Withdraw Funds',
                                style:
                                    interText(18, Colors.black, FontWeight.w600)
                                        .copyWith(letterSpacing: 0),
                              ),
                              Text(
                                'Monthly auto-transfer will initiate on 21/27',
                                style: interText(
                                        14, Color(0xff636366), FontWeight.w400)
                                    .copyWith(letterSpacing: 0),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: myColors.greyBtn,
                                      elevation: 1,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                PayoutMethodsPage()));
                                  },
                                  child: Text(
                                    'Manage Bank Account',
                                    style: interText(
                                        14, Colors.black, FontWeight.w500),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    height: 4,
                    color: const Color(0xffF6F6F6),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earnings History',
                        style: interText(18, Colors.black, FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Consumer<UserProvider>(
                        builder: (context, pro, _) => SizedBox(
                            height: 200,
                            width: 500,
                            child: pro.tipsChartLoading
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                        child: CircularProgressIndicator()))
                                : MonthlyEarningsChart(
                                    pro.earningChartListData)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Consumer<UserProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading == true) {
                  return CircularProgressIndicator(
                    color: myColors.green,
                  );
                } else {
                  return provider.workerEarninghistoryInfoList.isEmpty
                      ? const Center(
                          child: Text('No data found'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async {
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black);
                              if (await provider.dateWiseEarningList(provider
                                  .workerEarninghistoryInfoList[index].date!)) {
                                var model = CustomEarningDetailsModel(
                                    date: provider
                                            .workerEarninghistoryInfoList[index]
                                            .date ??
                                        '',
                                    amount: provider
                                        .workerEarninghistoryInfoList[index]
                                        .totalAmount
                                        .toString(),
                                    jobCompleted: provider.jobCompleted,
                                    avgAmount: provider.avg_amount,
                                    totalAmountSummary:
                                        provider.totalAmountSummary);
                                EasyLoading.dismiss();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EarningDetails(
                                            model, selectedDate)));
                              } else {
                                EasyLoading.dismiss();
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DashboardHelpers.formatDate(provider
                                                .workerEarninghistoryInfoList[
                                                    index]
                                                .date ??
                                            ''),
                                        style: interText(
                                            16, Colors.black, FontWeight.w500),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '\$${provider.workerEarninghistoryInfoList[index].totalAmount.toString()}',
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
                                    height: 12,
                                  ),
                                  Container(
                                    height: 1,
                                    color: Color(0xfff6f6f6),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount:
                              provider.workerEarninghistoryInfoList.length,
                        );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  void callEarningHistory(UserProvider provider) async {
    //provider.getProviderEarningHistory();
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 30));
    String start_date =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    String end_date =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
    Map<String, dynamic> filterDate = {
      "start_date": start_date,
      "end_date": end_date,
      "range_type": 'rangeType',
    };

    debugPrint('filterDate ${filterDate}');

    provider.getEarningHistory(date: filterDate, callDefault: 'monthly');
  }

  String getLast30DaysRange() {
    final DateTime today = DateTime.now();
    final DateTime last30Days = today.subtract(const Duration(days: 30));

    String formatDate(DateTime date) {
      const List<String> months = [
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
      String month = months[date.month - 1];
      String day = date.day.toString();
      return '$month$day';
    }

    String startDate = formatDate(last30Days);
    String endDate = formatDate(today);

    return '$startDate-$endDate';
  }
}
