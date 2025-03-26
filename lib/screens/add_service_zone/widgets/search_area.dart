import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:provider/provider.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by zone or service...',
          hintStyle: interText(14, Color(0xff636366), FontWeight.w400)
              .copyWith(letterSpacing: 0),
          filled: true,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 24,
          ),
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Set border radius
            borderSide: BorderSide.none, // Remove border
          ),
        ),
        onChanged: (val) {
          var ansp = context.read<AddNewServiceProvider>();
          ansp.searchWithZoneName(val);
        },
      ),
    );
  }
}
