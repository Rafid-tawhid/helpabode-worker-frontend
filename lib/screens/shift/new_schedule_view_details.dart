import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/widgets/delete_confirm_bottom_sheet.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/widgets/new_schedule_bottomsheet.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/widgets/pause_bottom.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewScheduleViewDetails extends StatelessWidget {
  final dynamic schedule;
  final DateTime date;
  String? startTime; // "00:30"
  String? endTime;
  NewScheduleViewDetails({required this.schedule, required this.date});

  @override
  Widget build(BuildContext context) {
    List<String> times = schedule['timeSlot'].split("-");

    startTime = times[0]; // "00:30"
    endTime = times[1];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: _buildScheduleDetails(),
                ),
              ),
            ),
            if (schedule['status'] != 'Booked')
              ButtonRow(info: schedule, date: date),
          ],
        ),
      ),
    );
  }

  /// Builds the header row with back button, title, and edit button.
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Row(
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 6),
                Text(DateFormat("d MMM").format(date)),
              ],
            ),
          ),
          Expanded(
            child: Text(
              'Schedule Details',
              textAlign: TextAlign.center,
              style: interText(18, Colors.black, FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              // var pro=context.read<ShiftProvider>();
              // await pro.setStartTimeAndEndTimeToNull();
              //
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   backgroundColor: Colors.transparent,
              //   builder: (_) => AddNewScheduleBottomSheet(
              //     firstTime: startTime??'',
              //     lastTime: endTime??'',
              //     selectDate: date,
              //   ),
              // );
            },
            child: Text('  '),
          ),
        ],
      ),
    );
  }

  /// Builds the schedule details section.
  Widget _buildScheduleDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule['area'] ?? '',
          style: interText(18, Colors.black, FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          '${formatSchedule(date, schedule['timeSlot'])}',
          style: interText(14, Colors.black, FontWeight.w400),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: myColors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              TimeSlotWidget(timeRange: schedule['timeSlot'], info: schedule),
        ),
      ],
    );
  }

  String formatSchedule(DateTime scheduleDate, String range) {
    List<String> times = range.split('-');
    if (times.length != 2) return "Invalid Time Range";

    DateTime startDateTime = DateTime(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      int.parse(times[0].split(':')[0]),
      int.parse(times[0].split(':')[1]),
    );

    DateTime endDateTime = DateTime(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      int.parse(times[1].split(':')[0]),
      int.parse(times[1].split(':')[1]),
    );

    // If end time is before start time, it means it goes past midnight
    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(Duration(days: 1));
    }

    String formattedStart =
        DateFormat("h:mm a EEE, d MMM, y").format(startDateTime);
    String formattedEnd =
        DateFormat("h:mm a EEE, d MMM, y").format(endDateTime);

    return "from $formattedStart \nto $formattedEnd";
  }
}

/// Button Row for Pause/Unpause and Delete
class ButtonRow extends StatelessWidget {
  final dynamic info;
  final DateTime date;

  ButtonRow({required this.info, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                showPauseScheduleBottomSheet(
                    context, info, date, info['status'] == 'paused');
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                side: BorderSide(color: Colors.grey.shade500, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                info['status'] == 'paused' ? "Unpause" : "Pause",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showDeleteConfirmationBottomSheet(context, info, date);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: FittedBox(
                child: Text(
                  "Delete Schedule",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable Time Slot Widget
class TimeSlotWidget extends StatefulWidget {
  final String timeRange;
  final dynamic info;

  TimeSlotWidget({required this.timeRange, required this.info});

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<String> times = widget.timeRange.split('-');
    if (times.length != 2) return Center(child: Text("Invalid Time Range"));

    TimeOfDay start = _parseTime(times[0]);
    TimeOfDay end = _parseTime(times[1]);

    int startHour = start.hour;
    int endHour = end.hour;

    List<int> displayedHours = [for (int i = startHour; i <= endHour; i++) i];

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: myColors.greyBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
          child: ConstrainedBox(
            constraints:
                isExpanded ? BoxConstraints() : BoxConstraints(maxHeight: 100),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: isExpanded
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  child: Column(
                    children: displayedHours.map((hour) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Text(
                                _formatHour(hour),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 1, color: Colors.grey.shade400)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                /// Use IntrinsicHeight to make this take only the necessary height
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.only(left: 60),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: TimeSlotCard(
                          location: widget.info['area'],
                          timeRange: widget.timeRange,
                          schedule: widget.info,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TimeOfDay _parseTime(String time) {
    List<String> parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatHour(int hour) {
    int displayHour = (hour % 12 == 0) ? 12 : hour % 12;
    return "$displayHour ${hour >= 12 ? 'PM' : 'AM'}";
  }
}

class TimeSlotCard extends StatefulWidget {
  final String location;
  final String timeRange;
  final dynamic schedule;

  const TimeSlotCard(
      {Key? key,
      required this.location,
      required this.timeRange,
      required this.schedule})
      : super(key: key);

  @override
  _TimeSlotCardState createState() => _TimeSlotCardState();
}

class _TimeSlotCardState extends State<TimeSlotCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: isExpanded?double.infinity:double.maxFinite
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Extra time index above
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.location,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.timeRange.split('-')[0]} ${DashboardHelpers.getAmPm(widget.timeRange.split('-')[0])} - ${widget.timeRange.split('-')[1]} ${DashboardHelpers.getAmPm(widget.timeRange.split('-')[1])}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          // Extra time index below
        ],
      ),
    );
  }
}

// class NewScheduleViewDetails extends StatelessWidget {
//   final dynamic schedule;
//   final DateTime date;
//
//
//   NewScheduleViewDetails({required this.schedule,required this.date});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(onPressed: (){Navigator.pop(context);}, icon: Row(
//                             children: [
//                               Icon(Icons.arrow_back),
//                               SizedBox(width: 6,),
//                               Text(DateFormat("d MMM").format(date).toString())
//                             ],
//                           )),
//                           Expanded(child: Text('Schedule Details',textAlign: TextAlign.center,style: interText(18, Colors.black, FontWeight.bold),)),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: TextButton(onPressed: (){}, child: Text('Edit')),
//                           )
//                         ],
//                       ),
//                       Text(schedule['area']??'',style: interText(18, Colors.black, FontWeight.bold),),
//                       Text('from ${DashboardHelpers.convertDateTime(date.toString(),pattern: 'hh:mm a EEE')}, ${schedule['timeSlot']}',style: interText(14, myColors.greyTxt, FontWeight.w400),),
//                      // TimeSlotCard(location: schedule['area'], timeRange: schedule['timeSlot'], info: schedule)
//                       SizedBox(height: 8,),
//                       Container(
//                           decoration: BoxDecoration(
//                               color: schedule['status']=='Booked'?Colors.red.shade200: Colors.green.shade700,
//                               borderRadius: BorderRadius.circular(12)
//                           ),
//                           child: TimeSlotWidget(timeRange: schedule['timeSlot'],info: schedule,)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//            if(schedule['status']!='Booked') ButtonRow(info: schedule,date: date,)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TimeSlotCard extends StatefulWidget {
//   final String location;
//   final String timeRange;
//   final dynamic schedule;
//
//   const TimeSlotCard({Key? key, required this.location, required this.timeRange,required this.schedule}) : super(key: key);
//
//   @override
//   _TimeSlotCardState createState() => _TimeSlotCardState();
// }
//
// class _TimeSlotCardState extends State<TimeSlotCard> {
//   bool isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(height: 12), // Extra time index above
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isExpanded = !isExpanded;
//               });
//             },
//             child: Column(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color:widget.schedule['status']=='Booked'?Color(0xffFFF1F1): Colors.green.shade700,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.location,
//                         style:  TextStyle(color:widget.schedule['status']=='Booked'?Colors.black: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.access_time, color:widget.schedule['status']=='Booked'?Colors.black: Colors.white70, size: 16),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${widget.timeRange.split('-')[0]} ${DashboardHelpers.getAmPm(widget.timeRange.split('-')[0])} - ${widget.timeRange.split('-')[1]} ${DashboardHelpers.getAmPm(widget.timeRange.split('-')[1])}',
//                             style:  TextStyle(color:widget.schedule['status']=='Booked'?Colors.black: Colors.white, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                       if (isExpanded) ...[
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("• Start ${widget.timeRange.split('-')[0]} ${DashboardHelpers.getAmPm(widget.timeRange.split('-')[0])}", style: const TextStyle(color: Colors.white)),
//                               Text("• End ${widget.timeRange.split('-')[1]} ${DashboardHelpers.getAmPm(widget.timeRange.split('-')[0])}", style: const TextStyle(color: Colors.white)),
//                               const Text("• Additional Details...", style: TextStyle(color: Colors.white70)),
//                             ],
//                           ),
//                         ),
//                       ]
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12), // Extra time index below
//         ],
//       ),
//     );
//   }
// }
//
// class TimeSlotWidget extends StatefulWidget {
//   final String timeRange;
//   final dynamic info;
//   TimeSlotWidget({required this.timeRange,required this.info});
//
//   @override
//   _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
// }
//
// class _TimeSlotWidgetState extends State<TimeSlotWidget> {
//   bool isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> times = widget.timeRange.split('-');
//     if (times.length != 2) return Center(child: Text("Invalid Time Range"));
//
//     TimeOfDay start = _parseTime(times[0]);
//     TimeOfDay end = _parseTime(times[1]);
//
//     int startHour = start.hour;
//     int endHour = end.hour;
//
//     List<int> displayedHours = [];
//     for (int i = startHour; i <= endHour; i++) {
//       displayedHours.add(i);
//     }
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isExpanded = !isExpanded;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color:  Colors.green.shade700,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: AnimatedSize(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: ConstrainedBox(
//             constraints: isExpanded
//                 ? BoxConstraints() // Expand fully
//                 : BoxConstraints(maxHeight: 80), // Show only 1 row initially
//             child: Stack(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: isExpanded? 80:16),
//                   height: 140,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12)
//                   ),
//                   child: TimeSlotCard(location: widget.info['area'], timeRange: widget.timeRange,schedule: widget.info,),
//                 ),
//                 SingleChildScrollView(
//                   physics: isExpanded ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
//                   child: Column(
//                     children: displayedHours.map((hour) {
//                       int index = displayedHours.indexOf(hour);
//                       bool isFirst = index == 0;
//                       bool isLast = index == displayedHours.length - 1;
//                       return Container(
//                         height: 60,
//                         padding: const EdgeInsets.all(12),
//                         child: Row(
//                           children: [
//                             (index==0&&!isExpanded)?SizedBox(
//                              width: 50,
//                              child:  Text(
//                                '',
//                                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
//                              ),
//                            ): SizedBox(
//                               width: 50,
//                               child:  Text(
//                                 _formatHour(hour),
//                                 style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
//                               ),
//                             ),
//
//                            if(!isFirst) Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TimeOfDay _parseTime(String time) {
//     List<String> parts = time.split(':');
//     int hour = int.parse(parts[0]);
//     int minute = int.parse(parts[1]);
//     return TimeOfDay(hour: hour, minute: minute);
//   }
//
//   String _formatHour(int hour) {
//     int displayHour = (hour % 12 == 0) ? 12 : hour % 12;
//     String period = (hour >= 12) ? "PM" : "AM";
//     return "$displayHour $period";
//   }
// }
//
// class ButtonRow extends StatelessWidget {
//   final dynamic info;
//   final DateTime date;
//   ButtonRow({required this.info,required this.date});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x0C000000),
//             blurRadius: 8,
//             offset: Offset(0, -4),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: (){
//                 showPauseScheduleBottomSheet(context,info,date,info['status']=='paused'?true:false);
//               },
//               style: OutlinedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                 side: BorderSide(color: Colors.grey.shade500, width: 1),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Increased border radius
//                 ),
//               ),
//               child: Text(
//                 info['status']=='paused'?"Unpause":"Pause",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 showDeleteConfirmationBottomSheet(context,info,date);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey.shade300, // Light grey background
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Matching border radius
//                 ),
//                 elevation: 0,
//               ),
//               child: FittedBox(
//                 child: Text(
//                   "Delete Schedule",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
