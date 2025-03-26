import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../helper_functions/colors.dart';
import '../../../helper_functions/dashboard_helpers.dart';
import '../../../models/pending_service_details_model.dart';
import '../../../widgets_reuse/custom_rounded_button.dart';
import '../../dashboard/dashboard_screen.dart';

class CancelOrderScreen extends StatefulWidget {
  final PendingServiceDetailsModel item;

  const CancelOrderScreen(this.item, {Key? key}) : super(key: key);

  @override
  CancelOrderScreenState createState() => CancelOrderScreenState();
}

class CancelOrderScreenState extends State<CancelOrderScreen> {
  String _selectedReason = 'I changed my mind';
  final List<Map<String, String>> _reasons = [
    {'title': 'Order is taking too long', 'value': 'Order is taking too long'},
    {'title': 'Wrong address', 'value': 'Wrong address'},
    {'title': 'I changed my mind', 'value': 'I changed my mind'},
    {
      'title': 'Order needs to be modified',
      'value': 'Order needs to be modified'
    },
    {'title': 'Other', 'value': 'Other'},
  ];

  final TextEditingController _commentController = TextEditingController();
  String _commentValidationMessage = '';
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  void _onReasonChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedReason = value;
      _commentValidationMessage = '';
      _commentController.clear();
    });
  }

  void _validateComment() {
    setState(() {
      _commentValidationMessage = _commentController.text.length < 30
          ? 'Must be a minimum of 30 characters'
          : '';
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: _reasons.length + 1, // +1 for the button
              itemBuilder: (context, index) {
                if (index == _reasons.length) {
                  return CustomRoundedButton(
                    label: 'Reject',
                    funcName: () async {
                      if (_selectedReason == 'Other') {
                        _selectedReason = _commentController.text.trim();
                      }
                      _btnController2.start();
                      final order = widget.item;
                      final provider = context.read<OrderProvider>();
                      final output = await provider.workerServiceRequestReject(
                        order.orderItemId.toString(),
                        order.serviceTextId ?? '',
                        _selectedReason,
                      );

                      output
                          ? DashboardHelpers.successStopAnimation(
                              _btnController2)
                          : DashboardHelpers.errorStopAnimation(
                              _btnController2);
                      if (output) {
                        DashboardHelpers.showAlert(msg: 'Order is cancelled');
                        calltonavigate();
                      }
                    },
                    buttonColor: myColors.green,
                    fontColor: Colors.white,
                    borderRadius: 12,
                    controller: _btnController2,
                  );
                } else {
                  final isSelected =
                      _selectedReason == _reasons[index]['value'];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Transform.scale(
                          scale: 1.5,
                          child: Radio<String>(
                            value: _reasons[index]['value']!,
                            groupValue: _selectedReason,
                            activeColor: const Color(0xFF008951),
                            onChanged: _onReasonChanged,
                          ),
                        ),
                        title: Text(
                          _reasons[index]['title']!,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF008951)
                                : Colors.black,
                          ),
                        ),
                        onTap: () => _onReasonChanged(_reasons[index]['value']),
                      ),
                      if (_reasons[index]['value'] == 'Other' && isSelected)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _commentController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: 'Please specify',
                                  labelStyle: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                maxLines: 3,
                                onChanged: (_) => _validateComment(),
                                onSubmitted: (v) {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                              const SizedBox(height: 8),
                              if (_commentController.text.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (_commentValidationMessage.isNotEmpty)
                                      Text(
                                        _commentValidationMessage,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    Text(
                                      '${_commentController.text.length}/30',
                                      style: TextStyle(
                                        color:
                                            _commentController.text.length < 30
                                                ? Colors.red
                                                : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void calltonavigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }
}
