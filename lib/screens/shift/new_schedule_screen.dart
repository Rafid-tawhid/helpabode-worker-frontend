import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/custom_bottom_button.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/single_line_shimmer.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/widgets/booked_order_details.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/widgets/new_schedule_bottomsheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/dashboard_helpers.dart';
import '../../provider/shift_config_provider.dart';
import 'new_schedule_view_details.dart';

class NewScheduleScreen extends StatefulWidget {
  const NewScheduleScreen({super.key});

  @override
  State<NewScheduleScreen> createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return ShiftConfigurationScreen();
  }
}

class ShiftConfigurationScreen extends StatefulWidget {
  @override
  _ShiftConfigurationScreenState createState() => _ShiftConfigurationScreenState();
}

class _ShiftConfigurationScreenState extends State<ShiftConfigurationScreen> {
  List<String> daysOfWeek = [];
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now(); // Track selected date

  @override
  void initState() {
    daysOfWeek = getOrderedDaysOfWeek();
    getTimeSlots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Schedule Configuration",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: myColors.greyBg,
      ),
      body: Stack(
        children: [
          Consumer<ShiftProvider>(
            builder: (context, pro, _) => Column(
              children: [
                Container(
                  color: myColors.greyBg,
                  child: Column(
                    children: [
                      // Days of the week (Fixed)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: daysOfWeek.map((day) {
                          return Expanded(
                            child: Center(
                              child: Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }).toList(),
                      ),
                      // Scrollable weeks (7-day chunks)
                      SizedBox(
                        height: 50,
                        child: Consumer<ShiftProvider>(
                            builder: (context, sp, _) => PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (weekOffset) {
                                    setState(() {
                                      selectedDate = today.add(Duration(days: weekOffset * 7)); // Select first date of the new week
                                    });
                                    sp.getNewScheduleInfo(DashboardHelpers.convertDateTime(selectedDate.toString(), pattern: 'yyyy-MM-dd'));
                                  },
                                  itemBuilder: (context, weekOffset) {
                                    DateTime startOfWeek = today.add(Duration(days: weekOffset * 7));
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: List.generate(7, (index) {
                                        DateTime date = startOfWeek.add(Duration(days: index));
                                        bool isSelected = date.day == selectedDate.day && date.month == selectedDate.month && date.year == selectedDate.year;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedDate = date; // Update selected date
                                            });
                                            //set start date
                                            sp.setDate('start', selectedDate);
                                            //experiment
                                            sp.setDate('end', selectedDate);

                                            sp.getNewScheduleInfo(DashboardHelpers.convertDateTime(selectedDate.toString(), pattern: 'yyyy-MM-dd'));
                                          },
                                          child: Container(
                                            width: isSelected ? 40 : 36,
                                            margin: EdgeInsets.symmetric(horizontal: 4),
                                            decoration: BoxDecoration(
                                              color: isSelected ? myColors.green : Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                DateFormat('d').format(date),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 1,
                        color: myColors.greyBtn,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                DashboardHelpers.convertDateTime(selectedDate.toString(), pattern: 'EEEE - dd MMM, yyyy'),
                                style: interText(16, Colors.black, FontWeight.w500),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: myColors.greyBtn,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: pro.isLoading
                      ? SingleLineShimmer(
                          itemCount: 8,
                        )
                      : pro.isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: pro.timeSlotList.length,
                              itemBuilder: (context, index) {
                                var item = pro.timeSlotList[index];
                                String status = item['status'];
                                bool isBooked = status == 'Booked';
                                bool isAvailable = status == 'available' || status == 'paused';
                                bool isUnused = status == 'unused';
                                bool isPaused = status == 'paused';
                                bool isZoneNextIntext = item['zoneNext'];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: InkWell(
                                    onTap: () async {
                                      if (isUnused) {
                                        debugPrint('timeSlots[index] selected ${pro.timeSlotList[index]}');
                                        pro.updateSelectedTimeSlot(index);
                                      } else if (isBooked) {
                                        debugPrint(item['bookedSlot']);
                                        var data = await pro.showBookedOrderDetails(selectedDate, item['bookedSlot']);
                                        showBookingDetailsSheet(
                                          context,
                                          serviceName: data['service_info']['serviceTitle'],
                                          scheduleDate: formatDateTimeWithRange(selectedDate, item['bookedSlot']),
                                          status: 'This slot is booked',
                                          statusColor: Colors.red,
                                          orderId: data['service_info']['OrderTextId'],
                                          address: '${data['service_info']['endUserFullAddress']['zip']} '
                                              '${data['service_info']['endUserFullAddress']['city']} '
                                              '${data['service_info']['endUserFullAddress']['state']}',
                                        );
                                      } else if (isAvailable || isPaused) {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => NewScheduleViewDetails(
                                              schedule: item,
                                              date: selectedDate,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Time Display
                                            SizedBox(
                                              width: 66,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    DashboardHelpers.get12HrFormat(pro.timeSlotList[index]['title']),
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    ' ${DashboardHelpers.getAmPm(pro.timeSlotList[index]['title'])}',
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            // Slot Container
                                            Expanded(
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: _getSlotColor(item),
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: isBooked
                                                            ? const Color(0xffFFF1F1)
                                                            : isAvailable
                                                                ? Colors.transparent
                                                                : Colors.grey.shade300),
                                                    left: BorderSide(
                                                      color: _getLeftBorderColor(item),
                                                      width: 2,
                                                    ),
                                                    bottom: BorderSide(
                                                        color: isBooked
                                                            ? const Color(0xffFFF1F1)
                                                            : isAvailable
                                                                ? Colors.transparent
                                                                : Colors.grey.shade300,
                                                        width: 1),
                                                  ),
                                                ),
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: item['zone'] == true
                                                        ? Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(item['area'], style: interText(16, Colors.black, FontWeight.w500)),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.watch_later_outlined,
                                                                          size: 18,
                                                                          color: isBooked ? Colors.red : myColors.green,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 4.0),
                                                                          child: Text(isBooked ? item['bookedSlot'] : item['timeSlot'], style: interText(14, isBooked ? Colors.red : myColors.green, FontWeight.w500)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              if (item['status'] != 'available') Text(item['status'], style: interText(14, myColors.green, FontWeight.w500)),
                                                            ],
                                                          )
                                                        : isZoneNextIntext
                                                            ? Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    '${DashboardHelpers.convertDateTime(item['start_date'], pattern: 'd MMM y')} to ${DashboardHelpers.convertDateTime(item['end_date'], pattern: 'd MMM y')}',
                                                                    style: interText(13, myColors.greyTxt, FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    'Expires in ${item['scheduleDifference']}',
                                                                    style: interText(14, Colors.redAccent, FontWeight.w500),
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox.shrink()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (item['finished'] == true) const SizedBox(height: 4, child: ColoredBox(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ))
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            child: Consumer<ShiftProvider>(
              builder: (context, pro, _) => pro.timeSlotList.where((e) => e['flag'] == 1).length >= 2
                  ? Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: CustomBottomButton(
                          btnText: 'Add Shift',
                          onpressed: () async {
                            //set first time and list time to null
                            await pro.setStartTimeAndEndTimeToNull();

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => AddNewScheduleBottomSheet(
                                firstTime: pro.timeSlotList.firstWhere((e) => e['flag'] == 1)['title'],
                                lastTime: pro.timeSlotList.lastWhere((e) => e['flag'] == 1)['title'],
                                selectDate: selectedDate,
                              ),
                            );
                          }),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> getOrderedDaysOfWeek() {
    List<String> daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    DateTime today = DateTime.now();
    int todayIndex = today.weekday % 7; // Adjust because DateTime.weekday starts from Monday (1)

    // Reorder the list to start from today
    return [...daysOfWeek.sublist(todayIndex), ...daysOfWeek.sublist(0, todayIndex)];
  }

  void getTimeSlots() async {
    var sp = context.read<ShiftProvider>();
    Future.microtask(() {
      //SET INITIAL TODAYS DATE
      sp.setDate('start', DateTime.now());
      sp.getNewScheduleInfo(DashboardHelpers.convertDateTime(DateTime.now().toString(), pattern: 'yyyy-MM-dd'));
    });
  }

  /// Helper function to get slot background color
  Color _getSlotColor(Map<String, dynamic> item) {
    if ((item['status'] == 'available' || item['flag'] == 1) || item['status'] == 'paused') return const Color(0xffD5E7E0);
    if (item['status'] == 'Booked') return const Color(0xffFFF1F1);
    return Colors.white;
  }

  /// Helper function to get left border color
  Color _getLeftBorderColor(Map<String, dynamic> item) {
    if (item['status'] == 'unused') return Colors.white;
    if (item['status'] == 'available' || item['flag'] == 1) return myColors.green;
    if (item['status'] == 'Booked') return Colors.redAccent;
    return Colors.white;
  }

  String formatDateTimeWithRange(DateTime date, String timeRange) {
    final dayFormat = DateFormat('EEEE d MMM yyyy'); // "Wednesday 10 Jan 2025"
    final timeFormat = DateFormat('h:mm a'); // "4:00 AM"

    // Split time range
    List<String> times = timeRange.split('-');
    if (times.length != 2) return "Invalid time range";

    // Convert times to DateTime objects
    DateTime startTime = DateTime(date.year, date.month, date.day, int.parse(times[0].split(':')[0]), int.parse(times[0].split(':')[1]));

    DateTime endTime = DateTime(date.year, date.month, date.day, int.parse(times[1].split(':')[0]), int.parse(times[1].split(':')[1]));

    // Format date and time
    String formattedDate = dayFormat.format(date);
    String formattedStartTime = timeFormat.format(startTime);
    String formattedEndTime = timeFormat.format(endTime);

    return "$formattedDate, $formattedStartTime - $formattedEndTime";
  }
}
