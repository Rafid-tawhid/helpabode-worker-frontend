import 'package:flutter/material.dart';

class CircularImageDisplay extends StatelessWidget {
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String email;
  final double size;
  final TextStyle? nameStyle;
  final TextStyle? emailStyle;

  const CircularImageDisplay({
    Key? key,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.size = 160,
    this.nameStyle,
    this.emailStyle,
  }) : super(key: key);

  String getInitials(String firstName, String lastName) {
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: size,
            width: size,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 4, color: Colors.white),
                borderRadius: BorderRadius.circular(size / 2),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x0C11111A),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                height: size - 10,
                width: size - 10,
                alignment: Alignment.center,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      height: size - 10,
                      width: size - 10,
                      alignment: Alignment.center,
                      child: Text(
                        getInitials(firstName, lastName),
                        style: nameStyle ??
                            TextStyle(
                                fontSize: size / 5,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: size - 10,
                    width: size - 10,
                    alignment: Alignment.center,
                    child: Text(
                      getInitials(firstName, lastName),
                      style: nameStyle ??
                          TextStyle(
                              fontSize: size / 5,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$firstName $lastName',
            style: nameStyle ??
                TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
          ),
          Text(
            email,
            style: emailStyle ??
                TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}
