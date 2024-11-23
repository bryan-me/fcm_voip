// import 'dart:convert';
// import 'dart:io';
//
// import 'package:fcm_voip/services/auth_service.dart';
// import 'package:fcm_voip/services/form_response.dart';
// import 'package:fcm_voip/utilities/form.dart';
// import 'package:fcm_voip/utilities/note_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
//
// import '../../controllers/form_controller.dart';
// import '../../data/form_data.dart';
// import '../../data/model/task_model/form_model.dart';
// import '../../services/hive_service.dart';
// import '../../utilities/exception.dart';
// import '../../utilities/filter.dart';
// import '../../utilities/network.dart';
// import '../../utilities/resources/custom_dialog.dart';
// import '../../utilities/resources/dashed_divider.dart';
// import '../login/login.dart';
//
// class IncidentsScreen extends StatefulWidget {
//   const IncidentsScreen({super.key});
//
//   @override
//   State<IncidentsScreen> createState() => _IncidentsScreenState();
// }
//
// class _IncidentsScreenState extends State<IncidentsScreen> {
//   Future<FormResponse>? _formsResponse;
//
//   int pendingTasksCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _formsResponse = fetchForms();
//     _updatePendingTasksCount();
//   }
//
//   void _updatePendingTasksCount() async {
//     int count = await getPendingTasksCount();
//     setState(() {
//       pendingTasksCount = count;
//     });
//   }
//
//
//   Future<FormResponse> fetchForms() async {
//     var hiveBoxHelper = HiveBoxHelper();
//     var formBox = await hiveBoxHelper.openBox<FormModel>('forms');
//
//     // Check for internet connection
//     bool isConnected = await ConnectivityUtil.isConnected();
//     print("Is connected to the internet: $isConnected");
//
//     if (!isConnected) {
//       // Offline: Retrieve data from Hive
//       print("Fetching data from Hive due to no internet connection.");
//       if (formBox.isNotEmpty) {
//         var forms = formBox.values.toList();
//         print("Fetched ${forms.length} forms from Hive.");
//         return FormResponse(data: forms, statusCode: 200, message: 'Fetched from Hive');
//       } else {
//         print("No forms found in Hive. Attempting server fetch.");
//         // Attempt server fetch if Hive is empty
//         try {
//           return await _fetchFromServerAndSaveInHive();
//         } catch (e) {
//           if (e.toString().contains('401')) {
//             print("Unauthorized (401). Redirecting to login.");
//             _promptReLogin();
//             throw UnauthorizedException("Session expired. Please log in again.");
//           } else {
//             print("An error occurred: $e");
//             throw Exception("Failed to fetch forms from the server.");
//           }
//         }
//       }
//     } else {
//       // Online: Fetch from server and save in Hive
//       try {
//         return await _fetchFromServerAndSaveInHive();
//       } catch (e) {
//         if (e.toString().contains('401')) {
//           print("Unauthorized (401). Redirecting to login.");
//           _promptReLogin();
//           throw UnauthorizedException("Session expired. Please log in again.");
//         } else {
//           print("An error occurred: $e");
//           throw Exception("Failed to fetch forms from the server.");
//         }
//       }
//     }
//   }
//
// // Method to redirect user to the login screen
//   void _promptReLogin() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Session Expired'),
//           content: Text('Your session has expired. Please log in again to continue.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 // Navigate to the login screen
//
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => const Login()),
//                 );
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<int> getPendingTasksCount() async {
//     var box = await Hive.openBox('formPayloadQueue');
//     return box.length; // Each entry corresponds to a pending task
//   }
//
// // Helper method to fetch from the server and save data to Hive
//   Future<FormResponse> _fetchFromServerAndSaveInHive() async {
//     final authService = AuthService();
//     String? userId = await authService.getUserId();
//     if (userId == null) throw Exception('User not authenticated');
//
//     final token = await authService.getToken(userId);
//     if (token == null) throw Exception('Not authenticated');
//
//     final String endpoint = '${dotenv.env['FIND_ALL_FORMS']}';
//     final response = await http.get(
//       Uri.parse(endpoint),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     print('Response status: ${response.statusCode}');
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is List) {
//         var formResponse = FormResponse.fromJson(jsonResponse);
//
//         // Update Hive with new data from the server
//         var hiveBoxHelper = HiveBoxHelper();
//         var formBox = await hiveBoxHelper.openBox<FormModel>('forms');
//         await formBox.clear(); // Clear existing Hive data
//         for (var form in formResponse.data) {
//           await formBox.put(form.id, form); // Save each form by its ID
//           print('Form saved in Hive: ${form.id}');
//         }
//
//         print("Fetched and saved ${formResponse.data.length} forms from server.");
//         return formResponse;
//       } else {
//         throw Exception('Invalid response format');
//       }
//     } else {
//       print('Failed to load forms from server: ${response.statusCode}');
//       throw Exception('Failed to load forms: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           title: const Text('Incidents', style: TextStyle(color: Colors.black)),
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
//                             '$formCount Incident${formCount == 1 ? '' : 's'}',
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           Text('Pending Tasks: $pendingTasksCount'),
//                           const SizedBox(height: 16),
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: formCount,
//                               itemBuilder: (context, index) {
//                                 final form = snapshot.data!.data[index];
//                                 return GestureDetector(
//
//                                   onTap: () {
//                                     final tappedFormId = form.id; // Get the tapped form's ID
//                                     final formController = Get.find<FormController>();
//
//                                     if (formController.isFormAlreadySubmitted(tappedFormId)) {
//                                       // Fetch submitted data for this form
//                                       final formData = formController.getSubmittedFormData(tappedFormId);
//
//                                       // Show dialog with submitted form details
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return Dialog(
//                                             insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//                                             backgroundColor: Colors.transparent,
//                                             child: ClipPath(
//                                               clipper: ZigZagClipper(),
//                                               child: Container(
//                                                 width: MediaQuery.of(context).size.width * 0.9,
//                                                 height: MediaQuery.of(context).size.height * 0.7,
//                                                 color: Colors.white,
//                                                 padding: const EdgeInsets.all(20),
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                                   children: [
//                                                     const Center(
//                                                       child: Column(
//                                                         children: [
//                                                           Icon(
//                                                             Icons.check_circle,
//                                                             color: Colors.green,
//                                                             size: 30,
//                                                           ),
//                                                           SizedBox(height: 10),
//                                                           Text(
//                                                             'Submitted🥳!!',
//                                                             style: TextStyle(
//                                                               fontSize: 20,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 20),
//                                                     const Text(
//                                                       'Form Information',
//                                                       style: TextStyle(
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 10),
//                                                     _buildTitleRow('', formData['formName'] ?? 'N/A'),
//                                                     _buildIdRow('', tappedFormId.toString()),
//                                                     const SizedBox(height: 20),
//                                                     const DashedDivider(
//                                                       height: 2,
//                                                       dashWidth: 10,
//                                                       dashSpacing: 5,
//                                                       color: Colors.grey,
//                                                     ),
//                                                     const SizedBox(height: 30),
//                                                     const Text(
//                                                       'Submitted Data',
//                                                       style: TextStyle(
//                                                         fontSize: 16,
//                                                         fontWeight: FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 10),
//                                                     Expanded(
//                                                       child: GridView.builder(
//                                                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                                           crossAxisCount: 2,
//                                                           crossAxisSpacing: 10,
//                                                           mainAxisSpacing: 10,
//                                                           childAspectRatio: 3,
//                                                         ),
//                                                         itemCount: (formData['payload'] ?? []).length,
//                                                         itemBuilder: (context, index) {
//                                                           final entry = formData['payload'][index];
//                                                           return _buildGridItem(entry);
//                                                         },
//                                                       ),
//                                                     ),
//                                                     Align(
//                                                       alignment: Alignment.centerRight,
//                                                       child: ElevatedButton(
//                                                         onPressed: () => Navigator.pop(context),
//                                                         style: ElevatedButton.styleFrom(
//                                                           backgroundColor: Colors.blue,
//                                                           shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.circular(8),
//                                                           ),
//                                                         ),
//                                                         child: const Text(
//                                                           'Close',
//                                                           style: TextStyle(color: Colors.white),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     } else {
//                                       // Navigate to form screen for unsubmitted forms
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => FormBuild(formId: tappedFormId),
//                                         ),
//                                       );
//                                     }
//                                   },
//
//                                   child: NoteCard(
//                                     title: form.name ?? 'Title',
//                                     region: form.region ?? 'Unknown region',
//                                     branchName:
//                                     form.branchName ?? 'Unknown branch',
//                                     customer:
//                                     form.customer ?? 'Unknown customer',
//                                     siteId: form.name ?? 'N/A',
//                                     dateAssigned: form.dateAssigned ?? 'N/A',
//                                     dateReceived: form.dateReceived ?? 'N/A',
//                                     color: Colors.red.shade600,
//                                     icon: Icons.warning,
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
//   Widget _buildTitleRow(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(width: 2),
//           Expanded(
//             child: Text(
//               value.toString(),
//               style: const TextStyle(
//                   color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 30
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIdRow(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(width: 2),
//           Expanded(
//             child: Text(
//               value.toString(),
//               style: TextStyle(
//                   color: Colors.black54,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGridItem(Map<String, dynamic> entry) {
//     final fieldLabel = entry['field_label'] ?? 'N/A';
//     final answer = entry['answer'];
//
//     if (answer is String && _isBase64Encoded(answer)) {
//       // Decode Base64 and display as an image
//       final imageBytes = base64Decode(answer);
//
//       return GestureDetector(
//         onTap: () {
//           // Open the image in a dialog when tapped
//           showDialog(
//             context: context,
//             builder: (context) {
//               return Dialog(
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0),
//               ),
//               child: Padding(
//               padding: const EdgeInsets.all(16.0),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16.0),
//                         child: Image.memory(
//                           imageBytes,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 8.0,
//                       right: 8.0,
//                       child: IconButton(
//                         icon: const Icon(Icons.cancel, color: Colors.red),
//                         onPressed: () {
//                           // Implement deletion logic here
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//               );
//             },
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               fieldLabel,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.memory(
//                   imageBytes,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Text('Failed to load image');
//                   },
//                 )
//                 // Image.memory(
//                 //   imageBytes,
//                 //   fit: BoxFit.cover,
//                 // ),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Display other text data
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             entry['fieldLabel']  ?? 'N/A',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//               color: Colors.black54,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             answer?.toString() ?? 'N/A',
//             overflow: TextOverflow.ellipsis,
//             maxLines: 3,
//             textAlign: TextAlign.center,
//           )
//         ],
//       );
//     }
//   }
//
//   bool _isValidBase64Image(String data) {
//     final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return base64Regex.hasMatch(data) && (data.length % 4 == 0);
//   }
//
//   bool _isBase64Encoded(String value) {
//     try {
//       // Check if the string is Base64-encoded
//       base64Decode(value);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
// }
//
//


import 'package:flutter/cupertino.dart';

import '../filtered_screen.dart';

class IncidentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilteredScreen(type: 'incident');
  }
}