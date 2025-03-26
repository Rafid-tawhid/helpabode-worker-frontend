import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/shift_config_worker_plan.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../misc/constants.dart';
import '../models/available_schedule_new.dart';
import '../models/schedule_model_new.dart';
import '../models/shift_worker_city_model.dart';

DateTime now = DateTime.now();
String dayName = DateFormat('EEE').format(now);

class ShiftProvider extends ChangeNotifier {
  String selectedDay = dayName;
  List<String> indicesList = [];

  // List<String> activeTimeList = [];
  List<Map<String, dynamic>> newActiveTimeList = [];
  List<Map<String, dynamic>> listOfDate = [];
  List<ShiftConfigWorkerPlan> shiftWorkerplanList = [];
  List<Quarters> quarterList = [];
  List<DateTime> breakingDays = [];
  List<ShiftWorkerCityModel> _workerCityLIST = [];
  List<ShiftWorkerCityModel> get workerCityLIST => _workerCityLIST;
  bool isLoading = false;
  bool isLoadingBttn = false;
  bool deleteIsLoading = false;
  String timeSlot = '';

  changeDate(String date) {
    selectedDay = date;
    print('selectedDay $selectedDay');
    notifyListeners();
  }

  void updateList(int index) {
    if (listOfDate[index]['flag'] == 0) {
      listOfDate[index]['flag'] = 1;
    } else if (listOfDate[index]['flag'] == 1) {
      listOfDate[index]['flag'] = 0;
    }
    notifyListeners();
  }

  void addtoDeleteList(int index) {
    if (listOfDate[index]['deleteFlag'] == 0) {
      listOfDate[index]['deleteFlag'] = 1;
    } else if (listOfDate[index]['deleteFlag'] == 1) {
      listOfDate[index]['deleteFlag'] = 0;
    }
    notifyListeners();
  }

  bool isTimeInRange(String currentTime, String timesloth) {
    debugPrint('currentTime ${currentTime}');
    debugPrint('timeslot ${timesloth}');

    String start = timesloth.substring(0, 5);
    String end = timesloth.substring(timesloth.length - 5);
    DateTime startTime = DateTime.parse("2022-01-01 $start:00");
    DateTime endTime = DateTime.parse("2022-01-01 $end:00");
    DateTime currentTimeDateTime = DateTime.parse("2022-01-01 $currentTime:00");

    return currentTimeDateTime.isAtSameMomentAs(startTime) ||
        currentTimeDateTime.isAfter(startTime) &&
            currentTimeDateTime.isBefore(endTime) ||
        currentTimeDateTime.isAtSameMomentAs(endTime);
  }

  bool isTimeInRange2(String currentTime, String timesloth) {
    String start = timesloth.substring(0, 5);
    String end = timesloth.substring(timesloth.length - 5);
    DateTime startTime = DateTime.parse("2022-01-01 $start:00");
    DateTime endTime = DateTime.parse("2022-01-01 $end:00");
    DateTime currentTimeDateTime = DateTime.parse("2022-01-01 $currentTime:00");

    // Check if currentTime and end are equal, return false
    if (currentTime == end) {
      return false;
    }

    return currentTimeDateTime.isAtSameMomentAs(startTime) ||
        currentTimeDateTime.isAfter(startTime) &&
            currentTimeDateTime.isBefore(endTime) ||
        currentTimeDateTime.isAtSameMomentAs(endTime);
  }

  void deleteScheduleIconShow(
      String daysOfWeek, String id, String zone_title, int index) {
    shiftWorkerplanList.forEach((element) {
      if (element.dayOfWeek == daysOfWeek) {
        element.quarters!.forEach((element) {
          if (isTimeInRange2(id, element.clmData!.first.timeSlot!)) {
            print('final deleted json $index');
            print(element.toJson());
            listOfDate.forEach((item) {
              if (isTimeInRange2(
                  item['title'], element.clmData!.first.timeSlot!)) {
                if (item['deleteFlag'] == 0) {
                  item['deleteFlag'] = 1;
                } else if (item['deleteFlag'] == 1) {
                  item['deleteFlag'] = 0;
                }
              }
            });
          }
        });
      }
    });

    notifyListeners();
  }

  Quarters? deleteScheduleQuarte(String daysOfWeek, String id) {
    Quarters? deleteQuarter;
    shiftWorkerplanList.forEach((element) {
      if (element.dayOfWeek == daysOfWeek) {
        element.quarters!.forEach((element) {
          if (isTimeInRange2(id, element.clmData!.first.timeSlot!)) {
            print('Deleted Quarter Json');
            print(element.toJson());
            deleteQuarter = element;
          }
        });
      }
    });

    return deleteQuarter;
  }

  Future<bool> getWorkerScheduleInfo() async {
    try {
      print("try");

      print("_______ SHIFT CONFIG GET _________");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await get(
        Uri.parse("${urlBase}api/workerShiftConfiguration"),
        headers: header,
      );

      var responseDecodeJson = jsonDecode(response.body);
      print('RESPONSE $responseDecodeJson');

      if (response.statusCode == 200) {
        shiftWorkerplanList.clear();
        _workerCityLIST.clear();
        var responseDecodeJson = jsonDecode(response.body);
        for (Map i in responseDecodeJson['worker_plan']) {
          shiftWorkerplanList.add(ShiftConfigWorkerPlan.fromJson(i));
        }
        for (Map i in responseDecodeJson['worker_city']) {
          _workerCityLIST.add(ShiftWorkerCityModel.fromJson(i));
        }
        print('shiftWorkerplanList ${shiftWorkerplanList.length}');
        print('workerCityLIST ${_workerCityLIST.length}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("catch 2");
      print(e);

      return false;
    }
  }

  Future<void> setShifthour(String daysOfWeek) async {
    debugPrint('daysOfWeek ${daysOfWeek}');
    bool callOnce = false;
    //  print(daysOfWeek);
    // activeTimeList.clear();
    listOfDate.clear();

    if (shiftWorkerplanList.isNotEmpty) {
      for (var element in shiftWorkerplanList) {
        if (element.dayOfWeek == daysOfWeek) {
          quarterList.clear();
          newActiveTimeList.clear();
          for (var element in element.quarters!) {
            quarterList.add(element);
          }

          for (var element in quarterList) {
            List<String> timeParts =
                element.clmData!.first.timeSlot!.split('-');
            String zoneTitle = element.clmData!.first.zoneTitle ?? '';
            String duration = element.clmData!.first.duration ?? '';
            String startTime = timeParts[0];
            String endTime = timeParts[1];

            // Accumulate the values in activeTimeList across all iterations
            // activeTimeList.addAll(generateTimeList(startTime, endTime));

            newActiveTimeList.addAll(
                generateTimeMapList(startTime, endTime, zoneTitle, duration));

            for (var element in newActiveTimeList) {
              print('timeMapList $element');
            }
            print('timeMapList ${newActiveTimeList.length}');

            // print('newActiveTimeList ${newActiveTimeList.toString()}');
            // debugPrint('------------Final Results---------:$newActiveTimeList');

            // print('generateTimeList(startTime, endTime) ${generateTimeList(startTime, endTime)}');

            // Create listOfDate after all iterations
            if (quarterList.last == element) {
              listOfDate = List.generate(
                96,
                (index) {
                  // debugPrint('-------Key of selected------${newActiveTimeList}');
                  // bool hasKey0515 = newActiveTimeList.any((map) => map.containsKey(getTimeAtIndex(index)));
                  dynamic value0515 = newActiveTimeList.firstWhere(
                      (map) => map.containsKey(getTimeAtIndex(index)),
                      orElse: () => {});

                  // debugPrint('-------Key of selected------${value0515.length != 0 ? value0515[getTimeAtIndex(index)]['duration'] : null}');
                  return {
                    'title': getTimeAtIndex(index),
                    'id': getTimeAtIndex(index),
                    'flag': 0,
                    'deleteFlag': 0,
                    'area': '',
                    'city': '',
                    'duration': value0515.length != 0
                        ? value0515[getTimeAtIndex(index)]['duration']
                        : '',
                    'selected': newActiveTimeList
                        .any((map) => map.containsKey(getTimeAtIndex(index))),
                    'zone_title': value0515.length != 0
                        ? value0515[getTimeAtIndex(index)]['zone_title']
                        : '',
                  };
                },
              );
            }
          }

          callOnce = true;
        } else {
          debugPrint('NO DAY FOUND');
        }
      }
    }

    if (!callOnce) {
      newActiveTimeList.clear();
      listOfDate = List.generate(
        96,
        (index) => {
          'title': getTimeAtIndex(index),
          'id': getTimeAtIndex(index),
          'flag': 0,
          'deleteFlag': 0,
          'area': '',
          'city': '',
          'duration': '',
          'selected': false,
          'zone_title': '',
        },
      );
    }

    notifyListeners();
  }

  bool hasFlagSetTo1() {
    return listOfDate
        .any((item) => item['flag'] == 1 && item['selected'] == false);
  }

  Map<String, String> calculateMinMaxTime() {
    List<String> titlesWithFlag1 = listOfDate
        .where((item) => item['flag'] == 1)
        .map((item) => item['title'] as String)
        .toList();

    if (titlesWithFlag1.isEmpty) {
      // No items with flag=1, return default values or handle accordingly
      return {'minTitle': '', 'maxTitle': ''};
    }
    // Calculate minimum and maximum titles
    String minTitle =
        titlesWithFlag1.reduce((a, b) => a.compareTo(b) < 0 ? a : b);
    String maxTitle =
        titlesWithFlag1.reduce((a, b) => a.compareTo(b) > 0 ? a : b);

    return {'minTitle': minTitle, 'maxTitle': maxTitle};
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setLoadingBtn(bool loading) {
    isLoadingBttn = loading;
    notifyListeners();
  }

  //for shift viwer

  List<Map<String, dynamic>> scheduleList = [];

  void makeScheduleList(String dayName) async {
    scheduleList = await List.generate(
      96,
      (index) {
        return {
          'title': getTimeString(index),
          'id': index,
          'flag': 0,
          'deleteFlag': 0,
          'area': '',
          'city': '',
          'duration': '',
          'selected': false,
          'zone_title': '',
          'booked': ifAvailable(dayName, getTimeString(index).toString())
        };
      },
    );

    notifyListeners();
  }

  setSelected(int index) {
    scheduleList[index]['selected'] = !scheduleList[index]['selected'];
    notifyListeners();
  }

  clearTimeList() {
    scheduleList.clear();
    notifyListeners();
  }

  String getTimeString(int index) {
    // Calculate hour and minute
    int hour = index ~/ 4;
    int minute = (index % 4) * 15;

    // Format hour and minute to display leading zeros
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    // Combine hour and minute into a time string
    return '$hourStr:$minuteStr';
  }

  bool ifAvailable(String day, String time) {
    return shiftWorkerplanList
        .where((element) => element.dayOfWeek == day)
        .any((element) {
      return element.quarters!.any((quarter) {
        return quarter.clmData!.any((clmData) {
          return isTimeInRange(time, clmData.timeSlot.toString());
        });
      });
    });
  }

  Future deleteShiftConfigData(
    String dayOfWeek,
    String startTime,
    String endTime,
  ) async {
    try {
      print("try ");
      deleteIsLoading = true;
      notifyListeners();
      print("before delete 2 $dayOfWeek/${startTime}/${endTime}");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await delete(
        Uri.parse(
            "${urlBase}api/workerShiftConfigurationDelete/$dayOfWeek/$startTime/$endTime/"),
        headers: header,
      );
      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);

        print('Response Json');
        print(responseDecodeJson);
        print('Returning Response Json');
        //call all info again
        await getWorkerScheduleInfo();

        deleteIsLoading = false;
        notifyListeners();
        return true;
      } else {
        deleteIsLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("catch");
      print(e);
      deleteIsLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setBreakDays(DateTime selectedDates) {
    // breakingDays.clear();
    if (breakingDays.contains(selectedDates)) {
      breakingDays.remove(selectedDates);
    } else {
      breakingDays.add(selectedDates);
    }
    debugPrint('breakingDays ${breakingDays.length}');
    notifyListeners();
  }

  void setSelectedDate(List<DateTime> selectedDates) {
    breakingDays.clear();
    breakingDays.addAll(selectedDates);
    debugPrint('brakeDateList ${breakingDays.length}');
    notifyListeners();
  }

  Future<void> newShiftConfiguration(
      {String? startDate,
      String? startTime,
      String? endDate,
      String? endTime,
      BuildContext? context}) async {
    Map<String, dynamic> result = {
      "franchisetextId": franchiseTextId,
      "workertextId": textId,
      "start_date": startDate,
      "end_date": endDate,
      "start_time": startTime,
      "end_time": endTime,
      "selected_zone": ["zone1"],
      "scheduleStatus": "available",
      "break_dates": breakingDays
          .map((date) => "${date.year}-${date.month}-${date.day}")
          .join(", ")
          .split(", ")
    };

    ApiService apiService = ApiService();
    var data = await apiService.postData2(
        'http://192.168.1.10:8000/home/schedule', result);
    if (data != null) {
      breakingDays.clear();
      DashboardHelpers.showAlert(msg: 'Shift Added Successfully!');
    }
  }

  List<ScheduleModelNew> _scheduleList = [];

  List<ScheduleModelNew> get scheduleListNew => _scheduleList;

  List<AvailableScheduleNew> _availableList = [];

  List<AvailableScheduleNew> get availableList => _availableList;
  List<String> _scheduleIntervalList = [];

  List<String> get scheduleIntervalList => _scheduleIntervalList;

  Future<void> getShiftConfiguration() async {
    ApiService apiService = ApiService();
    var data = await apiService.getData2(
        'http://192.168.1.10:8000/home/schedule-view/$textId/$franchiseTextId/');
    if (data['results'] != null || data['results'].toString().isNotEmpty) {
      _scheduleList.clear();
      _availableList.clear();
      _scheduleIntervalList.clear();
      for (var i in data['results'][0]['scheduleList']) {
        _scheduleList.add(ScheduleModelNew.fromJson(i));
        _scheduleIntervalList
            .add([i['schedule'][0], i['schedule'][1]].toString());
      }
      for (var i in data['results'][0]['availableList']) {
        _availableList.add(AvailableScheduleNew.fromJson(i));
      }
      debugPrint('availableList ${availableList.length}');
      debugPrint('scheduleList ${scheduleListNew.length}');
      debugPrint('_scheduleIntervalList ${_scheduleIntervalList}');
    }
  }

  bool isTimeInRangeNew(String targetTime) {
    // Convert the target time to minutes
    int targetMinutes = _timeStringToMinutes(targetTime);

    for (String rangeString in scheduleIntervalList) {
      // Parse the range from the string format "[start, end]"
      List<String> range =
          rangeString.replaceAll('[', '').replaceAll(']', '').split(', ');

      int startMinutes = _timeStringToMinutes(range[0]);
      int endMinutes = _timeStringToMinutes(range[1]);

      // Check if target time falls within the range
      if (targetMinutes >= startMinutes && targetMinutes < endMinutes) {
        return true;
      }
    }

    return false; // Return false if no range matches
  }

// Helper function to convert "HH:mm" to total minutes
  int _timeStringToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  List<Map<String, dynamic>> _timeSlotList = [];
  List<Map<String, dynamic>> get timeSlotList => _timeSlotList;

  void getTimeSlots() async {
    _timeSlotList.clear();
    _timeSlotZones.clear();

    _timeSlotList = List.generate(
      96,
      (index) {
        String slot = getTimeAtIndex(index);
        Map<String, dynamic>? data = getScheduleMap(slot);
        bool isUnique = data != null &&
            isUniqueZone(
                data['status'] == 'Booked'
                    ? data['bookedSlot']
                    : data['timeSlot'],
                slot,
                data['zoneTextId']);

        return {
          'title': slot,
          'id': slot,
          'flag': 0,
          'deleteFlag': 0,
          'area': data == null ? '' : data['zoneTitle'],
          'city': '',
          'status': data == null ? 'unused' : data['status'],
          'timeSlot': data == null
              ? ''
              : data['status'] == 'booked'
                  ? data['bookedSlot']
                  : data['timeSlot'],
          'bookedSlot': data == null ? '' : data['bookedSlot'],
          'selected': '',
          'end_date': data == null ? '' : data['end_date'],
          'start_date': data == null ? '' : data['start_date'] ?? '2025-03-08',
          'finished': data == null ? '' : isLastTimeInSlot(data['timeSlot'], slot),
          'zone': isUnique,
          'zoneNext': false,
          'scheduleDifference': data == null ? '' : data['scheduleDifference']
        };
      },
    );

    // Update "zoneNext" in the next index if the current index has "zone" as true
    for (int i = 0; i < _timeSlotList.length - 1; i++) {
      if (_timeSlotList[i]['zone'] == true &&
          _timeSlotList[i]['status'] != 'Booked') {
        _timeSlotList[i + 1]['zoneNext'] = true;
      }
    }
    notifyListeners();
  }

  // void getTimeSlots() async{
  //   _timeSlotList.clear();
  //   _timeSlotZones.clear();
  //   _timeSlotList=  List.generate(
  //     96,
  //         (index) {
  //       String slot=getTimeAtIndex(index);
  //       Map<String, dynamic>? data=getScheduleMap(slot);
  //       return {
  //         'title': slot,
  //         'id': slot,
  //         'flag': 0,
  //         'deleteFlag': 0,
  //         'area': data==null?'':data['zoneTitle'],
  //         'city': '',
  //         'status':data==null?'unused':data['status'],
  //         'timeSlot': data==null?'':data['timeSlot'],
  //         'bookedSlot': data==null?'':data['bookedSlot'],
  //         'selected': '',
  //         'end_date':data==null?'':data['end_date'],
  //         'finished':data==null?'': isLastTimeInSlot(data['timeSlot'],slot),
  //         'zone': data==null?'': isUniqueZone(data['timeSlot'],slot,data['zoneTextId']),
  //         'zoneNext': '',
  //       };
  //     },
  //   );
  //
  //   notifyListeners();
  // }

  bool isLastTimeInSlot(String timeSlot, String time) {
    //add 15 min extra to separate time slots
    var extTime = DashboardHelpers.addMinutesToTime(time, 15);
    List<String> rangeParts = timeSlot.split('-');
    if (rangeParts.length != 2) return false;
    String lastTimeInRange = rangeParts[1]; // Get the end time of the range
    debugPrint('TimeInRange ${lastTimeInRange} and time ${extTime} and value ${lastTimeInRange == extTime} ');
    return lastTimeInRange == extTime;
  }

  void updateSelectedTimeSlot(int index) {
    if (_timeSlotList[index]['flag'] == 0) {
      _timeSlotList[index]['flag'] = 1;
    } else if (_timeSlotList[index]['flag'] == 1) {
      _timeSlotList[index]['flag'] = 0;
    }
    notifyListeners();
  }

  bool _showDatePicker = false;
  bool get showDatePicker => _showDatePicker;

  void showDatePicter({bool? val}) {
    if (val == null) {
      _showDatePicker = !showDatePicker;
    } else {
      _showDatePicker = val;
    }
    notifyListeners();
    debugPrint('showDatePicker ${showDatePicker}');
  }

  bool? _isStartButtonClicked;
  bool? get isStartButtonClicked => _isStartButtonClicked;

  void isStartButtonClick(bool val) {
    _isStartButtonClicked = val;
    notifyListeners();
  }

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setDate(String type, DateTime date) {
    if (type == 'start') {
      _startDate = date;
      debugPrint('Start data ${date}');
    } else {
      _endDate = date;
      debugPrint('End data ${date}');
    }
    notifyListeners();
  }

  bool _showTimePickerW = false;
  bool get showTimePickerW => _showTimePickerW;

  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;

  void setSelectedStartEndTime(DateTime newTime, String type) {
    if (type == 'start') {
      _startTime = newTime;
    } else {
      _endTime = newTime;
    }

    notifyListeners();
  }

  Future<void> setStartTimeAndEndTimeToNull() async {
    _startTime = null;
    _endTime = null;
    // _endDate=null;
    // _startDate=null;
    debugPrint('_startDate ${_startDate}');
    notifyListeners();
  }

  Map<String, dynamic>? getScheduleMap(String time) {
    for (var slot in dateWiseTimeSlotList) {
      if (slot.containsKey(time)) {
        return slot[time]; // Return the matched slot data
      }
    }
    return null; // Return null if not found
  }

  List<Map<String, dynamic>> dateWiseTimeSlotList = [];

  Future<void> getNewScheduleInfo(String date) async {
    ApiService apiService = ApiService();
    setLoading(true);
    var data = await apiService.getData('api/scheduleView/${date}');
    setLoading(false);
    if (data != null) {
      _workerCityLIST.clear();
      dateWiseTimeSlotList.clear();
      if (data['workerListArray'].isNotEmpty) {
        for (var i in data['workerListArray'][0]['column_json']) {
          dateWiseTimeSlotList.add(i);
        }
      }
      for (Map i in data['workerCityArray']) {
        _workerCityLIST.add(ShiftWorkerCityModel.fromJson(i));
      }
      getTimeSlots();
    }
    setLoading(false);
    debugPrint('dateWiseTimeSlotList ${dateWiseTimeSlotList.length}');
  }

  void setInitialDateAndTime(String firstTime, String lastTime, String today) {
    // _startDate= DateFormat('yyyy-MM-dd').parse(today);
    _startTime = getDateTimeFromTime(firstTime);
    _endTime = getDateTimeFromTime(lastTime);
    if (_startDate == null) {
      _startDate = DateTime.now();
    }
    if (_endDate == null) {
      _endDate = DateTime.now();
    }
    debugPrint('This is initial _starttime ${_startTime}');
    debugPrint('This is initial _endDate ${_endTime}');
    debugPrint('This is initial _startDate ${_startDate}');
    notifyListeners();
  }

  DateTime getDateTimeFromTime(String timeString) {
    DateTime now = DateTime.now(); // Get today's date
    DateTime time = DateFormat('HH:mm').parse(timeString); // Parse the time
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Future<dynamic> saveNewShiftConfiguration(var data) async {
    ApiService apiService = ApiService();
    setLoading(true);
    var response = await apiService.postData2('api/scheduleGenerate', data);
    setLoading(false);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  final Map<String, Set<String>> _timeSlotZones = {};

  bool isUniqueZone(String timeSlot, String time, String zoneId) {
    if (!_timeSlotZones.containsKey(timeSlot)) {
      _timeSlotZones[timeSlot] = {zoneId};
      return true;
    }

    if (_timeSlotZones[timeSlot]!.contains(zoneId)) {
      return false;
    }
    _timeSlotZones[timeSlot]!.add(zoneId);
    return true;
  }

  Future<bool> pauseAschedule(data, DateTime date, bool isPause) async {
    debugPrint('Pause Data : ${data.toString()}');
    ApiService apiService = ApiService();
    var pause = isPause != true ? 'Pause' : 'Unpause';
    setLoading(true);
    var response = await apiService.putData2(
        'api/schedulePauseUnpause/${pause}/${DashboardHelpers.convertDateTime(date.toString(), pattern: 'yyyy-MM-dd')}/${data['timeSlot']}',
        {});
    setLoading(false);
    if (response['message'] != null)
      DashboardHelpers.showAlert(msg: response['message']);
    return response != null ? true : false;
  }

  Future<bool> newDeleteShiftConfig(data, DateTime date) async {
    debugPrint('Pause Data : ${data.toString()}');
    ApiService apiService = ApiService();
    setLoading(true);
    var response = await apiService.deleteData(
        'api/scheduleDelete/${DashboardHelpers.convertDateTime(date.toString(), pattern: 'yyyy-MM-dd')}/${data['timeSlot']}');
    setLoading(false);
    if (response['message'] != null)
      DashboardHelpers.showAlert(msg: response['message']);
    return response != null ? true : false;
  }

  Future<dynamic> showBookedOrderDetails(
      DateTime selectedDate, timeRange) async {
    ApiService apiService = ApiService();
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    debugPrint('selectedDate ${formattedDate}');
    debugPrint('item ${timeRange}');
    var data = await apiService.getData(
        'api/scheduleBookDetails/${formattedDate}/${timeRange.toString().replaceAll(" ", "")}');
    if (data != null) {
      return data;
    } else {
      return null;
    }
  }
}

//TODO: NEW 1
List<Map<String, dynamic>> generateTimeMapList(
    String startTime, String endTime, String zt, String d) {
  List<Map<String, dynamic>> timeMapList = [];

  List<int> startComponents = startTime.split(':').map(int.parse).toList();
  List<int> endComponents = endTime.split(':').map(int.parse).toList();

  int startHour = startComponents[0];
  int startMinute = startComponents[1];
  int endHour = endComponents[0];
  int endMinute = endComponents[1];

  while (startHour < endHour ||
      (startHour == endHour && startMinute <= endMinute)) {
    String key =
        '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
    Map<String, dynamic> newEntry = {
      "zone_title": zt,
      "duration": d,
    };

    // Check if the key already exists in the list
    int existingIndex =
        timeMapList.indexWhere((element) => element.containsKey(key));
    if (existingIndex != -1) {
      // If the key exists, update the value
      timeMapList[existingIndex][key] = newEntry;
    } else {
      // If the key doesn't exist, add a new entry to the list
      timeMapList.add({key: newEntry});
    }

    startMinute += 15;
    if (startMinute >= 60) {
      startMinute -= 60;
      startHour += 1;
    }
  }
  //remove the last index each time to show properly in ui
  timeMapList.isNotEmpty ? timeMapList.removeLast() : null;
  return timeMapList;
}

String getTimeAtIndex(int index) {
  int totalMinutes = index * 15;
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  String hourString = hours.toString().padLeft(2, '0');
  String minuteString = minutes.toString().padLeft(2, '0');

  return '$hourString:$minuteString';
}
