import 'package:expense_manager/controller/themeController.dart';
import 'package:expense_manager/theme/theme.dart';
import 'package:expense_manager/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
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
