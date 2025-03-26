import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/new_schedule_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/loading_indicator.dart';
import 'package:provider/provider.dart';

void showPauseScheduleBottomSheet(
    BuildContext context, dynamic data, DateTime date, bool isPause) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade600),
                SizedBox(width: 8),
                Text(
                  "${isPause == true ? 'Unpause Schedule?' : 'Pause Schedule?'}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Your schedule will be temporarily paused, and you won't receive new orders until you resume. Ongoing orders will not be affected.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20),
            Consumer<ShiftProvider>(
                builder: (context, pro, _) => ElevatedButton(
                      onPressed: () async {
                        var sp = context.read<ShiftProvider>();
                        if (await sp.pauseAschedule(data, date, isPause)) {
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewScheduleScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: pro.isLoading
                          ? LoadingIndicatorWidget(
                              color: Colors.black,
                            )
                          : Text(
                              '${isPause == true ? 'Confirm Unpause' : 'Confirm Pause'}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                    )),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Handle cancel action
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
