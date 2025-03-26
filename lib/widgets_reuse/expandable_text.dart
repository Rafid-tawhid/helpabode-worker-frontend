import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/pending_price_view_details_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../screens/pricing/widgets/show_service_attribute_animation.dart';

class ExpandText extends StatefulWidget {
  final String text;
  final int maxLines;
  final bool position;
  final String? pricingBy;
  final bool? showOpacity;
  final bool? showAttributes;
  final String? end;
  // final PendingRequestedServiceList? serviceModel;
  final Color? bgColor;
  final Color? txtColor;
  final Color? seeMoreColor;
  final List<PendingAttribute>? pendingAttributes;
  ExpandText(
      {required this.text,
      required this.maxLines,
      this.position = false,
      this.end,
      this.pricingBy,
      this.bgColor,
      this.txtColor,
      this.seeMoreColor,
      this.showOpacity,
      this.showAttributes,
      this.pendingAttributes});

  @override
  State<ExpandText> createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText>
    with SingleTickerProviderStateMixin {
  late bool isExpanded;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            // vsync: this,
            duration:
                Duration(milliseconds: 500), // Adjust the duration as needed
            child: SizedBox(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      widget.text,
                      maxLines: isExpanded ? null : widget.maxLines,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                      style: interText(
                          14, widget.txtColor ?? Colors.black, FontWeight.w400),
                    ),
                  ),
                  if (widget.showOpacity != false)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: isExpanded ||
                                NecessaryMethods.calculateLineCount(
                                      widget.text,
                                      MediaQuery.of(context).size.width - 40,
                                    ) <=
                                    3
                            ? 0
                            : 25,
                        color: Colors.red.withOpacity(.5),
                      ),
                    ),
                ],
              ),
            ),
          ),
          //visible: true: NecessaryMethods.calculateLineCount(widget.text, MediaQuery.of(context).size.width - 40) > 3
          Visibility(
            visible: true,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                  isExpanded ? _controller.forward() : _controller.reverse();
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: widget.end == 'end'
                    ? MainAxisAlignment.end
                    : widget.position == true
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      isExpanded ? 'See Less' : 'See More',
                      style: interText(
                          12,
                          widget.seeMoreColor ?? myColors.green,
                          FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 4),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * pi,
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          if (widget.pricingBy != 'Bundle' &&
              isExpanded == true &&
              widget.pendingAttributes != null)
            ShowServiceAttributes(widget.pendingAttributes ?? []),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NecessaryMethods {
  static int calculateLineCount(String text, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16.0), // Set your desired font size
      ),
      maxLines: 100, // A large number to ensure accurate measurement
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }

  static String formatNumber(double number) {
    // Check if the number has decimal places
    if (number % 1 == 0) {
      // It's an integer, format with two decimal places
      return number.toStringAsFixed(2);
    } else {
      // It's a double, format without trailing zeros
      return number.toStringAsFixed(2);
    }
  }

  static bool sameDateCheck(DateTime date1, date2) {
    DateTime date1WithoutTime = DateTime(date1.year, date1.month, date1.day);
    DateTime date2WithoutTime = DateTime(date2.year, date2.month, date2.day);

    return date1WithoutTime == date2WithoutTime;
  }

  static String detectCard(String cardName) {
    switch (cardName) {
      case 'visa':
        // Visa card
        return 'assets/png/visa.png';
      case 'mastercard':
        // MasterCard
        return 'assets/png/mastercard.png';
      case 'americanExpress':
        // American Express
        return 'assets/png/american_express.png';
      case 'unionpay':
        // American Express
        return 'assets/png/unionPay.png';
      case 'jcb':
        // American Express
        return 'assets/png/jcb-card.png';
      case 'discover':
        // American Express
        return 'assets/png/discover-card.png';
      default:
        // Default image or error handling
        return 'assets/png/default_card.png';
    }
  }

  static Future<XFile?> pickImage(BuildContext context,
      {bool? isCamera}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      // Convert XFile to File
      File imageFile = File(pickedFile.path);

      // Get a temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Define the output path for the compressed image
      String targetPath =
          path.join(tempPath, 'compressed_${path.basename(pickedFile.path)}');

      // Compress the image
      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 30, // Adjust the quality as needed (0-100)
      );

      if (result != null) {
        // Use the compressed image file
        debugPrint(
            "-----------__________-Image compressed successfully--__________!!!!!");
        imageFile = File(result.toString());
      }
      return result;
    }
    return null;
  }

  static Future<List<XFile>?> pickMultiImage(
    BuildContext context,
  ) async {
    List<XFile> resultList = [];
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFileList = await picker.pickMultiImage();

    if (pickedFileList != null) {
      for (var pickedFile in pickedFileList) {
        // Convert XFile to File
        File imageFile = File(pickedFile.path);

        // Get a temporary directory
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Define the output path for the compressed image
        String targetPath =
            path.join(tempPath, 'compressed_${path.basename(pickedFile.path)}');

        // Compress the image
        var result = await FlutterImageCompress.compressAndGetFile(
          imageFile.absolute.path,
          targetPath,
          quality: 70, // Adjust the quality as needed (0-100)
        );

        if (result != null) {
          // Use the compressed image file
          debugPrint(
              "-----------__________-Image compressed successfully--__________!!!!!");
          imageFile = File(result.toString());
          resultList.add(result);
        }
      }
    }
    return resultList.isEmpty ? null : resultList;
  }
}
