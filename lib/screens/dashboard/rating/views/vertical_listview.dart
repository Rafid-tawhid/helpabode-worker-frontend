import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import '../../../../helper_functions/colors.dart';

class HorizontalSelectionList extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final ValueChanged<dynamic> onSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const HorizontalSelectionList({
    Key? key,
    required this.items,
    required this.onSelected,
    this.selectedColor = Colors.green,
    this.unselectedColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black,
  }) : super(key: key);

  @override
  _HorizontalSelectionListState createState() =>
      _HorizontalSelectionListState();
}

class _HorizontalSelectionListState extends State<HorizontalSelectionList> {
  String selectedItem = 'All Service';

  @override
  Widget build(BuildContext context) {
    // Define the dummy item
    final dummyItem = {
      "serviceTextId": "",
      "serviceTitle": "All Service",
      "categoryTextId": ""
    };

    // Create a new list with the dummy item at the start
    final List<Map<String, dynamic>> updatedItems = [
      dummyItem,
      ...widget.items
    ];

    return Container(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: updatedItems.length,
        itemBuilder: (context, index) {
          final item = updatedItems[index];
          final isSelected = selectedItem == item['serviceTitle'];

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedItem = item['serviceTitle'];
                });
                widget.onSelected(item); // Pass selected value back
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.selectedColor
                      : widget.unselectedColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade200, width: .5),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                  child: Text(
                    item['serviceTitle'],
                    style: interText(
                        14,
                        isSelected
                            ? widget.selectedTextColor
                            : widget.unselectedTextColor,
                        FontWeight.w500),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
