import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoBottomSheetExample extends StatelessWidget {
  void _showCupertinoBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Choose an Option'),
          message: Text('Select one of the following actions:'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                print('Option 1 selected');
              },
              child: Text('Option 1'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                print('Option 2 selected');
              },
              child: Text('Option 2'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                print('Option 3 selected');
              },
              child: Text('Option 3'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            isDefaultAction: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cupertino Bottom Sheet')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showCupertinoBottomSheet(context),
          child: Text('Show Cupertino Bottom Sheet'),
        ),
      ),
    );
  }
}
