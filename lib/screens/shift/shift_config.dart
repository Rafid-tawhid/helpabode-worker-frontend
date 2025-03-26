import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../custom_packages/extensions/custom_material_button.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../misc/constants.dart';
import '../../provider/shift_config_provider.dart';
import '../../widgets_reuse/circular_tab_day.dart';
import '../../widgets_reuse/delete_bottom_modal_sheet.dart';
import '../../widgets_reuse/shift_config_bottom_modal_sheet.dart';

class ShiftConfigration extends StatefulWidget {
  const ShiftConfigration({super.key});

  @override
  State<ShiftConfigration> createState() => _ShiftConfigrationState();
}

class _ShiftConfigrationState extends State<ShiftConfigration> {
  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  late ShiftProvider provider;
  String selectedDay = '';
  bool callOnce = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (callOnce) {
      provider = Provider.of(context, listen: true);
      getWorkersTodaysShiftConfiguration(provider);
      callOnce = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ShiftProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                //ScheduleViwerScreen

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        'Shift Configuration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             ScheduleViwerScreen()));
                          },
                          icon: const Text('')),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: List.generate(
                      daysOfWeek.length,
                      (index) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CustomCircularTabDay(
                                flagDay: provider.selectedDay,
                                day: daysOfWeek[index],
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  selectedDay = daysOfWeek[index];
                                  provider.setLoading(true);
                                  provider.changeDate(daysOfWeek[index]);
                                  if (await provider.getWorkerScheduleInfo()) {
                                    provider.setShifthour(daysOfWeek[index]);

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ),
                          )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: cardDividerClr,
                  height: 8,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Select schedule hour',
                          style: textField_18_black_600_TextStyle,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Consumer<ShiftProvider>(builder: (context, pro, _) {
                  if (!isLoading) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: pro.listOfDate.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (UserHelpers.empType !=
                                UserHelpers.empTypeUnderProvider) {
                              provider.updateList(index);
                            }
                          },
                          onLongPress: () {
                            print('Long Press');
                            provider.deleteScheduleIconShow(
                                selectedDay,
                                provider.listOfDate[index]['title'],
                                provider.listOfDate[index]['zone_title'],
                                index);
                            //provider.addtoDeleteList(index);
                          },
                          onHorizontalDragUpdate: (details) {
                            // if (provider.hoursList[index]['deleteFlag'] == 1 && details.delta.dx > 0) {
                            //   //provider.hoursList[index]['deleteFlag'] = 0;
                            //   //setState(() {});
                            // }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 8),
                                  child: FittedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          DashboardHelpers.get12HrFormat(
                                              provider.listOfDate[index]
                                                  ['title']),
                                          style: const TextStyle(
                                            height: 1,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          ' ${DashboardHelpers.getAmPm(provider.listOfDate[index]['title'])}',
                                          style: const TextStyle(
                                            height: 1,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: fontClr,
                                      ),
                                      Container(
                                        height: 48,
                                        width: double.infinity,
                                        color: provider.listOfDate[index]
                                                ['selected']
                                            ? Color(0xffd5e7e0)
                                            : provider.listOfDate[index]
                                                        ['flag'] ==
                                                    1
                                                ? Color(0xffd5e7e0)
                                                : Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  provider.listOfDate[index]
                                                      ['zone_title'],
                                                  style: interText(
                                                      14,
                                                      Colors.black,
                                                      FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            provider.listOfDate[index]
                                                        ['deleteFlag'] ==
                                                    0
                                                ? Row(
                                                    children: [
                                                      if (pro.listOfDate[index]
                                                              ['selected'] ==
                                                          true)
                                                        Text(
                                                          '${provider.listOfDate[index]['duration']} Week',
                                                          style: interText(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.w400),
                                                        ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        provider.listOfDate[
                                                                        index]
                                                                    ['area'] ==
                                                                ''
                                                            ? '${provider.listOfDate[index]['duration']}'
                                                            : '${provider.listOfDate[index]['duration']} W',
                                                        style:
                                                            text_16_white_400_TextStyle,
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      if (pro.listOfDate[index]
                                                              ['selected'] &&
                                                          pro.listOfDate[index][
                                                                  'deleteFlag'] ==
                                                              1)
                                                        InkWell(
                                                          child: Container(
                                                            width: 50,
                                                            height:
                                                                double.infinity,
                                                            color: shiftCardClr,
                                                            child: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            var data = provider
                                                                .deleteScheduleQuarte(
                                                                    selectedDay,
                                                                    pro.listOfDate[
                                                                            index]
                                                                        ['id']);

                                                            if (data != null) {
                                                              await buildShowDeleteModalBottomSheet(
                                                                  context,
                                                                  index,
                                                                  [
                                                                    data.clmData!
                                                                        .first
                                                                        .toJson(),
                                                                    selectedDay
                                                                  ],
                                                                  'workerShiftConfigurationDelete');
                                                            }

                                                            //previous code
                                                            // pro.shiftWorkerplanList.forEach((element) {
                                                            //   if (element.dayOfWeek == selectedDay) {
                                                            //     element.quarters!.forEach((item) async {
                                                            //       if (item.clmData!.first.zoneTitle == pro.listOfDate[index]['zone_title'] && pro.isTimeInRange(pro.listOfDate[index]['id'], item.clmData!.first.timeSlot!)) {
                                                            //         print('item found');
                                                            //         print(item.clmData!.first.timeSlot);
                                                            //         print(item.clmData!.first.toJson());
                                                            //         //get the selected item
                                                            //         // await buildShowDeleteModalBottomSheet(context, index, [item.clmData!.first.toJson(), selectedDay], 'workerShiftConfigurationDelete');
                                                            //       }
                                                            //     });
                                                            //   }
                                                            // });
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: myColors.green,
                      ),
                    );
                  }
                })),
                if (UserHelpers.empType != UserHelpers.empTypeUnderProvider)
                  SizedBox(
                    height: 15,
                  ),
                if (UserHelpers.empType != UserHelpers.empTypeUnderProvider)
                  Consumer<ShiftProvider>(
                    builder: (context, pro, _) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: CustomMaterialButton(
                        label: 'Add Shift',
                        buttonColor:
                            pro.hasFlagSetTo1() ? buttonClr : buttonDisableClr,
                        fontColor:
                            pro.hasFlagSetTo1() ? buttonFontClr : Colors.black,
                        funcName: pro.hasFlagSetTo1()
                            ? () async {
                                //calculate min and max time where flag ==1
                                String minTime =
                                    pro.calculateMinMaxTime()['minTitle'] ?? '';
                                String maxTime =
                                    pro.calculateMinMaxTime()['maxTitle'] ?? '';
                                String addTime =
                                    DashboardHelpers.addMinutesToTime(
                                        maxTime, 15);
                                print('$minTime $addTime');
                                await buildShowShiftConfigModalBottomSheet(
                                    context, selectedDay, minTime, addTime);
                              }
                            : () {
                                setState(() {});
                              },
                        borderRadius: 50,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future postPlanGenerate() async {
    try {
      print("try");

      print("before post");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await post(
        Uri.parse("${urlBase}api/workerScheduleGenerate"),
        headers: header,
      );
    } catch (e) {
      print("catch");
      print(e);
    }
  }

  Future<void> getWorkersTodaysShiftConfiguration(
      ShiftProvider provider) async {
    DateTime now = DateTime.now();
    String today = DateFormat.EEEE().format(now).toString().substring(0, 3);
    print('today $today');

    setState(() {
      isLoading = true;
    });
    await provider.getWorkerScheduleInfo().then((value) {
      setState(() {
        isLoading = false;
      });
      provider.setLoading(false);
      daysOfWeek.indexOf(today);
      selectedDay = today;
      provider.changeDate(today);
      provider.setShifthour(today);
    });
  }
}
