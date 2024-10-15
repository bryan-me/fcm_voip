import 'dart:io';

import 'package:fcm_voip/ui/landing_page.dart';
import 'package:fcm_voip/utilities/resources/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class ApplicationHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

void main() async {
  HttpOverrides.global = ApplicationHttpOverrides();
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = ApplicationHttpOverrides();

  // Hive.registerAdapter(FormModelAdapter());
  // Hive.registerAdapter(FormDetailAdapter());
  // Hive.registerAdapter(FieldOptionAdapter());

  // Logger.root.onRecord.listen((record) {
  //   if (kReleaseMode) {
  //     print('[${record.level.name}] ${record.time}: ${record.message}');
  //   }
  // });

  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        buttonTheme: const ButtonThemeData(buttonColor: AppColors.buttonColor),
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch:
                    AppColors.createMaterialColor(AppColors.primaryColor))
            .copyWith(secondary: AppColors.accentColor),
      ),
      home: LandingPage(title: 'STL Notification Demo'),
    );
  }
}
