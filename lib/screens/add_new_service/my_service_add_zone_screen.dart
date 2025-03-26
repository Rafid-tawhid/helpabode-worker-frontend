import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:provider/provider.dart';

import '../../custom_packages/extensions/custom_material_button.dart';
import '../../helper_functions/colors.dart';
import '../../models/pending_price_view_details_model.dart';
import '../../provider/addnew_services_provider.dart';
import '../../widgets_reuse/new_text_formfield.dart';
import '../registration/search_area_zip.dart';

class MyServiceAddZoneScreen extends StatefulWidget {
  final PricingServiceInfo service;

  MyServiceAddZoneScreen({required this.service});

  @override
  State<MyServiceAddZoneScreen> createState() => _MyServiceAddZoneScreenState();
}

class _MyServiceAddZoneScreenState extends State<MyServiceAddZoneScreen> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add Service Zone',
            style: interText(18, Colors.black, FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Service:',
                            style: interText(16, Colors.black, FontWeight.w600),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: myColors.greyBg,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20),
                                child: Text(widget.service.title ?? '',
                                    style: interText(
                                        12, Colors.black, FontWeight.w600)),
                              )),
                        ],
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: NewCustomTextField(
                              fieldTextFieldController: controller,
                              funcOnChanged: (val) {},
                              funcValidate: (value, setErrorInfo) {
                                if (value == null || value.isEmpty) {
                                  setErrorInfo(true, 'Zone name is required');
                                  return '';
                                }
                                if (value.length < 3) {
                                  setErrorInfo(true, 'Minimum 3 character');
                                  return '';
                                }
                                return null;
                              },
                              hintText: 'Enter zone name',
                              borderRadius: 8),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add / Remove City or Zip',
                        style: interText(16, Colors.black, FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Consumer<AddNewServiceProvider>(
                        builder: (context, ap, _) => Column(
                              children:
                                  ap.searchSuggestionListAddedMain.map((val) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: myColors.greyBg,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Text(
                                              '${val.zip}, ${val.cityTextId}, ${val.stateShortName} ${val.countryShortName}',
                                              // Update based on your model
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
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
                            ))
                  ],
                ),
              ),
            ),
            Consumer<AddNewServiceProvider>(
              builder: (context, asp, _) =>
                  asp.searchSuggestionListAddedMain.length > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12),
                          child: CustomMaterialButton(
                              label: 'Save Zone',
                              height: 40,
                              buttonColor: myColors.green,
                              fontColor: Colors.white,
                              isLoading: asp.showLoadingZipUpdateBtn,
                              funcName: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (await asp.createZoneFromMyService(
                                      controller.text.trim(), widget.service)) {
                                    //clear selected list
                                    asp.clearSelectedList();
                                    var pp = context.read<PricingProvider>();
                                    //for update list
                                    asp.showLoadingZipUpdateButton(true);
                                    await pp.getPricingServiceViewDetails(
                                        widget.service.textId,
                                        widget.service.status ?? '',
                                        widget.service.categoryTextId);
                                    asp.showLoadingZipUpdateButton(false);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              borderRadius: 8),
                        )
                      : SizedBox.shrink(),
            )
          ],
        ),
      ),
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
