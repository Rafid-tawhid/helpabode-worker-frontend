// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import '../../../corporate/corporate_review_details_tracker.dart';

class OrderTracker4 extends StatefulWidget {
  final OrderStatus? status;
  final Color? activeColor;
  final Color? inActiveColor;
  final TextStyle? subTitleTextStyle;

  final List<Map<String, dynamic>> dataList;

  const OrderTracker4({
    super.key,
    required this.status,
    this.activeColor,
    this.inActiveColor,
    this.subTitleTextStyle,
    required this.dataList,
  });

  @override
  State<OrderTracker4> createState() => _OrderTracker4State();
}

class _OrderTracker4State extends State<OrderTracker4> {
  @override
  void initState() {
    super.initState();
  }

  int defineColor(OrderStatus status) {
    if (status == OrderStatus.pending) {
      return 1;
    } else if (status == OrderStatus.booked) {
      return 2;
    } else if (status == OrderStatus.confirmed) {
      return 4;
    } else if (status == OrderStatus.inTransit) {
      return 5;
    } else if (status == OrderStatus.jobStarted) {
      return 6;
    } else if (status == OrderStatus.completedByProvider) {
      return 7;
    } else if (status == OrderStatus.completed) {
      return 8;
    }
    return 0;
  }

  double boxH = 200;
  bool clicked = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Service TimeLine',
              style: interText(18, Colors.black, FontWeight.w700),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: boxH,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      8,
                      (index) => trackSection(
                        thisIndex: index + 1,
                        data: widget.dataList[index],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: clicked,
                child: Positioned(
                  bottom: 0,
                  child: Container(
                    height: 70,
                    width: 400,
                    color: Colors.white.withOpacity(.7),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                clicked ? 'See More' : 'See Less',
                style: interText(16, Colors.black, FontWeight.w600)
                    .copyWith(letterSpacing: 0),
              ),
              Icon(
                clicked
                    ? Icons.arrow_drop_down_rounded
                    : Icons.arrow_drop_up_rounded,
                color: myColors.green,
                size: 36,
              ),
            ],
          ),
          onTap: () async {
            setState(() {
              boxH = clicked ? 450 : 116;
              clicked = !clicked;
            });
          },
        ),
      ],
    );
  }

  Column trackSection({
    required int thisIndex,
    required Map<String, dynamic> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // defineColor(widget.status!) != thisIndex &&
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: defineColor(widget.status!) >= thisIndex
                        ? widget.activeColor ?? Colors.green
                        : widget.inActiveColor ?? Colors.grey[300],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:
                      thisIndex > 3 && defineColor(widget.status!) >= thisIndex
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : SizedBox.shrink(),
                ),
                thisIndex != 8
                    ? SizedBox(
                        width: 3.3,
                        height: 50,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: LinearProgressIndicator(
                            value: defineColor(widget.status!) > thisIndex
                                ? 1
                                : defineColor(widget.status!) == thisIndex
                                    ? 0.5
                                    : 0,
                            backgroundColor:
                                widget.inActiveColor ?? Colors.grey[300],
                            color: defineColor(widget.status!) >= thisIndex
                                ? widget.activeColor ?? Colors.green
                                : widget.inActiveColor ?? Colors.grey[300],
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    data['title'],
                    style: interText(16, Colors.black, FontWeight.w600),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    data['subTitle'] ?? "",
                    style: widget.subTitleTextStyle ??
                        const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff636366)),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

//
