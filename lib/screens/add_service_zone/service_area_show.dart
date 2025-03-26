import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_service_zone/widgets/search_area.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_service_zone/widgets/service_list.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_service_zone/widgets/zone_list.dart';
import 'package:provider/provider.dart';

class MyServiceArea extends StatefulWidget {
  const MyServiceArea({super.key});

  @override
  State<MyServiceArea> createState() => _MyServiceAreaState();
}

class _MyServiceAreaState extends State<MyServiceArea> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pro = Provider.of<AddNewServiceProvider>(context, listen: false);
      pro.getMyAllServiceAreaWIthAllInfo();
      pro.getAllServicesToSearch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff9fafb),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Service Areas',
            style: interText(16, Colors.black, FontWeight.w600),
          ),
        ),
        //  bottomNavigationBar: const MyBottomNavBar(),
        body: SafeArea(
            child: Column(
          children: [
            SearchTextField(),
            HorizontalServicesList(),
            Expanded(child: ZoneListView())
          ],
        )));
  }
}
