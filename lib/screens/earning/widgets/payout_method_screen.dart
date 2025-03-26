import 'package:flutter/material.dart';

import '../../../misc/constants.dart';
import 'add_bank account.dart';

class PayoutMethodsPage extends StatefulWidget {
  const PayoutMethodsPage({super.key});

  @override
  State<PayoutMethodsPage> createState() => _PayoutMethodsPageState();
}

class _PayoutMethodsPageState extends State<PayoutMethodsPage> {
  int _selectedCardIndex = 0; // Index of the selected card

  void _onCardTapped(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey, // Set a distinct shadow color
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          'Payout Methods',
          style: interText(16, Colors.black, FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current',
                style: interText(22, Colors.black, FontWeight.w600)),
            const SizedBox(height: 16),
            _buildSelectableCard(
              index: 0,
              title: 'Monthly payout',
              fee: 'Free',
              day: 'Every Monday',
              showBankDetails: true,
              bankDetails: '** ** **** 2891',
              showEditButton: true,
            ),
            const SizedBox(height: 20),
            Text('Available',
                style: interText(22, Colors.black, FontWeight.w600)),
            const SizedBox(height: 10),
            _buildSelectableCard(
              index: 1,
              title: 'Weekly payout',
              fee: 'Free',
              day: 'Every Monday',
            ),
            const SizedBox(height: 10),
            _buildSelectableCard(
              index: 2,
              title: 'Daily payout',
              fee: '\$1.65 fee',
              day: 'Every Monday',
            ),
          ],
        ),
      ),
    );
  }

  // Widget for selectable payout cards
  Widget _buildSelectableCard({
    required int index,
    required String title,
    required String fee,
    required String day,
    bool showBankDetails = false,
    String bankDetails = '',
    bool showEditButton = false,
  }) {
    final bool isSelected = _selectedCardIndex == index;

    return GestureDetector(
      onTap: () => _onCardTapped(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xffe9e9e9),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: interText(18, Colors.black, FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 20),
                const SizedBox(width: 8),
                Text(
                  fee,
                  style: interText(16, Colors.black, FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Every Monday',
                        style: interText(16, Colors.black, FontWeight.w500),
                      ),
                      TextSpan(
                          text: ' • 3 day processing',
                          style: interText(16, Colors.grey, FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
            if (showBankDetails) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('assets/mastercard.png', height: 24, width: 24,
                      errorBuilder: (a, _, ___) {
                    return const Icon(Icons.credit_card, size: 24);
                  }),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank account',
                        style: interText(12, Colors.grey, FontWeight.w400),
                      ),
                      Text(
                        bankDetails,
                        style: interText(12, Colors.black, FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 9),
              Text(
                'Bank Account',
                style: interText(14, Colors.grey, FontWeight.w400),
              )
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => AddBankAccountBottomSheet(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    index == 0 ? 'Cashout' : 'Add a Bank Account',
                    style: interText(14, Colors.black, FontWeight.w500),
                  ),
                ),
                if (showEditButton) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: interText(14, Colors.black, FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
