import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/team_member_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/colors.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../misc/constants.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../screens/dashboard/notification_menu_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/edit_user_address.dart';
import '../../widgets_reuse/in_app_webview.dart';

class MemberAccountScreen extends StatefulWidget {
  static const String routeName = 'accountMember';

  const MemberAccountScreen({Key? key}) : super(key: key);

  @override
  State<MemberAccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<MemberAccountScreen> {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
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
                        builder: (context, provider, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '${provider.userModel.firstName ?? 'Jon'} ${provider.userModel.lastName ?? 'doe'}',
                              style: profileText,
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              child: AutoSizeText(
                                provider.userModel.email ?? 'mail',
                                style: profileEmail,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            InkWell(
                              onTap: () {
                                // context.pushNamed('profile_edit');
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      EditProfileScreen(),
                                ));

                                // Navigator.push(context, CupertinoPageRoute(builder: (context) => EditProfileScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: myColors.primaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  'Edit Profile',
                                  style: editProfile,
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
                    onTap: () {}),
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
                AccountInfoListTileWithSub(
                    title: 'Notifications',
                    leading: 'assets/svg/notifications.svg',
                    trailing: '',
                    subTitle:
                        'Manage your delivery and promotional notifications.',
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  const NotificationMenuScreent()));
                    }),
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
      bottomNavigationBar: const MyBottomNavBarTeam(),
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
