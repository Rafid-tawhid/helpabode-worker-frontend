// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/provider/navbar_provider.dart';
import 'package:provider/provider.dart';

import 'sign_in_tab.dart';
import 'sign_up_tab.dart';

List<String> bg_images = [
  'assets/svg/images (1)/Carpet Cleaning.jpg',
  'assets/svg/images (1)/car wash 1.png',
  'assets/svg/images (1)/landscaping (2).jpg',
  'assets/svg/images (1)/pest control.png',
  'assets/svg/images (1)/handyman.webp',
  'assets/svg/images (1)/iPhone Screen Repair - Charlotte NC- CyberMax.webp',
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  setTab(int index) async {
    var topTabControllerProvider = context.read<TabControllerProvider>();
    await topTabControllerProvider.loginTabControl(index);
  }

  getTab() {
    var topTabControllerProvider = context.read<TabControllerProvider>();
    return topTabControllerProvider.loginTabIndex;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = getTab();

    _tabController.addListener(() {
      // setState(() {
      //   selectedIndex1 = _tabController.index;
      // });
      setTab(_tabController.index);
    });
  }

  @override
  void dispose() {
    setTab(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabControllerProvider = context.watch<TabControllerProvider>();
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor:
                  Colors.transparent, // Set your desired status bar color
              statusBarIconBrightness: Brightness
                  .light, // Set the status icons color (Brightness.dark for dark icons)
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                // FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    // top: 0,
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      // child: Image(
                      //   fit: BoxFit.cover,
                      //   image: AssetImage('assets/background2.jpg'),
                      // ),
                      child: GridView.builder(
                        padding: EdgeInsets.all(0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 0, // Spacing between columns
                          mainAxisSpacing: 0, // Spacing between rows
                          childAspectRatio: 2 *
                              MediaQuery.of(context).size.width /
                              MediaQuery.of(context).size.height,
                        ),
                        itemCount: bg_images.length,
                        itemBuilder: (context, index) {
                          return Image(
                            image: AssetImage(bg_images[index]),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      child: Container(
                    color: Colors.black.withOpacity(0.5),
                  )),
                  Positioned(
                    top: 240.h,
                    left: 20.w,
                    right: 20.w,
                    child: Center(
                        child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.65),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Center(
                          child: Image.asset(
                            'assets/png/logos.png',
                            fit: BoxFit.contain,
                            height: 150,
                            width: 170,
                          ),
                        ),
                      ),
                    )),
                  ),
                  Positioned(
                    //TODO: Uncomment it
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  SignInTab(widget),
                                  SignUpTab(widget),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            onTap: (value) {},
                            isScrollable: false,
                            physics: NeverScrollableScrollPhysics(),
                            tabAlignment: TabAlignment.center,
                            padding: EdgeInsets.all(4),
                            indicatorWeight: 0.0,
                            indicator: CustomTabIndicator(),
                            indicatorSize: TabBarIndicatorSize.label,
                            controller: _tabController,
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                child: CustomTab(
                                  'Sign In',
                                  0,
                                  tabControllerProvider.loginTabIndex,
                                ),
                              ),
                              Tab(
                                child: CustomTab(
                                  'Sign Up',
                                  1,
                                  tabControllerProvider.loginTabIndex,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final paint = Paint()
      ..color = Color(0xff008951) // Set the indicator color
      ..style = PaintingStyle.fill;

    // Draw a rectangle that covers the entire tab label
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect, Radius.circular(50.0)), // Adjust the radius as needed
      paint,
    );
  }
}

class TabContent extends StatelessWidget {
  final String text;

  const TabContent(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
          Spacer(),
          TextFormField()
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String text;
  final int index;
  final int selectedIndex1;

  const CustomTab(this.text, this.index, this.selectedIndex1, {super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = index == selectedIndex1 ? Colors.white : Colors.black;

    return Container(
      width: 132,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
