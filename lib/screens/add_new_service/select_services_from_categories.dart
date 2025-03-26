import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/service_according_category_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/prefered_service_area_2.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/single_line_shimmer.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../misc/constants.dart';
import '../../models/all_service_items.dart';
import '../../widgets_reuse/custom_appbar.dart';
import '../../widgets_reuse/custom_rounded_button.dart';

class SelectServicesFromCategories extends StatefulWidget {
  SelectServicesFromCategories(this.service, {super.key});
  AllServiceItems service;

  @override
  State<SelectServicesFromCategories> createState() =>
      _SelectServicesFromCategoriesState();
}

class _SelectServicesFromCategoriesState
    extends State<SelectServicesFromCategories> {
  bool check = false;
  String selectedCategory = '';
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var cp = context.read<AddNewServiceProvider>();
    Future.microtask(() {
      // cp.setParentValue(true);
      cp.setParentServiceTextIdToSaveServices(widget.service.textId ?? '');
      cp.getValueMapOfSaveService.clear();
      cp.setSelectedIndexCategory(0);
      //set cat name
      selectedCategory = widget.service.title ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(label: 'Select Services'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration:
                        BoxDecoration(color: Colors.white, boxShadow: []),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.service.title ?? '',
                                    style: interText(
                                        22, Colors.black, FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Please select services you would like to provide.',
                                    style: interText(14, myColors.greyTxt,
                                            FontWeight.w500)
                                        .copyWith(letterSpacing: 0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CategoriesItem(
                      selectedCategoryName: (catName) {
                        debugPrint('catName ${catName}');
                        setState(() {
                          selectedCategory = catName ?? '';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Consumer<AddNewServiceProvider>(
                        builder: (context, provider, _) => Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available Services for "${selectedCategory}"',
                                    style: interText(
                                        16, Colors.black, FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      provider.getValueMapOfSaveService
                                                  .length ==
                                              0
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.warning_amber,
                                                  size: 14,
                                                  color: Color(0xffB14A00),
                                                ),
                                                Text(
                                                  ' Required',
                                                  style: interText(
                                                      14,
                                                      Color(0xffB14A00),
                                                      FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 14,
                                                  color: myColors.green,
                                                ),
                                                Text(
                                                  ' Required',
                                                  style: interText(
                                                      14,
                                                      myColors.green,
                                                      FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Container(
                                          color: Colors.black,
                                          height: 3,
                                          width: 3,
                                        ),
                                      ),
                                      Text(
                                        'Select up to ${provider.serviceCategoryList.length}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            )),
                    Expanded(
                      child: Consumer<AddNewServiceProvider>(
                        builder: (context, provider, _) {
                          return provider.isloadingServices
                              ? SingleLineShimmer()
                              : provider.serviceCategoryList.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          provider.serviceCategoryList.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            provider.serviceCategoryList[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6.0,
                                          ),
                                          child: ServiceItem(
                                            item: item,
                                            index: index,
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text('No Service Found'),
                                    );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border(top: BorderSide(color: AppColors.grey)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 8,
                      offset: Offset(0, -4),
                      spreadRadius: 0,
                    )
                  ]),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Consumer<AddNewServiceProvider>(
                    builder: (context, provider, _) => CustomRoundedButton(
                      height: 48,
                      label: 'Save & Next',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: provider.getValueMapOfSaveService.length == 0
                          ? null
                          : () async {
                              provider.getSelectesService2();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PreferedServiceAreas2(
                                              widget.service)));
                            },
                      borderRadius: 8,
                      controller: _btnController,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesItem extends StatelessWidget {
  final Function(String? title) selectedCategoryName;

  CategoriesItem({required this.selectedCategoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.topLeft,
      child: Consumer<AddNewServiceProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: provider.subCategoryListNew.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = provider.subCategoryListNew[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
                  child: GestureDetector(
                    onTap: () async {
                      provider.getServiceByCategoryId(
                          provider.subCategoryListNew[index].textId);
                      provider.setSelectedIndexCategory(index);
                      selectedCategoryName(item.title);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(
                                color: provider.selectedIndexCategory == index
                                    ? Colors.black
                                    : myColors.greyBtn,
                                width: provider.selectedIndexCategory == index
                                    ? 1.5
                                    : 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                item.title ?? '',
                                style: interText(
                                    16, Colors.black, FontWeight.w500),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              //CustomCircleShimmerImage(imageUrl: '${urlBase}${item.image}', placeholder: 'images/placeholder.jpg', size: 36,borderRadius: 4,)
                              SizedBox(
                                child: CachedNetworkImage(
                                  imageUrl: '${urlBase}${item.icon}',
                                  fit: BoxFit.cover,
                                  height: 36,
                                  width: 36,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                );
              });
        },
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  const ServiceItem({super.key, required this.item, required this.index});

  final ServiceAccordingCategoryModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewServiceProvider>(
      builder: (context, provider, _) => Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (provider.serviceCategoryList[index].isExist == "Yes") {
                  CustomHelperWidgets.showIsPricingExistsBottomSheet(
                    context: context,
                    title: 'Service Already Added',
                    serviceImage:
                        provider.serviceCategoryList[index].image ?? '',
                    serviceTitle: 'House Cleaning',
                    description: 'You have already added this service. ',
                    onSeeAssignedZones: () {
                      // Navigate to Assigned Zones
                    },
                  );
                } else {
                  // Use the existing method to toggle the selection
                  provider.setValueMapToSaveService(
                    provider.serviceCategoryList[index].subCategoryTextId ??
                        provider.serviceCategoryList[index].categoryTextId ??
                        '',
                    provider.serviceCategoryList[index].textId ?? '',
                    provider.serviceCategoryList[index].title ?? '',
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading Checkbox
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Checkbox(
                      activeColor: myColors.green,
                      value: provider.getValueMapOfSaveService.any(
                        (e) => e['key'] == getSubCategoryId(provider),
                      ),
                      onChanged: (value) {
                        if (provider.serviceCategoryList[index].isExist ==
                            "Yes") {
                          CustomHelperWidgets.showIsPricingExistsBottomSheet(
                            context: context,
                            serviceImage:
                                provider.serviceCategoryList[index].image ?? '',
                            title: 'Service Already Added',
                            serviceTitle: 'House Cleaning',
                            description:
                                'You have already added this service. ',
                            onSeeAssignedZones: () {
                              // Navigate to Assigned Zones
                            },
                          );
                        } else {
                          // Use the existing method to toggle the selection
                          provider.setValueMapToSaveService(
                            provider.serviceCategoryList[index]
                                    .subCategoryTextId ??
                                provider.serviceCategoryList[index]
                                    .categoryTextId ??
                                '',
                            provider.serviceCategoryList[index].textId ?? '',
                            provider.serviceCategoryList[index].title ?? '',
                          );
                        }
                      },
                    ),
                  ),
                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item.title ?? '',
                            style: interText(14, Colors.black, FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trailing Image
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: CachedNetworkImage(
                        imageUrl: '${urlBase}${item.image}',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Space between icon and title
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: myColors.divider,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  String getSubCategoryId(AddNewServiceProvider provider) {
    if (provider.serviceCategoryList[index].subCategoryTextId == null) {
      return '${provider.serviceCategoryList[index].categoryTextId}' +
          '${provider.serviceCategoryList[index].textId}';
    } else {
      return '${provider.serviceCategoryList[index].subCategoryTextId}' +
          '${provider.serviceCategoryList[index].textId}';
    }
  }
}
