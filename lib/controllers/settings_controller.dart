// Controller class for managing settings state
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SettingsController extends GetxController {
  var locationSettings = true.obs;
  var pushNotifications = true.obs;
  var emailNotifications = false.obs;
}