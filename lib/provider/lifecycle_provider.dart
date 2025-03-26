import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';

class AppLifecycleProvider with ChangeNotifier, WidgetsBindingObserver {
  AppLifecycleProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isAvailable('Y'); // Call API when app is resumed
    }
    if (state == AppLifecycleState.paused) {
      isAvailable('N');
    } else if (state == AppLifecycleState.detached) {
      isAvailable('N');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    isAvailable('N');
    super.dispose();
  }

  Future<void> isAvailable(String status) async {
    debugPrint('isAvailable is called $status');
    ApiService apiService = ApiService();
    var data = await apiService
        .putData2('api/worker-status-update', {"isOnlineStatus": status});

    debugPrint('isAvailable ${data}');
  }
}
