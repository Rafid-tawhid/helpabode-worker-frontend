import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/models/pending_service_details_model.dart';
import 'package:provider/provider.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../helper_functions/dashboard_helpers.dart';
import '../../../../misc/constants.dart';
import '../../../../provider/user_provider.dart';

class ServiceAttribute extends StatelessWidget {
  List<ServiceJson> serviceJsonList;
  String? type;
  ServiceAttribute({required this.serviceJsonList, this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            child: Consumer<UserProvider>(
              builder: (context, provider, _) => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: serviceJsonList.length,
                  itemBuilder: (context, index) {
                    var info = serviceJsonList[index];
                    return info.inputType == 'checkbox' ||
                            info.inputType == 'textarea'
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      margin: EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: myColors.green, width: 1)),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: myColors.green),
                                        height: 4,
                                        width: 4,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            info.title ?? '',
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          type == 'Admin Default Plan'
                                              ? Text(
                                                  '${info.attributeValue!.replaceAll("[", "").replaceAll("]", "")}')
                                              : Text(DashboardHelpers
                                                  .extractTitles(info
                                                      .attributeValue!
                                                      .replaceAll("[", "")
                                                      .replaceAll("]", "")))
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8)
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: myColors.green, width: 1)),
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: myColors.green),
                                  height: 4,
                                  width: 4,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    info.title ?? '',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    ': ${info.amount}',
                                    style: interText(
                                        14, Color(0xff636366), FontWeight.w500),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${info.attributeValue}',
                                            textAlign: TextAlign.right,
                                            style: interText(
                                                14,
                                                Color(0xff636366),
                                                FontWeight.w500)),
                                        if (info.measurementUnit != "null" ||
                                            info.measurementUnit == "")
                                          Text(' ${info.measurementUnit}',
                                              textAlign: TextAlign.right,
                                              style: interText(
                                                  14,
                                                  Color(0xff636366),
                                                  FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                  }),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFF6F6F6),
                ),
              ),
            ),
          ),

          //  CardAddress(requestedServiceDetailsMap: requestedServiceDetailsMap),
        ],
      ),
    );
  }
}

class ShowAttributeListWidget extends StatelessWidget {
  final List<ServiceJson> attributes;
  final Color borderColor;
  final Color iconColor;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  const ShowAttributeListWidget({
    Key? key,
    required this.attributes,
    this.borderColor = Colors.green,
    this.iconColor = Colors.green,
    this.titleStyle = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
    this.valueStyle = const TextStyle(fontSize: 14, color: Colors.black),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attributes
          .map((attribute) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      child: Container(
                        height: 7,
                        width: 7,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    attribute.inputType != 'checkbox'
                        ? Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${attribute.title}: ', style: titleStyle),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        attribute.attributeValue
                                                ?.replaceAll("[", "")
                                                .replaceAll("]", "") ??
                                            '',
                                        style: valueStyle,
                                      ),
                                      if (attribute.measurementUnit != 'null')
                                        Text(
                                            ' ${attribute.measurementUnit ?? ''}')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                      text: '${attribute.title}: ',
                                      style: titleStyle),
                                  TextSpan(
                                    text: DashboardHelpers.extractTitles(
                                        attribute.attributeValue ?? ''),
                                    style: valueStyle,
                                  ),
                                  if (attribute.measurementUnit != 'null')
                                    TextSpan(
                                      text:
                                          ' ${attribute.measurementUnit ?? ''}',
                                      style: valueStyle,
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
