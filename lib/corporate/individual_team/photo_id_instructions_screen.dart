import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../widgets_reuse/custom_rounded_button.dart';

class PhotoIdInstructionsScreen extends StatelessWidget {
  File? front;
  File? back;
  String? form;

  PhotoIdInstructionsScreen({this.front, this.back, this.form});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    List<String> instructionList = [
      'Your ID hasn’t expired',
      'It’s entirely in the frame',
      'All your details can be seen',
      'It’s clear and easy to read'
    ];

    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/png/instructions.png',
                height: 200,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 44),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take Photo of Your \n(Driver’s License)',
                  style: interText(22, Colors.black, FontWeight.bold),
                ),
                Text(
                  'We require a photo of a government-issued ID to verify your identity.',
                  style: interText(14, myColors.greyTxt, FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFF6F6F6),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Make sure that',
                          style:
                              interText(14, myColors.greyTxt, FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              ...instructionList
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              e,
                                              style: interText(14, Colors.black,
                                                  FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        )),
                  ],
                ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Text(
                                  'We’ll encrypt your info and store it securely. and only use it to verify your identity.'))
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF6F6F6),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomRoundedButton(
                    height: 44,
                    label: 'Submit Document',
                    buttonColor: myColors.green,
                    fontColor: Colors.white,
                    funcName: () {},
                    borderRadius: 8,
                    controller: _btnController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
