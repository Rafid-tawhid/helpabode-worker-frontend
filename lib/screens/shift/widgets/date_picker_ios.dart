import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CupertinoDateRangePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  CupertinoDateRangePicker({required this.startDate, required this.endDate});

  @override
  _CupertinoDateRangePickerState createState() =>
      _CupertinoDateRangePickerState();
}

class _CupertinoDateRangePickerState extends State<CupertinoDateRangePicker> {
  // DateTime startDate = DateTime.now();
  DateTime? selectedDate;
  bool showCalendar = false;
  DateRangePickerController _datePickerController = DateRangePickerController();

  @override
  void initState() {
    selectedDate = widget.startDate;
    _datePickerController.displayDate = selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('selectedDate ${selectedDate}');

    return Consumer<ShiftProvider>(
        builder: (context, pro, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Date",
                              style:
                                  interText(16, Colors.black, FontWeight.w500)),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              // debugPrint('This is calling ${selectedDate}');
                              pro.isStartButtonClick(true);
                              pro.showDatePicter();
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  DateFormat("dd MMM, yyyy").format(
                                      pro.startDate ?? widget.startDate),
                                  style: interText(
                                      15, Colors.black, FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("End Date",
                              style:
                                  interText(16, Colors.black, FontWeight.w500)),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint('This is calling ${selectedDate}');
                              pro.isStartButtonClick(false);
                              pro.showDatePicter();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  DateFormat("dd MMM, yyyy")
                                      .format(pro.endDate ?? widget.endDate),
                                  style: interText(
                                      15, Colors.black, FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Calendar View (Expands/Collapses)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Visibility(
                    visible: pro.showDatePicker,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: myColors.greyBg,
                        // borderRadius: BorderRadius.circular(12),
                      ),
                      height: pro.showDatePicker ? 260 : 0,
                      child: pro.showDatePicker
                          ? Stack(
                              children: [
                                SfDateRangePicker(
                                  controller: _datePickerController,
                                  backgroundColor: Colors.transparent,
                                  onSelectionChanged: (val) {
                                    pro.showDatePicter();
                                    debugPrint(
                                        'isStartButtonClicked ${pro.isStartButtonClicked}');
                                    pro.isStartButtonClicked == true
                                        ? pro.setDate('start', val.value)
                                        : pro.setDate('end', val.value);
                                  },
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  minDate: DateTime.now(),
                                  initialSelectedDate: widget.startDate,
                                  headerHeight: 40, // Adjust header height
                                  headerStyle: DateRangePickerHeaderStyle(
                                    backgroundColor: myColors.greyBg,
                                    textStyle: interText(
                                        18, Colors.black, FontWeight.bold),
                                  ),
                                  selectionColor: Color(0XFFD5E7E0),
                                  selectionTextStyle: interText(
                                      16, myColors.green, FontWeight.w600),
                                  todayHighlightColor: myColors.green,
                                  selectionShape:
                                      DateRangePickerSelectionShape.circle,
                                  view: DateRangePickerView.month,
                                  monthViewSettings:
                                      DateRangePickerMonthViewSettings(
                                    firstDayOfWeek: 7,
                                    weekendDays: [
                                      DateTime.friday,
                                      DateTime.saturday
                                    ],
                                    weekNumberStyle:
                                        DateRangePickerWeekNumberStyle(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                  yearCellStyle: DateRangePickerYearCellStyle(
                                    textStyle: interText(
                                        15, Colors.black, FontWeight.w600),
                                    todayTextStyle: interText(
                                        15, Colors.black, FontWeight.w600),
                                  ),
                                  navigationMode:
                                      DateRangePickerNavigationMode.none,
                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                    textStyle: interText(15, Colors.grey,
                                        FontWeight.w500), // Non-selected dates
                                    todayTextStyle: interText(15, Colors.black,
                                        FontWeight.bold), // Today's date
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _datePickerController.backward!();
                                          },
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            size: 20,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            _datePickerController.forward!();
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 20,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ),
                  ),
                ),
              ],
            ));
  }
}
