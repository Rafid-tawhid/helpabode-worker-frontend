// import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_week/flutter_calendar_week.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
// import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
// import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
// import 'package:help_abode_worker_app_ver_2/provider/notification_provider.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../provider/shift_config_provider.dart';
// import '../shift/widgets/break_days.dart';
//
// class ScheduleViwerScreen extends StatefulWidget {
//   const ScheduleViwerScreen({super.key});
//
//   @override
//   State<ScheduleViwerScreen> createState() => _ScheduleViwerScreenState();
// }
//
// class _ScheduleViwerScreenState extends State<ScheduleViwerScreen> {
//   final CalendarWeekController _controller = CalendarWeekController();
//   late DateTime? swapDt;
//   String dayName = '';
//
//   @override
//   void initState() {
//     DateFormat dateFormat = DateFormat.E();
//     dayName = dateFormat.format(DateTime.now());
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _controller.jumpToDate(DateTime.now());
//             setState(() {});
//           },
//           child: const Icon(Icons.today),
//         ),
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back)),
//           title: Text(
//             'Scheduler Viewer',
//             style: interText(18, Colors.black, FontWeight.w600),
//           ),
//         ),
//         body: Column(children: [
//           Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 0,
//                     spreadRadius: 0)
//               ],
//             ),
//             child: Stack(
//               children: [
//                 CalendarWeek(
//                   controller: _controller,
//                   // weekendsIndexes: [4],
//                   weekendsStyle: TextStyle(
//                       color: myColors.green, fontWeight: FontWeight.bold),
//                   todayDateStyle: TextStyle(color: myColors.green),
//                   pressedDateBackgroundColor: myColors.green,
//                   dateStyle: TextStyle(color: myColors.green),
//                   height: 120,
//                   showMonth: true,
//                   todayBackgroundColor: Color(0xffE9E9E9),
//                   dayOfWeekStyle: TextStyle(
//                       color: myColors.green, fontWeight: FontWeight.bold),
//                   minDate: DateTime.now().add(
//                     const Duration(days: -365),
//                   ),
//                   maxDate: DateTime.now().add(
//                     const Duration(days: 365),
//                   ),
//                   onDatePressed: (DateTime datetime) {
//                     // Do something
//                     DateFormat dateFormat = DateFormat.E();
//                     setState(() {
//                       dayName = dateFormat.format(datetime);
//                     });
//                     Provider.of<ShiftProvider>(context, listen: false)
//                         .clearTimeList();
//                   },
//                   onDateLongPressed: (DateTime datetime) {
//                     // Do something
//                   },
//                   onWeekChanged: () {
//                     // Do something
//                   },
//                   monthViewBuilder: (DateTime time) => Align(
//                     alignment: FractionalOffset.center,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         DateFormat.yMMMM().format(time),
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: myColors.green,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 24),
//                       ),
//                     ),
//                   ),
//                   decorations: [],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: DefaultTabController(
//               length: 2,
//               child: Scaffold(
//                 body: SafeArea(
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: SegmentedTabControl(
//                           // Customization of widget
//                           radius: const Radius.circular(30),
//                           backgroundColor: myColors.greyBtn,
//                           indicatorColor: Colors.orange.shade200,
//                           tabTextColor: Colors.black,
//                           textStyle:
//                               interText(14, Colors.black, FontWeight.w600),
//                           selectedTabTextColor: Colors.white,
//                           squeezeIntensity: 2,
//                           height: 40,
//                           tabPadding: const EdgeInsets.symmetric(horizontal: 8),
//                           tabs: [
//                             SegmentTab(
//                               label: 'Available',
//                               // For example, this overrides [indicatorColor] from [SegmentedTabControl]
//                               color: myColors.green,
//                             ),
//                             SegmentTab(
//                               label: 'Scheduled',
//                               color: myColors.green,
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Sample pages
//                       Padding(
//                         padding: const EdgeInsets.only(top: 70),
//                         child: TabBarView(
//                           physics: const BouncingScrollPhysics(),
//                           children: [
//                             TimeList(dayName),
//                             ScheduleList(dayName),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ]),
//       );
// }
//
// class TimeList extends StatelessWidget {
//   String day;
//
//   TimeList(this.day);
//
//   @override
//   Widget build(BuildContext context) {
//     Provider.of<ShiftProvider>(context, listen: false).makeScheduleList(day);
//
//     return Consumer<ShiftProvider>(
//       builder: (context, pro, _) {
//         // List<Map<String, dynamic>> bookedValuesList = pro.scheduleList.where((element) => element['booked'] == false).toList();
//         return ListView.builder(
//           itemCount: pro
//               .scheduleList.length, // 24 hours * 4 quarters (15 minutes each)
//           itemBuilder: (context, index) {
//             var item = pro.scheduleList[index];
//
//             return pro.isTimeInRangeNew(item['title'])
//                 ? SizedBox.shrink()
//                 : Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 70,
//                         child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               item['title'].toString(),
//                               style:
//                                   interText(16, Colors.black, FontWeight.w400),
//                             )),
//                       ),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () async {
//                             String minTime = item['title'];
//                             // String maxTime = DashboardHelpers.addMinutesToTime(item['title'], 60);
//                             // await buildShowShiftConfigModalBottomSheet(context, day, minTime, maxTime);
//                             debugPrint(
//                                 pro.isTimeInRangeNew(item['title']).toString());
//                             DashboardHelpers.showBottomDialog(
//                                 context: context,
//                                 child: AddScheduleScreen(),
//                                 dragable: true,
//                                 height: 600);
//                           },
//                           onLongPress: () async {},
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 1,
//                                 color: myColors.grey,
//                               ),
//                               Container(
//                                 height: 50,
//                                 margin: EdgeInsets.only(left: 4),
//                                 color: Color(0XFFF7F7F7),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//           },
//         );
//       },
//     );
//   }
// }
//
// class ScheduleList extends StatelessWidget {
//   String dayName;
//   ScheduleList(this.dayName);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<ShiftProvider>(
//         builder: (context, provider, _) {
//           return ListView.builder(
//             itemCount: provider.scheduleListNew.length,
//             itemBuilder: (context, index) {
//               final data = provider.scheduleListNew[index];
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   leading: Icon(Icons.access_time),
//                   title: Text(
//                     '${data.schedule![0]} - ${data.schedule![1]}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   subtitle: Text(data.zone!.first ?? ''),
//                   trailing: Text(data.currentStatus ?? ''),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   String formatTimeString(String timeString) {
//     // Replace "-" with a line break
//     String formattedString = timeString.replaceAll('-', '\n');
//     // Remove any remaining "-"
//     formattedString = formattedString.replaceAll('-', '');
//     return formattedString;
//   }
// }
//
// class AddScheduleScreen extends StatefulWidget {
//   const AddScheduleScreen({super.key});
//
//   @override
//   State<AddScheduleScreen> createState() => _AddScheduleScreenState();
// }
//
// class _AddScheduleScreenState extends State<AddScheduleScreen> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   bool showBreak = false;
//   String? selectedZone; // To store the selected zone
//   // List of zones
//   final List<String> zoneList = [
//     'North Zone',
//     'South Zone',
//     'East Zone',
//     'West Zone',
//     'Central Zone',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Text(
//                   'Add Schedule',
//                   style: interText(20, Colors.black, FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Card(
//                   elevation: 6,
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(8.0),
//                               onTap: () async {
//                                 final date = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2000),
//                                   lastDate: DateTime(2100),
//                                 );
//                                 if (date != null) {
//                                   setState(() {
//                                     _startDate = date;
//                                   });
//                                 }
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Start Date',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _startDate == null
//                                         ? 'Select Date'
//                                         : '${_startDate!.toLocal()}'
//                                             .split(' ')[0],
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(8.0),
//                               onTap: () async {
//                                 final time = await DashboardHelpers.pickTime(
//                                     context, _startTime);
//                                 if (time != null) {
//                                   setState(() {
//                                     _startTime = time;
//                                   });
//                                 }
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Start Time',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _startTime == null
//                                         ? 'Select Time'
//                                         : _startTime!.format(context),
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // End Date and Time
//                 Card(
//                   elevation: 6,
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(8.0),
//                               onTap: () async {
//                                 final date = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2000),
//                                   lastDate: DateTime(2100),
//                                 );
//                                 if (date != null) {
//                                   setState(() {
//                                     _endDate = date;
//                                   });
//                                 }
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'End Date',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _endDate == null
//                                         ? 'Select Date'
//                                         : '${_endDate!.toLocal()}'.split(' ')[0],
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(8.0),
//                               onTap: () async {
//                                 final time = await DashboardHelpers.pickTime(
//                                     context, _endTime);
//                                 if (time != null) {
//                                   setState(() {
//                                     _endTime = time;
//                                   });
//                                 }
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'End Time',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _endTime == null
//                                         ? 'Select Time'
//                                         : _endTime!.format(context),
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Submit Button
//                 Consumer<NotificationProvider>(
//                     builder: (context, pro, _) => DropdownButton2<String>(
//                           value: selectedZone,
//                           isExpanded: true,
//                           isDense: true,
//                           barrierColor: Colors.white
//                               .withOpacity(0.5), // Semi-transparent background
//                           dropdownStyleData: DropdownStyleData(
//                             maxHeight: 300,
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             decoration: BoxDecoration(
//                               color: Colors.white, // Dropdown background color
//                               borderRadius:
//                                   BorderRadius.circular(12), // Rounded corners
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black
//                                       .withOpacity(0.1), // Subtle shadow
//                                   blurRadius: 10,
//                                   offset: Offset(0, 4), // Shadow position
//                                 ),
//                               ],
//                             ),
//                           ),
//                           items: pro.zoneList.toSet().toList().map((zone) {
//                             return DropdownMenuItem<String>(
//                               value: zone,
//                               child: Text(
//                                 zone,
//                                 style:
//                                     TextStyle(color: Colors.black), // Text color
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedZone = value;
//                             });
//                           },
//                           hint: Text(
//                             'Choose a zone',
//                             style: TextStyle(
//                                 color: Colors.black54), // Hint text style
//                           ),
//                           buttonStyleData: ButtonStyleData(
//                             height: 50,
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             decoration: BoxDecoration(
//                               color: Colors.white, // Button background color
//                               borderRadius:
//                                   BorderRadius.circular(12), // Rounded corners
//                               border: Border.all(
//                                   color: Colors
//                                       .grey.shade300), // Border color and width
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black
//                                       .withOpacity(0.1), // Subtle shadow
//                                   blurRadius: 10,
//                                   offset: Offset(0, 4), // Shadow position
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )),
//
//                 SizedBox(
//                   height: 16,
//                 ),
//                 // Break Section
//                 if (_startDate != null && _endDate != null)
//                   TextButton(
//                     onPressed: () {
//                       DashboardHelpers.showCustomAnimatedDialog(
//                         context: context,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: Container(
//                             height: 400.h,
//                             child: IntervalDatePicker(
//                                 startDate: _startDate!, endDate: _endDate!),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'Add Break',
//                       style: const TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 if (_startDate != null && _endDate != null)
//                   Consumer<ShiftProvider>(
//                       builder: (context, pro, _) => Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Break Dates: ${pro.breakingDays.map((date) => "${date.day}-${date.month}-${date.year}").join(", ")}",
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             ),
//                           )),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_startDate != null &&
//                         _endDate != null &&
//                         _startTime != null &&
//                         _endTime != null) {
//                       var sp = context.read<ShiftProvider>();
//                       await sp.newShiftConfiguration(
//                           startDate: '${_startDate!.toLocal()}'.split(' ')[0],
//                           startTime: DashboardHelpers.formatTime24Hour(
//                               _startTime ?? TimeOfDay.now()),
//                           endDate: '${_endDate!.toLocal()}'.split(' ')[0],
//                           endTime: DashboardHelpers.formatTime24Hour(
//                               _endTime ?? TimeOfDay.now()),
//                           context: context);
//                       await sp.getShiftConfiguration();
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
