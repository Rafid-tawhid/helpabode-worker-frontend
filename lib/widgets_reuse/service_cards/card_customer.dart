import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';

import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/circular_cached_image.dart';
import 'package:provider/provider.dart';

class CardCustomer extends StatelessWidget {
  CardCustomer({
    required this.customerName,
    required this.customerAddress,
    required this.customerImageUrl,
    required this.topBorderRadius,
    required this.bottomBorderRadius,
  });

  final String customerName;
  final String customerAddress;
  final String customerImageUrl;
  final double topBorderRadius;
  final double bottomBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topBorderRadius),
          bottom: Radius.circular(bottomBorderRadius),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<UserProvider>(builder: (context, provider, _) {
            return InkWell(
              onTap: () {
                print('customerImageUrl ${customerImageUrl}');
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: myColors.green, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: MyImageWidget(
                    imageUrl: customerImageUrl,
                    firstName: customerName,
                    lastName: customerName,
                    size: 50,
                    // borderColor: myColors.green,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customerAddress,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
