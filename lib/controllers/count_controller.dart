import 'package:get/get.dart';

class CountController extends GetxController {
  var taskCount = 0.obs;
  var incidentCount = 0.obs;
  var surveyCount = 0.obs;

  void updateCount(String type, int count) {
    if (type == 'task') {
      taskCount.value = count;
    } else if (type == 'incident') {
      incidentCount.value = count;
    } else if (type == 'survey') {
      surveyCount.value = count;
    }
  }
}