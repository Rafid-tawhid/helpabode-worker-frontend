import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';

Widget CircularProfileImage(String imageUrl, String firstName, String? lastName,
    Color borderColor, double? size) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // Shadow color with opacity
          blurRadius: 2, // Blur radius
          spreadRadius: 1, // Spread radius
          offset: Offset(0, 1), // Shadow position
        ),
      ],
    ),
    child: ClipOval(
      child: Image.network(
        imageUrl,
        width: size ?? 88,
        height: size ?? 88,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child; // When image is loaded, show the image
          } else {
            return Container(
              width: size ?? 88,
              height: size ?? 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Text(
                DashboardHelpers.getFirstCharacterCombinationName(
                    firstName, lastName),
                style: TextStyle(
                  fontSize: size == null ? 20 : 16,
                  color: borderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size ?? 88,
            height: size ?? 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Text(
              DashboardHelpers.getFirstCharacterCombinationName(
                  firstName, lastName),
              style: TextStyle(
                fontSize: 20,
                color: borderColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    ),
  );
}

class MyImageWidget extends StatelessWidget {
  final String imageUrl;
  final String firstName;
  final String? lastName;
  final Color? borderColor;
  final double? size;

  const MyImageWidget({
    Key? key,
    required this.imageUrl,
    required this.firstName,
    this.lastName,
    this.borderColor,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 88,
      width: size ?? 88,
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/png/person2.png',
          image: imageUrl,
          height: size ?? 88,
          width: size ?? 88,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: size ?? 88,
      width: size ?? 88,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border:
            Border.all(color: myColors.green ?? Colors.transparent, width: 2),
      ),
      child: Text(
        DashboardHelpers.getFirstCharacterCombinationName(firstName, lastName),
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
