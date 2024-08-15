
import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool lightTheme = false;

  void toggleTheme(bool value) {
    lightTheme = value;
    update();
  }
}
