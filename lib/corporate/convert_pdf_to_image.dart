import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/colors.dart';
import '../../../provider/corporate_provider.dart';
import 'corporate_documents.dart';

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl(
      {Key? key, required this.url, required this.title})
      : super(key: key);
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
            child: const PDF().cachedFromUrl(
              url,
              placeholder: (double progress) =>
                  Center(child: Text('$progress %')),
              errorWidget: (dynamic error) =>
                  Center(child: Text(error.toString())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      var cp = context.read<CorporateProvider>();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CorporateDocuments(
                                  corporateReviewDataModel:
                                      cp.corporateReviewDataModel)));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: myColors.green),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: myColors.green),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
