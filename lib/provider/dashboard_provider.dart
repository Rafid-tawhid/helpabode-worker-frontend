import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/api/dashboard_api_calls.dart';
import 'package:help_abode_worker_app_ver_2/models/city_models_service_area.dart';
import 'package:http/http.dart';

import '../helper_functions/api_services.dart';
import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/dynamic_menu_models.dart';
import '../models/faw_models.dart';
import '../models/worker_city_model.dart';

class DashboardProvider extends ChangeNotifier {
  List<ServiceArea> allCityModels = [];
  List<WorkerCityModel> workersWorkingCity = [];
  List<FawModels> faqList = [];
  List<FawModels> faqListName = [];
  List<FawModels> faqQuestionsList = [];

  Future<CityModels?> getWorkersCityModels() async {
    final response = await DashboardApi.getCityAndAreaData();
    allCityModels.clear();
    workersWorkingCity.clear();
    if (response != null) {
      for (Map i in response['service_area']) {
        allCityModels.add(ServiceArea.fromJson(i));
      }

      for (Map i in response['worker_city']) {
        workersWorkingCity.add(WorkerCityModel.fromJson(i));
      }
      notifyListeners();
      print('allCityModels ${allCityModels.length}');
      print('workersWorkingCity ${workersWorkingCity.length}');
    }
    return null;
  }

  List<DynamicMenuModels> dynamicMenuList = [];

  Future<void> getDynamicMenuAccordingToRole() async {
    dynamicMenuList.clear();
    ApiService apiService = ApiService();
    var data = await apiService.getData('api/provider/dashboard-menus');
    if (data != null) {
      for (var i in data['menuArrays']) {
        dynamicMenuList.add(DynamicMenuModels.fromJson(i));
      }
    }

    debugPrint('dynamicMenuList ${dynamicMenuList.length}');
    notifyListeners();
  }

  Future<bool> getAllFaqs() async {
    try {
      print("getAllFaqs is calling..... ${token}");
      debugPrint('TEXT ID: ${textId}');
      debugPrint('TOKEN: ${token}');
      debugPrint('STATUS: ${status}');

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}api/worker/faqs/"),
        headers: header,
      );

      var responseDecodeJson = jsonDecode(response.body);
      debugPrint('FAQ Return Response ${responseDecodeJson}');

      if (response.statusCode == 200) {
        for (Map i in responseDecodeJson['allFaqs']) {
          faqList.add(FawModels.fromJson(i));
        }

        //FILTER FAQ
        faqListName = filterUniqueFAQByType(faqList);

        debugPrint('faqList ${faqList.length}');
        debugPrint('faqListName ${faqListName.length}');
        return true;
      } else {
        //  DashboardHelpers.showAlert(msg: 'No Faqs Found');
        notifyListeners();

        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print("catch ${e}");
      return false;
    }
  }

  setPreviousList() async {
    for (final person in allCityModels) {
      if (person.isChecked == true) {
        person.isChecked = false;
      }
    }
    notifyListeners();
  }

  void setOnTapped(String clickedId) {
    faqQuestionsList.forEach((e) {
      if (e.clickedId == clickedId) {
        e.clicked = !e.clicked;
      }
    });
    // dataInfoList[index]['clickable'] = !dataInfoList[index]['clickable'];
    // debugPrint(dataInfoList[index]['details'].toString());

    debugPrint(clickedId);

    faqQuestionsList.forEach((e) {
      debugPrint('Hello ${e.clickedId}');
      debugPrint('Hello ${e.clicked}');
    });
    notifyListeners();
  }

  void changeListWhenTappedItem(String faqType) {
    faqQuestionsList.clear();
    faqList.forEach((e) {
      if (e.faqType == faqType) {
        faqQuestionsList.add(e);
      }
    });
    debugPrint('faqQuestionsList ${faqQuestionsList.length}');
    notifyListeners();
    //dataInfoList.clear();
    // if (index == 0) {
    //   dataInfoList.addAll(orderingInfoList);
    // } else if (index == 1) {
    //   dataInfoList.addAll(scheduleManagementList);
    // } else if (index == 2) {
    //   dataInfoList.addAll(accountManagementList);
    // } else if (index == 3) {
    //   dataInfoList.addAll(ratingManagementList);
    // } else if (index == 4) {
    //   dataInfoList.addAll(earningManagementList);
    // }
  }

  final List<Map<String, dynamic>> dataInfoList = [];
  final List<Map<String, dynamic>> orderingInfoList = [
    {
      "title": "General issues while Ordering",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to place an order",
          "instructions": [
            {
              "line1": "Check your internet connection.",
              "line2": "",
            },
            {
              "line1": "Restart the app and try again.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Payment failed",
          "instructions": [
            {
              "line1": "Ensure that your payment method is valid.",
              "line2": "",
            },
            {
              "line1": "Try using a different payment method.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Order not confirmed",
          "instructions": [
            {
              "line1":
                  "Check your order history to verify if the order was placed.",
              "line2": "",
            },
            {
              "line1": "Contact customer support for further assistance.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues at the location",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to find the location",
          "instructions": [
            {
              "line1": "Verify the address and check your GPS settings.",
              "line2": "",
            },
            {
              "line1": "Contact the customer for precise directions.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Location closed",
          "instructions": [
            {
              "line1": "Check the operating hours of the location.",
              "line2": "",
            },
            {
              "line1":
                  "Inform the customer and suggest rescheduling the order.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Location inaccessible",
          "instructions": [
            {
              "line1": "Look for alternative routes or contact the customer.",
              "line2": "",
            },
            {
              "line1":
                  "Check for any road closures or construction work in the area.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with working with the customer",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Customer not responding",
          "instructions": [
            {
              "line1": "Try calling or messaging the customer.",
              "line2": "",
            },
            {
              "line1": "Leave a message explaining the situation.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Incorrect customer information",
          "instructions": [
            {
              "line1": "Double-check the information provided by the customer.",
              "line2": "",
            },
            {
              "line1":
                  "Contact customer support for help in updating the information.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Customer canceled the order",
          "instructions": [
            {
              "line1":
                  "Confirm the cancellation and process any necessary refunds.",
              "line2": "",
            },
            {
              "line1":
                  "Notify the restaurant or vendor about the cancellation.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Cannot continue with the order",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Order is taking too long to prepare",
          "instructions": [
            {
              "line1": "Inform the customer about the delay.",
              "line2": "",
            },
            {
              "line1": "Check with the restaurant/vendor for an updated time.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Missing items in the order",
          "instructions": [
            {
              "line1": "Inform the customer and suggest alternatives.",
              "line2": "",
            },
            {
              "line1": "Notify the restaurant/vendor to update the order.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Equipment malfunction",
          "instructions": [
            {
              "line1": "Report the issue to management and seek assistance.",
              "line2": "",
            },
            {
              "line1": "Try to find a workaround if possible.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Schedule extend usage",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. How to extend schedule",
          "instructions": [
            {
              "line1": "Go to the schedule tab and select the desired shift.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure that the shift is available and does not conflict with existing schedules.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Schedule conflict",
          "instructions": [
            {
              "line1": "Check your calendar and adjust your availability.",
              "line2": "",
            },
            {
              "line1":
                  "Communicate with your manager to resolve any conflicts.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Unable to extend schedule",
          "instructions": [
            {
              "line1": "Contact your manager for approval.",
              "line2": "",
            },
            {
              "line1": "Consider adjusting your existing shifts if necessary.",
              "line2": "",
            },
          ],
        },
      ],
    },
  ];
  final List<Map<String, dynamic>> scheduleManagementList = [
    {
      "title": "Shift Scheduling Issues",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to create a shift",
          "instructions": [
            {
              "line1": "Ensure that the selected time slot is available.",
              "line2": "",
            },
            {
              "line1": "Check if the shift overlaps with an existing shift.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Shift not appearing on the schedule",
          "instructions": [
            {
              "line1": "Refresh the schedule page.",
              "line2": "",
            },
            {
              "line1": "Check the filters applied on the schedule view.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Incorrect shift timings",
          "instructions": [
            {
              "line1": "Verify the time zone settings.",
              "line2": "",
            },
            {
              "line1": "Edit the shift and adjust the timings accordingly.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Availability Management",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to update availability",
          "instructions": [
            {
              "line1": "Ensure that your current schedule allows changes.",
              "line2": "",
            },
            {
              "line1": "Contact the admin if the option is restricted.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Conflicting availability entries",
          "instructions": [
            {
              "line1": "Check for overlapping availability slots.",
              "line2": "",
            },
            {
              "line1": "Remove or adjust conflicting entries.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Availability not saving",
          "instructions": [
            {
              "line1": "Make sure all required fields are filled out.",
              "line2": "",
            },
            {
              "line1": "Clear the browser cache and try again.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Shift Swap and Pickup",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to swap shifts",
          "instructions": [
            {
              "line1": "Ensure that the other employee has accepted the swap.",
              "line2": "",
            },
            {
              "line1": "Check if the shift swap policy allows the change.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Shift pickup request not processed",
          "instructions": [
            {
              "line1":
                  "Verify if the request has been approved by the manager.",
              "line2": "",
            },
            {
              "line1": "Contact the admin if the request remains pending.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Shift swap canceled unexpectedly",
          "instructions": [
            {
              "line1": "Check the cancellation reason in the notifications.",
              "line2": "",
            },
            {
              "line1": "Contact the manager for clarification.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Overtime Management",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Overtime not calculated",
          "instructions": [
            {
              "line1": "Ensure the shift hours exceed the regular work hours.",
              "line2": "",
            },
            {
              "line1":
                  "Check if the overtime settings are configured correctly.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Overtime request denied",
          "instructions": [
            {
              "line1": "Review the overtime policy for any restrictions.",
              "line2": "",
            },
            {
              "line1": "Contact the manager for further clarification.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Overtime not reflecting on the payroll",
          "instructions": [
            {
              "line1": "Ensure that the overtime hours were approved.",
              "line2": "",
            },
            {
              "line1": "Check the payroll settings for any discrepancies.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Time-off and Leave Management",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to request time-off",
          "instructions": [
            {
              "line1": "Ensure you have enough time-off balance available.",
              "line2": "",
            },
            {
              "line1":
                  "Check if the requested dates fall within blackout periods.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Time-off request not approved",
          "instructions": [
            {
              "line1": "Verify the approval status with your manager.",
              "line2": "",
            },
            {
              "line1": "Submit the request again if it was denied in error.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Leave balance incorrect",
          "instructions": [
            {
              "line1": "Check your leave history for any discrepancies.",
              "line2": "",
            },
            {
              "line1": "Contact HR for an update on your leave balance.",
              "line2": "",
            },
          ],
        },
      ],
    },
  ];
  final List<Map<String, dynamic>> accountManagementList = [
    {
      "title": "Issues with Login",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to log in",
          "instructions": [
            {
              "line1":
                  "Ensure you are using the correct username and password.",
              "line2": "",
            },
            {
              "line1": "Reset your password if you forgot it.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Account locked",
          "instructions": [
            {
              "line1": "Wait for 30 minutes and try logging in again.",
              "line2": "",
            },
            {
              "line1": "Contact support if the issue persists.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Two-factor authentication issues",
          "instructions": [
            {
              "line1": "Ensure that your registered device is available.",
              "line2": "",
            },
            {
              "line1":
                  "Check if the time on your device is synchronized correctly.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Profile Management Issues",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to update profile",
          "instructions": [
            {
              "line1": "Check if all required fields are filled out correctly.",
              "line2": "",
            },
            {
              "line1": "Ensure that your internet connection is stable.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Profile picture not updating",
          "instructions": [
            {
              "line1":
                  "Try uploading a picture with a different format or size.",
              "line2": "",
            },
            {
              "line1": "Clear your cache and try again.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Unable to change email address",
          "instructions": [
            {
              "line1":
                  "Ensure that the new email address is not already in use.",
              "line2": "",
            },
            {
              "line1":
                  "Verify the email change request via the confirmation email.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Password Management",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to reset password",
          "instructions": [
            {
              "line1": "Check if the reset link was sent to the correct email.",
              "line2": "",
            },
            {
              "line1": "Ensure that the reset link hasn't expired.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Password reset link not received",
          "instructions": [
            {
              "line1": "Check your spam/junk folder.",
              "line2": "",
            },
            {
              "line1": "Try resending the reset link.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Unable to set a new password",
          "instructions": [
            {
              "line1":
                  "Ensure that your new password meets all the security requirements.",
              "line2": "",
            },
            {
              "line1": "Clear your browser cache and try again.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Account Deactivation/Deletion",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to deactivate account",
          "instructions": [
            {
              "line1":
                  "Check if you have any active subscriptions that need to be canceled first.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure that all your data has been backed up before proceeding.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Account deletion not processing",
          "instructions": [
            {
              "line1":
                  "Verify that you have confirmed the deletion request via email.",
              "line2": "",
            },
            {
              "line1":
                  "Contact support if the deletion is still pending after 24 hours.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Recovering a deactivated account",
          "instructions": [
            {
              "line1": "Contact support to initiate the recovery process.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure you have your account details and verification methods available.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Subscription and Billing",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to update payment method",
          "instructions": [
            {
              "line1":
                  "Ensure that your new payment method is valid and up to date.",
              "line2": "",
            },
            {
              "line1":
                  "Check if there are any issues with the payment gateway.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Subscription renewal failed",
          "instructions": [
            {
              "line1":
                  "Ensure your payment information is correct and funds are available.",
              "line2": "",
            },
            {
              "line1":
                  "Try manually renewing your subscription through the billing page.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Canceling a subscription",
          "instructions": [
            {
              "line1": "Navigate to the subscription page and select cancel.",
              "line2": "",
            },
            {
              "line1":
                  "Confirm the cancellation and ensure no further charges will be made.",
              "line2": "",
            },
          ],
        },
      ],
    },
  ];
  final List<Map<String, dynamic>> ratingManagementList = [
    {
      "title": "Issues with receiving ratings",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Customer did not leave a rating",
          "instructions": [
            {
              "line1":
                  "Send a follow-up message reminding the customer to rate their experience.",
              "line2": "",
            },
            {
              "line1": "Check if the rating system is functioning properly.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Incorrect rating received",
          "instructions": [
            {
              "line1":
                  "Contact customer support to investigate and rectify the issue.",
              "line2": "",
            },
            {
              "line1":
                  "Provide documentation or evidence to support the correction.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. No feedback provided with rating",
          "instructions": [
            {
              "line1":
                  "Encourage the customer to provide feedback along with their rating.",
              "line2": "",
            },
            {
              "line1":
                  "Check if the feedback option is properly configured in the system.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with viewing ratings",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Rating not showing in dashboard",
          "instructions": [
            {
              "line1": "Refresh the dashboard or log out and log back in.",
              "line2": "",
            },
            {
              "line1": "Check if the rating data is syncing correctly.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Ratings displayed incorrectly",
          "instructions": [
            {
              "line1": "Verify the rating calculations and display settings.",
              "line2": "",
            },
            {
              "line1": "Contact technical support if the issue persists.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Unable to filter ratings by date",
          "instructions": [
            {
              "line1": "Ensure that the date filter is applied correctly.",
              "line2": "",
            },
            {
              "line1":
                  "Check if there are any system updates affecting the filter functionality.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with rating notifications",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Not receiving rating notifications",
          "instructions": [
            {
              "line1":
                  "Check notification settings and ensure they are enabled.",
              "line2": "",
            },
            {
              "line1":
                  "Verify that your device or app is not in Do Not Disturb mode.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Delayed rating notifications",
          "instructions": [
            {
              "line1": "Check your internet connection for any issues.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure that the server is running smoothly and handling requests promptly.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Incorrect notification content",
          "instructions": [
            {
              "line1": "Verify the notification template and content settings.",
              "line2": "",
            },
            {
              "line1":
                  "Report the issue to technical support for further investigation.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with managing ratings",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to respond to a rating",
          "instructions": [
            {
              "line1":
                  "Ensure that the response option is enabled in the settings.",
              "line2": "",
            },
            {
              "line1": "Contact customer support if the issue persists.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Unable to delete an inappropriate rating",
          "instructions": [
            {
              "line1":
                  "Check the rating management permissions and access controls.",
              "line2": "",
            },
            {
              "line1": "Request assistance from customer support if necessary.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Unable to export ratings",
          "instructions": [
            {
              "line1":
                  "Verify the export settings and file format compatibility.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure that there are no system limitations preventing the export.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with improving ratings",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Consistently low ratings",
          "instructions": [
            {
              "line1":
                  "Analyze the feedback provided and identify areas for improvement.",
              "line2": "",
            },
            {
              "line1":
                  "Consider offering incentives or discounts for improved ratings.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. No change in ratings despite efforts",
          "instructions": [
            {
              "line1":
                  "Reevaluate the strategies being used to improve ratings.",
              "line2": "",
            },
            {
              "line1":
                  "Seek feedback from customers on how to enhance their experience.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Difficulty in identifying rating trends",
          "instructions": [
            {
              "line1":
                  "Use analytics tools to better understand the rating patterns.",
              "line2": "",
            },
            {
              "line1": "Consult with a data analyst for deeper insights.",
              "line2": "",
            },
          ],
        },
      ],
    },
  ];
  final List<Map<String, dynamic>> earningManagementList = [
    {
      "title": "Issues with earnings display",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Earnings not showing up",
          "instructions": [
            {
              "line1": "Check if the payment cycle has completed.",
              "line2": "",
            },
            {
              "line1": "Refresh the earnings page or log out and log back in.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Incorrect earnings displayed",
          "instructions": [
            {
              "line1": "Verify the calculations and transactions for accuracy.",
              "line2": "",
            },
            {
              "line1":
                  "Report discrepancies to the finance team for correction.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Earnings data delayed",
          "instructions": [
            {
              "line1": "Check your internet connection and server status.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure that there are no ongoing system updates affecting data sync.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with payment processing",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Payment not received",
          "instructions": [
            {
              "line1":
                  "Verify the payment schedule and expected processing time.",
              "line2": "",
            },
            {
              "line1": "Contact the payment provider or financial institution.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Incorrect payment amount",
          "instructions": [
            {
              "line1":
                  "Double-check the earnings breakdown and payment details.",
              "line2": "",
            },
            {
              "line1": "Reach out to the finance department for clarification.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Payment method declined",
          "instructions": [
            {
              "line1": "Ensure that the payment method details are up to date.",
              "line2": "",
            },
            {
              "line1": "Consider using an alternative payment method.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with earnings reports",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to generate earnings report",
          "instructions": [
            {
              "line1": "Check if the reporting period is correctly selected.",
              "line2": "",
            },
            {
              "line1":
                  "Ensure that there are no restrictions on report generation.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Inaccurate earnings report",
          "instructions": [
            {
              "line1":
                  "Verify the data input and filter criteria used in the report.",
              "line2": "",
            },
            {
              "line1": "Contact technical support if the issue persists.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Report format not compatible",
          "instructions": [
            {
              "line1":
                  "Check the file format settings before generating the report.",
              "line2": "",
            },
            {
              "line1":
                  "Convert the report to the desired format using appropriate software.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with earning adjustments",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Unable to request an earnings adjustment",
          "instructions": [
            {
              "line1": "Ensure that the adjustment request option is enabled.",
              "line2": "",
            },
            {
              "line1":
                  "Reach out to your manager or HR for further assistance.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Incorrect adjustment applied",
          "instructions": [
            {
              "line1": "Review the adjustment details and calculations.",
              "line2": "",
            },
            {
              "line1": "Request a correction if the adjustment is incorrect.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Adjustment request denied",
          "instructions": [
            {
              "line1": "Check the reason for denial and the policy guidelines.",
              "line2": "",
            },
            {
              "line1":
                  "Discuss the issue with HR or your supervisor for a resolution.",
              "line2": "",
            },
          ],
        },
      ],
    },
    {
      "title": "Issues with bonuses and incentives",
      "clickable": false,
      "details": [
        {
          "subTitle": "1. Bonus not received",
          "instructions": [
            {
              "line1": "Verify if you met the criteria for the bonus period.",
              "line2": "",
            },
            {
              "line1": "Contact HR or your manager for clarification.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "2. Incorrect bonus amount",
          "instructions": [
            {
              "line1": "Review the bonus calculation and criteria.",
              "line2": "",
            },
            {
              "line1": "Report any discrepancies to HR or your manager.",
              "line2": "",
            },
          ],
        },
        {
          "subTitle": "3. Delayed incentive payout",
          "instructions": [
            {
              "line1": "Check the incentive payout schedule.",
              "line2": "",
            },
            {
              "line1":
                  "Follow up with HR or the finance team if the delay persists.",
              "line2": "",
            },
          ],
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> snippetList = [
    {
      "title": "When to Start",
      "subTitle":
          "There are more delivery opportunities during lunch and dinner times."
    },
    {
      "title": "Customer Support",
      "subTitle":
          "Have questions or need help? Contact our 24/7 customer support."
    },
    {
      "title": "Delivery Best Practices",
      "subTitle":
          "Ensure timely deliveries by planning your route efficiently. Maintain..."
    },
    {
      "title": "Earnings Maximization",
      "subTitle":
          "Increase earnings by accepting nearby orders. Look for peak time...."
    },
    {
      "title": "Order Preparation Tips",
      "subTitle":
          "Double-check items before leaving pick-up. Communicate issues..."
    },
  ];

  List<FawModels> filterUniqueFAQByType(List<FawModels> faqList) {
    final uniqueFAQMap = <String, FawModels>{};

    for (var faq in faqList) {
      if (!uniqueFAQMap.containsKey(faq.faqType)) {
        uniqueFAQMap[faq.faqType ?? ''] = faq;
      }
    }

    return uniqueFAQMap.values.toList();
  }
}
