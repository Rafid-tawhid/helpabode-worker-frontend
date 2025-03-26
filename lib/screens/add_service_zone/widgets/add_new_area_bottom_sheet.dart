import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/pending_price_view_details_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_service_zone/widgets/service_search_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../custom_packages/extensions/custom_material_button.dart';
import '../../registration/search_area_zip.dart';

//pro.serviceTitle

class NewZoneAddBottomSheet extends StatefulWidget {
  @override
  State<NewZoneAddBottomSheet> createState() => _NewZoneAddBottomSheetState();
}

class _NewZoneAddBottomSheetState extends State<NewZoneAddBottomSheet> {
  TextEditingController _conAreaName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(context),
                  SelectedServices(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _conAreaName,
                      decoration: InputDecoration(
                          hintText: 'Service Area Name',
                          filled: true,
                          fillColor: myColors.greyBg,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.edit)),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Name is Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  // _buildServiceAreaField(context, _conAreaName),
                  const SizedBox(height: 10),
                  _buildZipSearch(context),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Add / Remove City or Zip',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildZipList(context),
                  const SizedBox(height: 60),
                  _buildSaveButton(context, 'zoneId', _conAreaName),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        const Expanded(
          child: Text(
            'Add New Service Area',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.delete, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildServiceAreaField(
      BuildContext context, TextEditingController controller) {
    return Consumer<AddNewServiceProvider>(
      builder: (context, ap, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
              color: myColors.greyBg, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Service Area Name',
                      filled: true,
                      fillColor: myColors.greyBg,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.edit)),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Name is Required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZipSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          searchFunction(context);
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: myColors.greyBg,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.black),
              SizedBox(width: 8.0),
              Text(
                'Search by City or Zip Code',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZipList(BuildContext context) {
    return Consumer<AddNewServiceProvider>(
        builder: (context, ap, _) => Column(
              children: ap.searchSuggestionListAddedMain.map((val) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: myColors.greyBg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              '${val.zip}, ${val.cityTextId}, ${val.stateShortName} ${val.countryShortName}',
                              // Update based on your model
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ap.deleteSearchList(val);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ));
  }

  Widget _buildSaveButton(
      BuildContext context, String zoneId, TextEditingController zoneName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Consumer<AddNewServiceProvider>(
          builder: (context, asp, _) => Row(
                children: [
                  asp.searchSuggestionListAddedMain.length > 0
                      ? Expanded(
                          child: CustomMaterialButton(
                              label: 'Save Service Area',
                              height: 40,
                              buttonColor: myColors.green,
                              fontColor: Colors.white,
                              isLoading: asp.showLoadingZipUpdateBtn,
                              funcName: () async {
                                if (_formKey.currentState!.validate()) {
                                  var pro =
                                      context.read<AddNewServiceProvider>();
                                  debugPrint(
                                      'service id ${pro.selectedService}');
                                  debugPrint(
                                      'category id ${pro.selectedCategoryId}');
                                  await asp.createZoneFromMyService(
                                      zoneName.text.trim(),
                                      PricingServiceInfo(
                                          textId: pro.selectedServiceId,
                                          categoryTextId:
                                              pro.selectedCategoryId));
                                  //get all data
                                  await pro.getMyAllServiceAreaWIthAllInfo();
                                  //get selected service areas only
                                  pro.filterServiceArea(
                                      pro.selectedServiceId ?? '',
                                      pro.selectedService ?? '',
                                      pro.selectedCategoryId ?? '');
                                  Navigator.pop(context);
                                }
                              },
                              borderRadius: 8))
                      : SizedBox.shrink(),
                ],
              )),
    );
  }

  void searchFunction(BuildContext context) {
    var provider = context.read<AddNewServiceProvider>();
    provider.isLoadingSearch2(true);
    provider.searchByCityAndZip('945').then((val) {
      provider.isLoadingSearch2(false);
    });
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeScaleTransition(
              animation: animation,
              child: const AreaZipSearchScreen(
                editModal: 'edit',
              ),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeIn;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeScaleTween =
                Tween(begin: 0.2, end: 1.0).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            var fadeScaleAnimation = animation.drive(fadeScaleTween);

            return FadeScaleTransition(
              animation: fadeScaleAnimation,
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                    .animate(offsetAnimation),
                child: child,
              ),
            );
          },
        ));
  }
}

class SelectedServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Service :',
                  style: interText(14, Colors.black, FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Consumer<AddNewServiceProvider>(
            builder: (context, ap, _) => GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Default: 2 items per row
                crossAxisSpacing: 6, // Space between columns
                mainAxisSpacing: 6, // Space between rows
                childAspectRatio: 5 / 1, // Adjust based on content
              ),
              itemCount: ap.searchSelectedServiceList.length,
              itemBuilder: (context, index) {
                var service = ap.searchSelectedServiceList[index];
                bool isLongTitle = (service.serviceTitle?.length ?? 0) > 15;
                // Adjust layout for long titles
                return GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      color: myColors.greyBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '${DashboardHelpers.truncateString(service.serviceTitle ?? '', 16)}',
                        style: interText(14, Colors.black, FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  footer: isLongTitle
                      ? SizedBox.shrink() // Placeholder to ensure proper layout
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}
