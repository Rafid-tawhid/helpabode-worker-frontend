import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/corporate/team_member_details.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';

class AddTeamAndTeamMembers extends StatefulWidget {
  const AddTeamAndTeamMembers({super.key});

  @override
  State<AddTeamAndTeamMembers> createState() => _AddTeamAndTeamMembersState();
}

class _AddTeamAndTeamMembersState extends State<AddTeamAndTeamMembers> {
  String? _selectedMember;
  String? _selectedTeam;
  final _formKey = GlobalKey<FormState>();
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();
  //List<String> optionsList = ["I don't have any members yet.", "1 to 10", "11-25", "26-50", "50-100"];

  @override
  void initState() {
    callTeamConfiguration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Consumer<CorporateProvider>(
          builder: (context, provider, _) => Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back))
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Add your teams and team member',
                                    style: interText(
                                        24, Colors.black, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Specify teams and add members to streamline management.',
                                    style: interText(
                                        14, myColors.greyTxt, FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'How many team members',
                                    style: interText(
                                        16, Colors.black, FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  provider.isLoadingConfig
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: myColors.green,
                                        ))
                                      : ListView.builder(
                                          itemCount: provider.teamList.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: Colors.white),
                                                child: RadioListTile<String>(
                                                  title: Text(provider.teamList[
                                                              index] ==
                                                          '0'
                                                      ? 'I don\'t have any team member yet.'
                                                      : provider
                                                          .teamList[index]),
                                                  activeColor: myColors.green,
                                                  value:
                                                      provider.teamList[index],
                                                  groupValue: _selectedMember,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedMember = value;
                                                    });
                                                  },
                                                  contentPadding: EdgeInsets.all(
                                                      0), // Remove default padding
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              )
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'How many teams',
                                    style: interText(
                                        16, Colors.black, FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  provider.isLoadingConfig
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: myColors.green,
                                        ))
                                      : ListView.builder(
                                          itemCount:
                                              provider.teamMemberArray.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: Colors.white),
                                                child: RadioListTile<String>(
                                                  title: Text(provider
                                                                  .teamMemberArray[
                                                              index] ==
                                                          '0'
                                                      ? 'I don\'t have any team yet.'
                                                      : provider
                                                              .teamMemberArray[
                                                          index]),
                                                  activeColor: myColors.green,
                                                  value:
                                                      provider.teamList[index],
                                                  groupValue: _selectedTeam,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedTeam = value;
                                                    });
                                                  },
                                                  contentPadding: EdgeInsets.all(
                                                      0), // Remove default padding
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              )
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                    height: 44,
                    controller: _controller,
                    label: 'Next',
                    buttonColor: myColors.green,
                    fontColor: Colors.white,
                    funcName: (_selectedMember == null || _selectedTeam == null)
                        ? null
                        : () async {
                            _controller.start();
                            if (await provider.setTeamMember(
                                _selectedMember, _selectedTeam)) {
                              _controller.stop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeamMemberDetails()));
                            } else {
                              _controller.stop();
                            }
                          },
                    borderRadius: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void callTeamConfiguration() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CorporateProvider>().getTeamConfiguration();
    });
  }
}
