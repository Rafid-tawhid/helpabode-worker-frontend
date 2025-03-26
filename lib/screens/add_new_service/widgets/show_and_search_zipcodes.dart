import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper_functions/colors.dart';
import '../../../helper_functions/signin_signup_helpers.dart';
import '../../../misc/constants.dart';
import '../../../provider/addnew_services_provider.dart';
import '../../registration/search_area_zip.dart';

class SearchAndShowZipcodes extends StatelessWidget {
  const SearchAndShowZipcodes({
    super.key,
    required this.provider,
  });

  final AddNewServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Hero(
            tag: 'tag1',
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: myColors.greyBg,
                    borderRadius: BorderRadius.circular(36.0),
                    border: Border.all(color: Colors.transparent, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            //call provider city initial value

                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            String? data = await pref.getString("city");
                            if (data != null) {
                              provider.isLoadingSearch2(true);
                              provider.searchByCityAndZip(data).then((val) {
                                provider.isLoadingSearch2(false);
                              });
                            } else {
                              provider.isLoadingSearch2(true);
                              provider.searchByCityAndZip('945').then((val) {
                                provider.isLoadingSearch2(false);
                              });
                            }

                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return FadeScaleTransition(
                                      animation: animation,
                                      child: const AreaZipSearchScreen(),
                                    );
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = 0.0;
                                    const end = 1.0;
                                    const curve = Curves.easeIn;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var fadeScaleTween =
                                        Tween(begin: 0.2, end: 1.0)
                                            .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);
                                    var fadeScaleAnimation =
                                        animation.drive(fadeScaleTween);

                                    return FadeScaleTransition(
                                      animation: fadeScaleAnimation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                                begin: Offset(1, 0),
                                                end: Offset.zero)
                                            .animate(offsetAnimation),
                                        child: child,
                                      ),
                                    );
                                  },
                                ));

                            // if (await provider.getAllCityAndZipCodes()) {
                            //   Navigator.push(
                            //       context,
                            //       PageRouteBuilder(
                            //         pageBuilder: (context, animation, secondaryAnimation) {
                            //           return FadeScaleTransition(
                            //             animation: animation,
                            //             child: const AreaZipSearchScreen(),
                            //           );
                            //         },
                            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            //           const begin = 0.0;
                            //           const end = 1.0;
                            //           const curve = Curves.easeIn;
                            //           var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            //           var fadeScaleTween = Tween(begin: 0.2, end: 1.0).chain(CurveTween(curve: curve));
                            //           var offsetAnimation = animation.drive(tween);
                            //           var fadeScaleAnimation = animation.drive(fadeScaleTween);
                            //
                            //           return FadeScaleTransition(
                            //             animation: fadeScaleAnimation,
                            //             child: SlideTransition(
                            //               position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(offsetAnimation),
                            //               child: child,
                            //             ),
                            //           );
                            //         },
                            //       ));
                            // }
                          },
                          child: Text(
                            'Search by City or Zip Code',
                            style: TextStyle(
                              color: fontClr,
                              fontSize: CurrentDevice.isAndroid() ? 16 : 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        if (provider.searchSuggestionListAddedMain.length > 0)
          Container(
            height: 6,
            color: myColors.greyBg,
          ),
        SizedBox(
          height: 10,
        ),
        if (provider.searchSuggestionListAddedMain.length > 0)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Selected zip code',
              style: interText(16, Colors.black, FontWeight.w500),
            ),
          ),
        SizedBox(
          height: 4,
        ),
        Column(
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          children: provider.searchSuggestionListAddedMain
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16),
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
                              '${e.zip}, ${e.cityTextId}, ${e.stateShortName} ${e.countryShortName}',
                              style:
                                  interText(14, Colors.black, FontWeight.w400),
                            ),
                          )),
                          IconButton(
                              onPressed: () {
                                provider.deleteSearchList(e);
                              },
                              icon: Icon(
                                Icons.close,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class SelectedCategories2 extends StatelessWidget {
  const SelectedCategories2({
    super.key,
    required this.provider,
  });

  final AddNewServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Services',
                    style: interText(16, Colors.black, FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: provider.getValueMapOfSaveService.length <= 2
                    ? 50
                    : provider.getValueMapOfSaveService.length <= 4
                        ? 100
                        : 150,
                child: GridView.builder(
                  itemCount: provider.getValueMapOfSaveService
                      .length, // Specify the total number of items
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing:
                        10.0, // Spacing between each item horizontally
                    mainAxisSpacing:
                        10.0, // Spacing between each row vertically
                    childAspectRatio: 5, // Aspect ratio of each item
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // Return a widget for each item
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: myColors.greyBg),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8),
                        child: Text(
                          provider.getValueMapOfSaveService[index]
                                  ['serviceTitle'] ??
                              '',
                          maxLines: 1,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ); // Your item widget, pass index if needed
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 4,
          color: myColors.greyBg,
        ),
      ],
    );
  }
}
