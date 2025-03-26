import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../models/pending_requested_servicelist.dart';
import '../../../provider/pricing_provider.dart';

class ShowServiceAttributeAnimation extends StatelessWidget {
  final isExpanded;
  final PendingRequestedServiceList service;

  ShowServiceAttributeAnimation(this.isExpanded, this.service);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: isExpanded ? 1.0 : 0.0,
      child: Visibility(
        visible: true,
        child: AnimatedContainer(
          duration: Duration(microseconds: 300),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pricing by',
                      style: interText(14, Colors.black, FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: myColors.greyBg,
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 8),
                        child: Text(
                          service.pricingBy ?? '',
                          style: interText(14, Colors.black, FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Consumer<PricingProvider>(
                builder: (context, provider, _) => Visibility(
                  visible: provider.pricingServiceDetailsinfo != null,
                  child: SizedBox(
                    height: provider.pricingServiceDetailsinfo!.attributes!
                                .length <=
                            2
                        ? 50
                        : provider.pricingServiceDetailsinfo!.attributes!
                                    .length <=
                                4
                            ? 100
                            : 160,
                    child: GridView.builder(
                      itemCount: provider
                          .pricingServiceDetailsinfo!.attributes!.length,
                      // physics: NeverScrollableScrollPhysics(), // Specify the total number of items
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
                              borderRadius: BorderRadius.circular(4),
                              color: myColors.greyBg),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8),
                            child:
                                provider.pricingServiceDetailsinfo!.pricingBy ==
                                        'bundle'
                                    ? Text(
                                        '${provider.pricingServiceDetailsinfo!.attributes![index].title}-${provider.pricingServiceDetailsinfo!.attributes![index].values}',
                                        maxLines: 1,
                                        style: GoogleFonts.inter(),
                                      )
                                    : Text(
                                        '${provider.pricingServiceDetailsinfo!.attributes![index].title}',
                                        maxLines: 1,
                                        style: GoogleFonts.inter(),
                                      ),
                          ),
                        ); // Your item widget, pass index if needed
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
