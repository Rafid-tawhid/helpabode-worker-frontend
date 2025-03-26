// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';

import '../misc/constants.dart';
import '../models/service_plan_model.dart';

class ServicePlanTabView extends StatefulWidget {
  const ServicePlanTabView({super.key, required this.servicePlans});

  final List<ServicePlanModel> servicePlans;

  @override
  _ServicePlanTabViewState createState() => _ServicePlanTabViewState();
}

class _ServicePlanTabViewState extends State<ServicePlanTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.servicePlans.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textColor =
    //     _tabController.index == selectedIndex ? Colors.white : Colors.black;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: TabBar(
                  tabAlignment: TabAlignment.center,
                  indicator: CustomTabIndicator(
                      isActiveIndex: selectedIndex == _tabController.index),
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorWeight: 0,
                  tabs: List.generate(
                    widget.servicePlans.length,
                    (index) => Column(
                      children: [
                        Tab(
                          height: 34,
                          child: CustomTab(
                            '${widget.servicePlans[index].servicePlanTitle}',
                            index,
                            selectedIndex,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // tabs: [
                  // Tab(
                  //   child: CustomTab('Sign In', 0, selectedIndex),
                  // ),
                  //   Tab(
                  //     child: CustomTab('Sign Up', 1, selectedIndex),
                  //   ),
                  // ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: TabBarView(
              // mainAxisSize: MainAxisSize.min,
              controller: _tabController,
              // physics: NeverScrollableScrollPhysics(),

              children: widget.servicePlans
                  .map(
                    (e) => Container(
                      decoration: BoxDecoration(
                          color: myColors.greyServiceBg,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 12),
                                    child: Text(
                                      e.level1 ?? '',
                                      style: text_16_black_600_TextStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: TextField(
                                        style: TextStyle(
                                            color: Colors.black), // Text color
                                        decoration: InputDecoration(
                                          // contentPadding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              16, 12, 16, 12),
                                          // contentPadding: isValid == null ? null : EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'price',
                                          hintStyle: TextStyle(
                                            color: fontClr,
                                            fontSize: 16,
                                          ),

                                          //border: InputBorder.none,

                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 0.5,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          print('TAB VALUE ${val}');
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      e.level2 ?? '',
                                      style: text_16_black_600_TextStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: TextField(
                                        style: TextStyle(
                                            color: Colors.black), // Text color
                                        decoration: InputDecoration(
                                          // contentPadding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              16, 12, 16, 12),
                                          // contentPadding: isValid == null ? null : EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'price',
                                          hintStyle: TextStyle(
                                            color: fontClr,
                                            fontSize: 16,
                                          ),

                                          //border: InputBorder.none,

                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 0.5,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          print('TAB VALUE 2 ${val}');
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 12),
                                    child: Text(
                                      e.level1 ?? '',
                                      style: text_16_black_600_TextStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: TextField(
                                        style: TextStyle(
                                            color: Colors.black), // Text color
                                        decoration: InputDecoration(
                                          // contentPadding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              16, 12, 16, 12),
                                          // contentPadding: isValid == null ? null : EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'price',
                                          hintStyle: TextStyle(
                                            color: fontClr,
                                            fontSize: 16,
                                          ),

                                          //border: InputBorder.none,

                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 0.5,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          print('TAB VALUE ${val}');
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 8),
                                              child: Text(
                                                'Save Info',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            )),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}

class CustomTabIndicator extends Decoration {
  final bool isActiveIndex;

  CustomTabIndicator({required this.isActiveIndex});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged, isActiveIndex);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final bool isActiveIndex;

  _CustomPainter(this.decoration, VoidCallback? onChanged, this.isActiveIndex)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final paint = Paint()
      ..color = isActiveIndex
          ? Color(0xff008951)
          : Colors.red // Set the indicator color
      ..style = PaintingStyle.fill;

    // Draw a rectangle that covers the entire tab label
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(50.0), // Adjust the radius as needed
      ),
      paint,
    );

    // Draw the down arrow indicator
    // final arrowPaint = Paint()
    //   ..color = Color(0xff008951) // Set the arrow color
    //   ..style = PaintingStyle.fill;
    //
    // final arrowPath = Path()
    //   ..moveTo(rect.center.dx - 10, rect.bottom - 5)
    //   ..lineTo(rect.center.dx + 10, rect.bottom - 5)
    //   ..lineTo(rect.center.dx, rect.bottom + 10)
    //   ..close();

    //canvas.drawPath(arrowPath, arrowPaint);
  }
}

class TabContent extends StatelessWidget {
  final String text;

  TabContent(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: textField_16_black_bold_LabelTextStyle.copyWith(
            fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String text;
  final int index;
  final int selectedIndex;

  CustomTab(this.text, this.index, this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    final textColor = index == selectedIndex ? Colors.white : Color(0xFF535151);

    return Container(
      // width: ,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            text,
            style: textField_16_black_bold_LabelTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0,
            ),
            // style: TextStyle(
            //   color: textColor,
            //   fontSize: 16,

            // ),
          ),
        ),
      ),
    );
  }
}
