import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../misc/constants.dart';
import '../../../models/pending_requested_servicelist.dart';

class RejectedPopupContent extends StatefulWidget {
  final PendingRequestedServiceList service;

  RejectedPopupContent(this.service);

  @override
  _RejectedPopupContentState createState() => _RejectedPopupContentState();
}

class _RejectedPopupContentState extends State<RejectedPopupContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cross icon with red circle background
            Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(height: 20),

            // "Rejected" text
            Text(
              'Rejected',
              style: TextStyle(
                fontSize: 24,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Description text
            Text(
              widget.service.priceRejectedNote ??
                  'Your request has been rejected. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            if (widget.service.priceRejectedDate!.isNotEmpty ||
                widget.service.priceRejectedDate != null)
              Text(
                DashboardHelpers.convertDateTime(
                    widget.service.priceRejectedDate ?? ''),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            SizedBox(height: 20),

            // Close button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

getColor(String? status, String? statusId) {
  if (statusId == PendingRequested.Approved) {
    return myColors.green;
  } else if (statusId == PendingRequested.Pending_Approval) {
    return Color(0xFFFAA71A);
  } else {
    return Colors.red;
  }
}
