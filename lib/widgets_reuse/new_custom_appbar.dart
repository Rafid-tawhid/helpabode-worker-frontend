import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomAppBarNew extends StatelessWidget {
  final String title;
  final IconData? iconData;

  const CustomAppBarNew({
    Key? key,
    required this.title,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        Expanded(
          child: Text(title,
              textAlign: TextAlign.center,
              style: interText(16, Colors.black, FontWeight.w700)),
        ),

        // Container(
        //   margin: const EdgeInsets.only(right: 16),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(color: Colors.black, width: 1),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(2.0),
        //     child: Icon(
        //       iconData,
        //       size: 18,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
