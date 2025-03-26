import 'package:flutter/services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/pricing_attribute_model_new.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../misc/constants.dart';
import '../../../widgets_reuse/bordered_textfield.dart';

class ListItemField extends StatefulWidget {
  PriceConfigaruatinAttr attribute;
  int index;
  String keys;

  ListItemField(this.attribute, this.index, this.keys);

  @override
  State<ListItemField> createState() => _ListItemFieldState();
}

class _ListItemFieldState extends State<ListItemField> {
  @override
  void initState() {
    //setPreviousValue(widget.attribute);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PricingProvider>(
        builder: (context, provider, _) => Container(
              color: myColors.greyBg,
              child: Column(
                children: [
                  Container(
                    color: myColors.greenLight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.attribute.title ?? '',
                            style: interText(14, Colors.black, FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: widget.attribute.instruction != "",
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                                onTap: () {
                                  debugPrint(widget.attribute.instruction);
                                  DashboardHelpers.showAnimatedDialog(context,
                                      widget.attribute.instruction ?? '', null);
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: myColors.green,
                                  size: 18,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 4),
                    child: Column(
                      children: widget.attribute.options!
                          .map((item) => Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                item.optionLabel ?? '',
                                                style: interText(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.w500),
                                              ),
                                              Text(
                                                '(${provider.serviceInfo.pricingBy})',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        TextFieldBordered(
                                          hintText: '\$',
                                          // hintText: provider.previousPricingAttributeList.firstWhere((element) => element.textId == widget.attribute.textId).options!.first.price,
                                          // hintText: widget.attribute.title,
                                          keys: widget.keys,
                                          initialValue: widget
                                                  .attribute
                                                  .options![widget
                                                      .attribute.options!
                                                      .indexOf(item)]
                                                  .price ??
                                              '',
                                          // keyboard: TextInputType.numberWithOptions(decimal: true),
                                          keyboard:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          isDolar: true,
                                          // fieldTextFieldController: attributePricingController[index],
                                          // focusNode: focusNodeList[index],
                                          inputFormat: [
                                            //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$')),
                                          ],
                                          funcValidate: (value, setErrorInfo) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              setErrorInfo(true,
                                                  '${provider.attributeList[widget.index].title} is required');
                                              //focusNodeEmail.requestFocus();
                                              return '';
                                            } else
                                              return null;
                                          },
                                          funcOnChanged: (String? val) {
                                            provider.updateAttributes(
                                                textId:
                                                    widget.attribute.textId ??
                                                        '',
                                                optionLabel: widget
                                                        .attribute
                                                        .options![widget
                                                            .attribute.options!
                                                            .indexOf(item)]
                                                        .optionLabel ??
                                                    '',
                                                update: 'price',
                                                value: val ?? '');

                                            // //DEC 18// changes may remove later
                                            //  provider.setAttributeValueMap(attributeId: widget.attribute.textId ?? '', type: "price", value: val ?? '', label: widget.attribute.options![widget.attribute.options!.indexOf(item)].optionLabel ?? '',);
                                          },
                                          borderRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Est. Time',
                                          style: interText(14, Colors.black,
                                              FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        TextFieldBordered(
                                          //hintText: widget.keys,
                                          // hintText: provider.previousPricingAttributeList.firstWhere((element) => element.textId == widget.attribute.textId).options!.first.price,
                                          // hintText: widget.attribute.title,
                                          hintText: 'ex. 33 min',
                                          keys: widget.keys,
                                          initialValue: widget
                                                  .attribute
                                                  .options![widget
                                                      .attribute.options!
                                                      .indexOf(item)]
                                                  .estTime ??
                                              '',
                                          // keyboard: TextInputType.numberWithOptions(decimal: true),
                                          keyboard: TextInputType.number,
                                          isPostFix: true,
                                          // fieldTextFieldController: attributePricingController[index],
                                          // focusNode: focusNodeList[index],
                                          inputFormat: [
                                            //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$')),
                                          ],
                                          funcValidate: (value, setErrorInfo) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              setErrorInfo(true, 'required');

                                              //focusNodeEmail.requestFocus();
                                              return '';
                                            } else
                                              return null;
                                          },
                                          funcOnChanged: (String? val) {
                                            // var map = {"attrName": attribute.title, "textId": attribute.textId, "price": val};

                                            //olso price changed

                                            //  provider.setAttributeValueMap(attributeId: widget.attribute.textId ?? '', type: "price", value: widget.attribute.options![widget.attribute.options!.indexOf(item)].price ?? '', label: widget.attribute.options![widget.attribute.options!.indexOf(item)].optionLabel ?? '');

                                            provider.updateAttributes(
                                                textId:
                                                    widget.attribute.textId ??
                                                        '',
                                                optionLabel: widget
                                                        .attribute
                                                        .options![widget
                                                            .attribute.options!
                                                            .indexOf(item)]
                                                        .optionLabel ??
                                                    '',
                                                update: 'time',
                                                value: val ?? '');

                                            //   // //Dec 18// changes may remove later
                                            // provider.setAttributeValueMap(
                                            //     attributeId:
                                            //         widget.attribute.textId ??
                                            //             '',
                                            //     type: "time",
                                            //     value: val ?? '',
                                            //     label: widget
                                            //             .attribute
                                            //             .options![widget
                                            //                 .attribute.options!
                                            //                 .indexOf(item)]
                                            //             .optionLabel ??
                                            //         '');
                                          },
                                          borderRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ));
  }

  // void setPreviousValue(PriceConfigaruatinAttr attribute) {
  //   final provider = Provider.of<PricingProvider>(context, listen: false);
  //   Future.microtask(() {
  //     try {
  //       if (attribute.options!.first.price != '' &&
  //           attribute.options!.first.estTime != '') {
  //         widget.attribute.options!.forEach((element) {
  //           provider.setAttributeValueMap(
  //               attributeId: widget.attribute.textId ?? '',
  //               type: "price",
  //               value: element.price ?? '',
  //               label: element.optionLabel ?? '');
  //           provider.setAttributeValueMap(
  //               attributeId: widget.attribute.textId ?? '',
  //               type: "time",
  //               value: element.estTime ?? '',
  //               label: element.optionLabel ?? '');
  //         });
  //       } else {
  //         // Handle the else case if needed
  //       }
  //     } catch (e) {
  //       // Handle the exception if needed
  //     }
  //   });
  // }
}
