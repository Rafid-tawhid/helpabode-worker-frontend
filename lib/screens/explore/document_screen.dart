import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_review_data_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/worker_pending_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/explore/selfy_submit_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/explore/ssn_update_screen.dart';
import 'package:provider/provider.dart';

import '../../corporate/corporate_documents.dart';
import '../../misc/constants.dart';
import 'driving_license_submit_screen.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider =
          Provider.of<WorkerPendingProvider>(context, listen: false);
      provider.getDocumentValidationCheck().then((_) {
        for (var e in provider.documentationList) {
          if (e.status == 'Error') {
            Future.delayed(Duration(seconds: 2), () {
              DashboardHelpers.showAnimatedDialog(
                  context, e.popupDetails ?? '', e.popupTitle);
            });
          }
        }
      });
    });
  }

  List<String> docInfo = [
    'Profile Photo',
    'Driving License',
    'SSN (Social Security Number)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<WorkerPendingProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Documents', 30),
                const SizedBox(height: 32),
                Expanded(
                  child: provider.showLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: myColors.green,
                          ),
                        )
                      : Column(
                          children: provider.documentationList
                              .map((item) => GestureDetector(
                                    onTap: () async {
                                      if (item.stage == 'PhotoId Required' &&
                                          item.status == 'Error') {
                                        EasyLoading.show(
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        debugPrint(
                                            'postDocumentValidationUpdate ');
                                        await provider
                                            .postDocumentValidationUpdate(
                                                'PhotoId Required');
                                        EasyLoading.dismiss();
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    DrivingLicenseSubmitScreen(
                                                      idNo: provider
                                                          .documentUpdateInfoList
                                                          .first
                                                          .photoIdNo,
                                                      date: provider
                                                          .documentUpdateInfoList
                                                          .first
                                                          .photoIdExpirationDate,
                                                    )));
                                      } else if (item.stage ==
                                              'Selfie Required' &&
                                          item.status == 'Error') {
                                        EasyLoading.show(
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        await provider
                                            .postDocumentValidationUpdate(
                                                'Selfie Required');
                                        EasyLoading.dismiss();
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    SelfieUploadScreen()));
                                      } else if (item.stage == 'SSN Required' &&
                                          item.status == 'Error') {
                                        EasyLoading.show(
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        // await provider.postDocumentValidationUpdate(PendingStatus.ssn);
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    SsnUpdateDocument()));
                                        EasyLoading.dismiss();
                                      } else if (item.stage ==
                                              'Upload Documents' &&
                                          item.status == 'Error') {
                                        await provider
                                            .getCorporateValidationDocument();

                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) => CorporateDocuments(
                                                    corporateReviewDataModel: CorporateReviewDataModel(
                                                        textId: textId,
                                                        corporationName: provider
                                                            .corporationDocValidationModel
                                                            .companyName,
                                                        articleStateTextId: provider
                                                            .corporationDocValidationModel
                                                            .articleStateTextId,
                                                        salesStateTextId: provider
                                                            .corporationDocValidationModel
                                                            .articleStateTextId,
                                                        entityNo: provider
                                                            .corporationDocValidationModel
                                                            .entityNo,
                                                        salesStateTaxId: provider
                                                            .corporationDocValidationModel
                                                            .salesStateTaxId),
                                                    from: 'processing')));
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Card(
                                          color: provider
                                              .getColorByStatus(item.status),
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                    provider.getIconByStatus(
                                                        item.status)['icon'],
                                                    size: 28,
                                                    color: provider
                                                        .getIconByStatus(item
                                                            .status)['color']),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                item.status ==
                                                                        'Error'
                                                                    ? item.errorTitle ??
                                                                        ''
                                                                    : item.title ??
                                                                        '',
                                                                style: interText(
                                                                    16,
                                                                    myColors
                                                                        .grey,
                                                                    FontWeight
                                                                        .w600)),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                item.status ==
                                                                        'Error'
                                                                    ? item.errorDetails ??
                                                                        ''
                                                                    : item.details ??
                                                                        '' ??
                                                                        '',
                                                                style: interText(
                                                                    14,
                                                                    myColors
                                                                        .grey,
                                                                    FontWeight
                                                                        .w500),
                                                                maxLines: 2),
                                                          ],
                                                        ),
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double fontSize) {
    return Text(
      title,
      style: interText(fontSize, Colors.black, FontWeight.w700),
    );
  }
}
