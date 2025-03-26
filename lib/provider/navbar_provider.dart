import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/support/dashboard_support_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/rating/rating_information_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/shift/shift_config.dart';
import '../corporate/individual_team/dashboard_individual_team_member.dart';
import '../corporate/individual_team/member_account_screen.dart';
import '../screens/earning/earning_history.dart';
import '../screens/dashboard/account_info_screen.dart';
import '../screens/shift/new_schedule_screen.dart';

class TabControllerProvider extends ChangeNotifier {
  int _currectIndex = 0;
  int _currentIndexTeam = 0;
  int get currentIndex => _currectIndex;
  int get currentIndexTeam => _currentIndexTeam;
  PageController? pageController;

  PageController pageControllerSet(int? index) {
    pageController = PageController(initialPage: index ?? 0);
    notifyListeners();
    return PageController(initialPage: index ?? 0);
  }

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;
  setDisposeStatus(bool status) {
    _isDisposed = status;
    notifyListeners();
  }

  controlTab(int newIndex, BuildContext context, String? name) {
    _currectIndex = newIndex;
    switch (_currectIndex) {
      case 0:
        {
          if (name == 'explore') {
            DashboardHelpers.showAlert(msg: 'You are not verified yet');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          }
          break;
        }
      case 1:
        {
          if (name == 'explore') {
            DashboardHelpers.showAlert(msg: 'You are not verified yet');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewScheduleScreen()),
            ).then((e) {
              updateNavBarAtInitialStage(context, 0);
            });
          }

          break;
        }
      case 2:
        {
          if (name == 'explore') {
            DashboardHelpers.showAlert(msg: 'You are not verified yet');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            ).then((e) {
              updateNavBarAtInitialStage(context, 0);
            });
          }
        }
        break;
      case 3:
        {
          if (name == 'explore') {
            DashboardHelpers.showAlert(msg: 'You are not verified yet');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RatingScreen()),
            ).then((e) {
              updateNavBarAtInitialStage(context, 0);
            });
          }
        }
        break;
      case 4:
        {
          if (name == 'explore') {
            DashboardHelpers.showAlert(msg: 'You are not verified yet');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EarningHistoryScreen()),
            ).then((e) {
              updateNavBarAtInitialStage(context, 0);
            });
          }
        }
    }
    notifyListeners();
  }

  controlMemberTab(int index, BuildContext context) {
    _currentIndexTeam = index;
    switch (_currentIndexTeam) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DashboardIndividualTeamMember()),
        );
        break;
      case 1:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MemberAccountScreen()),
          );
          break;
        }
      case 2:
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardSupportScreen()),
          );
          break;
        }
        break;
    }
  }

  int _loginTabIndex = 0;
  int get loginTabIndex => _loginTabIndex;

  loginTabControl(int newIndex) {
    _loginTabIndex = newIndex;
    debugPrint('_loginTabIndex ${_loginTabIndex}');
    notifyListeners();
  }

  // New method to update navbar at initial stage
  void updateNavBarAtInitialStage(BuildContext context, int index,
      {String? name}) {
    _currectIndex = index;
    controlTab(index, context, name);
    debugPrint('updateNavBarAtInitialStage ');
    notifyListeners();
  }
}
