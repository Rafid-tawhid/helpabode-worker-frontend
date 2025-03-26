import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../misc/constants.dart';
import '../../../../provider/pricing_provider.dart';
import '../../../models/pending_price_view_details_model.dart';
import '../../../widgets_reuse/attribute_display.dart';

class ShowServiceAttributes extends StatelessWidget {
  final List<PendingAttribute> pendingAttributes;

  ShowServiceAttributes(this.pendingAttributes);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: myColors.greyBg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Options',
              style: interText(15, Colors.black, FontWeight.w600),
            ),
            SizedBox(height: 6),
            Consumer<PricingProvider>(
              builder: (context, provider, _) => pendingAttributes.isEmpty
                  ? Center(
                      child: Text('No attributes found'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pendingAttributes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final attribute = pendingAttributes[index];
                        return AttributeDisplay(
                          title: attribute.title ?? '',
                          values: attribute.values!
                              .map((e) => e.toString())
                              .toList(), // Ensure it's a List<String>
                          borderColor: myColors.green,
                          dotColor: myColors.green,
                          titleStyle:
                              interText(14, Colors.black, FontWeight.w500),
                          valueStyle:
                              interText(14, Colors.grey[700]!, FontWeight.w400),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
