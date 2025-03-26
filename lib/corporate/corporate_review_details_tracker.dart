import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/pending_registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../provider/corporate_provider.dart';
import '../../../widgets_reuse/custom_back_button.dart';
import '../../../widgets_reuse/custom_rounded_button.dart';
import 'convert_pdf_to_image.dart';
import 'corporate_category_selection_expandable.dart';
import 'corporate_documents.dart';
import 'corporation_details_screen.dart';

class CorporateReviewDetailsTracker extends StatefulWidget {
  @override
  State<CorporateReviewDetailsTracker> createState() => _OrderTracker4State();
}

class _OrderTracker4State extends State<CorporateReviewDetailsTracker> {
  int defineColor(OrderStatus status) {
    if (status == OrderStatus.pending) {
      return 1;
    } else if (status == OrderStatus.booked) {
      return 2;
    } else if (status == OrderStatus.confirmed) {
      return 4;
    } else if (status == OrderStatus.inTransit) {
      return 5;
    } else if (status == OrderStatus.jobStarted) {
      return 6;
    } else if (status == OrderStatus.completedByProvider) {
      return 7;
    } else if (status == OrderStatus.completed) {
      return 8;
    }
    return 0;
  }

  double boxH = 200;
  bool clicked = true;
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();

  @override
  void initState() {
    var cp = context.read<CorporateProvider>();
    Future.microtask(() {
      cp.getAllCorporateSubmittedDocumentInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyCustomBackButton(onPressed: () {
                          Navigator.pop(context);
                        })
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: myColors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Review your details',
                            style: interText(24, Colors.black, FontWeight.bold),
                          ),
                          Text(
                              'Please review your entered details before finalizing the registration.'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(
                        height: 1,
                        width: MediaQuery.sizeOf(context).width,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          FullInfoCard(
                              cardHeight: 200,
                              infoDts: InformationDts(),
                              title: 'Corporation Details'),
                          FullInfoCard(
                              cardHeight: 270,
                              infoDts: CorporationDocuments(),
                              title: 'Corporate Documentation'),
                          FullInfoCard(
                            cardHeight: 260,
                            infoDts: SalesTaxCertificate(),
                            title: 'Selected Services',
                            progressbar: .75,
                          ),
                          FullInfoCard(
                            cardHeight: 0,
                            infoDts: Container(),
                            title: 'Complete your sign up',
                            indexNo: 4,
                            showArrow: false,
                          ),
                          SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border(top: BorderSide(color: AppColors.grey)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 8,
                      offset: Offset(0, -4),
                      spreadRadius: 0,
                    )
                  ]),
              child: CustomRoundedButton(
                  height: 50,
                  width: 388,
                  controller: _controller,
                  label: 'Save & Next',
                  buttonColor: myColors.green,
                  fontColor: Colors.white,
                  funcName: () async {
                    var cp = context.read<CorporateProvider>();
                    cp.saveCorporateSubmittedDocumentInfo();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PendingRegistrationProcess()));
                  },
                  borderRadius: 8),
            )
          ],
        ),
      ),
    );
  }

  Consumer CorporationDocuments() {
    return Consumer<CorporateProvider>(
      builder: (context, provider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Article of Corporation',
            style: interText(15, Colors.black, FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uploaded File: ',
                style: TextStyle(fontSize: 14),
              ),
              InkWell(
                onTap: () {
                  final validExtensions = ['.jpg', '.png', '.jpeg', '.gif'];

                  if (validExtensions.contains(provider.corporateReviewDataModel
                      .isCorporationArticleExist![1])) {
                    // Your logic here
                    debugPrint('THIS');

                    showImageAlert(
                        'Article of Corporation',
                        provider.corporateReviewDataModel
                            .isCorporationArticleExist![0]);
                  } else {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewExample(conditionsUrl: '${urlBase}${provider.corporateReviewDataModel.isCorporationArticleExist![0]}', title: 'Article of Corporation')));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFViewerCachedFromUrl(
                                url:
                                    '${urlBase}${provider.corporateReviewDataModel.isCorporationArticleExist![0]}',
                                title: 'Article of Corporation')));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 10),
                        child: Text(
                          'View',
                          style: interText(14, myColors.green, FontWeight.w400),
                        ),
                      )),
                ),
              ),
            ],
          ),
          Text(
            'Entity No: ${provider.corporateReviewDataModel.entityNo}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'State: ${provider.corporateReviewDataModel.articleStateTextId}',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'State Sales Tax Certificate',
            style: interText(15, Colors.black, FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uploaded File: ',
                style: TextStyle(fontSize: 14),
              ),
              InkWell(
                onTap: () {
                  final validExtensions = ['.jpg', '.png', '.jpeg', '.gif'];

                  if (validExtensions.contains(provider.corporateReviewDataModel
                      .isStateSalesTaxCertificateExist![1])) {
                    // Your logic here
                    showImageAlert(
                        'State Sales Tax Certificate',
                        provider.corporateReviewDataModel
                            .isStateSalesTaxCertificateExist![0]);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFViewerCachedFromUrl(
                                  url:
                                      '${urlBase}${provider.corporateReviewDataModel.isStateSalesTaxCertificateExist![0]}',
                                  title: 'State Sales Tax Certificate',
                                )));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 10),
                        child: Text(
                          'View',
                          style: interText(14, myColors.green, FontWeight.w400),
                        ),
                      )),
                ),
              ),
            ],
          ),
          Text(
            'State Sales Tax Id: ${provider.corporateReviewDataModel.salesStateTaxId}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'State: ${provider.corporateReviewDataModel.salesStateTextId}',
            style: TextStyle(fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CorporateDocuments(
                              corporateReviewDataModel:
                                  provider.corporateReviewDataModel,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: myColors.greyBtn,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                  child: Text(
                    'Edit Document',
                    style: interText(14, Colors.black, FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showImageAlert(String title, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: interText(16, Colors.black, FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${urlBase}${image}',
                  fit: BoxFit.cover,
                  height: 200,
                  width: 300,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 300,
                            child: Image.asset(
                              'images/placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          CircularProgressIndicator()
                        ],
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      height: 200,
                      width: 300,
                      color: Colors.grey,
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
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
            ],
          ),
        );
      },
    );
  }
}

class SalesTaxCertificate extends StatelessWidget {
  const SalesTaxCertificate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Consumer<CorporateProvider>(
                  builder: (context, provider, _) {
                    //provider.corporateReviewDataModel.workerCategory!.length>0
                    return provider.isLoadingAll
                        ? Center(
                            child: CircularProgressIndicator(
                            color: myColors.green,
                          ))
                        : ListView.builder(
                            itemCount: provider.corporateReviewDataModel
                                        .workerCategory ==
                                    null
                                ? 0
                                : provider.corporateReviewDataModel
                                    .workerCategory!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var item = provider.corporateReviewDataModel
                                  .workerCategory![index];
                              if (provider.corporateReviewDataModel
                                      .workerCategory!.length >
                                  0) {
                                return Column(
                                  children: [
                                    ListTile(
                                        title: Text(
                                          item.parentTitle ?? '',
                                          style: interText(16, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        subtitle: Text(item.subCategory!
                                                .map<String>(
                                                    (item) => item.title ?? '')
                                                .toList()
                                                .join(
                                                    ', ') // Joins the list items into a single string separated by a comma and a space
                                            )),
                                    Container(
                                      height: 1,
                                      color: Colors.grey.shade100,
                                    )
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Text('No Service Found'),
                                );
                              }
                            },
                          );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: InkWell(
              onTap: () {
                var cp = context.read<CorporateProvider>();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CorporateServiceSelectionExpandable(
                              corporateReviewDataModel:
                                  cp.corporateReviewDataModel,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: myColors.greyBtn,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                  child: Text(
                    'Edit Service',
                    style: interText(14, Colors.black, FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FullInfoCard extends StatefulWidget {
  String title;
  double cardHeight;
  Widget infoDts;
  double? progressbar;
  int? indexNo;
  bool? showArrow;
  FullInfoCard(
      {required this.cardHeight,
      required this.infoDts,
      required this.title,
      this.progressbar,
      this.indexNo,
      this.showArrow});

  @override
  State<FullInfoCard> createState() => _FullInfoCardState();
}

class _FullInfoCardState extends State<FullInfoCard>
    with TickerProviderStateMixin {
  bool isCollapsed = true;
  late AnimationController _animationController;
  bool isArrowDown = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Duration of rotation
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleArrow() {
    setState(() {
      if (isArrowDown) {
        _animationController.forward(); // Rotate to up
      } else {
        _animationController.reverse(); // Rotate to down
      }
      isArrowDown = !isArrowDown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // defineColor(widget.status!) != thisIndex &&
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.indexNo == null
                    ? Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border:
                                Border.all(color: myColors.green, width: 2)),
                        child: Icon(
                          Icons.check,
                          color: myColors.green,
                          size: 18,
                        ))
                    : Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border:
                                Border.all(color: AppColors.grey, width: 2)),
                        child: Text(
                          widget.indexNo.toString(),
                          style: interText(14, Colors.black, FontWeight.bold),
                        )),
                SizedBox(
                  width: 3,
                  height: isCollapsed ? widget.cardHeight : 0,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: LinearProgressIndicator(
                      value:
                          widget.progressbar == null ? 1 : widget.progressbar,
                      backgroundColor: Colors.grey,
                      color: myColors.green,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCollapsed = !isCollapsed;
                        if (isArrowDown) {
                          _animationController.forward(); // Rotate to up
                        } else {
                          _animationController.reverse(); // Rotate to down
                        }
                        isArrowDown = !isArrowDown;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: interText(16, Colors.black, FontWeight.bold),
                          ),
                        ),
                        widget.showArrow == null
                            ? SizedBox(
                                height: 30,
                                width: 30,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _animationController.value *
                                            3.14159, // Rotation value (pi radians)
                                        child: Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ))
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (isCollapsed) widget.infoDts
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class InformationDts extends StatelessWidget {
  const InformationDts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CorporateProvider>(
      builder: (context, provider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Corporation name : ${provider.corporateReviewDataModel.corporationName}',
            style: TextStyle(fontSize: 14),
          ),
          if (provider.corporateReviewDataModel.address != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address 1: ${provider.corporateReviewDataModel.address![0].addressLine1Data}, ${provider.corporateReviewDataModel.address![0].addressLine2Data} ',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Address 2: ${provider.corporateReviewDataModel.address![0].addressLine2Data}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '${provider.corporateReviewDataModel.address![0].zipData}, ${provider.corporateReviewDataModel.address![0].cityData} ${provider.corporateReviewDataModel.address![0].stateData}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          if (provider.corporateReviewDataModel.alternateName != null)
            Text(
              'DBA : ${provider.corporateReviewDataModel.alternateName}',
              style: TextStyle(fontSize: 14),
            ),
          Text(
            'Tax ID or SSN: ${provider.corporateReviewDataModel.salesStateTaxId}',
            style: TextStyle(fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CorporationDetaiils(
                              corporateReviewDataModel:
                                  provider.corporateReviewDataModel,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: myColors.greyBtn,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                  child: Text(
                    'Edit Info',
                    style: interText(14, Colors.black, FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum OrderStatus {
  pending,
  booked,
  scheduled,
  confirmed,
  inTransit,
  jobStarted,
  completedByProvider,
  completed
}
