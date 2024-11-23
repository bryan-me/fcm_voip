import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/model/base_data.dart';
import '../services/auth_service.dart'; // Import the AuthService for token handling

class BaseDataController {
  final String baseUrl;
  final AuthService authService; // Dependency on AuthService for token management

  BaseDataController({required this.baseUrl, required this.authService});

  /// Fetches the base data for a specific technician
  // Future<List<BaseData>> fetchBaseData(String userId) async {
  //   final url = Uri.parse('$baseUrl/mobile/tickets/mobile-data?technicianId=$userId');
  //
  //   // Retrieve the access token
  //   // final currentUserId = await authService.getCurrentUserId();
  //
  //   final accessToken = await authService.getToken(userId);
  //   print('Access Token: $accessToken');
  //
  //   if (accessToken == null) {
  //     throw Exception('Access token is missing. Please log in again.');
  //   }
  //
  //   try {
  //     // Make the HTTP GET request with the Authorization header
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );
  //
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       // Parse the response JSON
  //       final List<dynamic> jsonData = jsonDecode(response.body);
  //       return jsonData.map((e) => BaseData.fromJson(e)).toList();
  //     } else if (response.statusCode == 401) {
  //       throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
  //     } else {
  //       throw Exception(
  //           'Failed to fetch data: ${response.statusCode} ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     throw Exception('An error occurred while fetching base data: $e');
  //   }
  // }

  Future<List<BaseData>> fetchBaseData(String userId) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return [
      BaseData(
        id: '3aefadf4-a398-45df-8c83-d394072363dd',
        title: 'FAB SALTPOND PACKAGING LTD PREMISES',
        client: 'FIRST ATLANTIC BANK',
        taskType: 'incident',
        dateAssigned: DateTime.now(),
        serviceRecordId: 10102,
        siteId: '5349',
        type: 'Incident',
        technicianId: '',
        assignedTo: '',
        project: 'first atlantic bank 2020',
      ),
    ];
  }
}