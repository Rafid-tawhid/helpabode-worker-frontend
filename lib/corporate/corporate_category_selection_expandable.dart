import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/explore/explore_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../misc/constants.dart';
import '../../../models/corporate_review_data_model.dart';
import '../../../models/corporation_category_selection_model.dart';
import '../../../widgets_reuse/custom_rounded_button.dart';
import 'corporate_review_details_tracker.dart';

class CorporateServiceSelectionExpandable extends StatefulWidget {
  CorporateReviewDataModel? corporateReviewDataModel;
  CorporateServiceSelectionExpandable({this.corporateReviewDataModel});

  @override
  _CorporateServiceSelectionExpandableState createState() =>
      _CorporateServiceSelectionExpandableState();
}

class _CorporateServiceSelectionExpandableState
    extends State<CorporateServiceSelectionExpandable> {
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  final TextEditingController _searchCon = TextEditingController();
  String searchVal = '';

  @override
  void initState() {
    var cp = context.read<CorporateProvider>();
    Future.microtask(() {
      cp.getAllItemsAndCategory();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0XFFE9E9E9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _searchCon,
                            onChanged: (val) {
                              var cp = context.read<CorporateProvider>();
                              searchVal = val;
                              cp.getCategorySearchItems(val);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search services...',
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    child: Container(
                                        margin: const EdgeInsets.all(8),
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white),
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 26,
                                        )),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              suffixIcon: searchVal != ''
                                  ? InkWell(
                                      onTap: () {
                                        var cp =
                                            context.read<CorporateProvider>();
                                        setState(() {
                                          _searchCon.clear();
                                          cp.clearSearchList();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: SvgPicture.asset(
                                          'assets/svg/close.svg',
                                          height: 16,
                                          width: 16,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: myColors.green,
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Services',
                            style: interText(24, Colors.black, FontWeight.bold),
                          ),
                          Text(
                            'Select services you provide',
                            style: interText(
                                14, myColors.greyTxt, FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Consumer<CorporateProvider>(
                      builder: (context, provider, _) => provider.isLoadingAll
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShowSearchResult(provider),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: provider
                                        .corporationCategorySelectionList
                                        .length,
                                    itemBuilder: (context, index) {
                                      final item = provider
                                              .corporationCategorySelectionList[
                                          index];
                                      return CardItem(context, item);
                                    }),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
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
              child: CustomRoundedButton(
                  height: 50,
                  width: 388,
                  controller: _controller,
                  label: 'Save & Next',
                  buttonColor: myColors.green,
                  fontColor: Colors.white,
                  funcName: () async {
                    var cp = context.read<CorporateProvider>();
                    _controller.start();
                    var response = await cp.saveSelectedCategories();
                    _controller.stop();
                    if (response) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CorporateReviewDetailsTracker()));
                    }
                  },
                  borderRadius: 8),
            )
          ],
        ),
      ),
    );
  }

  Widget CardItem(
      BuildContext context, CorporationCategorySelectionModel item) {
    return item.children!.length > 0
        ? Card(
            color: Colors.white,
            margin: EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent), // Remove the divider line
              child: ExpansionTile(
                iconColor: myColors.green,
                collapsedIconColor: myColors.green,
                title: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: item.isSelected == true ? 0.0 : 12),
                  child: Row(
                    children: [
                      Text(
                        '${item.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ],
                  ),
                ),
                childrenPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                trailing: item.isSelected == true
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: myColors.green,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                onExpansionChanged: (bool expanded) {
                  var cp = context.read<CorporateProvider>();
                  cp.changeExpandable(item, expanded);
                },
                children: [
                  SizedBox(
                    height: item.children!.length == 1 ? 140 : 240,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: CustomPaint(
                            size: const Size(20, 10),
                            painter: ReversedTrianglePainter(
                                color: Colors.grey.shade50),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Text(
                                    'Select Services you provide',
                                    style: interText(
                                        14, Colors.black, FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, bottom: 16),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            item.children!.length == 1 ? 1 : 2,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                        childAspectRatio: .5,
                                      ),
                                      itemCount: item.children!.length,
                                      itemBuilder: (context, childIndex) {
                                        return item.children!.length > 0
                                            ? SizedBox.expand(
                                                // Ensures the item takes the full available space
                                                child: GridViewItem(
                                                    item.children![childIndex],
                                                    childIndex),
                                              )
                                            : Center(
                                                child: Text('No Service Found'),
                                              );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }

  InkWell GridViewItem(Children item, int childIndex) {
    var cp = context.watch<CorporateProvider>();
    bool isExists = cp.selectedServiceList.any((e) => e.textId == item.textId);
    return InkWell(
      onTap: () {
        cp.addToList(item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isExists ? myColors.green : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          item.title ?? '',
          style: TextStyle(
            color: isExists ? Colors.white : myColors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  ShowSearchResult(CorporateProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.corporateSearchCategoryList.length > 0 &&
              provider.isLoadingSearch == false)
            Text(
              '${provider.corporateSearchCategoryList.length} Search results',
              style: interText(18, Colors.black, FontWeight.w600),
            ),
          provider.isLoadingSearch
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: myColors.green,
                      )),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.corporateSearchCategoryList.length,
                  itemBuilder: (context, index) {
                    var data = provider.corporateSearchCategoryList[index];
                    //convert search item data to children
                    Children item = Children(
                        title: data.title,
                        textId: data.textId,
                        categoryTextId: data.categoryTextId,
                        rank: data.rank);
                    bool isExists = provider.selectedServiceList
                        .any((e) => e.textId == item.textId);

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            provider.addToList(item);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 8),
                                child: Text(data.title ?? ''),
                              )),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: isExists
                                        ? myColors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: isExists
                                            ? Colors.white
                                            : myColors.green)),
                                child: isExists
                                    ? Text(
                                        'selected',
                                        style: interText(
                                            12, Colors.white, FontWeight.w400),
                                      )
                                    : Text(
                                        'select',
                                        style: interText(12, myColors.green,
                                            FontWeight.w400),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: myColors.divider,
                        )
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
