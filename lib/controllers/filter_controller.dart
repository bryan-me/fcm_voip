import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'base_data_controller.dart';

///Old
// import 'package:get/get.dart';
//
// class FilterController extends GetxController {
//   // Observable fields for filters
//   var selectedCustomer = ''.obs;
//   var selectedTaskNumber = ''.obs;
//   var selectedStatus = ''.obs;
//   var selectedSeverity = ''.obs;
//
//   // Method to apply filters (you can customize this logic)
//   void applyFilters() {
//     // Example logic: print or use the selected filters
//     print('Filters Applied:');
//     print('Customer: ${selectedCustomer.value}');
//     print('Task Number: ${selectedTaskNumber.value}');
//     print('Status: ${selectedStatus.value}');
//     print('Severity: ${selectedSeverity.value}');
//   }
//
//   // Method to reset filters
//   void resetFilters() {
//     selectedCustomer.value = '';
//     selectedTaskNumber.value = '';
//     selectedStatus.value = '';
//     selectedSeverity.value = '';
//   }
// }

///New
class FilterController extends GetxController {
  final selectedCustomer = ''.obs;
  final selectedTaskNumber = ''.obs;
  final selectedStatus = ''.obs;
  final selectedSeverity = ''.obs;

  void resetFilters() {
    selectedCustomer.value = '';
    selectedTaskNumber.value = '';
    selectedStatus.value = '';
    selectedSeverity.value = '';

    Get.find<BaseDataController>().applyFilters(
      customer: null,
      taskNumber: null,
      status: null,
      severity: null,
    ); // Reset filters
  }

  void applyFilters() {
    print('Applying filters...');
    Get.find<BaseDataController>().applyFilters(
      customer: selectedCustomer.value.isEmpty ? null : selectedCustomer.value,
      taskNumber: selectedTaskNumber.value.isEmpty ? null : selectedTaskNumber.value,
      status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      severity: selectedSeverity.value.isEmpty ? null : selectedSeverity.value,
    );
  }
}