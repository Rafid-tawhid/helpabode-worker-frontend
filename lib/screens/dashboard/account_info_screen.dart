import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/user_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/rating/rating_review_details.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/completed_order/completed_service.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/open_order_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/profile/edit_user_address.dart';
import 'package:provider/provider.dart';

import '../../corporate/individual_team/my_team_member_list.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../widgets_reuse/bottom_nav_bar.dart';
import '../../widgets_reuse/in_app_webview.dart';
import '../earning/tips_rewards_screen.dart';
import '../open_order/rejected_order_list.dart';
import '../profile/accounting_screen.dart';
import 'notification_menu_screen.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = 'account';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel user = UserModel();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  String _title = '';
  late UserProvider provider;

  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double scrollOffset = _scrollController.offset;
      double maxScrollExtent = _scrollController.position.maxScrollExtent;

      if (scrollOffset > maxScrollExtent * 0.2) {
        setState(() {
          _title = 'Account';
        });
      } else {
        setState(() {
          _title = '';
        });
      }
    });

    debugPrint('_title $_title ');
    getProfiileImage();
  }

  Future<void> getProfiileImage() async {
    await Provider.of<UserProvider>(context, listen: false).getProfileImage();
    await provider.getUserFromProvider();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);
    user = provider.userModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          _title,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Account',
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.only(left: 28, top: 16, bottom: 16),
              decoration: BoxDecoration(color: myColors.greyBg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<UserProvider>(builder: (context, pro, _) {
                        return Hero(
                          tag: 'account',
                          child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(100),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: '${pro.userImageUrl}',
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder:
                                    (BuildContext context, String url) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    color: myColors.green,
                                    alignment: Alignment.center,
                                    child: Text(
                                      DashboardHelpers
                                          .getFirstCharacterCombinationName(
                                              pro.userModel.firstName ?? '',
                                              pro.userModel.lastName ?? ''),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  );
                                },
                                errorWidget: (BuildContext context, String url,
                                    dynamic error) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    color: myColors.green,
                                    alignment: Alignment.center,
                                    child: Text(
                                      DashboardHelpers
                                          .getFirstCharacterCombinationName(
                                              pro.userModel.firstName ?? '',
                                              pro.userModel.lastName ?? ''),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 28,
                      ),
                      Consumer<UserProvider>(
                        builder: (context, pro, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '${provider.userModel.firstName ?? 'Jon'} ${provider.userModel.lastName ?? 'doe'}',
                              style: profileText,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/business_center.svg'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: FittedBox(
                                    child: AutoSizeText(
                                      provider.userModel.employeeType ?? 'mail',
                                      style: profileEmail,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            InkWell(
                              onTap: () async {
                                // context.pushNamed('profile_edit');
                                var rating = await DashboardHelpers.getString('average_rating');
                                debugPrint(rating);
                                if (rating == 'Warning') {
                                  showLowRatingBottomSheet(context);
                                } else {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        RatingReviewDetailsScreen(subTitle: ''),
                                  ));
                                }

                                // Navigator.push(context, CupertinoPageRoute(builder: (context) => EditProfileScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: rating == 'Warning'
                                      ? Color(0xffFF9525)
                                      : myColors.primaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      rating == 'Warning'
                                          ? Icons.warning
                                          : Icons.star,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    FutureBuilder<String>(
                                      future: DashboardHelpers.getString(
                                          'average_rating'),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          // If an error occurs, display an error message
                                          return Text(
                                            'Error: ${snapshot.error}',
                                            style: editProfile,
                                          );
                                        } else if (snapshot.hasData) {
                                          // Process the data when available
                                          final rating = snapshot.data;
                                          return Text(
                                            rating ?? 'N/A',
                                            style: editProfile,
                                          );
                                        } else {
                                          // If no data and no error, display a fallback
                                          return Text(
                                            'N/A',
                                            style: editProfile,
                                          );
                                        }
                                      },
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AccountInfoListTile(
                    title: 'Open Order',
                    leading: 'images/Receipt.svg',
                    trailing: '',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                const RequestedServiceScreen()),
                      );
                    }),
                AccountInfoListTile(
                    title: 'Completed Order',
                    leading: 'assets/svg/tik.svg',
                    trailing: '',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CompletedServices()),
                      );
                    }),
                AccountInfoListTile(
                    title: 'Rejected Order',
                    leading: 'assets/svg/cancel.svg',
                    trailing: '',
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RejectedOrderList()));
                    }),
                AccountInfoListTile(
                    title: 'Accounting',
                    leading: 'assets/svg/profit.svg',
                    trailing: '',
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AccountingScreen()));
                    }),
                AccountInfoListTile(
                    title: 'Tips / Rewards',
                    leading: 'assets/svg/tip.svg',
                    trailing: '',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const TipsAndRewards()),
                      );
                    }),
                if (provider.userModel.employeeType !=
                        UserHelpers.empTypeCorporateMember ||
                    provider.userModel.employeeType !=
                        UserHelpers.empTypeUnderProvider)
                  AccountInfoListTile(
                      title: 'My Teams',
                      leading: 'images/Users.svg',
                      trailing: '',
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MyTeamMemberList()),
                        );
                      }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 10,
                  color: const Color(0xffF6F6F6),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Account Settings',
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                AccountInfoListTileWithSub(
                    title: 'Manage Account',
                    leading: 'assets/svg/acc.svg',
                    trailing: '',
                    subTitle: 'Update your information and manage account',
                    onTap: () {
                      context.pushNamed('profile_edit');
                    }),
                AccountInfoListTileWithSub(
                    title: 'Payment',
                    leading: 'assets/svg/Payment.svg',
                    trailing: '',
                    subTitle: 'Manage your payment methods.',
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AccountingScreen(
                                    title: 'Payment Screen',
                                  )));
                    }),
                AccountInfoListTileWithSub(
                    title: 'Address',
                    leading: 'assets/svg/address.svg',
                    trailing: '',
                    subTitle: 'Add or remove an address.',
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditUserAddress()));
                    }),
                // AccountInfoListTileWithSub(
                //     title: 'Privacy',
                //     leading: 'assets/svg/privacy.svg',
                //     trailing: '',
                //     subTitle: 'Learn about privacy and manage your settings.',
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           CupertinoPageRoute(
                //               builder: (context) => WebViewExample(
                //                     conditionsUrl: 'https://helpabode.com/privacy-policy.html',
                //                     title: 'Privacy & Policies',
                //                   )));
                //     }),
                AccountInfoListTileWithSub(
                    title: 'Notifications',
                    leading: 'assets/svg/notifications.svg',
                    trailing: '',
                    showDevider: false,
                    subTitle:
                        'Manage your delivery and promotional notifications.',
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  const NotificationMenuScreent()));
                    }),
                // AccountInfoListTileWithSub(
                //   title: 'Logout',
                //   leading: 'images/log-out.svg',
                //   trailing: '',
                //   showDevider: false,
                //   subTitle: 'subTitle',
                //   onTap: () async {
                //     SignInSignUpHelpers sp = SignInSignUpHelpers();
                //     sp.remove('user');
                //     sp.remove('textId');
                //     sp.remove('address');
                //     sp.remove('status');
                //     sp.remove('token');
                //     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LauncherScreen()));
                //   },
                // ),
                Container(
                  height: 10,
                  color: const Color(0xffF6F6F6),
                ),

                if (employeeType == 'Corporate') ShowOptionsForCorporate(),

                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'More',
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => WebViewExample(
                                    conditionsUrl:
                                        'https://helpabode.com/terms-and-conditions.html',
                                    title: 'Terms & Conditions',
                                  )));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Terms & Conditions',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            )
                          ],
                        ),
                        const Divider(
                          height: .3,
                          color: myColors.primaryStroke,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      // DashboardHelpers.openUrl('https://helpabode.com/privacy-policy.html');
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => WebViewExample(
                                    conditionsUrl:
                                        'https://helpabode.com/privacy-policy.html',
                                    title: 'Privacy & Policy',
                                  )));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Privacy Policy',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            )
                          ],
                        ),
                        const Divider(
                          height: .3,
                          color: myColors.primaryStroke,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  void showLowRatingBottomSheet(BuildContext context) {
    var up = context.read<UserProvider>();
    if (up.ratingWarningDocList.isEmpty) {
      up.getRatingWarningDocInfo();
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<UserProvider>(
            builder: (context, provider, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close)),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.warning, color: Colors.red, size: 28)),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Your account is at risk due to low ratings.",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                    "Some of your ratings are below 4.0, which may affect your account visibility.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text('${up.ratingWarningDocList.first.title}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...up.ratingWarningDocList.first.reason!
                              .map((e) => _buildListItem(e.title ?? '')),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.lightbulb,
                                  color: Colors.yellow[700], size: 24),
                              const SizedBox(width: 8),
                              Text(
                                '${up.ratingWarningDocList.last.title}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...up.ratingWarningDocList.last.reason!
                              .map((e) => _buildListItem(e.title ?? '')),
                        ],
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Learn How to Improve",
                          style: interText(12, myColors.green, FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myColors.green,
                        ),
                        child: Text(
                          "View Excluded Ratings",
                          style: interText(12, Colors.white, FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.remove_circle_outline, color: Colors.grey[700], size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_box, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class ShowOptionsForCorporate extends StatelessWidget {
  const ShowOptionsForCorporate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Business Settings',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //         builder: (context) => WebViewExample(
              //           conditionsUrl: 'https://helpabode.com/terms-and-conditions.html',
              //           title: 'Business Information',
              //         )));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Business Information',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    )
                  ],
                ),
                const Divider(
                  height: .3,
                  color: myColors.primaryStroke,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //         builder: (context) => WebViewExample(
              //           conditionsUrl: 'https://helpabode.com/terms-and-conditions.html',
              //           title: 'Business Information',
              //         )));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Documentation',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    )
                  ],
                ),
                const Divider(
                  height: .3,
                  color: myColors.primaryStroke,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //         builder: (context) => WebViewExample(
              //           conditionsUrl: 'https://helpabode.com/terms-and-conditions.html',
              //           title: 'Business Information',
              //         )));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sales Tax',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 10,
          color: const Color(0xffF6F6F6),
        ),
      ],
    );
  }
}

class AccountInfoListTileWithSub extends StatelessWidget {
  String title;
  String leading;
  String trailing;
  String subTitle;
  final VoidCallback onTap;
  bool showDevider;

  AccountInfoListTileWithSub(
      {required this.title,
      required this.leading,
      required this.trailing,
      required this.subTitle,
      required this.onTap,
      this.showDevider = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  leading,
                  color: Colors.black,
                  height: 22,
                  width: 22,
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          subTitle,
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: const Color(0xff535151),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                )
              ],
            ),
            if (showDevider)
              const Divider(
                height: .3,
                color: myColors.primaryStroke,
              )
          ],
        ),
      ),
    );
  }
}

class AccountInfoListTile extends StatelessWidget {
  String title;
  String leading;
  String trailing;
  final VoidCallback onTap;
  bool showDevider;

  AccountInfoListTile(
      {required this.title,
      required this.leading,
      required this.trailing,
      required this.onTap,
      this.showDevider = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  leading,
                  color: Colors.black,
                  height: 22,
                  width: 22,
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                )
              ],
            ),
            if (showDevider)
              const Divider(
                height: .3,
                color: myColors.primaryStroke,
              )
          ],
        ),
      ),
    );
  }
}
