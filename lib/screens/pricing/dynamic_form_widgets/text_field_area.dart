import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../misc/constants.dart';
import '../../../models/pricing_attribute_model_new.dart';
import '../../../provider/pricing_provider.dart';
import '../../../widgets_reuse/bordered_textfield.dart';

class TextFieldArea extends StatefulWidget {
  PriceConfigaruatinAttr attribute;
  int index;
  String keys;
  ZoneList selectedZone;
  String plan;
  PricingProvider provider;

  TextFieldArea(this.attribute, this.index, this.keys, this.selectedZone, this.plan, this.provider);

  @override
  State<TextFieldArea> createState() => _TextFieldAreaState();
}

class _TextFieldAreaState extends State<TextFieldArea> {
  String? price;
  String? time;

  @override
  void initState() {
    //setPreviousValue(widget.attribute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.attribute.title ?? '',
                        style: interText(14, Colors.black, FontWeight.w500),
                      ),
                      Text(
                        '(${widget.provider.serviceInfo.pricingBy})',
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFieldBordered(
                  keys: widget.keys + '${widget.attribute.textId}',
                  hintText: '\$',
                  initialValue: widget.attribute.options!.first.price ?? '',
                  keyboard: TextInputType.numberWithOptions(decimal: true),
                  //keyboard: TextInputType.number,
                  isDolar: true,
                  // fieldTextFieldController: attributePricingController[index],
                  // focusNode: focusNodeList[index],
                  inputFormat: [
                    //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  funcValidate: (value, setErrorInfo) {
                    if (value == null || value.isEmpty) {
                      setErrorInfo(true, '${widget.provider.attributeList[widget.index].title} is required');

                      //focusNodeEmail.requestFocus();
                      return '';
                    } else
                      return null;
                  },
                  funcOnChanged: (String? val) {
                    // var map = {"attrName": attribute.title, "textId": attribute.textId, "price": val};
                    // widget.provider.setAttributeValueMap(attributeId: widget.attribute.textId ?? '', type: "price", value: val ?? '', label: widget.attribute.options!.first.optionLabel ?? '');

                    widget.provider.updateAttributes(textId: widget.attribute.textId ?? '', optionLabel: widget.attribute.options!.first.optionLabel ?? '', update: 'price', value: val ?? '');
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Est. Time',
                  style: interText(14, Colors.black, FontWeight.w500),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFieldBordered(
                  hintText: 'ex. 33 min',
                  isPostFix: true,
                  keys: widget.keys + '${widget.attribute.textId}',
                  initialValue: widget.attribute.options!.first.estTime ?? '',
                  keyboard: TextInputType.number,
                  // fieldTextFieldController: durationController[index],
                  inputFormat: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  funcValidate: (value, setErrorInfo) {
                    if (value == null || value.isEmpty) {
                      setErrorInfo(true, 'required');
                      //focusNodeEmail.requestFocus();
                      return '';
                    } else
                      return null;
                  },
                  funcOnChanged: (String? val) {
                    // widget.provider.setAttributeValueMap(
                    //     attributeId: widget.attribute.textId ?? '',
                    //     type: "time",
                    //     value: val ?? '',
                    //     label:
                    //     widget.attribute.options!.first.optionLabel ?? '');

                    widget.provider.updateAttributes(textId: widget.attribute.textId ?? '', optionLabel: widget.attribute.options!.first.optionLabel ?? '', update: 'time', value: val ?? '');

                    //to avoid null value
                    //widget.provider.setAttributeValueMap(attributeId: widget.attribute.textId ?? '', type: "price", value: widget.attribute.options!.first.price ?? '', label: widget.attribute.options!.first.optionLabel ?? '');
                  },
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// var count = 0;
// void setPreviousValue(PriceConfigaruatinAttr attribute) async {
//   try {
//     price = attribute.options!.first.price ?? '';
//     time = attribute.options!.first.estTime ?? '';
//     if (price != '' && time != '') {
//       Future.microtask(() {
//         widget.provider.setAttributeValueMap(
//             attributeId: widget.attribute.textId ?? '',
//             type: "price",
//             value: price ?? '',
//             label: widget.attribute.options!.first.optionLabel ?? '');
//         widget.provider.setAttributeValueMap(
//             attributeId: widget.attribute.textId ?? '',
//             type: "time",
//             value: time ?? '',
//             label: widget.attribute.options!.first.optionLabel ?? '');
//         ;
//       });
//     } else {
//       if (widget.provider.somethingList.isNotEmpty) {
//         for (var i in widget.provider.somethingList) {
//           if (i['textId'] == widget.attribute.textId) {
//             // debugPrint('MATCHED FOUND ${i['options'][0]['estTime']}');
//             Future.microtask(() {
//               widget.provider.setAttributeValueMap(
//                   attributeId: widget.attribute.textId ?? '',
//                   type: "price",
//                   value: i['options'][0]['price'] ?? '',
//                   label: widget.attribute.options!.first.optionLabel ?? '');
//               widget.provider.setAttributeValueMap(
//                   attributeId: widget.attribute.textId ?? '',
//                   type: "time",
//                   value: i['options'][0]['estTime'] ?? '',
//                   label: widget.attribute.options!.first.optionLabel ?? '');
//             });
//           }
//         }
//       }
//     }
//   } catch (e) {
//     price = null;
//     time = null;
//   }
// }
}
