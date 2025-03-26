import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ShowChartOptions extends StatefulWidget {
  final String type;
  final String? selectFillterd;
  final Function(String title, String date) onSelected;
  final Function(String title, String rangeType, int daysBack)?
      onFilterSelected;

  const ShowChartOptions({
    required this.type,
    required this.onSelected,
    this.selectFillterd,
    this.onFilterSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<ShowChartOptions> createState() => _ShowChartOptionsState();
}

class _ShowChartOptionsState extends State<ShowChartOptions> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    // Optionally initialize selected filter
    selectedFilter = widget.selectFillterd;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 8, bottom: 12),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffe9e9e9)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text('Date Ranges',
                  style: interText(20, Colors.black, FontWeight.w600)),
            ),
          ),
          Divider(color: Color(0xfff6f6f6), height: 1),
          CustomRadioListTile(
            title: 'Last 7 days',
            isSelected: selectedFilter == 'Last 7 days',
            onSelected: () =>
                handleSelection(context, 'Last 7 days', 'weekly', 7),
          ),
          CustomRadioListTile(
            title: 'Last 30 days',
            isSelected: selectedFilter == 'Last 30 days',
            onSelected: () =>
                handleSelection(context, 'Last 30 days', 'monthly', 30),
          ),
          CustomRadioListTile(
            title: 'Money made all times',
            isSelected: selectedFilter == 'Money made all times',
            onSelected: () =>
                handleSelection(context, 'Money made all times', 'yearly', 365),
          ),
        ],
      ),
    );
  }

  Future<void> handleSelection(
    BuildContext context,
    String title,
    String rangeType,
    int daysBack,
  ) async {
    setState(() {
      selectedFilter = title;
    });

    final userProvider = context.read<UserProvider>();
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: daysBack));

    String start_date =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    String end_date =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

    Map<String, dynamic> filterDate = {
      "start_date": start_date,
      "end_date": end_date,
      "range_type": rangeType,
    };

    if (widget.type == 'earning') {
      await userProvider.getEarningHistory(
          date: filterDate, callDefault: daysBack > 31 ? 'get' : '');
    }
    if (widget.type == 'tips') {
      await userProvider.getTipManagement(
          date: filterDate, callDefault: daysBack > 31 ? 'get' : '');
    }

    widget.onSelected(title, '$start_date $end_date');
    Navigator.pop(context); // Close modal

    // Notify parent if `onFilterSelected` is provided
    widget.onFilterSelected?.call(title, rangeType, daysBack);
  }
}

class CustomRadioListTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onSelected;

  const CustomRadioListTile({
    required this.title,
    required this.isSelected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title,
                  style: interText(16, Colors.black, FontWeight.w600),
                ),
              ),
            ),
            isSelected
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black, width: 1.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.circle,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  )
                : Icon(
                    Icons.circle_outlined,
                    color: Colors.black,
                    size: 26,
                  ),
          ],
        ),
      ),
    );
  }
}
