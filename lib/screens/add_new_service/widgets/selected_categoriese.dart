import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../provider/addnew_services_provider.dart';

class SelectedCategories extends StatelessWidget {
  const SelectedCategories({
    super.key,
    required this.provider,
  });

  final AddNewServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Categories',
                      style: textField_16_black_bold_LabelTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: provider.selectedServiceList.length <= 2
                      ? 50
                      : provider.selectedServiceList.length <= 4
                          ? 100
                          : 150,
                  child: GridView.builder(
                    itemCount: provider.selectedServiceList
                        .length, // Specify the total number of items
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of items per row
                      crossAxisSpacing:
                          10.0, // Spacing between each item horizontally
                      mainAxisSpacing:
                          10.0, // Spacing between each row vertically
                      childAspectRatio: 5, // Aspect ratio of each item
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // Return a widget for each item
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: myColors.greyBg),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8),
                          child: Text(
                            provider.selectedServiceList[index].title ?? '',
                            maxLines: 1,
                            style: GoogleFonts.inter(),
                          ),
                        ),
                      ); // Your item widget, pass index if needed
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 6,
          color: myColors.greyBg,
        ),
      ],
    );
  }
}
