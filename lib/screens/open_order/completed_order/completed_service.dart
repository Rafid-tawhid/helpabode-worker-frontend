import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/completed_order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/earning/earning_history.dart';
import 'package:provider/provider.dart';

import '../../../misc/constants.dart';
import '../../../models/worker_service_request_model.dart';
import '../../../provider/navbar_provider.dart';
import '../../../widgets_reuse/loading_indicator.dart';
import 'completed_order_details.dart';

class CompletedServices extends StatefulWidget {
  const CompletedServices({Key? key}) : super(key: key);

  @override
  State<CompletedServices> createState() => _CompletedServicesState();
}

class _CompletedServicesState extends State<CompletedServices> {
  double ratings = 3;

  @override
  void initState() {
    super.initState();
    // Fetch completed services when the widget is first created
    callCompletedWorkInfo();
  }

  Future<void> _refresh() async {
    Provider.of<CompletedOrderProvider>(context, listen: false)
        .getWorkerCompletedService();
  }

  @override
  Widget build(BuildContext context) {
    // Show completed service list
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Completed Orders',
          style: interText(18, Colors.black, FontWeight.w600),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
                onTap: () {
                  var pp = context.read<TabControllerProvider>();
                  pp.updateNavBarAtInitialStage(
                    context,
                    4,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EarningHistoryScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    'assets/svg/court house.svg',
                    height: 24,
                    width: 24,
                  ),
                )),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Consumer<CompletedOrderProvider>(
            builder: (context, provider, _) => SafeArea(
                  child: provider.loadingAllCompletedService
                      ? Center(
                          child: CircularProgressIndicator(
                            color: myColors.green,
                          ),
                        )
                      : Column(
                          children: [
                            provider.completedServiceModelList.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child:
                                          Text('No completed services found.'),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: provider
                                          .completedServiceModelList.length,
                                      itemBuilder: (context, index) {
                                        var item = provider
                                            .completedServiceModelList[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: OrderCard(item),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                )),
      ),
    );
  }

  void callCompletedWorkInfo() async {
    Future.microtask(() {
      var op = context.read<CompletedOrderProvider>();
      if (op.completedServiceModelList.isEmpty) {
        Provider.of<CompletedOrderProvider>(context, listen: false)
            .getWorkerCompletedService();
      }
    });
  }
}

class OrderCard extends StatelessWidget {
  final OrderItems item;

  OrderCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFF2F2F2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x0C11111A),
              blurRadius: 32,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: CompletedOrderCard(item),
      ),
    );
  }
}

class CompletedOrderCard extends StatefulWidget {
  final OrderItems singleItems;
  // final CompletedServiceModel orderInfo;
  CompletedOrderCard(this.singleItems);

  @override
  State<CompletedOrderCard> createState() => _CompletedOrderCardState();
}

class _CompletedOrderCardState extends State<CompletedOrderCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '\$${widget.singleItems.serviceAmount.toString()}',
                style: cardPriceTextStyle,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Paid')
            ],
          ),
          Text(
              '${DashboardHelpers.convertDateTime(widget.singleItems.orderPlaceTime ?? '')}',
              style: interText(12, Color(0xff767676), FontWeight.w500)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
            child: Divider(
              thickness: .5,
              height: .5,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  height: 64,
                  width: 64,
                  image: NetworkImage(
                      '$urlBase${widget.singleItems.serviceImage}'),
                  placeholder: const NetworkImage(
                      'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
                      fit: BoxFit.cover,
                      height: 64,
                      width: 64,
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.singleItems.serviceTitle ?? '',
                      style: interText(16, Colors.black, FontWeight.w600),
                    ),
                    // FittedBox(
                    //   child: Text(
                    //     '${widget.singleItems.endUserDeliveryAddress!.city},${widget.singleItems.endUserDeliveryAddress!.state} ${widget.singleItems.endUserDeliveryAddress!.zip} ${widget.singleItems.endUserDeliveryAddress!.countryIso2Code}',
                    //     style: interText(14, Colors.black, FontWeight.w400),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Scheduled: ${widget.singleItems.scheduledDate} ${widget.singleItems.scheduledStartTime} | ${widget.singleItems.scheduleEndtime}',
                      style: interText(14, Colors.black54, FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: .5,
              height: .5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                child: FittedBox(
                  child: RatingBar.builder(
                    initialRating: double.parse(
                        widget.singleItems.rateForWorkerByEndUser.toString()),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 14,
                      color: myColors.green,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var provider = context.read<CompletedOrderProvider>();
                  if (!provider.clicked) {
                    setState(() {
                      isLoading = true;
                    });
                    if (await provider.getSelectedCompletedOrderDetails(
                        widget.singleItems.orderTimesId.toString() ?? '',
                        widget.singleItems.serviceTextId ?? '')) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => CompletedOrderDetails(
                                    singleItem: widget.singleItems,
                                  )));
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: isLoading
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade100, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: 120,
                          height: 40,
                          child: LoadingIndicatorWidget(
                            color: myColors.green,
                          ),
                        )
                      : Text(
                          'View Details',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
