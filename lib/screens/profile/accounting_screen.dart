import 'package:flutter/material.dart';

class AccountingScreen extends StatelessWidget {
  String? title;

  AccountingScreen({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title == null ? 'Accounting Screen' : title.toString()),
      ),
      body: Column(
        children: [Expanded(child: Center(child: Text('Under Construction')))],
      ),
    );
  }
}
