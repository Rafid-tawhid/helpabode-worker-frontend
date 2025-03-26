import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/custom_bottom_button.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../helper_functions/colors.dart';
import '../models/corporate_team_member_model.dart';
import '../models/pending_service_details_model.dart';
import '../provider/corporate_provider.dart';
import '../screens/open_order/open_order_screen.dart';
import '../widgets_reuse/custom_snackbar_message.dart';

class OrderAssignMemberList extends StatefulWidget {
  PendingServiceDetailsModel orderInfo;
  OrderAssignMemberList({required this.orderInfo});

  @override
  State<OrderAssignMemberList> createState() => _OrderAssignMemberListState();
}

class _OrderAssignMemberListState extends State<OrderAssignMemberList> {
  String selectedMember = '';
  TeamMemberModel? member;
  List<TeamMemberModel> verifiedUsers = [];

  @override
  void initState() {
    CorporateProvider cp = context.read<CorporateProvider>();
    UserProvider up = context.read<UserProvider>();

    //get members if corporate
    up.addNewMemberToIndividual(null, cp).then((v) {
      setVerifiedMemberList(up);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Available Team Member'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, pro, _) => Column(
          children: [
            Expanded(
              child: verifiedUsers.isEmpty
                  ? pro.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: myColors.green,
                          ),
                        )
                      : Center(
                          child: Text(
                            'No verified members found or Member\'s schedule is not available',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        )
                  : ListView.builder(
                      itemCount: verifiedUsers.length,
                      itemBuilder: (context, index) {
                        final user = verifiedUsers[index];
                        return Card(
                          color: Colors.grey[100],
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                member = user;
                              });
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                '${urlBase}${user.profileImage}',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: myColors.green,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            title: Text('${user.firstName} ${user.lastName}'),
                            subtitle: Text(user.email ?? 'No Email'),
                            trailing: IconButton(
                              onPressed: () async {
                                debugPrint(widget.orderInfo.scheduledDate);
                                debugPrint(widget.orderInfo.startTime);
                                // Add functionality here
                              },
                              icon: Icon(
                                Icons.check_circle,
                                color: member?.email == user.email
                                    ? myColors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (member != null)
              CustomBottomButton(
                  btnText: 'Select',
                  onpressed: () async {
                    var data = {
                      "assignWorkerTextId": member!.textId,
                      "orderTextId": widget.orderInfo.orderTextId,
                      "serviceTextId": widget.orderInfo.serviceTextId,
                      "orderItemId": widget.orderInfo.orderItemId,
                      "scheduleDate": widget.orderInfo.scheduledDate,
                      "scheduleStartTime": widget.orderInfo.startTime,
                      "scheduleEndTime": widget.orderInfo.endtime,
                      "categoryTextId": widget.orderInfo.serviceCategoryTextId,
                    };
                    debugPrint('MEMBER DATA ${data}');

                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Row(
                          children: [
                            Icon(Icons.exit_to_app, color: Colors.green),
                            const SizedBox(width: 10),
                            Text('Order Assign',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        content: Text(
                          'Do you really want to assign this order to ${member!.firstName}?',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Close',
                                style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              AnimationController? localAnimationController;
                              var cp = context.read<CorporateProvider>();
                              var res = await cp.assignOrderToMember(data);
                              Navigator.pop(context);
                              //
                              if (res) {
                                showCustomSnackBar(
                                  context,
                                  'Order Assign Successful',
                                  Colors.green,
                                  snackBarNeutralTextStyle,
                                  localAnimationController,
                                );
                                var provider = context.read<OrderProvider>();
                                provider.isLoading = true;
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const RequestedServiceScreen()));
                              }
                            },
                            child: const Text('Assign',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );

                    //Navigator.pop(context);
                  })
          ],
        ),
      ),
    );
  }

  void setVerifiedMemberList(UserProvider up) {
    verifiedUsers = up.addIndividualUserModelList
        .where((user) => user == 'Verified')
        .toList();
    setState(() {});
  }
}
