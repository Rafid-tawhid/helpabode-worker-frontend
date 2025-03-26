import 'package:flutter/material.dart';

class MyCustomBackButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback for the button press action

  const MyCustomBackButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          border: Border.all(color: Colors.white, width: 2), // White border
        ),
        child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 22,
              ),
            )),
      ),
    );
  }
}
