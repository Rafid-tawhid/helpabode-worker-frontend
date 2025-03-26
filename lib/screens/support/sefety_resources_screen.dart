import 'package:flutter/material.dart';

import '../../misc/constants.dart';

class SafetySupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 80), // Padding to prevent footer overlap
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with background image and cross icon
                  Stack(
                    children: [
                      _buildHeaderImage(),
                      Positioned(
                        top: 48,
                        left: 16,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.black, size: 20),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Safety Resources',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Welcome to Safety Resources! Your safety is our top priority. Explore the categories below to find tips and best practices.',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff767676)),
                        ),
                        // Safety options list using ListView.builder
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics:
                              NeverScrollableScrollPhysics(), // Disable inner scrolling
                          shrinkWrap: true,
                          itemCount: PendingRequested.safetyOptions.length,
                          itemBuilder: (context, index) {
                            return _buildSafetyOption(
                              imagePath: PendingRequested.safetyOptions[index]
                                  ['imagePath'],
                              title: PendingRequested.safetyOptions[index]
                                  ['title'],
                              description: PendingRequested.safetyOptions[index]
                                  ['description'],
                            );
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed Footer at the bottom of the screen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  // Header background image with avatar
  Widget _buildHeaderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/png/instructions.png'), // Replace with your image asset
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Individual safety option using ListTile
  Widget _buildSafetyOption({
    required String imagePath, // Path to the PNG image
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PNG Image section
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Image.asset(
              imagePath, // Path to the image
              width: 48, // Set the width of the image
              height: 48, // Set the height of the image
            ),
          ),
          // Title and description on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Footer section with lock icon
  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(Icons.lock, color: Colors.grey),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'We’ll encrypt your info and store it securely, and only use it to verify your identity.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
