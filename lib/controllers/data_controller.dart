// import 'package:get/get.dart';
// import '../data/model/base_data.dart';
// import '../services/auth_service.dart';
// import '../controllers/base_data_controller.dart';
//
// class DataController extends GetxController {
//   final RxList<BaseData> filteredData = <BaseData>[].obs;
//   final RxBool isLoading = true.obs;
//   final BaseDataController baseDataController;
//   final AuthService authService;
//
//   DataController(this.baseDataController, this.authService);
//
//   /// Fetch data for the specified type
//   Future<void> fetchFilteredData(String type) async {
//     isLoading.value = true;
//     try {
//       final currentUserId = await authService.getCurrentUserId();
//       if (currentUserId == null) {
//         throw Exception('No user ID found. Please log in again.');
//       }
//       final allData = await baseDataController.fetchBaseData(currentUserId);
//       filteredData.value =
//           allData.where((data) => data.taskType == type).toList();
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch data: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }