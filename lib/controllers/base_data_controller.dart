// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../data/model/base_data.dart';
// import '../services/auth_service.dart'; // Import the AuthService for token handling
//
// class BaseDataController {
//   final String baseUrl;
//   final AuthService authService; // Dependency on AuthService for token management
//
//   BaseDataController({required this.baseUrl, required this.authService});
//
//   /// Fetches the base data for a specific technician
// //   Future<List<BaseData>> fetchBaseData(String userId) async {
// //     final url = Uri.parse('$baseUrl/mobile/tickets/mobile-data?technicianId=$userId');
// //
// //     // Retrieve the access token
// //     // final currentUserId = await authService.getCurrentUserId();
// //
// //     final accessToken = await authService.getToken(userId);
// //     print('Access Token: $accessToken');
// //
// //     if (accessToken == null) {
// //       throw Exception('Access token is missing. Please log in again.');
// //     }
// //
// //     try {
// //       // Make the HTTP GET request with the Authorization header
// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $accessToken',
// //         },
// //       );
// //
// //       print('Response status: ${response.statusCode}');
// //       print('Response body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         // Parse the response JSON
// //         final List<dynamic> jsonData = jsonDecode(response.body);
// //         return jsonData.map((e) => BaseData.fromJson(e)).toList();
// //       } else if (response.statusCode == 401) {
// //         throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
// //       } else {
// //         throw Exception(
// //             'Failed to fetch data: ${response.statusCode} ${response.reasonPhrase}');
// //       }
// //     } catch (e) {
// //       throw Exception('An error occurred while fetching base data: $e');
// //     }
// //   }
// // }
//   Future<List<BaseData>> fetchBaseData(String userId) async {
//     // await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
//     return [
//       BaseData(
//         id: '3aefadf4-a398-45df-8c83-d394072363dd',
//         title: 'FAB SALTPOND PACKAGING LTD PREMISES',
//         client: 'FIRST ATLANTIC BANK',
//         taskType: 'SITE SURVEY',
//         dateAssigned: DateTime.now(),
//         serviceRecordId: 10102,
//         siteId: '5349',
//         type: 'incident',
//         technicianId: '',
//         assignedTo: '',
//         project: 'first atlantic bank 2020',
//         formId: '51b36dc1-2dcd-405e-8d40-c792169e077c',
//       ),
//
//       BaseData(
//         id: '3aefadf4-a398-45df-8c83-d394072363dd',
//         title: 'FAB SALTPOND PACKAGING LTD PREMISES',
//         client: 'FIRST ATLANTIC BANK',
//         taskType: 'SITE SURVEY',
//         dateAssigned: DateTime.now(),
//         serviceRecordId: 10102,
//         siteId: '5349',
//         type: 'task',
//         technicianId: '',
//         assignedTo: '',
//         project: 'first atlantic bank 2020',
//         formId: '',
//       ),
//
//       BaseData(
//         id: '3aefadf4-a398-45df-8c83-d394072363dd',
//         title: 'FAB SALTPOND PACKAGING LTD PREMISES',
//         client: 'FIRST ATLANTIC BANK',
//         taskType: 'SITE SURVEY',
//         dateAssigned: DateTime.now(),
//         serviceRecordId: 10102,
//         siteId: '5349',
//         type: 'task',
//         technicianId: '',
//         assignedTo: '',
//         project: 'first atlantic bank 2020',
//         formId: '',
//       ),
//     ];
//   }
//
//
// }

///New
import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../data/model/base_data.dart';
import '../../services/auth_service.dart';
import '../services/hive_service.dart';
import '../services/websocket_service.dart';
import '../utilities/network.dart';

class BaseDataController extends GetxController {
  final WebSocketService webSocketService;
  final AuthService authService;

  final String baseUrl;

  // Observable lists for data
  RxList<BaseData> allData = <BaseData>[].obs; // Complete dataset
  // final filteredData = <BaseData>[].obs; // Filtered data by type or conditions
  RxList<BaseData> filteredData = <BaseData>[].obs;

  final typeCounts = <String, int>{}.obs; // Tracks counts for each type
  RxBool isLoading = true.obs; // Tracks the loading state

  static const String hiveBoxName = 'forms'; // Hive box name for local storage
  var hiveBoxHelper = HiveBoxHelper();

  BaseDataController({
    required this.baseUrl,
    required this.authService,
    required this.webSocketService,
  });

  // Fetch the technician ID (e.g., for WebSocket subscription or API requests)
  Future<String?> fetchTechId() async {
    return authService.getCurrentUserId();
  }

  @override
  void onInit() async {
    super.onInit();

    // Initialize WebSocket
    webSocketService.onMessageReceived = _handleWebSocketMessage;
    await _initializeWebSocket();

    // Load data (online or offline)
    await loadDataFromHive();
  }

  @override
  void onClose() {
    webSocketService.disconnect();
    super.onClose();
  }

  /// Filter data by a specific date
  void filterDataByDate(DateTime selectedDate) {
    if (allData.isEmpty) {
      filteredData.clear();
      return;
    }

    // Format the selected date for filtering (year, month, and day only)
    final selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    filteredData.assignAll(
      allData.where((item) {
        if (item.dateAssigned == null) return false;

        // Convert task date to year, month, and day for comparison
        final itemDateOnly = DateTime(
          item.dateAssigned!.year,
          item.dateAssigned!.month,
          item.dateAssigned!.day,
        );

        return itemDateOnly == selectedDateOnly;
      }).toList(),
    );

    print("Filtered data by date '${selectedDate.toIso8601String()}': ${filteredData.length} items.");
  }

  /// Initialize WebSocket and subscribe to a technician's channel
  Future<void> _initializeWebSocket() async {
    try {
      final techId = await fetchTechId();
      if (techId != null) {
        webSocketService.connect();
        webSocketService.subscribe("task_$techId");
        print("Subscribed to WebSocket channel: task_$techId");
      } else {
        print("Tech ID not available. Skipping WebSocket subscription.");
      }
    } catch (e) {
      print("Error initializing WebSocket: $e");
    }
  }



  /// Fetch data for the current technician
//   Future<List<BaseData>> fetchBaseData(String userId) async {
//     final url = Uri.parse('http://192.168.250.209:8060/api/v1/activity-service/mobile/tickets/mobile-data?technicianId=$userId');
//     final accessToken = await authService.getToken(userId);
// print('this is the url: $url');
//     if (accessToken == null) {
//       throw Exception('Access token is missing. Please log in again.');
//     }
//
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData['data'] is List) {
//           return (jsonData['data'] as List)
//               .map((item) => BaseData.fromJson(item))
//               .toList();
//         } else {
//           throw Exception('Unexpected data format: "data" field is not a list.');
//         }
//       } else if (response.statusCode == 401) {
//         //             print("Unauthorized (401). Redirecting to login.");
// //             _promptReLogin();
//         throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
//       } else {
//         throw Exception(
//             'Failed to fetch data. Status: ${response.statusCode}, Message: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching base data: $e');
//     }
//   }

  /// Fetch data by type (online or offline)
  Future<void> fetchBaseDataByType(String type) async {
    try {
      isLoading(true);
      bool isConnected = await ConnectivityUtil.isConnected();
      print("Is connected: $isConnected");

      if (isConnected) {
        // Fetch online data
        final currentUserId = await fetchTechId();
        if (currentUserId == null) {
          throw Exception('User ID is missing. Please log in again.');
        }

        final fetchedData = await fetchBaseData(currentUserId);
        allData.assignAll(fetchedData);

        // Store data in Hive for offline access
        await _storeDataInHive(fetchedData);
      } else {
        // Load data from Hive (offline mode)
        print("Offline mode: Loading data from Hive.");
        await loadDataFromHive();
      }

      // Apply type filter
      _filterDataByType(type);
    } catch (e) {
      print("Error fetching data by type: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(String message) async {
    try {
      final data = jsonDecode(message);
      if (data['type'] == 'task' || data['type'] == 'survey' || data['type'] == 'incident') {
        final newData = BaseData.fromJson(data);
        allData.add(newData);
        await _storeDataInHive(allData);
        _filterDataByType(newData.type!);
      } else {
        print("WebSocket: Unsupported data type: ${data['type']}");
      }
    } catch (e) {
      print("WebSocket: Error processing message: $e");
    }
  }

  /// Store data in Hive
  Future<void> _storeDataInHive(List<BaseData> data) async {
    try {
      final box = await hiveBoxHelper.openBox<BaseData>(hiveBoxName);
      final existingData = box.values.toList();

// Check if the new data already exists, and only add unique entries
      for (var newItem in data) {
        if (!existingData.any((existingItem) => existingItem.id == newItem.id)) {
          await box.add(newItem);
        }
      }

      _updateTypeCounts(data);
      print("Data stored in Hive successfully.");
    } catch (e) {
      print("Error storing data in Hive: $e");
    }
  }

  void _updateTypeCounts(List<BaseData> data){
    final counts = <String, int>{};

    for (var item in data) {
      final type = item.type?.toLowerCase() ?? 'unknown';
      counts[type] = (counts[type] ?? 0) + 1;

      typeCounts.refresh();
    }

    typeCounts.assignAll(counts);
    print("Updated type counts: $typeCounts");
  }

  /// Load data from Hive
  Future<void> loadDataFromHive() async {
    try {
      // final box = await Hive.openBox<BaseData>(hiveBoxName);
      final box = await hiveBoxHelper.openBox<BaseData>(hiveBoxName);

      final hiveData = box.values.toList();
      allData.assignAll(hiveData);

      _updateTypeCounts(hiveData);
      print("Data loaded from Hive: ${hiveData.length} items.");
    } catch (e) {
      print("Error loading data from Hive: $e");
    }
  }

  /// Filter data by type
  void _filterDataByType(String type) {
    filteredData.assignAll(
      allData.where((data) => (data.type?.toLowerCase() ?? '').isEmpty || data.type?.toLowerCase() == type.toLowerCase()).toList(),
    );
    print("Filtered data by type '$type': ${filteredData.length} items.");
  }

  /// Apply multiple filters
  // void applyFilters({
  //   String? customer,
  //   String? taskNumber,
  //   String? status,
  //   String? severity,
  // }) {
  //   filteredData.assignAll(
  //     allData.where((item) {
  //       final matchesCustomer = customer == null || item.client == customer;
  //       final matchesTaskNumber = taskNumber == null || item.siteId == taskNumber;
  //       final matchesStatus = status == null || item.type == status;
  //       final matchesSeverity = severity == null || item.type == severity;
  //       return matchesCustomer && matchesTaskNumber && matchesStatus && matchesSeverity;
  //     }).toList(),
  //   );
  //   print("Filtered data: ${filteredData.length} items match the criteria.");
  // }

  void applyFilters({
    String? customer,
    String? taskNumber,
    String? status,
    String? severity,
  }) {
    // Start filtering from the current filtered data
    var currentData = filteredData.toList();

    if (customer != null && customer.isNotEmpty) {
      currentData = currentData.where((item) => item.client == customer).toList();
    }
    if (taskNumber != null && taskNumber.isNotEmpty) {
      currentData = currentData.where((item) => item.siteId == taskNumber).toList();
    }
    if (status != null && status.isNotEmpty) {
      currentData = currentData.where((item) => item.type == status).toList();
    }
    if (severity != null && severity.isNotEmpty) {
      currentData = currentData.where((item) => item.type == severity).toList();
    }

    // Update filteredData with the new subset
    filteredData.value = currentData;
  }


}



  Future<List<BaseData>> fetchBaseData(String userId) async {
    // await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return [
      BaseData(
        id: '3aefadf4-a398-45df-1c83-d394072363dd',
        title: 'FAB SALTPOND PACKAGING LTD PREMISES',
        client: 'FIRST ATLANTIC BANK',
        taskType: 'SITE SURVEY',
        dateAssigned: DateTime.now(),
        serviceRecordId: 10102,
        siteId: '1234',
        type: 'incident',
        technicianId: '',
        assignedTo: '',
        project: 'first atlantic bank 2020',
        formId: 'bc947ba3-d8b7-46ce-b335-c2f39413e092',
      ),

      BaseData(
        id: '3aefadf4-a398-45df-4c83-d394072363dd',
        title: 'GHANA GAS PREMISES',
        client: 'FIRST ATLANTIC BANK',
        taskType: 'SITE SURVEY',
        dateAssigned: DateTime.now(),
        serviceRecordId: 10102,
        siteId: '6789',
        type: 'task',
        technicianId: '',
        assignedTo: '',
        project: 'first atlantic bank 2020',
        formId: 'bc947ba3-d8b7-46ce-b335-c2f39413e092',
      ),

      BaseData(
        id: '3aefadf4-a398-41df-8c83-d394072363dd',
        title: 'MARGIN ID GROUP PREMISES',
        client: 'MARGIN ID GROUP',
        taskType: 'SITE SURVEY',
        dateAssigned: DateTime.now(),
        serviceRecordId: 10102,
        siteId: '6473',
        type: 'Survey',
        technicianId: '',
        assignedTo: '',
        project: 'first atlantic bank 2020',
        formId: 'bc947ba3-d8b7-46ce-b335-c2f39413e092',
      ),




      BaseData(
        id: '3aefadf4-a398-45df-4c83-d334072363dd',
        title: 'TULLOW OIL PREMISES',
        client: 'TULLOW OIL',
        taskType: 'SITE SURVEY',
        dateAssigned: DateTime.now(),
        serviceRecordId: 10102,
        siteId: '83219',
        type: 'Survey',
        technicianId: '',
        assignedTo: '',
        project: 'first atlantic bank 2020',
        formId: 'bc947ba3-d8b7-46ce-b335-c2f39413e092',
      ),

      BaseData(
        id: '3aefadf4-a398-44df-8c83-d394072363dd',
        title: 'SUPERTECH LTD PREMISES',
        client: 'CONSOLIDATED BANK GHANA',
        taskType: 'SITE SURVEY',
        dateAssigned: DateTime.now(),
        serviceRecordId: 10102,
        siteId: '5349',
        type: 'Task',
        technicianId: '',
        assignedTo: '',
        project: 'first atlantic bank 2020',
        formId: 'bc947ba3-d8b7-46ce-b335-c2f39413e092',
      ),
    ];
  }


