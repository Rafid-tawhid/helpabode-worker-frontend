import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:provider/provider.dart';

class TimePickerWidget extends StatefulWidget {
  final String title;
  final Function(TimeOfDay) onTimePicked;

  const TimePickerWidget({
    Key? key,
    required this.title,
    required this.onTimePicked,
  }) : super(key: key);

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? selectedTime;

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
      widget.onTimePicked(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              selectedTime != null
                  ? selectedTime!.format(context)
                  : "Pick a Time",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}

class CupertinoTimePickerWidget extends StatefulWidget {
  DateTime firstTime;
  DateTime lastTime;

  CupertinoTimePickerWidget({required this.firstTime, required this.lastTime});

  @override
  _CupertinoTimePickerWidgetState createState() =>
      _CupertinoTimePickerWidgetState();
}

class _CupertinoTimePickerWidgetState extends State<CupertinoTimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShiftProvider>(
        builder: (context, pro, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                // Cupertino Time Picker (12-hour format with AM/PM)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                fontSize: 16, // Adjust font size
                                fontWeight: FontWeight.bold, // Make text bold
                                color: Colors.black, // Change text color
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: widget.firstTime,
                            minuteInterval: 15,
                            use24hFormat: false,
                            onDateTimeChanged: (DateTime newTime) {
                              pro.setSelectedStartEndTime(newTime, 'start');
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 180,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .black, // Different color for 'end' time picker
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: widget.lastTime,
                            use24hFormat: false,
                            minuteInterval: 15,
                            onDateTimeChanged: (DateTime newTime) {
                              pro.setSelectedStartEndTime(newTime, 'end');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
