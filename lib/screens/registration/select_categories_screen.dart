import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/prefered_service_area.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SelectServicesScreen extends StatefulWidget {
  static const String routeName = '/add_service';
  const SelectServicesScreen({super.key});

  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  late AddNewServiceProvider provider;
  bool isItemSelected = false;

  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);
    provider.getHomeServices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0)), // Set the border radius here
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Services',
                              style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            const Text('Select Services You Provide')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularStepProgressIndicator(
                                totalSteps: 3,
                                currentStep: 1,
                                stepSize: 4,
                                selectedColor: myColors.green,
                                width: 50,
                                height: 50,
                                roundedCap: (_, isSelected) => isSelected,
                              ),
                              const Text(
                                '1/3',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<AddNewServiceProvider>(
              builder: (context, provider, _) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 8.0, // Spacing between columns
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.6, // Spacing between rows
                      ),
                      itemCount: provider.addNewServiceList.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              provider.addNewServiceList[index].isSelected =
                                  !provider.addNewServiceList[index].isSelected;
                              provider.notifyListeners();

                              //is any item select
                              setState(() {
                                isItemSelected = true;
                              });
                              //context.pushNamed(SubCategoryServices.routeName, queryParameters: {'name': provider.addNewServiceList[index].title});
                            },
                            child: Card(
                              child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: provider.addNewServiceList[index]
                                                .isSelected
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                        width: 1),
                                    color: provider
                                            .addNewServiceList[index].isSelected
                                        ? myColors.green
                                        : Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          provider.addNewServiceList[index]
                                                  .title ??
                                              '',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: CurrentDevice.isAndroid()
                                                ? 18
                                                : 26,
                                            fontWeight: FontWeight.bold,
                                            color: provider
                                                    .addNewServiceList[index]
                                                    .isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.center,
                                      //   child: Html(
                                      //     data: provider.addNewServiceList[index].details ?? '',
                                      //     shrinkWrap: true,
                                      //   ),
                                      // ),
                                    ],
                                  )),
                            ),
                          )),
                ),
              ),
            ),
            if (provider.addNewServiceList.any((element) => element.isSelected))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CustomMaterialButton(
                    width: double.infinity,
                    label: 'Next',
                    buttonColor: myColors.green,
                    fontColor: Colors.white,
                    funcName: () {
                      provider.getSelectesService();
                      context.pushNamed(PreferedServiceAreas.routeName);
                    },
                    borderRadius: 8),
              ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
