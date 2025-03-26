import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/working_service_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/single_line_shimmer.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/pending_licence_show_shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/my_service_model.dart';
import '../../../models/pending_requested_servicelist.dart';
import '../../myservice/my_service_details_screen.dart';
import '../../pricing/pricing_screen.dart';

class MyServiceListMain extends StatelessWidget {
  List<MyServiceModel> services;

  MyServiceListMain({required this.services});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkingServiceProvider>(
      builder: (context, pro, _) => pro.isLoadingService
          ? SingleLineShimmer()
          : services.isEmpty
              ? Center(
                  child: Text('No Service Found'),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ServiceCard(service: service),
                    );
                  },
                ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final MyServiceModel service;

  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PricingProvider>(
      builder: (context, provider, _) => GestureDetector(
        onTap: () {
          showCategoryItems(service, context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: myColors.greyBtn, width: 1),
            boxShadow: [
              BoxShadow(
                  color: myColors.greyBtn,
                  blurRadius: 48,
                  offset: Offset(0, 12),
                  spreadRadius: 0),
            ],
          ),
          child: Column(
            children: [
              service.pricingBy!.toLowerCase() == 'bundle'
                  ? BundleServiceTopDesign()
                  : SizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  NetworkImageWithShimmer(
                      imageUrl: '${urlBase}${service.image}',
                      width: 72,
                      height: 72,
                      borderRadius: 8,
                      placeholder: 'images/placeholder.jpg'),
                  SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(service.serviceTitle ?? '',
                                style: interText(
                                    16, Colors.black, FontWeight.w700)),
                          ),
                          SizedBox(height: 4),
                          Text(service.pricingBy ?? '',
                              style: interText(
                                  12, Color(0xff535351), FontWeight.w500)),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text("View Details",
                                  style: interText(
                                      12, Colors.black, FontWeight.w600)),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                service.categoryArray!.length > 1
                                    ? Icons.add
                                    : Icons.chevron_right,
                                size: 18,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showCategoryItems(
      MyServiceModel service, BuildContext context) async {
    if (service.categoryArray!.length > 1) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Select Category',
                    style: interText(18, Colors.black, FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: service.categoryArray!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            leading: NetworkImageWithShimmer(
                              imageUrl:
                                  '${urlBase}${service.categoryArray![index].image}',
                              width: 40,
                              height: 40,
                              borderRadius: 50,
                              placeholder: 'images/placeholder.jpg',
                            ),
                            title: Text(
                              service.categoryArray![index].categoryTitle ?? '',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.circle_outlined),
                            onTap: () async {
                              var provider = context.read<PricingProvider>();
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black);
                              if (await provider.getPricingServiceViewDetails(
                                  service.serviceTextId,
                                  service.categoryArray![index].serviceStatus ??
                                      '',
                                  service
                                      .categoryArray![index].categoryTextId)) {
                                PendingRequestedServiceList data =
                                    PendingRequestedServiceList.fromJson(
                                        service.toJson());
                                data.categoryTitle =
                                    service.categoryArray!.first.categoryTitle;
                                data.categoryTextId =
                                    service.categoryArray!.first.categoryTextId;
                                EasyLoading.dismiss();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyServiceDetailsScreen(
                                      PendingRequestedServiceList.fromJson(
                                          data.toJson()),
                                    ),
                                  ),
                                );
                              } else {
                                EasyLoading.dismiss();
                              }
                            },
                          ),
                          Divider(
                              thickness: 1,
                              color: Color(
                                  0xfff6f6f6)), // Divider below each ListTile
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      var provider = context.read<PricingProvider>();
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      if (await provider.getPricingServiceViewDetails(
          service.serviceTextId,
          service.categoryArray!.first.serviceStatus ?? '',
          service.categoryArray!.first.categoryTextId)) {
        // provider.isLoadingViewDetails(index, false);
        EasyLoading.dismiss();
        PendingRequestedServiceList data =
            PendingRequestedServiceList.fromJson(service.toJson());
        //set cat info for different json
        data.categoryTitle = service.categoryArray!.first.categoryTitle;
        data.categoryTextId = service.categoryArray!.first.categoryTextId;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyServiceDetailsScreen(data)));
      } else {
        EasyLoading.dismiss();
      }
    }
  }
}
