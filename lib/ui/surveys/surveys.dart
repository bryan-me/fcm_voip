// import 'dart:convert';
//
// import 'package:fcm_voip/services/auth_service.dart';
// import 'package:fcm_voip/services/form_response.dart';
// import 'package:fcm_voip/utilities/form.dart';
// import 'package:fcm_voip/utilities/note_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
//
// import '../../utilities/filter.dart';
//
// class SurveysScreen extends StatefulWidget {
//   const SurveysScreen({super.key});
//
//   @override
//   State<SurveysScreen> createState() => _SurveysScreenState();
// }
//
// class _SurveysScreenState extends State<SurveysScreen> {
//   Future<FormResponse>? _formsResponse;
//
//   @override
//   void initState() {
//     super.initState();
//     _formsResponse = fetchForms();
//
//     //check that the form retrived from the database is being saved in hive
//     // checkHiveData();
//   }
//
//   Future<FormResponse> fetchForms() async {
//     final authService = AuthService();
//     String? userId = await authService.getUserId();
//
//     if (userId == null) {
//       throw Exception('User not authenticated');
//     }
//
//     final token = await authService.getToken(userId);
//     if (token == null) {
//       throw Exception('Not authenticated');
//     }
//
//     // Make the API call directly to fetch forms
//     final String endpoint = '${dotenv.env['FIND_ALL_FORMS']}';
//
//     final response = await http.get(
//       Uri.parse(endpoint),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}'); // Log the response body
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       if (jsonResponse is Map<String, dynamic> &&
//           jsonResponse['data'] is List) {
//         return FormResponse.fromJson(jsonResponse);
//       } else {
//         throw Exception('Invalid response format');
//       }
//     } else {
//       print('Failed to load forms: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       throw Exception('Failed to load forms: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           title: const Text('Surveys', style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           leading: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: CircleAvatar(
//               backgroundImage: AssetImage('assets/images/fcm_logo.png'),
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.filter_list, color: Colors.black),
//               onPressed: () {
//                 showFilterBottomSheet(context);
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FutureBuilder<FormResponse>(
//                 future: _formsResponse,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     int formCount = snapshot.data!.data.length;
//                     return Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '$formCount Survey${formCount == 1 ? '' : 's'}',
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 16),
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: formCount,
//                               itemBuilder: (context, index) {
//                                 final form = snapshot.data!.data[index];
//                                 return GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             FormBuild(formId: form.id),
//                                       ),
//                                     );
//                                   },
//                                   child: NoteCard(
//                                     title: form.name ?? 'Title',
//                                     region: form.region ?? 'Unknown region',
//                                     branchName:
//                                         form.branchName ?? 'Unknown branch',
//                                     customer:
//                                         form.customer ?? 'Unknown customer',
//                                     siteId: form.name ?? 'N/A',
//                                     dateAssigned: form.dateAssigned ?? 'N/A',
//                                     dateReceived: form.dateReceived ?? 'N/A',
//                                     color: Colors.blue.shade100,
//                                     icon: Icons.camera_alt_sharp,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return const Center(child: Text('No Form Found Currently'));
//                   }
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
// }

import 'package:flutter/cupertino.dart';

import '../filtered_screen.dart';

class SurveysScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilteredScreen(type: 'survey');
  }
}