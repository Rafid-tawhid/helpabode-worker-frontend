import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/corporate/individual_team/widgets/order_tab_card.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/dotted_line.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../models/corporate_team_member_model.dart';
import '../provider/order_provider.dart';
import '../widgets_reuse/circular_image_with_shimmer.dart';
import '../widgets_reuse/free_call_bottom_sheet.dart';
import 'views/corporate_schedule.dart';

class VerifiedMemberDetails extends StatefulWidget {
  final TeamMemberModel? member;

  VerifiedMemberDetails({this.member});

  @override
  State<VerifiedMemberDetails> createState() => _VerifiedMemberDetailsState();
}

class _VerifiedMemberDetailsState extends State<VerifiedMemberDetails> {
  int selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((val) {
      //getMemberFullDetails(widget.member);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<CorporateProvider>(
            builder: (context, pro, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomAppBar(label: ''),
                    TopProfileSection(widget.member),
                    Expanded(
                      child: UserHelpers.empType ==
                              UserHelpers.empTypeIndividualProvider
                          ? GeneralInformation()
                          : Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Consumer<OrderProvider>(
                                builder: (context, provider, _) =>
                                    ContainedTabBarView(
                                  initialIndex: provider.orderIndex,
                                  tabBarProperties: TabBarProperties(
                                    // Makes the TabBar scrollable horizontally
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                        width: 4.0,
                                        color: myColors.green,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      insets: const EdgeInsets.symmetric(
                                        horizontal: 0.0,
                                      ),
                                    ),
                                    labelColor: myColors.green,
                                    indicatorColor: myColors.green,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                  ),
                                  tabs: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'General',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Orders(${pro.teamMemberOrderList.length})',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Services',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    // Add additional tabs here
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Schedule',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                  views: [
                                    GeneralInformation(),
                                    OrdersList(),
                                    InterestServiceWidget(),
                                    ScheduleViewer(
                                      schedules:
                                          pro.corporateMemberScheduleList,
                                    ),
                                  ],
                                  onChange: (index) => print(index),
                                ),
                              ),
                            ),
                    ),
                    ContactButtons(
                      member: widget.member!,
                    )
                  ],
                )),
      ),
    );
  }

// void getMemberFullDetails(AddIndividualUserModel? member) async {
//   var cp = context.read<CorporateProvider>();
//   await cp.setIsLoading(true);
//   await cp.getMemberDetailsData(member!);
//   await cp.setIsLoading(false);
// }
}

class ContactButtons extends StatelessWidget {
  TeamMemberModel member;

  ContactButtons({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0x0C000000),
          blurRadius: 8,
          offset: Offset(0, -4),
          spreadRadius: 0,
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Message Button
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: myColors.greyBtn,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message,
                    size: 20,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Message',
                    style: interText(14, Colors.black, FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: myColors.greyBtn,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email,
                    size: 20,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Email',
                    style: interText(14, Colors.black, FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: myColors.green,
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CallSupportScreen(
                      model: member,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.call,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Call',
                      style: interText(14, Colors.white, FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Email Button
        ],
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CorporateProvider>(
        builder: (context, pro, _) => SingleChildScrollView(
              child: pro.teamMemberOrderList.isEmpty
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('No Order Found'),
                    ))
                  : Column(
                      children: pro.teamMemberOrderList
                          .map((e) => OrderCard2(
                                order: e,
                              ))
                          .toList(),
                    ),
            ));
  }
}

class GeneralInformation extends StatelessWidget {
  const GeneralInformation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: myColors.greyBg),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            ContactInfoCard(),
            SizedBox(height: 10),
            PersonalDetailsCard(),
            SizedBox(
              height: 10,
            ),
            DocumentInfoSection(),
            SizedBox(
              height: 10,
            ),
            ActivityOverview(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class PersonalDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<CorporateProvider>(
        builder: (context, pro, _) => Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.1),
              //   blurRadius: 5,
              //   spreadRadius: 1,
              // ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: interText(16, Colors.black, FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Role',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '${pro.singleMemberInfo!.employeeType}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Joined Date',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '${DashboardHelpers.convertDateTime2(pro.singleMemberInfo!.created)}',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last Updated',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '${DashboardHelpers.convertDateTime2(pro.singleMemberInfo!.updated)}',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<CorporateProvider>(
        builder: (context, pro, _) => Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.1),
              //   blurRadius: 5,
              //   spreadRadius: 1,
              // ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: interText(16, Colors.black, FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.phone,
                          color: Colors.black54,
                          size: 20,
                        ),
                      )),
                  SizedBox(width: 10),
                  Text(
                    '${pro.singleMemberInfo!.phone}',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.email,
                          color: Colors.black54,
                          size: 20,
                        ),
                      )),
                  SizedBox(width: 10),
                  Text(
                    '${pro.singleMemberInfo!.email}',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black54,
                          size: 20,
                        ),
                      )),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${pro.teamMemberDetails!.profileData!.address!.first.addressLine1Data},${pro.teamMemberDetails!.profileData!.countryName}',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
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
}

class DocumentInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.1),
                //   blurRadius: 5,
                //   spreadRadius: 1,
                // ),
              ],
            ),
            child: Consumer<CorporateProvider>(
              builder: (context, pro, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  DocumentCard(
                    title: "${pro.singleMemberInfo!.photoIdType}",
                    id: "${pro.singleMemberInfo!.photoIdNo}",
                    info: "${pro.singleMemberInfo!.photoIdExpirationDate}",
                    status: "Valid",
                    statusColor: Colors.green,
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'SSS: ',
                              style: interText(
                                  14, Colors.black87, FontWeight.w500),
                            ),
                            Text(
                              '${pro.singleMemberInfo!.ssn}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: pro.singleMemberInfo!.status == 'Verified'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.amber,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${pro.singleMemberInfo!.status}',
                          style: TextStyle(
                            color: pro.singleMemberInfo!.status == 'Verified'
                                ? Colors.green
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text('Background Check',
                                style: interText(
                                    14, Colors.black87, FontWeight.w400)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Complete',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // DocumentCard(
                  //   title: "Work Permit",
                  //   id: "XXXX5319",
                  //   info: "Submitted: Mar 20, 2024",
                  //   status: "Pending",
                  //   statusColor: Colors.orange,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DocumentCard extends StatelessWidget {
  final String title;
  final String id;
  final String info;
  final String status;
  final Color statusColor;

  const DocumentCard({
    required this.title,
    required this.id,
    required this.info,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: interText(14, Colors.black, FontWeight.w500)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text('ID: $id',
                style: interText(14, Colors.black, FontWeight.w500)),
            SizedBox(height: 4),
            Text('Expires: $info.',
                style: interText(14, Colors.black, FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class ActivityOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<CorporateProvider>(
        builder: (context, pro, _) => Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activity Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                        "Monthly Earnings",
                        "${pro.teamMemberDetails!.totalEarned}",
                        Icons.attach_money),
                    _buildStatCard(
                        "Orders Completed",
                        "${pro.teamMemberDetails!.totalOrders}",
                        Icons.shopping_cart),
                    _buildStatCard(
                        "Total Hours",
                        "${pro.teamMemberDetails!.totalHours}",
                        Icons.access_time),
                    _buildStatCard("Average Ratings",
                        "${pro.teamMemberDetails!.averageRating}", Icons.star,
                        isRating: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      {bool isRating = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              if (isRating) ...[
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.star, color: Colors.amber, size: 18),
              ] else ...[
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class InterestServiceWidget extends StatelessWidget {
  const InterestServiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DottedLine(
              dotSpacing: 3,
              dotWidth: 3,
              dotHeight: 1,
              dotColor: Colors.grey.shade300,
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<CorporateProvider>(
                  builder: (context, pro, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Text(
                          'Interests(${pro.teamMemberDetails!.workerServiceArray!.length})',
                          style: interText(16, Colors.black, FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        children: pro.teamMemberDetails!.workerServiceArray!
                            .map((user) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomCircleShimmerImage(
                                            imageUrl:
                                                '$urlBase${user.serviceImage}', // Replace with your actual image URL
                                            placeholder:
                                                'assets/png/person2.png',
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            user.serviceTitle ?? '',
                                            style: interText(14, Colors.black,
                                                FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: myColors.divider,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopProfileSection extends StatelessWidget {
  final TeamMemberModel? member;

  TopProfileSection(this.member);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Header
        Consumer<CorporateProvider>(
          builder: (context, pro, _) => Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                debugPrint('${urlBase}${member!.profileImage}');
                              },
                              child: CustomCircleShimmerImage(
                                  imageUrl: '${urlBase}${member!.profileImage}',
                                  size: 80,
                                  placeholder: 'assets/png/person2.png'),
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 4)),
                        ),
                        Positioned(
                          right: 24,
                          bottom: 0,
                          child: Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: myColors.green,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Profile Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                member == null
                                    ? 'Drake Danvers'
                                    : '${member!.firstName} ${member!.lastName}' ??
                                        '',
                                style: interText(
                                    22, Colors.black, FontWeight.w700),
                              ),
                              SizedBox(width: 12),
                              if (member!.status == 'Verified')
                                Icon(Icons.verified,
                                    color: myColors.green, size: 20),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                      'Member Since ${pro.teamMemberDetails!.profileData!.durationSinceCreated}',
                                      style: interText(
                                          14, myColors.grey, FontWeight.w400))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Available Tag
                          Container(
                            width: 114,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                    width: 1, color: myColors.green)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                Image.asset('assets/png/active.png',
                                    height: 12),
                                SizedBox(width: 4),
                                Text('Available Now',
                                    style: interText(
                                        10, myColors.green, FontWeight.w500)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
