// Controller class for managing filter state
import 'package:get/get.dart';

class FilterController extends GetxController {
  var selectedCategory = ''.obs;
  var selectedState = ''.obs;

  // Example filter options
  final categories = ['Task', 'Survey', 'Incident'];
  final states = ['New', 'Pending', 'Completed'];

  void clearFilters() {
    selectedCategory.value = '';
    selectedState.value = '';
  }
}

