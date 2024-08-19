import 'package:expense_manager/controller/themeController.dart';
import 'package:expense_manager/services/notifi_services.dart';
import 'package:expense_manager/theme/theme.dart';
import 'package:expense_manager/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your notification services
  final notificationService = NotificationServices();
  await notificationService.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return GetBuilder<ThemeController>(builder: (ThemeController controller) {
      return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: light,
          home: Dashboard());
    });
  }
}
