import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';

void showBookingDetailsSheet(
  BuildContext context, {
  required String serviceName,
  required String orderId,
  required String address,
  required String scheduleDate,
  required String status,
  required Color statusColor,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '📍 Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildDetailItem(
                Icons.favorite_border, 'Service Name', serviceName),
            _buildDetailItem(Icons.receipt_long, 'Order ID', orderId),
            _buildDetailItem(Icons.location_on_outlined, 'Address', address),
            _buildDetailItem(
                Icons.calendar_today_outlined, 'Schedule Date', scheduleDate),
            _buildStatusItem(status, statusColor),
            SizedBox(height: 20),
            CustomMaterialButton(
                label: 'Close',
                buttonColor: myColors.greyBtn,
                fontColor: Colors.black,
                funcName: () {
                  Navigator.pop(context);
                },
                borderRadius: 50),
            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _buildDetailItem(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.black54),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              SizedBox(height: 4),
              Text(value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatusItem(String status, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(Icons.error_outline, size: 22, color: color),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status',
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              SizedBox(height: 4),
              Text(status,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: color)),
            ],
          ),
        ),
      ],
    ),
  );
}
