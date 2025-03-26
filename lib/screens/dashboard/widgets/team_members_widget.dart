import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/chat/views/chat_screen.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../corporate/individual_team/my_team_member_list.dart';
import '../../../helper_functions/colors.dart';
import '../../../helper_functions/dashboard_helpers.dart';
import '../../../misc/constants.dart';
import '../../../models/corporate_team_member_model.dart';
import '../../../provider/corporate_provider.dart';
import '../../../widgets_reuse/free_call_bottom_sheet.dart';

class MyTeamMembers extends StatelessWidget {
  final List<TeamMemberModel> teamList;

  MyTeamMembers({required this.teamList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Teams',
                style: interText(16, Colors.black, FontWeight.w600),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => MyTeamMemberList()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See all ',
                        style: interText(14, Colors.black54, FontWeight.w600),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ...List.generate(
              teamList.length > 5 ? 5 : teamList.length,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: GestureDetector(
                      onTap: () {
                        var cp = context.read<CorporateProvider>();
                        var up = context.read<UserProvider>();
                        DashboardHelpers.handleMemberAction(
                            context: context,
                            member: teamList[index],
                            corporateProvider: cp,
                            provider: up);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade200, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${urlBase}${teamList[index].profileImage}',
                                      height: 40,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/png/service.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 1),
                                                shape: BoxShape.circle),
                                            child: Text(DashboardHelpers
                                                .getFirstCharacterCombinationName(
                                                    teamList[index].firstName ??
                                                        '',
                                                    teamList[index].lastName))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            teamList[index].firstName ??
                                                'John Doe',
                                            style: interText(14, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            teamList[index].email ??
                                                'johndoe@example.com',
                                            style: interText(
                                                12,
                                                myColors.greyTxt,
                                                FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //Text(teamList[index].employeeType??'',style: interText(12, myColors.greyTxt, FontWeight.w500),),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => CallSupportScreen(
                                          model: teamList[index],
                                        ),
                                      );
                                      // DashboardHelpers.openNumber(number: teamList[index].phone ?? '', isMessage: false);
                                    },
                                    child: Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(
                                            0xFFF6F6F6), // Background color of the circle
                                      ),
                                      child: Icon(
                                        Icons.call,
                                        color: Colors
                                            .grey, // Color of the call icon
                                        size: 18.0, // Size of the call icon
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiverName: teamList[index].firstName??'', receiverTextId: 'receiverTextId', groupTextId: 'groupTextId')));
                                    },
                                    child: Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(
                                            0xFFF6F6F6), // Background color of the circle
                                      ),
                                      child: Icon(
                                        Icons.message,
                                        color: Colors
                                            .grey, // Color of the call icon
                                        size: 18.0, // Size of the call icon
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Text('')),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: teamList[index].status ==
                                                  'Verified'
                                              ? myColors.green10
                                              : Colors.amber,
                                          border: Border.all(
                                              width: 0.6,
                                              color: Color(0xFFC3E6CB)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(24),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                getStatus(
                                                    teamList[index].status),
                                                textAlign: TextAlign.right,
                                                style: interText(
                                                    12,
                                                    teamList[index].status ==
                                                            'Verified'
                                                        ? Color(0xff1B5E20)
                                                        : Colors.white,
                                                    FontWeight.w500)),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            if (teamList[index].status ==
                                                'Verified')
                                              Icon(
                                                Icons.verified,
                                                color: Color(0xff1B5E20),
                                                size: 16,
                                              )
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
        ],
      ),
    );
  }

  String getStatus(String? status) {
    if (status == 'Pending Invitation') {
      return 'Invitation Sent';
    } else if (status == 'Documents Submitted') {
      return status ?? '';
    } else if (status == 'Verified') {
      return status ?? 'Approved';
    } else {
      return 'Pending Invitation';
    }
  }
}
