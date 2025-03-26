import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/custom_bottom_button.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/widgets/time_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../corporate/views/dropdown.dart';
import '../../../misc/constants.dart';
import '../../../models/shift_worker_city_model.dart';
import '../../../widgets_reuse/custom_snackbar_message.dart';
import 'date_picker_ios.dart';

class AddNewScheduleBottomSheet extends StatefulWidget {
  final String firstTime;
  final String lastTime;
  final DateTime selectDate;

  const AddNewScheduleBottomSheet(
      {Key? key,
      required this.firstTime,
      required this.lastTime,
      required this.selectDate})
      : super(key: key);

  @override
  _AddNewScheduleBottomSheetState createState() =>
      _AddNewScheduleBottomSheetState();
}

class _AddNewScheduleBottomSheetState extends State<AddNewScheduleBottomSheet> {
  ShiftWorkerCityModel? selectedZone;
  String selectedBreak = 'No break';
  bool showAdd1StateError = false;
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();

  final List<String> breakList = [
    "No break",
    "09:00-09:30",
    "03:00-03:30",
    "08:00-07:30",
    "18:00-18:30"
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<ShiftProvider>()
          .setInitialDateAndTime(widget.firstTime, widget.lastTime, '');
      context.read<ShiftProvider>().showDatePicter(val: false);
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      minChildSize: .6,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close)),
                        Expanded(
                          child: Text(
                            "New Schedule",
                            textAlign: TextAlign.center,
                            style: interText(18, Colors.black, FontWeight.w600),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: myColors.divider,
                      height: 1,
                      width: MediaQuery.sizeOf(context).width,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CupertinoDateRangePicker(
                        startDate: widget.selectDate,
                        endDate: widget.selectDate,
                      ),
                    ),
                    Consumer<ShiftProvider>(
                      builder: (context, pro, _) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TimeSelector(
                                label: "Start Time",
                                time: DashboardHelpers.format12Time(
                                    pro.startTime ??
                                        DashboardHelpers
                                            .getDateTimeWithTimeInterval(
                                                widget.firstTime)),
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TimeSelector(
                                label: "End Time",
                                time: DashboardHelpers.format12Time(
                                    pro.endTime ??
                                        DashboardHelpers
                                            .getDateTimeWithTimeInterval(
                                                widget.lastTime)),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CupertinoTimePickerWidget(
                        firstTime: DashboardHelpers.getDateTimeWithTimeInterval(
                            widget.firstTime),
                        lastTime: DashboardHelpers.getDateTimeWithTimeInterval(
                            widget.lastTime),
                      ),
                    ),
                    Consumer<ShiftProvider>(
                      builder: (context, pro, _) => pro.isLoading
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: CustomDropdown<ShiftWorkerCityModel>(
                                bgColor: myColors.greyBg,
                                items: pro.workerCityLIST,
                                selectedItem: selectedZone,
                                hint: 'Select Zone',
                                isError: showAdd1StateError,
                                itemLabel: (item) => item.zoneTitle ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedZone = value;
                                    showAdd1StateError = false;
                                  });
                                },
                              ),
                            ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child:  CustomDropdown<String>(
                    //     items: breakList,
                    //     selectedItem: selectedBreak,
                    //     hint: 'Select a break',
                    //     isError: showAdd1StateError,
                    //     itemLabel: (item) => item,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedBreak = value!;
                    //         showAdd1StateError = false;
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Consumer<ShiftProvider>(
              builder: (context, pro, _) => CustomBottomButton(
                btnText: 'Save Schedule',
                btnController: controller,
                onpressed: saveSchedule,
                isLoading: pro.isLoading,
              ),
            )
          ],
        );
      },
    );
  }

  void saveSchedule() async {
    var sp = context.read<ShiftProvider>();
    // if (sp.endDate == null) {
    //   DashboardHelpers.showAlert(msg: 'Please select End Date');
    //   return;
    // }
    if (selectedZone == null) {
      DashboardHelpers.showAlert(msg: 'Please select Zone');
      return;
    }
    if (sp.startDate != null && sp.endDate != null) {
      debugPrint('sp.startDate ${sp.startDate}');
      debugPrint('sp.endDate ${sp.endDate}');
      if (DashboardHelpers.isEndDateGreaterOrEqual(
          sp.startDate!, sp.endDate!)) {
        var data = {
          "start_time": DashboardHelpers.get24HrFormat(sp.startTime!),
          "end_time": DashboardHelpers.addMinutesToTime(
              DashboardHelpers.get24HrFormat(sp.endTime!), 15),
          "start_date": DashboardHelpers.convertDateTime(
              sp.startDate.toString(),
              pattern: 'yyyy-MM-dd'),
          "end_date": sp.endDate == null
              ? DashboardHelpers.convertDateTime(DateTime.now().toString(),
                  pattern: 'yyyy-MM-dd')
              : DashboardHelpers.convertDateTime(sp.endDate.toString(),
                  pattern: 'yyyy-MM-dd'),
          "zoneTitle": selectedZone!.zoneTitle,
          "zoneTextId": selectedZone!.zoneTextId,
        };
        sp.setLoading(true);
        controller.start();
        var response = await sp.saveNewShiftConfiguration(data);
        AnimationController? localAnimationController;
        if (response != null) {
          //DashboardHelpers.showAnimatedDialog(context, 'Shift Successfully Added','Successful');
          if (response['message'] != null) {
            await sp.getNewScheduleInfo(DashboardHelpers.convertDateTime(
                sp.startDate.toString(),
                pattern: 'yyyy-MM-dd'));
            await sp.getNewScheduleInfo(DashboardHelpers.convertDateTime(
                sp.startDate.toString(),
                pattern: 'yyyy-MM-dd'));
            showCustomSnackBar(
              context,
              response['message'] ?? 'Shift Successfully Added',
              buttonClr,
              snackBarNeutralTextStyle,
              localAnimationController,
            );
            Navigator.pop(context);
          }
        }
        sp.setLoading(false);
        controller.stop();
        setState(() {
          selectedZone = null;
        });
      } else {
        DashboardHelpers.showAlert(msg: 'Please select a valid date');
      }
    }
  }
}

class TimeSelector extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const TimeSelector(
      {required this.label, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: interText(16, Colors.black, FontWeight.w500)),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(time,
                  style: interText(15, Colors.black, FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }
}
