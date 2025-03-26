import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/all_service_items.dart';
import '../../../models/pending_requested_servicelist.dart';
import '../../../widgets_reuse/loading_indicator.dart';
import '../../add_new_service/prefered_service_area_2.dart';
import '../dynamic_form_pricing.dart';

class AddPriceButton extends StatefulWidget {
  final PendingRequestedServiceList service;

  AddPriceButton(this.service);

  @override
  State<AddPriceButton> createState() => _AddPriceButtonState();
}

class _AddPriceButtonState extends State<AddPriceButton> {
  bool loadingBtn = false;

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PricingProvider>();
    return loadingBtn
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: myColors.greyTxt, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 100,
            height: 40,
            child: const LoadingIndicatorWidget(),
          )
        : GestureDetector(
            onTap: provider.isClickedLoading
                ? null
                : () async {
                    if (widget.service.statusId == PendingRequested.Area_not_add) {
                      // provider.setAllValuesToFalse();
                      //No Area Added;
                      var itemService = AllServiceItems.fromJson(widget.service.toJson());
                      //my now nov 13
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => PreferedServiceAreas2(itemService)));
                    }
                    else {
                      setState(() {
                        loadingBtn = true;
                      });
                      if (await provider.getPriceConfiguration(serviceTextId: widget.service.serviceTextId, plan: widget.service.firstPlanTextId, zone: widget.service.firstZoneTextId, type: widget.service.pricingBy, categoryTextId: widget.service.categoryTextId)) {
                        setState(() {
                          loadingBtn = false;
                        });
                        provider.zoneListForDropDown.clear();
                        provider.zoneListForDropDown.addAll(provider.zoneList);
                        provider.planListForDropDown.clear();
                        provider.planListForDropDown.addAll(provider.servicePlanList);
                        provider.setAllValuesToFalse();
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => DynamicFromPricing(widget.service)));
                      } else {
                        setState(() {
                          loadingBtn = false;
                        });
                      }
                    }
                  },
            child: Container(
              width: 110,
              child: Text(
                'Add Price',
                style: interText(14, Colors.white, FontWeight.w600),
              ),
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: myColors.green, borderRadius: BorderRadius.circular(6)),
            ),
          );
  }
}
