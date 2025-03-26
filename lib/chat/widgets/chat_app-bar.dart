// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import '../../auth/helper.dart';

class ChatScreenAppBar extends StatelessWidget {
  final String? name;

  ChatScreenAppBar({required this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Helper.back(context);
              },
              icon: Icon(Icons.close),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(44),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(44),
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name ?? "Drake Danvers",
                  style: interText(
                    16,
                    Colors.black,
                    FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Online",
                    style: interText(12, Colors.black, FontWeight.w600)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(msg: "Need to configure call system");
              },
              child: Container(
                width: 21,
                height: 21,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(21)),
                child: Icon(
                  Icons.phone,
                  color: Color(0xFF008951),
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
