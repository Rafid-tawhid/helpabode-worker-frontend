import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/earning_chart_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/add_new_service.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/widgets/recent_order_widget.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/widgets/team_members_widget.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/earning_history.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/shift_config.dart';
import 'package:provider/provider.dart';
import '../../../corporate/individual_team/my_team_member_list.dart';
import '../../../misc/constants.dart';
import '../../open_order/open_order_screen.dart';
import '../../pricing/pricing_screen.dart';
import '../../myservice/my_services_screen.dart';
import '../../add_service_zone/service_area_show.dart';
import '../../shift/new_schedule_screen.dart';
import 'dashboard_gridview.dart';

class DashboardBottomSheet extends StatelessWidget {
  final String frrom;

  DashboardBottomSheet({required this.frrom});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: frrom == 'db'
            ? MediaQuery.sizeOf(context).height / 1
            : MediaQuery.sizeOf(context).height / 2,
        child: DraggableScrollableSheet(
          initialChildSize: 0.76,
          // Initial size of the sheet
          minChildSize: 0.4,
          // Minimum size of the sheet
          maxChildSize: 0.76,
          // Maximum size of the sheet
          expand: true,
          // Whether to expand the sheet to full screen when dragged upwards
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFD9D9D9)),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopServicesWidget(
                            frrom: frrom, // or any value based on your logic
                            serviceItems: serviceItems,
                          ),
                          Container(
                            height: 4,
                            color: myColors.greyBg,
                          ),
                          ChartEarnings(
                            from: frrom,
                          ),
                          if (frrom == 'db')
                            Consumer<OrderProvider>(
                                builder: (context, pro, _) => MyGridView(
                                      dataList: pro.dashboardOrderCardDataList,
                                    )),
                          const SizedBox(
                            height: 24,
                          ),
                          Consumer<OrderProvider>(
                            builder: (context, pro, _) {
                              return pro.workerRunningServiceList.length > 0
                                  ? RecentOrdersWidget(
                                      serviceList: pro.workerRunningServiceList)
                                  : SizedBox.shrink();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (frrom == 'db')
                            Container(
                              height: 4,
                              color: myColors.greyBg,
                            ),
                          Consumer<OrderProvider>(
                              builder: (context, pro, _) =>
                                  pro.dashboardMyTeamMemberList.length > 0
                                      ? MyTeamMembers(
                                          teamList:
                                              pro.dashboardMyTeamMemberList,
                                        )
                                      : SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const MyServicesScreen(),
      //           ),
      //         );
      //       },
      //       style: ElevatedButton.styleFrom(backgroundColor: myColors.green),
      //       child: const Text(
      //         'My Service',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 20,
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const MyServiceArea(),
      //           ),
      //         );
      //       },
      //       style: ElevatedButton.styleFrom(backgroundColor: myColors.green),
      //       child: const Text(
      //         'My Service Area',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ChartEarnings extends StatelessWidget {
  final String from;

  ChartEarnings({required this.from});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OrderProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: provider.dashboardEarningChartData.isEmpty
          ? Text('')
          : GestureDetector(
              onTap: () {
                from == 'db'
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EarningHistoryScreen()))
                    : DashboardHelpers.showAlert(
                        msg: 'you are not verified yet.');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, right: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Earnings',
                                    style: interText(
                                        14, Color(0XFF535151), FontWeight.w500),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '\$' +
                                        '${provider.dashboardEarningChartData.isEmpty ? '0.0' : getChartDataTotalEarning(provider.dashboardEarningChartData)}',
                                    style: interText(
                                        22, myColors.green, FontWeight.w600),
                                  ),
                                ],
                              ),
                              Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF7F7F7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/svg/bank_icon.svg',
                                      height: 18,
                                      width: 18,
                                      color: Colors.black,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LineChart(provider.mainData(
                              provider.parseEarningChartData(
                                  provider.dashboardEarningChartData))),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  String getChartDataTotalEarning(
      List<EarningChartModel> dashboardEarningChartData) {
    double total = 0.0;
    dashboardEarningChartData.forEach((e) {
      total = total + e.totalEarned;
    });

    return total.toString();
  }
}

class TopServicesWidget extends StatelessWidget {
  const TopServicesWidget({
    super.key,
    required this.frrom,
    required this.serviceItems,
  });

  final String frrom;
  final List<Map<String, dynamic>> serviceItems;

  @override
  Widget build(BuildContext context) {
    var filteredServiceItems = [];
    // Remove the item for under provider or corporate member
    if (DashboardHelpers.userModel!.employeeType ==
        UserHelpers.empTypeCorporateMember) {
      filteredServiceItems = List.from(serviceItems)..removeAt(5);
    } else if (DashboardHelpers.userModel!.employeeType ==
        UserHelpers.empTypeUnderProvider) {
      List<int> indicesToRemove = [0, 1, 3, 5];

      // Create a new list excluding the specified indices
      filteredServiceItems = List.from(serviceItems
          .asMap()
          .entries
          .where((entry) => !indicesToRemove.contains(entry.key))
          .map((entry) => entry.value));
    } else {
      filteredServiceItems = serviceItems;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            // Removes the default padding in the GridView
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 items in each row
              mainAxisSpacing: 10, // Spacing between rows
              crossAxisSpacing: 10, // Spacing between items in a row
              childAspectRatio: .9, // Aspect ratio for uniform width and height
            ),
            itemCount: filteredServiceItems.length,
            itemBuilder: (context, index) {
              final item = filteredServiceItems[index];
              return InkWell(
                onTap: () => item['onTap'](context, frrom),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: myColors.greyBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (item['icon'].endsWith('.svg'))
                        SvgPicture.asset(
                          item['icon'],
                          color: myColors.grey,
                          height: 28,
                          width: 28,
                        )
                      else
                        Image.asset(
                          item['icon'],
                          height: 28,
                          width: 28,
                        ),
                      const SizedBox(height: 6),
                      Text(
                        item['title'],
                        style: interText(12, Colors.black, FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

final List<Map<String, dynamic>> serviceItems = [
  {
    "title": "Add\nSchedule",
    "icon": "assets/svg/time.svg",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => NewScheduleScreen()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "Add New\nServices",
    "icon": "assets/svg/addNewServices.svg",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AddNewServiceScreen()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "Service\nAreas",
    "icon": "assets/svg/loc_on.svg",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => MyServiceArea()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "Pricing\n",
    "icon": "assets/svg/pricing.svg",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => PricingScreen()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "My\nServices",
    "icon": "assets/png/myservices.png",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => MyServicesScreen()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "My\nTeams",
    "icon": "assets/svg/user.svg",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => MyTeamMemberList()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "Open\nOrders",
    "icon": "assets/svg/receipt.svg",
    "onTap": (BuildContext context, String frrom) {
      Provider.of<OrderProvider>(context, listen: false).isLoading = true;
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const RequestedServiceScreen()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
  {
    "title": "Tips & Rewards",
    "icon": "assets/svg/reward.svg",
    "onTap": (BuildContext context, String frrom) {
      frrom == 'db'
          ? Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => EarningHistoryScreen()),
              //? Navigator.push(context, CupertinoPageRoute(builder: (context) => TipsAndRewards()),
            )
          : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
    },
  },
];

//class TopServicesWidget extends StatelessWidget {
//   const TopServicesWidget({
//     super.key,
//     required this.frrom,
//   });
//
//   final String frrom;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(
//               width: 12,
//             ),
//             // TODO: Schedule
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/time.svg',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'Add\nSchedule',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   frrom == 'db'
//                       ? Navigator.push(
//                           context,
//                           CupertinoPageRoute(
//                               builder: (context) => ShiftConfigration()))
//                       : DashboardHelpers.showAlert(
//                           msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             // TODO: Add new services
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   frrom == 'db'
//                       ? Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) => AddNewServiceScreen()))
//                       : DashboardHelpers.showAlert(
//                       msg: 'you are not verified yet.');
//                 },
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/addNewServices.svg',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'Add New \nServices',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // TODO: Service Areas
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/loc_on.svg',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'Service \nAreas',
//                         style: interText(
//                           12,
//                           Colors.black,
//                           FontWeight.w500,
//                         ),
//                         maxLines: 2,
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   frrom == 'db'
//                       ? Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) => MyServiceArea()))
//                       : DashboardHelpers.showAlert(
//                       msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             // TODO: Pricing
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/dollar_green.svg',
//                         height: 32,
//                         width: 32,
//                         color: Color(0XFF636366),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         'Pricing',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   frrom == 'db'
//                       ? Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) => PricingScreen()))
//                       : DashboardHelpers.showAlert(
//                       msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(
//               width: 12,
//             ),
//             // TODO: My services
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/png/myservices.png',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'My \n Services',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   frrom == 'db'
//                       ? Navigator.push(
//                           context,
//                           CupertinoPageRoute(
//                               builder: (context) => MyServicesScreen()))
//                       : DashboardHelpers.showAlert(
//                           msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             // TODO: My Team
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/user.svg',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'My \nTeams',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   // frrom == 'db' ? Navigator.push(context, CupertinoPageRoute(builder: (context) => ScheduleViwerScreen())) : DashboardHelpers.showAlert(msg: 'you are not verified yet.');
//                   frrom == 'db'
//                       ? Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) => MyTeamMemberList()))
//                       : DashboardHelpers.showAlert(
//                       msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             // TODO: Open orders
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/receipt.svg',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'Open\nOrders',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   Provider.of<OrderProvider>(context, listen: false).isLoading =
//                   true;
//                   frrom == 'db'
//                       ? Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) =>
//                           const RequestedServiceScreen()))
//                       : DashboardHelpers.showAlert(
//                       msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             // TODO: Tips & Rewards
//             Expanded(
//               child: InkWell(
//                 child: Container(
//                   height: 100,
//                   width: 80,
//                   margin: EdgeInsets.all(4),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: myColors.greyBg,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/svg/reward.svg',
//                         height: 28,
//                         width: 28,
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         'Tips & Rewards',
//                         style: interText(12, Colors.black, FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   frrom == 'db'
//                       ? Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (context) => TipsAndRewards()))
//                       : DashboardHelpers.showAlert(
//                       msg: 'you are not verified yet.');
//                 },
//               ),
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
// }
