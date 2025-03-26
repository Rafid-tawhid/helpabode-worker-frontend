import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/single_line_shimmer.dart';
import 'package:provider/provider.dart';

class HorizontalServicesList extends StatefulWidget {
  const HorizontalServicesList({Key? key}) : super(key: key);

  @override
  _HorizontalServicesListState createState() => _HorizontalServicesListState();
}

class _HorizontalServicesListState extends State<HorizontalServicesList> {
  int selectedIndex = 0; // By default, the first item is selected
  String? selectedServiceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Consumer<AddNewServiceProvider>(
        builder: (context, pro, _) {
          return pro.isLoadingArea
              ? SingleLineShimmer()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pro.servicesList.length + 1,
                        // Add 1 for "All Service"
                        itemBuilder: (context, index) {
                          final isSelected = selectedIndex == index;
                          // Handle "All Service" as the first item
                          final String serviceTitle = index == 0
                              ? "All Service"
                              : pro.servicesList[index - 1]['serviceTitle'];
                          final String serviceTextId = index == 0
                              ? "All Service"
                              : pro.servicesList[index - 1]['serviceTextId'];
                          final String categoryTextId = index == 0
                              ? "All Service"
                              : pro.servicesList[index - 1]['categoryTextId'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                selectedServiceName = serviceTitle;
                              });
                              pro.filterServiceArea(
                                  serviceTextId, serviceTitle, categoryTextId);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? myColors.green : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.grey.shade300, // Grey border
                                  width: .5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  serviceTitle,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    // White text if selected
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: Row(
                        children: [
                          Text(
                            '${pro.filterserviceAreaWithInfoList.length} Zone found for',
                            style: interText(14, Colors.black, FontWeight.w600),
                          ),
                          Text(
                            ' "${selectedServiceName == null ? 'All service' : selectedServiceName}"',
                            style:
                                interText(14, myColors.green, FontWeight.w700),
                          ),
                        ],
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
