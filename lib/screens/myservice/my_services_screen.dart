import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/working_service_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/my_service_list_main.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../models/category_service_model.dart';
import '../../models/zone_service_model.dart';
import '../pricing/pricing_screen.dart';
import '../add_service_zone/service_area_show.dart';
import '../add_new_service/add_new_service.dart';

class MyServicesScreen extends StatefulWidget {
  static const String routeName = 'my_service_screen';
  String? empType;

  MyServicesScreen({this.empType});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  bool callOnce = true;
  final ScrollController _scrollController = ScrollController();
  bool _showSearchField = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    getMySelectedCatList();
  }

  void _handleScroll() {
    if (_scrollController.offset > 400 && !_showSearchField) {
      setState(() {
        _showSearchField = true;
      });
    } else if (_scrollController.offset <= 400 && _showSearchField) {
      setState(() {
        _showSearchField = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.empType == null ? MyBottomNavBar() : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    //Navigator.pop(context);
                    context.pushNamed('dashboard');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 6, top: 6, bottom: 6),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'My Services',
                    key: ValueKey('title'),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
                // Expanded(
                //   child: AnimatedSwitcher(
                //     duration: Duration(milliseconds: 300),
                //     child: _showSearchField
                //         ? Container(
                //             key: ValueKey('searchField'),
                //             height: 40,
                //             decoration: BoxDecoration(
                //               color: Colors.grey[100],
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: TextField(
                //               textAlign: TextAlign.left, // Center the hint text
                //               decoration: InputDecoration(hintText: 'Search by service name or city...', border: InputBorder.none, contentPadding: EdgeInsets.only(bottom: 8, left: 12)),
                //             ),
                //           )
                //         : Align(
                //             alignment: Alignment.center,
                //             child: Text(
                //               'My Services',
                //               key: ValueKey('title'),
                //               style: GoogleFonts.inter(
                //                 fontSize: 16,
                //                 color: Colors.black,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             ),
                //           ),
                //   ),
                // ),
                Icon(
                  Icons.arrow_back,
                  color: Colors.transparent,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      _handleScroll();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        if (widget.empType == null)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 2, color: myColors.green),
                                      color: myColors.green),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddNewServiceScreen()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            height: 36,
                                            width: 36,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Image.asset(
                                              'assets/png/addNew.png',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text('Add New Services',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.42)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 2, color: myColors.green),
                                      color: myColors.green),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyServiceArea(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            height: 36,
                                            width: 36,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: SvgPicture.asset(
                                              'assets/svg/serviceAreas.svg',
                                              color: Color(0xff008951),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'New Service Areas',
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.42),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (widget.empType == null)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: myColors.green,
                              gradient: LinearGradient(
                                begin: Alignment(1.00, 0.00),
                                end: Alignment(-1, 0),
                                colors: [Color(0xFF00897B), Color(0xFF4DAC85)],
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PricingScreen()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svg/pricing.svg',
                                        color: Color(0xff008951),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Pricing',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.42),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FilterCategoryDropDown(),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(child: FilterZoneDropDown()),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Consumer<WorkingServiceProvider>(
                            builder: (context, pro, _) => MyServiceListMain(
                                services: pro.myServiceFilterServiceList))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMySelectedCatList() async {
    var wsp = context.read<WorkingServiceProvider>();
    Future.microtask(() {
      wsp.getMySelectedCatList();
    });
  }
}

class FilterZoneDropDown extends StatefulWidget {
  @override
  _StatusFilterDropDownState createState() => _StatusFilterDropDownState();
}

class _StatusFilterDropDownState extends State<FilterZoneDropDown> {
  ZoneServiceModel? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkingServiceProvider>(
      builder: (context, pro, _) => Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(6), // Border radius
          border: Border.all(color: Color(0xffe9e9e9), width: 1), // Border
        ),
        child: DropdownButton2<ZoneServiceModel>(
          isExpanded: true, // Ensures dropdown covers full width
          underline: SizedBox(), // Removes the default underline
          value: selectedValue,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text('Select zone',
                style: interText(14, Colors.black, FontWeight.w500)),
          ),
          customButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedValue?.zoneTitle ?? 'Select zone',
                    style: interText(14, Colors.black, FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.black, size: 24), // Custom dropdown icon
              ],
            ),
          ),
          items: [
            DropdownMenuItem<ZoneServiceModel>(
              value: null, // Use null for the "All Zones" option
              child: Tooltip(
                message: 'All Zones', // Tooltip for "All Zones"
                child: Text(
                  'All Zones',
                  style: interText(14, Colors.black, FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            ...pro.myServiceZoneFilterList.map((ZoneServiceModel value) {
              return DropdownMenuItem<ZoneServiceModel>(
                value: value,
                child: Tooltip(
                  message: value.zoneTitle ?? '', // Tooltip for long values
                  child: Text(
                    value.zoneTitle ?? '',
                    style: interText(14, Colors.black, FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
          ],
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });

            if (selectedValue == null) {
              pro.getServicesByZone("all");
            } else {
              pro.getServicesByZone(selectedValue!.zoneTextId ?? '');
            }
          },
        ),
      ),
    );
  }
}

class FilterCategoryDropDown extends StatefulWidget {
  @override
  _FilterCategoryDropDownState createState() => _FilterCategoryDropDownState();
}

class _FilterCategoryDropDownState extends State<FilterCategoryDropDown> {
  CategoryServiceModel? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkingServiceProvider>(
      builder: (context, pro, _) => Container(
          decoration: BoxDecoration(
            color: Color(0xffe9e9e9), // Background color
            borderRadius: BorderRadius.circular(6), // Border radius
            border: Border.all(color: myColors.greyBtn, width: 1), // Border
          ),
          child: DropdownButton2<CategoryServiceModel>(
            isExpanded: true,
            underline: SizedBox(),
            value: selectedValue,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text('Category',
                  style: interText(14, Colors.black, FontWeight.w500)),
            ),
            customButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedValue?.categoryTitle ?? 'All Categories',
                      style: interText(14, Colors.black, FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.black, size: 24), // Custom dropdown icon
                ],
              ),
            ),
            items: [
              DropdownMenuItem<CategoryServiceModel>(
                value: null,
                child: Tooltip(
                  message: 'All Categories',
                  child: Text(
                    'All Categories',
                    style: interText(14, Colors.black, FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              ...pro.myServiceCategoryFilterList
                  .map((CategoryServiceModel value) {
                return DropdownMenuItem<CategoryServiceModel>(
                  value: value,
                  child: Tooltip(
                    message: value.categoryTitle ?? '',
                    child: Text(
                      value.categoryTitle ?? '',
                      style: interText(14, Colors.black, FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue;
              });

              if (selectedValue == null) {
                pro.getServicesByCategory('all');
              } else {
                pro.getServicesByCategory(selectedValue!.categoryTextId ?? '');
              }
            },
          )),
    );
  }
}
