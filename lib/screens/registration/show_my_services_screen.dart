import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/show_service_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/pending_registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../misc/constants.dart';
import '../../widgets_reuse/custom_material_button.dart';

class ShowMyServicesScreen extends StatefulWidget {
  static const String routeName = 'show_my_services';

  @override
  State<ShowMyServicesScreen> createState() => _ShowMyServicesScreenState();
}

class _ShowMyServicesScreenState extends State<ShowMyServicesScreen> {
  bool calledOnce = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ShowServiceProvider>(context, listen: false)
              .getMySelectedServiceZone();
        },
        child: Column(
          children: [
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0)), // Set the border radius here
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Service Areas',
                                style: interText(
                                    18, Colors.black, FontWeight.w600)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Preview',
                              style:
                                  interText(12, Colors.black, FontWeight.w400),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            print(token);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularStepProgressIndicator(
                                  totalSteps: 3,
                                  currentStep: 3,
                                  stepSize: 4,
                                  selectedColor: myColors.green,
                                  width: 48.h,
                                  removeRoundedCapExtraAngle: true,
                                  height: 48.h,
                                  roundedCap: (_, isSelected) => isSelected,
                                ),
                                const Text(
                                  '3/3',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Consumer<ShowServiceProvider>(
                    builder: (ctx, provider, child) => ListView.builder(
                          itemCount: provider.mySelectedZoneList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = provider.mySelectedZoneList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                  padding: const EdgeInsets.only(left: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: myColors.greyTxt, width: .5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    childrenPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    iconColor: Colors.black,
                                    initiallyExpanded: true,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.transparent,
                                            width: 2)),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${item.zoneTitle}',
                                          // Display index + 1
                                          style: interText(14, Colors.black,
                                              FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: myColors.greyBg,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: item.zipArray!
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int idx = entry.key;
                                            var e = entry.value;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          e.zipAddress ?? ''),
                                                    ),
                                                  ),
                                                  if (idx !=
                                                      item.zipArray!.length -
                                                          1) // Only show the grey line if it's not the last item
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: Container(
                                                        height: 0.2,
                                                        color: myColors.greyTxt,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  )),
                            );
                          },
                        )),
              ),
            ),
            CustomMaterialButton(
                label: 'Continue',
                buttonColor: myColors.green,
                fontColor: Colors.white,
                funcName: () {
                  //print(token);
                  context.pushNamed(PendingRegistrationProcess.routeName);
                },
                borderRadius: 40),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
