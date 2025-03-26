import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/common_screen/show_images_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WorkStatusStaticScreen extends StatefulWidget {
  @override
  State<WorkStatusStaticScreen> createState() => _WorkStatusStaticScreenState();
}

class _WorkStatusStaticScreenState extends State<WorkStatusStaticScreen> {
  // WorkStatusStaticScreen(this.orderInfo);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0, // No elevation
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<UserProvider>(
                builder: (context, provider, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Take photos of your work status',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Before you start your work, please follow these steps',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF535151),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/png/img1.png',
                                width: 164,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/png/img2.png',
                                width: 164,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/png/img3.png',
                                width: 164,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/png/img4.png',
                                width: 164,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Examples of high-quality photos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF636363),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.done,
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF636363),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Clear View: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Ensure the entire room is visible in the photo.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.done,
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF636363),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Good Lighting: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Ensure good lighting for a clear picture.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.done,
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF636363),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Multiple Angles: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Take multiple shots if necessary.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.done,
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF636363),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Details: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Pay attention to specific areas that need work.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Repeat the above structure for the remaining two texts
                        ],
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Container(color: Colors.white, child: _footerCTA()),
          ),
        ],
      ),
    );
  }

  Consumer<OrderProvider> _footerCTA() {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading == false
                  ? () async {
                      setState(() {
                        isLoading = true;
                      });

                      final image = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );
                      setState(() {
                        isLoading = false;
                      });
                      if (image != null) {
                        final imageTemp = File(image.path);
                        provider.addToCameraList(imageTemp);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowImageScreeen(type: 'camera')));
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008951),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Take Photo',
                      style: interText(16, Colors.white, FontWeight.w600),
                    ),
            ),
          ),
          const SizedBox(height: 12), // Add spacing between buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedFiles = await picker.pickMultiImage(
                  maxWidth: 800,
                  maxHeight: 800,
                  imageQuality: 100,
                );
                if (pickedFiles.isNotEmpty) {
                  pickedFiles.forEach((element) {
                    provider.addToCameraList(File(element.path));
                  });

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowImageScreeen(type: 'gallery')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe9e9e9),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Add Photo from Library',
                style: interText(16, Colors.black, FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
