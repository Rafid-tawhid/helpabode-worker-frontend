import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomServiceCard extends StatelessWidget {
  CustomServiceCard({
    required this.margin,
    required this.imageHeight,
    required this.imageUrl,
    required this.cardHeight,
    required this.categoryTitle,
    required this.serviceTitle,
    required this.minPrice,
    required this.categoryStyle,
    required this.serviceStyle,
    required this.priceTitleStyle,
    required this.priceStyle,
    required this.isOptionJsonNull,
  });

  final EdgeInsetsGeometry margin;

  final double imageHeight;
  final String imageUrl;
  final double cardHeight;

  final String categoryTitle;
  final String serviceTitle;
  final String minPrice;

  final TextStyle categoryStyle;
  final TextStyle serviceStyle;
  final TextStyle priceTitleStyle;
  final TextStyle priceStyle;

  final bool isOptionJsonNull;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: cardHeight,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: messageClr,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.w),
            child: FadeInImage(
              fit: BoxFit.cover,
              height: imageHeight,
              width: imageHeight,
              image: NetworkImage(
                  'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
              placeholder: NetworkImage(
                  'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
                  fit: BoxFit.cover,
                  height: imageHeight,
                  width: imageHeight,
                );
              },
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${categoryTitle}',
                style: categoryStyle,
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                '${serviceTitle}',
                style: serviceStyle,
              ),
              Spacer(
                flex: 3,
              ),
              // RichText(
              //   text: TextSpan(
              //     text: 'Min Price ',
              //     style: priceTitleStyle,
              //     children: [
              //       TextSpan(
              //         text: '${minPrice}',
              //         style: priceStyle,
              //       ),
              //       isOptionJsonNull == false
              //           ? TextSpan(
              //               text: ' ...Details >',
              //               style: priceStyle,
              //             )
              //           : TextSpan(
              //               text: '',
              //               style: priceStyle,
              //             ),
              //     ],
              //   ),
              // ),
              RichText(
                text: TextSpan(
                  text: '${minPrice}',
                  style: priceStyle,
                  children: [
                    isOptionJsonNull == false
                        ? TextSpan(
                            text: ' ...Details >',
                            style: priceStyle,
                          )
                        : TextSpan(
                            text: '',
                            style: priceStyle,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
