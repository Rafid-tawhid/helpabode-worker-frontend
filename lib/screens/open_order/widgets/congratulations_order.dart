import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/notification_model.dart';
import '../ordered_service_details_screen.dart';

class ReceivingOrderDialog extends StatelessWidget {
  final OptionJson optionJson;

  ReceivingOrderDialog(this.optionJson);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
              'assets/svg/check_green.svg'), // Update with appropriate asset
          SizedBox(height: 20.0),
          Text(
            'Order Received!',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Your have received a new order named ${optionJson.serviceTitle}.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          Text(
            'Schedule: ${optionJson.scheduleDate}.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          ReveivedOrderButton(optionJson: optionJson),
        ],
      ),
    );
  }
}

class ReveivedOrderButton extends StatefulWidget {
  const ReveivedOrderButton({
    super.key,
    required this.optionJson,
  });

  final OptionJson optionJson;

  @override
  State<ReveivedOrderButton> createState() => _ReveivedOrderButtonState();
}

class _ReveivedOrderButtonState extends State<ReveivedOrderButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
        builder: (context, provider, _) => ElevatedButton(
              onPressed: () async {
                setState(() {
                  isSelected = true;
                });
                if (await provider.getWorkerPendingServiceDetails(
                    widget.optionJson.endUserOrderTimeId.toString(),
                    widget.optionJson.serviceTextId)) {
                  setState(() {
                    isSelected = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderedServiceDetailsScreen(
                                orderTextId: widget.optionJson.orderTextId,
                                serviceId:
                                    widget.optionJson.serviceTextId ?? '',
                              )));
                } else {
                  setState(() {
                    isSelected = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColors.green, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              child: Text(
                'View Details',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
