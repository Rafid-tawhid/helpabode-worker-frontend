import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/completed_order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/dashboard_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/lifecycle_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/map_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/navbar_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/network_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/notification_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/show_service_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/worker_pending_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/working_service_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/myservice/my_services_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/crop_camera.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/search_area_zip.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/select_categories_screen.dart';
import 'package:help_abode_worker_app_ver_2/launcher_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/profile/edit_profile_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/profile/profile_information_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/account_info_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/mailing_address_screen_2.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/pending_registration_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/photo_id_upload_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/prefered_service_area.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/select_photos_of_id_screen_new.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/select_idcard_type_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/show_my_services_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/ssn_id_screen_2.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/forgot_password_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/otp_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/reset_password_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'auth/auth_screen.dart';
import 'auth/auth_providers.dart';
import 'chat/chat_provider.dart';
import 'custom_packages/mask_for_camera_view.dart';
import 'misc/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //MapboxOptions.setAccessToken('pk.eyJ1IjoicmFmaWR0YXdoaWQiLCJhIjoiY203enBmc3IyMG5veTJscTRzcGNrdTR2dSJ9.waHUb04g9eDS_GybsRv7Dw');
  Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAZ4QEW0_b8Tt0POb9Iuc-3ua-StewI3H0',
          appId: '1:1005492825344:android:05e491cd97d785e96557e5',
          messagingSenderId: '1005492825344',
          projectId: 'team-abode'));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();
  var registrationBox = await Hive.openBox('registrationBox');
  userBox = await Hive.box('registrationBox');
  cameras = await MaskForCameraView.initialize();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider()..getUserLoginInfo(),
    ),
    ChangeNotifierProvider(
      create: (context) => WorkingServiceProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AddNewServiceProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => TabControllerProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ShowServiceProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => PricingProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ShiftProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => WorkerPendingProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CorporateProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CompletedOrderProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MapProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => InternetProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AppLifecycleProvider(),
    ),
  ], child: MyApp()));
}

// @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background ${message.notification!.title.toString()}');
  print('Data ${message.data.toString()}');
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set context for device size
    // CurrentDevice.setContext(context);

    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          //title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.green,
            appBarTheme: AppBarTheme(
              color: Colors.white, // Change the app bar color here
            ),
          ),
          routerConfig: _router,
        );
      },
      // designSize: const Size(428, 926),
      minTextAdapt: true,
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        name: 'launcher',
        path: "/",
        builder: (context, state) => const LauncherScreen(),
        // builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        name: 'home',
        path: "/home",
        //builder: (context, state) => const RegistrationHandlerScreen4(),
        builder: (context, state) => const LoginScreen(),
        // builder: (context, state) => ProfileScreen(),
      ),

      ///Registration
      GoRoute(
        name: 'reset',
        path: "/reset",
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        name: 'forgot_password',
        path: "/forgot_password",
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        name: 'otp',
        path: "/otp",
        builder: (context, state) =>
            OTPScreen(emailText: state.uri.queryParameters['emailText']!),
      ),
      // GoRoute(
      //   name: 'photo_id',
      //   path: "/photo_id",
      //   builder: (context, state) => PhotoIdScreen(
      //     photoIdLabel: state.uri.queryParameters['photoIdLabel']!,
      //     isFrontTemp: state.uri.queryParameters['isFrontTemp']!,
      //     backImageTemp: state.uri.queryParameters['backImageTemp']!,
      //     frontImageTemp: state.uri.queryParameters['frontImageTemp']!,
      //   ),
      // ),
      GoRoute(
        name: 'photo_id_upload',
        path: "/photo_id_upload",
        builder: (context, state) => UploadPhotoId(
          photoIdLabel: state.uri.queryParameters['photoIdLabel']!,
          frontImage: state.uri.queryParameters['frontImage']!,
          isFront: state.uri.queryParameters['isFront']!,
          backImage: state.uri.queryParameters['backImage']!,
        ),
      ),
      GoRoute(
        name: SelectIdCardTypeScreen.routeName,
        path: "/select_photo_id",
        builder: (context, state) => SelectIdCardTypeScreen(),
      ),
      // GoRoute(
      //   name: SelfieCaptureScreen.routeName,
      //   path: "/selfie_capture",
      //   builder: (context, state) => SelfieCaptureScreen(),
      // ),
      GoRoute(
        name: 'ssn',
        path: "/ssn/:workerTextId/:workerStatus",
        builder: (context, state) => SSNIdScreen2(
          workerTextId: state.pathParameters['workerTextId'],
          workerStatus: state.pathParameters['workerStatus'],
        ),
      ),
      GoRoute(
        name: 'mail',
        path: "/mail/:workerTextId/:workerStatus",
        builder: (context, state) => MailingAddressScreen2(
          workerTextId: state.pathParameters['workerTextId'],
          workerStatus: state.pathParameters['workerStatus'],
        ),
      ),
      // GoRoute(
      //   name: 'terms',
      //   path: "/terms",
      //   builder: (context, state) => TermsPhotoIdScreen(photoIdLabel: state.uri.queryParameters['photoIdLabel']!),
      // ),

      ///Dashboard
      GoRoute(
        name: 'dashboard',
        path: "/dashboard",
        builder: (context, state) => DashboardScreen(),
      ),
      // GoRoute(
      //   name: 'city',
      //   path: "/city",
      //   builder: (context, state) => WorkerCityScreen(),
      // ),
      // GoRoute(
      //   name: 'shift_config',
      //   path: "/shift_config",
      //   builder: (context, state) => ShiftConfigurationScreen3(),
      // ),

      GoRoute(
        name: AccountScreen.routeName,
        path: "/account",
        builder: (context, state) => AccountScreen(),
      ),

      // GoRoute(
      //   name: 'customize_service',
      //   path: "/customize_service",
      //   builder: (context, state) => CustomizeServiceAndPriceScreen(),
      // ),

      ///Requested Service
      // GoRoute(
      //   name: 'requested_service',
      //   path: "/requested_service",
      //   builder: (context, state) => RequestedServiceScreen2(),
      // ),
      // GoRoute(
      //   name: 'requested_service_details',
      //   path: "/requested_service_details",
      //   builder: (context, state) => PendingOrderedServiceDetailsScreen(
      //     orderTextId: state.uri.queryParameters['orderTextId']!,
      //     serviceId: 'Nothing',
      //   ),
      // ),

      ///Upcoming Service
      // GoRoute(
      //   name: 'upcoming_service',
      //   path: "/upcoming_service",
      //   builder: (context, state) => UpcomingServiceScreen2(),
      // ),
      // GoRoute(
      //   name: 'upcoming_service_details',
      //   path: "/upcoming_service_details",
      //   builder: (context, state) => UpcomingDetailsScreen2(orderTextId: state.uri.queryParameters['orderTextId']!),
      // ),

      ///Completed Service
      // GoRoute(
      //   name: 'completed_service',
      //   path: "/completed_service",
      //   builder: (context, state) => CompletedServiceScreen2(),
      // ),
      // GoRoute(
      //   name: CompletedServiceDetailsScreen.routeName,
      //   path: "/completed_service_details",
      //   builder: (context, state) => CompletedServiceDetailsScreen(),
      // ),

      GoRoute(
        name: ProfileInformation.routeName,
        path: "/profile_information",
        builder: (context, state) => ProfileInformation(),
      ),
      GoRoute(
        name: EditProfileScreen.routeName,
        path: "/profile_edit",
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        name: PendingRegistrationProcess.routeName,
        path: "/profile_pending",
        builder: (context, state) => const PendingRegistrationProcess(),
      ),
      GoRoute(
        name: SelectServicesScreen.routeName,
        path: "/add_service",
        builder: (context, state) => const SelectServicesScreen(),
      ),
      // GoRoute(
      //   name: SubCategoryServices.routeName,
      //   path: "/sub_category_services",
      //   builder: (context, state) => const SubCategoryServices(),
      // ),
      GoRoute(
        name: SelectPhotoIdScreenNew.routeName,
        path: "/new_photo_id_scren",
        builder: (context, state) => SelectPhotoIdScreenNew(),
      ),

      GoRoute(
        name: PreferedServiceAreas.routeName,
        path: "/prefered_service_area",
        builder: (context, state) => PreferedServiceAreas(),
      ),
      GoRoute(
        name: ShowMyServicesScreen.routeName,
        path: "/show_my_services",
        builder: (context, state) => ShowMyServicesScreen(),
      ),
      GoRoute(
        name: AreaZipSearchScreen.routeName,
        path: "/area_zip_search_screen",
        builder: (context, state) => AreaZipSearchScreen(),
      ),
      GoRoute(
        name: MyServicesScreen.routeName,
        path: "/my_service_screen",
        builder: (context, state) => MyServicesScreen(),
      ),
    ],
  );
}

//HELLO 10 April
