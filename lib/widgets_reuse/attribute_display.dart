import 'package:flutter/material.dart';

class AttributeDisplay extends StatelessWidget {
  final String title;
  final List<String> values;
  final Color borderColor;
  final Color dotColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const AttributeDisplay({
    Key? key,
    required this.title,
    required this.values,
    this.borderColor = Colors.green,
    this.dotColor = Colors.green,
    this.titleStyle,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
      child: values.length > 1
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: dotColor),
                        height: 6,
                        width: 6,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$title : ',
                          style: titleStyle ??
                              TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                        ),
                        TextSpan(
                          text: values
                              .join(', '), // Join values into a single string
                          style: valueStyle ??
                              TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: dotColor),
                        height: 6,
                        width: 6,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '$title :',
                  style: titleStyle ??
                      TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                ),
                Expanded(
                  child: Text(
                    values.join(', '),
                    style: valueStyle ??
                        TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700]),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
    );
  }
}
