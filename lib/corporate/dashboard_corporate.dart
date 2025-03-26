//
// import 'dart:math';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:d_chart/commons/data_model/data_model.dart';
// import 'package:d_chart/commons/enums.dart';
// import 'package:d_chart/ordinal/bar.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
// import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
// import 'package:help_abode_worker_app_ver_2/models/corporate_team_member_model.dart';
// import 'package:help_abode_worker_app_ver_2/screens/dashboard/rating_information_screen.dart';
// import 'package:help_abode_worker_app_ver_2/screens/open_order/completed_order/completed_service.dart';
// import 'package:provider/provider.dart';
// import '../../../helper_functions/colors.dart';
// import '../../../helper_functions/signin_signup_helpers.dart';
// import '../../../launcher_screen.dart';
// import '../../../models/dashboard_order_card_model.dart';
// import '../../../models/upcoming_service_details_model.dart';
// import '../../../provider/order_provider.dart';
// import '../../../widgets_reuse/bottom_nav_bar.dart';
// import '../../../widgets_reuse/loading_indicator.dart';
// import '../../dashboard/widgets/dashboard_gridview.dart';
// import '../../earning/earning_history.dart';
// import '../../open_order/open_order_screen.dart';
// import '../../open_order/ordered_service_details_screen.dart';
// import '../../shift/shift_config.dart';
// import 'individual_team/my_team_member_list.dart';
//
// class DashboarCorporate extends StatefulWidget {
//   String? forrm;
//
//
//   DashboarCorporate({this.forrm});
//
//   @override
//   State<DashboarCorporate> createState() => _DashboarCorporateState();
// }
//
// class _DashboarCorporateState extends State<DashboarCorporate> {
//   ScrollController _scrollController = ScrollController();
//   bool _showRow = true;
//   double _containerHeight = 0; // This will control the height of the animated container
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       // Check if scrolled more than 10% of the screen height
//       if (_scrollController.offset > MediaQuery.of(context).size.height * 0.1) {
//         setState(() {
//           _showRow = false; // Hide the top row
//           _containerHeight =  66.h; // Show the animated container
//         });
//       }
//       else {
//         setState(() {
//           _showRow = true; // Show the top row
//           _containerHeight = 0; // Hide the animated container
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Show TopRow based on _showRow state
//             if (_showRow) TopRow(), // Your TopRow widget
//             // Animated Container that comes from the top
//             AnimatedContainer(
//               duration: Duration(milliseconds:_containerHeight>0? 500:0),
//               height: _containerHeight, // Animate the height
//               width: double.infinity,
//               color: Colors.transparent,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           InkWell(
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(50),
//                                       border: Border.all(
//                                           width: .5, color: Colors.grey)),
//                                   child: const Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Icon(Icons.notifications_none),
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 16,
//                                   width: 16,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: Colors.red),
//                                   child: Text(
//                                     '1',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 8),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             onTap: () async {
//
//                             },
//                           ),
//                           const SizedBox(width: 8),
//                           InkWell(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(50),
//                                   border: Border.all(width: .5, color: Colors.grey)),
//                               child: const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(Icons.message),
//                               ),
//                             ),
//                             onTap: () async {
//                               print('TOKEN : $token');
//                               print('TOKEN : $textId');
//                               print('TOKEN : $status');
//
//                               //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WebSocketDemo()));
//                               // Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
//                             },
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(28),
//                                 border:
//                                 Border.all(color: Colors.grey, width: .5)),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 8),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(Icons.receipt_long, size: 18),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Open Orders',
//                                   style: GoogleFonts.inter(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(50),
//                             border: Border.all(width: .5, color: Colors.grey)),
//                         child: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Icon(Icons.access_time_outlined, size: 24),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 8,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(width: .5, color: Colors.grey)),
//                       child: const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(
//                           Icons.help_outline_outlined,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Column(
//                   children: [
//                     LineChartSample2(frrom: widget.forrm,),
//                     Consumer<OrderProvider>(builder: (context,pro,_)=>MyGridView(dataList: pro.dashboardOrderCardDataList,),),
//                     MenuRow(frrom: widget.forrm,),
//                     RecentOrders(),
//                     PaymentHistory(),
//                   //  MyTeamMembers(),
//
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const MyBottomNavBar(),
//     );
//   }
// }
//
//
//
//
// class PaymentHistory extends StatelessWidget {
//   const PaymentHistory({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Payment History',style: interText(16, Colors.black, FontWeight.w600),),
//               Text('See all',style: interText(14,myColors.green, FontWeight.w600),),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: AspectRatio(
//             aspectRatio: 20 / 8,
//             child: DChartBarO(
//               animate: true,
//               animationDuration: const Duration(milliseconds: 600),
//               groupList: [
//                 OrdinalGroup(
//                   color: Color(0xFF1C7980),
//                   id: '3',
//                   chartType: ChartType.line,
//                   data: List.generate(12, (index) {
//                     String month = months[index];
//                     int measure = Random().nextInt(100) + 1; // Random measure between 1 and 10
//                     return OrdinalData(domain: month, measure: measure);
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
//
//
// class LineChartSample2 extends StatefulWidget {
// String? frrom;
//
//
// LineChartSample2({required this.frrom});
//
//   @override
//   State<LineChartSample2> createState() => _LineChartSample2State();
// }
//
// class _LineChartSample2State extends State<LineChartSample2> {
//   List<Color> gradientColors = [
//     Colors.greenAccent,
//     myColors.green.withOpacity(.3),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade200,width: 1),
//           borderRadius: BorderRadius.circular(12)
//         ),
//         child: AspectRatio(
//           aspectRatio: 2.2,
//           child: Stack(
//             children: [
//               LineChart(mainData(),),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0,right: 4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Earnings',style: interText(14, Colors.black, FontWeight.w600),),
//                         Text('\$4,981.00',style: interText(14, myColors.green, FontWeight.w600),),
//                       ],
//                     ),
//                     Container(
//                         decoration: BoxDecoration(
//                             color: myColors.green,
//                             borderRadius: BorderRadius.circular(50)
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Icon(Icons.food_bank_outlined,color: Colors.white,),
//                         ))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 2:
//         text = const Text('MAR', style: style);
//         break;
//       case 5:
//         text = const Text('JUN', style: style);
//         break;
//       case 8:
//         text = const Text('SEP', style: style);
//         break;
//       default:
//         text = const Text('', style: style);
//         break;
//     }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }
//
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '10K';
//         break;
//       case 3:
//         text = '30k';
//         break;
//       case 5:
//         text = '50k';
//         break;
//       default:
//         return Container();
//     }
//
//     return Text(text, style: style, textAlign: TextAlign.left);
//   }
//
//   LineChartData mainData() {
//     // Find min and max dynamically
//     List<FlSpot> spots = [
//       FlSpot(0, 1),
//       FlSpot(2.6, 2),
//       FlSpot(4.9, 5),
//       FlSpot(6.8, 3.1),
//       FlSpot(8, 4),
//       FlSpot(9.5, 3),
//       FlSpot(11, 4),
//       FlSpot(12, 6),
//       FlSpot(13, 7),
//       FlSpot(14, 5),
//       FlSpot(15, 6.1),
//       FlSpot(16, 4),
//       FlSpot(17.5, 3),
//       FlSpot(19, 4),
//     ];
//     double minX = spots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
//     double maxX = spots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
//     double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
//     double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
//     return LineChartData(
//       minX: minX,  // Use dynamically calculated minX
//       maxX: maxX,  // Use dynamically calculated maxX
//       minY: minY,  // Use dynamically calculated minY
//       maxY: maxY,
//
//       gridData: FlGridData(
//         show: false,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Colors.black,
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: AppColors.whiteColorDark,
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: false,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: Colors.white,),
//
//       ),
//
//       lineBarsData: [
//         LineChartBarData(
//           spots: spots,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 1,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: true,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
// class MenuRow extends StatelessWidget {
//
//   String? frrom;
//   MenuRow({required this.frrom});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
//       padding: EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 12.0),
//             child: Text('My Services',style: interText(16, Colors.black, FontWeight.w600),),
//           ),
//           SizedBox(
//             height: 120,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 const SizedBox(width: 12),
//                 DashboardTile(
//                   svgPath: 'assets/svg/time.svg',
//                   title: 'Add\nSchedule',
//                   onTap: () {
//                     frrom == null
//                         ? Navigator.push(context, CupertinoPageRoute(builder: (context) => ShiftConfigration()))
//                         : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
//                   },
//                 ),
//                 DashboardTile(
//                   svgPath: 'assets/svg/user.svg',
//                   title: 'My \n Team',
//                   onTap: () {
//                     frrom == null
//                         ? Navigator.push(context, CupertinoPageRoute(builder: (context) => MyTeamMemberList()))
//                         : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
//                   },
//                 ),
//                 DashboardTile(
//                   svgPath: 'assets/svg/receipt.svg',
//                   title: 'Open\nOrders',
//                   onTap: () {
//                     frrom == null
//                         ? Navigator.push(context, CupertinoPageRoute(builder: (context) => const RequestedServiceScreen()))
//                         : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
//                   },
//                 ),
//                 DashboardTile(
//                   svgPath: 'assets/svg/reward.svg',
//                   title: 'Tips \n& Rewards',
//                   onTap: () {
//                     frrom == null
//                         ? Navigator.push(context, CupertinoPageRoute(builder: (context) => EarningHistoryScreen()))
//                         : DashboardHelpers.showAlert(msg: 'You are not verified yet.');
//                   },
//                 ),
//                 const SizedBox(width: 12),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class DashboardTile extends StatelessWidget {
//   final String svgPath;
//   final String title;
//   final VoidCallback onTap;
//
//   const DashboardTile({
//     required this.svgPath,
//     required this.title,
//     required this.onTap,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 110,
//         width: 88,
//         margin: const EdgeInsets.all(4),
//         clipBehavior: Clip.antiAlias,
//         decoration: ShapeDecoration(
//           color: myColors.greyBg,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(svgPath, height: 30, width: 30),
//             const SizedBox(height: 6),
//             Text(
//               title,
//               style: interText(14, Colors.black, FontWeight.w500),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class RecentOrders extends StatelessWidget {
//   const RecentOrders({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Recent Orders',style: interText(16, Colors.black, FontWeight.w600),),
//               Text('See all',style: interText(14,myColors.green, FontWeight.w600),),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 230, // Adjust the height as needed
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: 4,
//           //  itemExtent:  MediaQuery.sizeOf(context).width,
//             // Example item count
//             itemBuilder: (context, index) {
//               //final item = pro.workerRunningServiceList[index];
//               return Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Center(
//                   child: Container(
//                     width: 300,
//                     // margin: EdgeInsets.symmetric(horizontal: 20.w),
//                     padding: const EdgeInsets.all(16),
//                     decoration: ShapeDecoration(
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                           width: 1,
//                           strokeAlign: BorderSide.strokeAlignOutside,
//                           color: Color(0xFFF2F2F2),
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       shadows: const [
//                         // BoxShadow(
//                         //   color: Color(0x0C11111A),
//                         //   blurRadius: 32,
//                         //   offset: Offset(0, 8),
//                         //   spreadRadius: 0,
//                         // ),
//                         // BoxShadow(
//                         //   color: Color(0x0C000000),
//                         //   blurRadius: 16,
//                         //   offset: Offset(0, 4),
//                         //   spreadRadius: 0,
//                         // )
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.end,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   '\$${112}',
//                                   style: interText(24, myColors.green,
//                                       FontWeight.w700),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       bottom: 4.0),
//                                   child: Text(
//                                     'Guaranteed',
//                                     style: interText(
//                                         14,
//                                         Color(0XFF636366),
//                                         FontWeight.w500),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             //  Consumer<UserProvider>(builder: (context, provier, _) => Text(provier.getTimerText() ?? ''))
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         CustomPaint(
//                           painter: DashedLinePainter(),
//                           // size: const Size(100.0, 100.0),
//                           size: Size(double.infinity, 10),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8.w),
//                               child: FadeInImage(
//                                 fit: BoxFit.cover,
//                                 height: 72,
//                                 width: 72,
//                                 image: NetworkImage(
//                                     '${'tem.serviceImage'}'),
//                                 placeholder: NetworkImage(
//                                     'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
//                                 imageErrorBuilder:
//                                     (context, error, stackTrace) {
//                                   return Image.network(
//                                     'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
//                                     fit: BoxFit.cover,
//                                     height: 72,
//                                     width: 72,
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 16,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'serviceTitle' ?? '',
//                                     style: interText(16, Colors.black,
//                                         FontWeight.w600),
//                                   ),
//                                   const SizedBox(
//                                     height: 4,
//                                   ),
//                                   FittedBox(
//                                     child: Text(
//                                       'scheduledDate' ?? 'No Date',
//                                       style:
//                                       text_16_black_400_TextStyle,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 4,
//                                   ),
//                                   Text(
//                                     'scheduledStartTime' ?? '',
//                                     style: text_16_black_400_TextStyle,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {},
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12, vertical: 7),
//                                   decoration: ShapeDecoration(
//                                     color: Color(0xFF008951),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(6)),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                         child: Text(
//                                           'serviceStatus' ?? '',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                             fontFamily: 'Inter',
//                                             fontWeight: FontWeight.w500,
//                                             height: 0.10,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8,),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets
//                                       .symmetric(
//                                       horizontal: 12,
//                                       vertical: 7),
//                                   decoration: ShapeDecoration(
//                                     color: const Color(0xFFE9E9E9),
//                                     shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(6)),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize:
//                                     MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                         child: Text('View Details',textAlign: TextAlign.center,style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontFamily: 'Inter',
//                                           fontWeight:
//                                           FontWeight.w500,
//                                           height: 0.10,
//                                         ),),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//
//       ],
//     );
//   }
// }
//
// class TopRow extends StatelessWidget {
//   const TopRow({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 InkWell(
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(50),
//                             border: Border.all(
//                                 width: .5, color: Colors.grey)),
//                         child: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Icon(Icons.notifications_none),
//                         ),
//                       ),
//                       Container(
//                           height: 16,
//                           width: 16,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.red),
//                           child: Text(
//                             '1',
//                             style: TextStyle(
//                                 color: Colors.white, fontSize: 8),
//                           ),
//                         )
//                     ],
//                   ),
//                   onTap: () async {
//
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 InkWell(
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(width: .5, color: Colors.grey)),
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(Icons.message),
//                     ),
//                   ),
//                   onTap: () async {
//                     print('TOKEN : $token');
//                     print('TOKEN : $textId');
//                     print('TOKEN : $status');
//
//                     //  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const WebSocketDemo()));
//                     // Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
//                   },
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(28),
//                       border:
//                       Border.all(color: Colors.grey, width: .5)),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 8, horizontal: 8),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.receipt_long, size: 18),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Open Orders',
//                         style: GoogleFonts.inter(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () {
//
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(width: .5, color: Colors.grey)),
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(Icons.access_time_outlined, size: 24),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 8,
//           ),
//           InkWell(
//             onTap: () {
//               SignInSignUpHelpers sp = SignInSignUpHelpers();
//               sp.remove('user');
//               sp.remove('textId');
//               sp.remove('address');
//               sp.remove('status');
//               sp.remove('token');
//               Navigator.pushReplacement(
//                   context,
//                   CupertinoPageRoute(
//                       builder: (context) => LauncherScreen()));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(width: .5, color: Colors.grey)),
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(
//                   Icons.help_outline_outlined,
//                   size: 24,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// List<Map<String, dynamic>> itemList = [
//   {
//     'title': 'Open order',
//     'amount': 150,
//     'percentage': 30,
//     'icon': Icons.content_paste_sharp,
//   },
//   {
//     'title': 'Completed order',
//     'amount': 250,
//     'percentage': 45,
//     'icon': Icons.check_circle,
//   },
//   {
//     'title': 'Rejected order',
//     'amount': 350,
//     'percentage': 60,
//     'icon': Icons.dangerous,
//   },
//   {
//     'title': 'Customer rating',
//     'amount': 500,
//     'percentage': 80,
//     'icon': Icons.star_border_purple500_outlined,
//   },
// ];
