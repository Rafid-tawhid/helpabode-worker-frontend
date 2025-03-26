import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/rating/views/progressbar.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/rating/views/vertical_listview.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';

class RatingReviewDetailsScreen extends StatefulWidget {
  final String subTitle;

  RatingReviewDetailsScreen({required this.subTitle});

  @override
  State<RatingReviewDetailsScreen> createState() =>
      _RatingReviewDetailsScreenState();
}

class _RatingReviewDetailsScreenState extends State<RatingReviewDetailsScreen> {
  List<String> dropdownList = [
    'All reviews',
    'High to Low',
    'Low to High',
  ];
  bool sortHighToLow = true;

  String selectedItem = 'All reviews';
  dynamic selectedService;

  @override
  void initState() {
    getRatingReviewDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Customer Ratings',
              style: interText(16, Colors.black, FontWeight.w600),
            ),
            Text(
              widget.subTitle,
              style: interText(12, Colors.black, FontWeight.w400),
            ),
          ],
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) => provider.ratingServiceArray.isEmpty
            ? Center(
                child: Text('No Review Rating Found.'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          color: myColors.devider,
                          height: 1,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Consumer<UserProvider>(
                            builder: (context, pro, _) =>
                                HorizontalSelectionList(
                              items: pro.ratingServiceArray,
                              unselectedColor: Colors.grey.shade300,
                              onSelected: (value) {
                                setState(() {
                                  selectedService = value;
                                });
                                if (selectedService['serviceTitle'] !=
                                    'All Service') {
                                  //get review for individual service
                                  pro.getReviewAccordingToService(
                                      selectedService);
                                } else {
                                  getRatingReviewDetails();
                                }
                              },
                            ),
                          ),
                        ),

                        // Container(
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: myColors.devider, width: 1),
                        //       borderRadius: BorderRadius.circular(8)),
                        //   child: DropdownButton2<String>(
                        //     value: dropdownItem,
                        //     hint: Text(
                        //       'Select an option',
                        //       style: TextStyle(color: Colors.grey),
                        //     ),
                        //     isExpanded: true,
                        //     underline:
                        //         SizedBox.shrink(), // Removes the default underline
                        //     dropdownStyleData: DropdownStyleData(
                        //         decoration: BoxDecoration(color: Colors.white)),
                        //     items: dropdownList.map((String item) {
                        //       return DropdownMenuItem<String>(
                        //         value: item,
                        //         child: Text(item),
                        //       );
                        //     }).toList(),
                        //     onChanged: (String? newValue) {
                        //       setState(() {
                        //         dropdownItem = newValue;
                        //       });
                        //     },
                        //   ),
                        // ),
                        RatingInfo(),

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: RatingSection(context),
                        ),

                      if(provider.ratingDetailsModel!.ratingCountBelowFour!=0)  Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, bottom: 8, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${provider.ratingDetailsModel!.ratingCountBelowFour} Ratings excluded ',
                                    style: interText(
                                        14, Colors.black, FontWeight.w600),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        showExcludedRatingsBottomSheet(context);
                                      },
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 20,
                                      ))
                                ],
                              ),
                              Text(
                                'Last updated ${DashboardHelpers.convertDateTime(provider.ratingDetailsModel!.ratingLastUpdateDate??'',pattern: 'dd/MM/yyyy')}',
                                style: interText(
                                    14, Colors.grey.shade600, FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Consumer<UserProvider>(
                                builder: (context, provider, _) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: myColors.greyTxt, width: .5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Likes'),
                                        if (provider.ratingDetailsModel != null)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${provider.ratingDetailsModel!.totalLike}',
                                                style: interText(
                                                    22,
                                                    Colors.black,
                                                    FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0, left: 4),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.thumb_up,
                                                      size: 20,
                                                      color: myColors.green,
                                                    ),
                                                    Text(
                                                        ' (${provider.ratingDetailsModel!.totalLike!.toInt().ceil()})')
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Consumer<UserProvider>(
                                      builder: (context, pro, _) => Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: myColors.greyTxt,
                                                    width: .5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Dislikes'),
                                                  if (pro.ratingDetailsModel !=
                                                      null)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${pro.ratingDetailsModel!.serviceDislike}',
                                                          style: interText(
                                                              22,
                                                              Colors.black,
                                                              FontWeight.bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 2.0,
                                                                  left: 4),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .thumb_down,
                                                                size: 20,
                                                                color: myColors
                                                                    .greyTxt,
                                                              ),
                                                              Text(
                                                                  ' (${pro.ratingDetailsModel!.totalLike!.toInt().ceil()})')
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ),
                                          ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                'Customer Compliments',
                                style: interText(
                                    18, Colors.black, FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200),
                                  child: SvgPicture.asset(
                                      'assets/svg/review_img.svg')),
                              title: Text(
                                'Above and Beyond',
                                style: interText(
                                    16, Colors.black, FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Number of times customers thought you went ‘Above and Beyond’.',
                                style: interText(
                                    14, myColors.greyTxt, FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 16, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Reviews From Customers',
                                        style: interText(
                                            16, Colors.black, FontWeight.w600),
                                      ),
                                      DropdownButton<String>(
                                        value: selectedItem,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 22),
                                        style: interText(
                                            16, Colors.black, FontWeight.w500),
                                        underline: Container(height: 0),
                                        // Removes the underline
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedItem = newValue!;
                                            if (selectedItem == 'High to Low') {
                                              sortHighToLow = true;
                                            } else {
                                              sortHighToLow = false;
                                            }
                                          });
                                        },
                                        items: dropdownList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: interText(12, Colors.black,
                                                  FontWeight.w400),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer<UserProvider>(
                                    builder: (context, provider, _) =>
                                        ReviewListView(reviews: [
                                          ...(sortHighToLow
                                                  ? provider.listOfUserReviews
                                                      .reversed // Reverse the list if true
                                                  : provider
                                                      .listOfUserReviews) // Original order if false
                                              .map((e) => Review(
                                                    reviewerName: e.userName ??
                                                        "John Doe",
                                                    rating: e.rating ?? '4.5',
                                                    reviewText: e
                                                            .ratingContent ??
                                                        "Great service, highly recommended!",
                                                    time: DateTime.now(),
                                                    profilePicture:
                                                        "https://randomuser.me/api/portraits/men/1.jpg",
                                                  ))
                                              .toList(),
                                        ]))
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void getRatingReviewDetails() async {
    var up = context.read<UserProvider>();
    up.getRatingDetailsInfo();
  }

  void showExcludedRatingsBottomSheet(BuildContext context) {
    var up = context.read<UserProvider>();
    if (up.excludeList.isEmpty) {
      up.getExcludingRatingInfo();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Consumer<UserProvider>(
              builder: (context, pro, _) => Column(
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
                      const SizedBox(height: 12),
                      const Text(
                        "Excluded Ratings",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "To ensure your rating accurately reflects your service quality, "
                        "we exclude ratings affected by factors beyond your control. "
                        "Here’s what we consider:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      pro.isLoading
                          ? Container(
                              height: 200,
                              width: MediaQuery.sizeOf(context).width,
                              child: Center(child: CircularProgressIndicator()))
                          : Column(
                              children: pro.excludeList
                                  .map((e) => _buildExcludedItem(e))
                                  .toList(),
                            ),
                      const SizedBox(height: 8),
                      if (pro.excludeOrderList.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  initialChildSize: 0.6, // 60% of screen height
                                  minChildSize: 0.4,
                                  maxChildSize: 0.9,
                                  builder: (context, scrollController) {
                                    return Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 50,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text("Excluded Orders",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: ListView.builder(
                                              controller:
                                                  scrollController, // Enables smooth scrolling
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              itemCount:
                                                  pro.excludeOrderList.length,
                                              itemBuilder: (context, index) {
                                                final order =
                                                    pro.excludeOrderList[index];
                                                return Card(
                                                  color: Colors.white,
                                                  elevation: 4,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child:
                                                                  Image.network(
                                                                order.userImage ??
                                                                    '',
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    Icon(
                                                                        Icons
                                                                            .account_circle,
                                                                        size:
                                                                            50,
                                                                        color: Colors
                                                                            .grey),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      order.userName ??
                                                                          '',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      "Order ID: ${order.orderTextId}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey[700])),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children:
                                                                  List.generate(
                                                                      5,
                                                                      (starIndex) {
                                                                return Icon(
                                                                  starIndex <
                                                                          (order.rateForWorkerByEndUser ??
                                                                              0)
                                                                      ? Icons
                                                                          .star
                                                                      : Icons
                                                                          .star_border,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 20,
                                                                );
                                                              }),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                            "Amount: \$${order.amount}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                        Text(
                                                            "Placed: ${order.orderPlaceTime}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                        Text(
                                                            "Scheduled: ${order.scheduledDate}, ${order.scheduledStartTime} - ${order.scheduleEndtime}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .blue)),
                                                        if (order
                                                                .commentForWorkerByEndUser !=
                                                            null)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: Text(
                                                                "Comment: ${order.commentForWorkerByEndUser}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic)),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }, // Add your action
                          child: const Text(
                            "View Excluded Ratings",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("Close",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )),
        );
      },
    );
  }

  Widget _buildExcludedItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.do_not_disturb, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingInfo extends StatelessWidget {
  const RatingInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, pro, _) => Column(
        children: [
          SizedBox(
            height: 20,
          ),
          if (pro.ratingDetailsModel != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${double.parse(pro.ratingDetailsModel!.avgRating.toString()).toStringAsFixed(2)}',
                  style: interText(22, Colors.black, FontWeight.bold),
                ),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pro.ratingDetailsModel != null)
                Text(
                  'Based on ${pro.ratingDetailsModel!.ratingCount} reviews',
                  style: interText(14, myColors.greyTxt, FontWeight.w400),
                )
            ],
          ),
          Text('Minimum 4.7 rating required for Top Performance',
              style: interText(12, myColors.greyTxt, FontWeight.w400)),
        ],
      ),
    );
  }
}

class Review {
  final String reviewerName;
  final String rating;
  final String reviewText;
  final DateTime time;
  final String? profilePicture;

  Review({
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    required this.time,
    this.profilePicture,
  });
}

class ReviewListView extends StatelessWidget {
  final List<Review> reviews;

  ReviewListView({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Column(
          children: [
            ReviewCard(
                userName: review.reviewerName,
                reviewText: review.reviewText,
                reviewDate: DateTime(2023, 2, 28),
                rating: double.parse(review.rating).toInt()),
            Container(
              height: 2,
              color: myColors.divider,
            )
          ],
        );
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String userName;
  final String reviewText;
  final DateTime reviewDate;
  final int rating; // Out of 5

  const ReviewCard({
    Key? key,
    required this.userName,
    required this.reviewText,
    required this.reviewDate,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStarRating(rating),
            const SizedBox(height: 6),
            Text(
              reviewText,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              '$userName • ${DashboardHelpers.convertDateTime(reviewDate.toString(), pattern: 'MMMM d, y')}',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.orange,
          size: 18,
        );
      }),
    );
  }
}
