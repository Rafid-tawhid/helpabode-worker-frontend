import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _feedbackController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedEmoji;
  bool _isFeedbackSubmitted = false;

  void _submitFeedback() {
    print('Feedback submitted: ${_feedbackController.text}');
    setState(() {
      _isFeedbackSubmitted = true;
    });
    _feedbackController.clear();
  }

  void _selectEmoji(String emoji) {
    setState(() {
      if (_selectedEmoji == emoji) {
        _selectedEmoji = null;
      } else {
        _selectedEmoji = emoji;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToFeedbackForm();
        });
      }
    });
  }

  void _scrollToFeedbackForm() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help Center',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to the Help Center. Search for solutions to common issues or explore our detailed guides below.',
              style: TextStyle(fontSize: 14, color: Color(0xff767676)),
            ),
            SizedBox(height: 24),
            Text(
              'Top FAQs:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            AccordionItem(
              title: 'How do I reset my password?',
              content:
                  'You can reset your password by clicking ‘Forgot Password’ on the login screen. Follow the prompts to receive a reset link via email.',
            ),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            AccordionItem(
              title: 'How do I update my payment information?',
              content:
                  'Go to ‘Account Settings’ > ‘Payment Information’ and update your details. Ensure all information is correct to avoid delays in payouts.',
            ),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            SizedBox(height: 16),
            Text(
              'Guides (Example for Account Management)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            AccordionItem(
              title: 'Setting Up Your Account',
              content:
                  'Follow these steps to create your account and start using our services. We’ll guide you through each step, from signing up to verifying your email.',
            ),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            AccordionItem(
              title: 'Managing Your Profile',
              content:
                  'Keep your profile up-to-date. Learn how to edit your personal information, add a profile picture, and set your preferences.',
            ),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            AccordionItem(
              title: 'Troubleshooting Flowchart (Example for Technical Issues)',
              content:
                  'Having trouble with the app? Follow this flowchart to diagnose and resolve common issues, like app crashes or login problems',
            ),
            Divider(thickness: 1, color: Color(0xffe9e9e9)),
            SizedBox(height: 24),
            Text(
              'We value your feedback!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEmojiButton('😄'),
                _buildEmojiButton('😊'),
                _buildEmojiButton('😐'),
                _buildEmojiButton('😞'),
                _buildEmojiButton('😡'),
              ],
            ),
            SizedBox(height: 16),
            if (_selectedEmoji != null && !_isFeedbackSubmitted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You selected $_selectedEmoji. Please provide more details:',
                    style: TextStyle(fontSize: 14, color: Color(0xff767676)),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your feedback here',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      backgroundColor: Color(0xff008951),
                    ),
                    onPressed: _submitFeedback,
                    child: Text(
                      'Submit Feedback',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            if (_isFeedbackSubmitted)
              Text(
                'Thank you for your feedback!',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return GestureDetector(
      onTap: () => _selectEmoji(emoji),
      child: Text(
        emoji,
        style: TextStyle(
          fontSize: 36,
          color: _selectedEmoji == emoji ? Colors.blue : Colors.black,
        ),
      ),
    );
  }
}

class AccordionItem extends StatefulWidget {
  final String title;
  final String content;

  AccordionItem({required this.title, required this.content});

  @override
  _AccordionItemState createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: Text(
              widget.content,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
      ],
    );
  }
}
