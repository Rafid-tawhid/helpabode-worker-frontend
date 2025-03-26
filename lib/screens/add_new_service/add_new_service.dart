import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/select_services_from_categories.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/single_line_shimmer.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/bottom_nav_bar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../misc/constants.dart';

class AddNewServiceScreen extends StatefulWidget {
  const AddNewServiceScreen({super.key});

  @override
  State<AddNewServiceScreen> createState() => _AddNewServiceScreenState();
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  @override
  void initState() {
    getAllServiceItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyBottomNavBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Ensures left alignment
          children: [
            const CustomAppBar(label: ''),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20), // Aligns with the list
              child: Text(
                'Add New Services',
                style: interText(22, Colors.black, FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20), // Aligns with the list
              child: Text(
                'Please select services you would like to provide.',
                style: interText(14, myColors.greyTxt, FontWeight.w500)
                    .copyWith(letterSpacing: 0),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20), // Keeps everything aligned
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AddNewServiceProvider>(
                          builder: (context, pro, _) {
                        if (pro.isloadingServices) {
                          return SingleLineShimmer();
                        } else if (pro.allServiceItemList.isEmpty) {
                          return const Center(
                            child: Text('No Service Found'),
                          );
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pro.allServiceItemList.length,
                              itemBuilder: (context, index) {
                                var items = pro.allServiceItemList[index];
                                if (pro.allServiceItemList.isNotEmpty) {
                                  return GestureDetector(
                                      onTap: () async {
                                        // print('service id ${provider.allServiceItemList[index].textId}');
                                        // EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                        // if (await provider.getCategoryAccordingToServiceItems(provider.allServiceItemList[index].textId!)) {
                                        //   EasyLoading.dismiss();
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => SelectItemsOfCategory(provider.allServiceItemList[index].title ?? '')));
                                        // } else {
                                        //   EasyLoading.dismiss();
                                        // }

                                        EasyLoading.show(
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        if (await pro.myCategoryServices(
                                            pro.allServiceItemList[index]
                                                .textId,
                                            pro.allServiceItemList[index]
                                                    .attributeGroupTextId ??
                                                '')) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectServicesFromCategories(
                                                          pro.allServiceItemList[
                                                              index])));
                                        }
                                        EasyLoading.dismiss();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6.0,
                                        ),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1.50,
                                                color: Color(0xFFE9E9E9)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          )),
                                          //decoration: BoxDecoration(border: Border.all(color: myColors.greyTxt, width: .5), borderRadius: BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  '$urlBase${items.image}' ??
                                                      '',
                                                  width:
                                                      48, // Adjust the width as needed
                                                  height:
                                                      48, // Adjust the height as needed
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'images/placeholder.jpg', // Replace with your placeholder image URL
                                                      width:
                                                          50, // Adjust the width as needed
                                                      height:
                                                          50, // Adjust the height as needed
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                              title: Text(
                                                items.title ?? '',
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                style: interText(
                                                    16,
                                                    Colors.black,
                                                    FontWeight.w600),
                                              ),
                                              trailing:
                                                  Icon(Icons.chevron_right),
                                              contentPadding: EdgeInsets.only(
                                                  right: 6, left: 16),
                                            ),
                                          ),
                                        ),
                                      ));
                                } else {
                                  return const Center(
                                    child: Text('No Service Found'),
                                  );
                                }
                              });
                        }
                      }),

                      //Consumer<AddNewServiceProvider>(
                      //                       builder: (context, provider, _) => FutureBuilder(
                      //                           future: provider.getMyAllAndUserSelectedCategory(),
                      //                           builder: (context, snapshot) {
                      //                             if (snapshot.hasData == true) {
                      //                               return GridView.builder(
                      //                                   shrinkWrap: true,
                      //                                   physics: const NeverScrollableScrollPhysics(),
                      //                                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //                                     crossAxisCount: 2, // Number of columns
                      //                                     crossAxisSpacing: 8.0, // Spacing between columns
                      //                                     mainAxisSpacing: 8.0, // Spacing between rows
                      //                                   ),
                      //                                   itemCount: provider.selectedCategoryModel.length,
                      //                                   itemBuilder: (context, index) {
                      //                                     var items = provider.selectedCategoryModel[index];
                      //                                     return InkWell(
                      //                                       onTap: () {
                      //                                         //context.pushNamed(SubCategoryServices.routeName, queryParameters: {'name': provider.addNewServiceList[index].title});
                      //                                       },
                      //                                       child: InkWell(
                      //                                         onTap: () {
                      //                                           //   context.pushNamed(PreferedServiceAreas.routeName, queryParameters: {'from': 'dashboard'});
                      //                                         },
                      //                                         child: Card(
                      //                                           color: items.status == true ? myColors.greyTxt : Colors.white,
                      //                                           child: Center(
                      //                                               child: Stack(
                      //                                             children: [
                      //                                               Column(
                      //                                                 mainAxisAlignment: MainAxisAlignment.center,
                      //                                                 children: [
                      //                                                   Padding(
                      //                                                     padding: const EdgeInsets.all(8.0),
                      //                                                     child: Text(
                      //                                                       items.title ?? '',
                      //                                                       textAlign: TextAlign.center,
                      //                                                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ],
                      //                                               ),
                      //                                             ],
                      //                                           )),
                      //                                         ),
                      //                                       ),
                      //                                     );
                      //                                   });
                      //                             } else if (snapshot.connectionState == ConnectionState.waiting) {
                      //                               return const Center(
                      //                                 child: CircularProgressIndicator(),
                      //                               );
                      //                             } else {
                      //                               return const Center(
                      //                                 child: Text('Nothing to show'),
                      //                               );
                      //                             }
                      //                           }),
                      //                     ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getAllServiceItems() async {
    var provider = context.read<AddNewServiceProvider>();
    Future.microtask(() {
      provider.getAllServiceItems2();
    });
  }
}
