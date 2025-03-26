import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.label});

  final label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 20),
      height: 60,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    //color: Colors.blue,
                    height: 60,
                    width: 70,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back)),
                  ),
                ],
              ),
            ),
          ),
          Text(
            label,
            style: interText(16, Colors.black, FontWeight.w600),
          ),
          SizedBox(
            height: 60,
            width: 60,
          ),
        ],
      ),
    );
  }
}
