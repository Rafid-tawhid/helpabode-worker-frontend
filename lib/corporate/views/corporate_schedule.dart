import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/corporate_schedule_model.dart';

class ScheduleViewer extends StatefulWidget {
  final List<CorporateScheduleModel> schedules;

  const ScheduleViewer({Key? key, required this.schedules}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleViewer> {
  String selectedOption = 'Today';
  final DateTime now = DateTime.now();
  // List<CorporateScheduleModel> filteredScheduleList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<CorporateProvider>(
        builder: (context, pro, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      'Sort By',
                      style: interText(16, Colors.black, FontWeight.w500),
                    )),
                    ToggleButton(
                      label: 'Today',
                      isSelected: selectedOption == 'Today',
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Today';
                        });
                        pro.filterByToday(widget.schedules);
                      },
                    ),
                    const SizedBox(width: 8),
                    ToggleButton(
                      label: 'Weekly',
                      isSelected: selectedOption == 'Weekly',
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Weekly';
                        });
                        pro.filterByWeek(widget.schedules, now);
                      },
                    ),
                    const SizedBox(width: 8),
                    ToggleButton(
                      label: 'Monthly',
                      isSelected: selectedOption == 'Monthly',
                      onPressed: () {
                        setState(() {
                          selectedOption = 'Monthly';
                        });
                        pro.filterByMonth(
                            widget.schedules, now.month, now.year);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: pro.filteredScheduleList.isEmpty
                        ? [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('No Schedule Found'),
                              ),
                            )
                          ]
                        : pro.filteredScheduleList
                            .map((schedule) => Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(schedule.dayOfWeek ?? '',
                                                  style: interText(
                                                      16,
                                                      Colors.black,
                                                      FontWeight.bold)),
                                              Text(
                                                schedule.scheduleDate ?? '',
                                                style: interText(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...schedule.quarters!.map((q) =>
                                            ListTile(
                                              title: Text(
                                                  q.clmData!.zoneTitle ?? ''),
                                              subtitle: Text(
                                                '${formatTimeRange(q.clmData!.timeSlot ?? '')} - ${q.clmData!.status}',
                                                style: interText(
                                                    12,
                                                    q.clmData!.status ==
                                                            'available'
                                                        ? myColors.green
                                                        : Colors.grey,
                                                    FontWeight.w500),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

// Function to convert time range to AM/PM format
  String formatTimeRange(String timeRange) {
    try {
      final times = timeRange.split('-');
      if (times.length != 2) return timeRange;

      final startTime = DateFormat('HH:mm').parse(times[0]);
      final endTime = DateFormat('HH:mm').parse(times[1]);

      final formattedStart = DateFormat('h:mm a').format(startTime);
      final formattedEnd = DateFormat('h:mm a').format(endTime);

      return '$formattedStart - $formattedEnd';
    } catch (e) {
      return timeRange; // Return original if parsing fails
    }
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? myColors.green : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
