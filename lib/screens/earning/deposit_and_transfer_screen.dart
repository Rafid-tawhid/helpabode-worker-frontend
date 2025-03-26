import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../misc/constants.dart';
import '../../provider/navbar_provider.dart';

class DepositAndTransferScreen extends StatelessWidget {
  const DepositAndTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Withdraw and transfers',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
                onTap: () {
                  var pp = context.read<TabControllerProvider>();
                  pp.updateNavBarAtInitialStage(context, 0);
                  Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => DashboardScreen()))
                      .then((val) {});
                },
                child: SvgPicture.asset('assets/svg/bank_icon.svg')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Available Balance',
                    style: interText(14, Colors.black, FontWeight.w700),
                  ),
                  Text(
                    '\$339.33',
                    style: interText(26, Colors.black, FontWeight.w700),
                  ),
                  Text('Weekly auto transfer will initiate on 1/16'),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        DashboardHelpers.showAlert(msg: 'Under development');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: myColors.greyBtn),
                      child: Text(
                        'Add Bank Account',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                onTap: () {
                  DashboardHelpers.showAlert(msg: 'Under development');
                },
                child: Text(
                  'Deposited to bank',
                  style: interText(18, Colors.black, FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: myColors.devider,
            ),
            ...List.generate(
                100,
                (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Tuesday, Feb 13',
                                              style: interText(16, Colors.black,
                                                  FontWeight.w500),
                                            ),
                                            Spacer(),
                                            Text(
                                              '\$23.99',
                                              style: interText(16, Colors.black,
                                                  FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Transaction# AG-20230910-178-001',
                                              style: interText(10, Colors.black,
                                                  FontWeight.w500),
                                            ),
                                            Spacer(),
                                            Text(
                                              'Weekly deposit',
                                              style: interText(10, Colors.black,
                                                  FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: .2,
                                color: myColors.greyTxt,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
