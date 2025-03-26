import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/support/dashboard_support_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/rating/rating_review_details.dart';
import 'package:provider/provider.dart';

import '../../../widgets_reuse/bottom_nav_bar.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var up = context.read<UserProvider>();
    up.getRatingInfo();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Ratings',
          style: interText(16, Colors.black, FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardSupportScreen()));
                },
                icon: Icon(
                  Icons.help_outline_outlined,
                  size: 24,
                )),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 1,
              color: myColors.devider,
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, up, _) => ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                  itemCount: up.ratingScreenModelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        _buildRatingItem(context,
                            percent:
                                '${up.ratingScreenModelList[index].isPercent}',
                            metric:
                                '${up.ratingScreenModelList[index].averageRating}',
                            title: '${up.ratingScreenModelList[index].title}',
                            subtitle:
                                '${up.ratingScreenModelList[index].subTitle}',
                            status: '${up.ratingScreenModelList[index].status}',
                            index: index),
                        Container(
                          height: 1,
                          color: myColors.devider,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  Widget _buildRatingItem(
    BuildContext context, {
    required String metric,
    required String title,
    required String subtitle,
    required String status,
    required String percent,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              RatingReviewDetailsScreen(subTitle: subtitle)));
                } else {
                  // DashboardHelpers.showAlert(msg: 'Nothing to show');
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${double.parse(metric).toStringAsFixed(2)}${percent == 'Yes' ? '%' : ''}',
                    style: interText(
                      30,
                      status == 'positive' ? myColors.green : Colors.red,
                      FontWeight.bold,
                    ).copyWith(letterSpacing: 0),
                  ),
                  Text(
                    title,
                    style: interText(16, Colors.black, FontWeight.w600)
                        .copyWith(letterSpacing: 0),
                  ),
                  Text(
                    subtitle,
                    style: interText(14, myColors.greyTxt, FontWeight.w500)
                        .copyWith(letterSpacing: 0),
                  ),
                ],
              ),
            ),
          ),
          if (index == 0)
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: myColors.greyTxt,
            ),
        ],
      ),
    );
  }
}
