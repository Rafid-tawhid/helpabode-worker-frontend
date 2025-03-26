import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/dashboard_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/support/help_center_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/support/sefety_resources_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/support/support_chat_screen.dart';
import 'package:provider/provider.dart';
import '../../helper_functions/colors.dart';
import '../../provider/user_provider.dart';
import '../../widgets_reuse/free_call_bottom_sheet.dart';
import '../open_order/widgets/before_after_image_confirmation_end_order.dart';
import '../shift/new_schedule_screen.dart';

class DashboardSupportScreen extends StatefulWidget {
  DashboardSupportScreen({super.key});

  @override
  State<DashboardSupportScreen> createState() => _DashboardSupportScreenState();
}

class _DashboardSupportScreenState extends State<DashboardSupportScreen> {
  final List<Map<String, String>> items = [
    {'assetPath': 'assets/svg/ordering.svg', 'title': 'Ordering'},
    {'assetPath': 'assets/svg/schedule.svg', 'title': 'Schedule'},
    {'assetPath': 'assets/svg/account_outline.svg', 'title': 'Account'},
    {'assetPath': 'assets/svg/ratings.svg', 'title': 'Rating'},
    {'assetPath': 'assets/svg/earnings.svg', 'title': 'Earnings'},
  ];
  int tapped = 0;
  bool showRes = true;
  bool showSnippet = true;
  String _title = 'Earnings';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((val) {
      var provider = Provider.of<DashboardProvider>(context, listen: false);
      provider.changeListWhenTappedItem(
          provider.faqListName.first.faqType ?? 'Earnings');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<DashboardProvider>(
          builder: (context, provider, _) => ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              SizedBox(height: 16),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                        Icon(Icons.close, size: 28, color: Color(0xff000000))),
              ),
              SizedBox(height: 20),
              Consumer<UserProvider>(
                builder: (context, provider, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${DashboardHelpers.userModel!.firstName}',
                      style: interText(16, Colors.black, FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'How can we help?',
                      style: interText(24, Colors.black, FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Ask a question or search support...',
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff535151)),
                  filled: true,
                  fillColor: Color(0xffE9E9E9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.faqListName.length,
                  itemBuilder: (context, index) {
                    var item = provider.faqListName[index];
                    return Consumer<DashboardProvider>(
                      builder: (context, provider, _) => GestureDetector(
                        onTap: () {
                          setState(() {
                            tapped = index;
                            _title = item.faqType ?? '';
                          });
                          //change list
                          provider.changeListWhenTappedItem(item.faqType ?? '');
                        },
                        child: buildItem(items[index]['assetPath'] ?? '',
                            item.faqType ?? '', index),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Text(
                '${_title} related issues',
                style: interText(20, Colors.black, FontWeight.w600),
              ),
              SizedBox(height: 6),
              Divider(color: myColors.devider, thickness: 2),
              Consumer<DashboardProvider>(
                builder: (context, provider, _) => ListView.builder(
                    itemCount: provider.faqQuestionsList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = provider.faqQuestionsList[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              provider.setOnTapped(data.clickedId ?? '');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        data.question ?? '',
                                        style: interText(
                                            16, Colors.black, FontWeight.w500),
                                      ),
                                    ),
                                    data.clicked
                                        ? Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 22,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 22,
                                          )
                                  ],
                                ),
                                if (data.clicked) Html(data: data.answer)
                              ],
                            ),
                          ),
                          Divider(color: myColors.devider, thickness: 1),
                        ],
                      );
                    }),
              ),
              SizedBox(height: 16),
              if (showSnippet)
                Container(
                  height: 78,
                  padding: EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: Color(0xFFE9E9E9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Snippets summarize information into key insights',
                          style: interText(14, Colors.black, FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showSnippet = false;
                          });
                        },
                        icon: Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                ),
              if (showSnippet) SizedBox(height: 16),
              if (showSnippet)
                Text(
                  'Related snippets (5)',
                  style: interText(18, Colors.black, FontWeight.w600),
                ),
              if (showSnippet)
                SizedBox(
                  height: 170,
                  child: Consumer<DashboardProvider>(
                    builder: (context, provider, _) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.snippetList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          right: (index == provider.snippetList.length - 1)
                              ? 0
                              : 8, // Conditional right padding
                          top: 8,
                        ),
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 12, bottom: 0),
                          decoration: ShapeDecoration(
                            color: Color(0xFFE9E9E9),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset('assets/svg/idea.svg'),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                provider.snippetList[index]['title'],
                                style: interText(
                                    12, Color(0xFF535151), FontWeight.w500),
                              ),
                              SizedBox(height: 4),
                              Text(
                                provider.snippetList[index]['subTitle'],
                                style: interText(
                                    14, Colors.black, FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>BeforeAfterImageAndEndOrder()));
                },
                child: Text(
                  'Still need help?',
                  style: interText(18, Colors.black, FontWeight.w600),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Additional resources',
                    style: interText(18, Colors.black, FontWeight.w400),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showRes = !showRes;
                      });
                    },
                    icon: Icon(
                      showRes
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      size: 28,
                    ),
                  ),
                ],
              ),
              Divider(color: Color(0xffe9e9e9)),
              if (showRes)
                Column(
                  children: [
                    buildListTile(
                      icon: Icons.message,
                      title: 'Chat with support',
                      subtitle: 'Need more help? Chat with us.',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SupportChatScreen()));
                      },
                    ),
                    Divider(color: Color(0xffe9e9e9)),
                    buildListTile(
                      icon: Icons.call,
                      title: 'Call support',
                      subtitle: 'Prefer to talk? Call us.',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => CallSupportScreen(
                            model: null,
                          ),
                        );
                      },
                    ),
                    Divider(color: Color(0xffe9e9e9)),
                    buildListTile(
                      icon: Icons.health_and_safety,
                      title: 'Safety resources',
                      subtitle: 'Dasher resources to stay safe',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SafetySupportScreen()));
                      },
                    ),
                    Divider(color: Color(0xffe9e9e9)),
                    buildListTile(
                      icon: Icons.person_3_outlined,
                      title: 'Help Center',
                      subtitle: 'Explore all of our resources.',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpCenterScreen()));
                      },
                    ),
                    Divider(color: Color(0xffe9e9e9)),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(String assetPath, String title, int index) {
    return Container(
      width: 80.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 56.h,
            width: 64.w,
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: interText(
                14.sp,
                tapped == index ? myColors.green : Colors.black,
                FontWeight.w500),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(
      {required IconData icon,
      required String title,
      required String subtitle,
      required Function() onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey.shade800, size: 24),
      title: Text(title, style: interText(16, Colors.black, FontWeight.w500)),
      subtitle: Text(subtitle,
          style: interText(12, Colors.grey.shade600, FontWeight.w500)),
      trailing:
          Icon(Icons.arrow_forward_ios, color: Color(0xff535151), size: 16),
      onTap: onTap,
    );
  }

  TextStyle interText(double size, Color color, FontWeight weight) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      fontFamily: 'Inter',
      height: 1.5,
    );
  }
}
