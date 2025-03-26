import 'package:flutter/material.dart';

class CallSupportScreen extends StatefulWidget {
  @override
  _CallSupportScreenState createState() => _CallSupportScreenState();
}

class _CallSupportScreenState extends State<CallSupportScreen> {
  final List<Map<String, dynamic>> supportTopics = [
    {
      "title": "General issues while Ordering",
      "expanded": false,
      "details": [
        {
          "subTitle": "Unable to place an order",
          "instructions": [
            "Check your internet connection.",
            "Restart the app and try again.",
          ],
        },
      ],
    },
    {
      "title": "Issues at the location",
      "expanded": false,
      "details": [
        {
          "subTitle": "Unable to find the location",
          "instructions": [
            "Verify the address and check your GPS settings.",
            "Contact the customer for precise directions.",
          ],
        },
      ],
    },
    {
      "title": "Issues with working with the customer",
      "expanded": false,
      "details": [
        {
          "subTitle": "Customer not responding",
          "instructions": [
            "Try calling or messaging the customer.",
            "Leave a message explaining the situation.",
          ],
        },
      ],
    },
  ];

  void toggleExpand(int index) {
    setState(() {
      supportTopics[index]['expanded'] = !supportTopics[index]['expanded'];
    });
  }

  void _callSupport() {
    // Implement call support functionality here
    print("Calling support...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Call Support'),
      ),
      body: ListView.builder(
        itemCount: supportTopics.length,
        itemBuilder: (context, index) {
          final topic = supportTopics[index];
          return Card(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(topic['title']),
                  trailing: Icon(
                    topic['expanded'] ? Icons.expand_less : Icons.expand_more,
                  ),
                  onTap: () => toggleExpand(index),
                ),
                if (topic['expanded'])
                  ...topic['details'].map<Widget>((detail) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['subTitle'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...detail['instructions'].map<Widget>((instruction) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(instruction),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                if (topic['expanded'])
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: _callSupport,
                      icon: Icon(Icons.phone),
                      label: Text("Call Support"),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
