import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final double size;
  final Color borderColor;
  final double borderWidth;
  final Color initialsColor;

  UserProfileImage({
    required this.imageUrl,
    required this.fullName,
    this.size = 80.0,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.initialsColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('imageUrl $imageUrl');
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl ?? '',
            height: size,
            width: size,
            alignment: Alignment.center,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return _buildInitialsContainer();
              }
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return _buildInitialsContainer();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsContainer() {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      child: Text(
        _getInitials(fullName),
        style: TextStyle(
            fontSize: size / 3.5,
            fontWeight: FontWeight.bold,
            color: initialsColor),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) {
      return '';
    }
    List<String> nameParts = name.split(' ');
    String firstInitial =
        nameParts.isNotEmpty ? nameParts.first[0].toUpperCase() : '';
    String lastInitial =
        nameParts.length > 1 ? nameParts.last[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }
}
