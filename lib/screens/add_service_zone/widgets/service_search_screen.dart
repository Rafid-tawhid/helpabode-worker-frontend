import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/custom_bottom_button.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_service_zone/widgets/search_item.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../provider/addnew_services_provider.dart';

class ServiceSearchScreen extends StatefulWidget {
  const ServiceSearchScreen({super.key});

  @override
  State<ServiceSearchScreen> createState() => _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  final TextEditingController _searchCon = TextEditingController();
  String searchVal = '';

  @override
  void initState() {
    setSomeInitialSearchItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Consumer<AddNewServiceProvider>(
                    builder: (context, pro, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFE9E9E9),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextFormField(
                          controller: _searchCon,
                          decoration: InputDecoration(
                            hintText: 'Search by service and category',
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
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
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
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            suffixIcon: _searchCon.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _searchCon.clear();
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
                          onChanged: (val) async {
                            if (_searchCon.text.length >= 2) {
                              pro.searchInServiceList(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<AddNewServiceProvider>(
                  builder: (context, pro, _) => Stack(
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Column(
                                children: pro.searchServiceListFilter
                                    .map((e) => SearchServiceItem(e))
                                    .toList(),
                              ),
                            ),
                          ),
                          pro.searchSelectedServiceList.length > 0
                              ? Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: CustomBottomButton(
                                      btnText: 'Save',
                                      onpressed: () {
                                        //add services to edit area screen to show service
                                        // var asp=context.read<AddNewServiceProvider>();
                                        // asp.zoneServiceModelList;
                                        Navigator.pop(context);
                                      }),
                                )
                              : SizedBox.shrink()
                        ],
                      )),
            )
          ],
        ),
      ),
    );
  }

  void setSomeInitialSearchItem() async {
    Future.microtask(() {
      var asp = context.read<AddNewServiceProvider>();
      asp.searchInServiceList('');
    });
  }
}
