import 'dart:convert';

import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/services/form_response.dart';
import 'package:fcm_voip/utilities/form.dart';
import 'package:fcm_voip/utilities/note_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../data/form_data.dart';
import '../../utilities/filter.dart';
import '../../utilities/resources/values/colors.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Future<FormResponse>? _formsResponse;

  @override
  void initState() {
    super.initState();
    _formsResponse = fetchForms();

    //check that the form retrived from the database is being saved in hive
    // checkHiveData();
  }


  Future<FormResponse> fetchForms() async {
    final authService = AuthService();
    String? userId = await authService.getCurrentUserId();

    if (userId == null) {
      throw Exception('User not authenticated. Please Re-Login.');
    }

    final token = await authService.getToken(userId);
    if (token == null) {
      throw Exception('Not authenticated, Please Re-Login.');
    }

    final String endpoint = '${dotenv.env['FIND_ALL_FORMS']}';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is List) {
        // Parse response
        List<FormData> formDataList = (jsonResponse['data'] as List)
            .map((item) => FormData.fromJson(item))
            .toList();

        // // Open Hive box and save data
        // var box = await Hive.openBox<FormData>('formsBox');
        // await box.clear(); // Clear previous data if needed
        // for (var form in formDataList) {
        //   await box.add(form);
        // }

        // Return the parsed response
        return FormResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load forms: ${response.statusCode}');
    }
  }

  // Background Thread
  static FormResponse parseFormResponse(String responseBody){
    final jsonResponse = json.decode(responseBody);
    if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is List) {
      return FormResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Tasks', style: TextStyle(
              color: AppColors.titleTextColor)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/fcm_logo.png'),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {
                showFilterBottomSheet(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<FormResponse>(
                future: _formsResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child:
                    // Text('Error: ${snapshot.error}')
                    Text('There\'s an error with your network. Please check and try again.')
                    );
                  } else if (snapshot.hasData) {
                    int formCount = snapshot.data!.data.length;
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$formCount Task${formCount == 1 ? '' : 's'}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: formCount,
                              itemBuilder: (context, index) {
                                final form = snapshot.data!.data[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FormBuild(formId: form.id),
                                      ),
                                    );
                                  },
                                   child: NoteCard(
                                    title: form.name ?? 'Title',
                                    region: form.region ?? 'Unknown region',
                                    branchName:
                                        form.branchName ?? 'Unknown branch',
                                    customer:
                                        form.customer ?? 'Unknown customer',
                                    siteId: form.name ?? 'N/A',
                                    dateAssigned: form.dateAssigned ?? 'N/A',
                                    dateReceived: form.dateReceived ?? 'N/A',
                                     color: Colors.yellow.shade700,
                                    icon: Icons.task,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No Form Found Currently'));
                  }
                },
              ),
            ],
          ),
        ));
  }
}


// import 'dart:convert';
// import 'package:fcm_voip/services/auth_service.dart';
// import 'package:fcm_voip/services/form_response.dart';
// import 'package:fcm_voip/utilities/form.dart';
// import 'package:fcm_voip/utilities/note_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
//
// import '../../data/form_data.dart';
// import '../../data/model/task_model/form_model.dart';
// import '../../utilities/network.dart';
// import '../../utilities/resources/values/colors.dart';
//
// class TasksScreen extends StatefulWidget {
//   const TasksScreen({super.key});
//
//   @override
//   State<TasksScreen> createState() => _TasksScreenState();
// }
//
// class _TasksScreenState extends State<TasksScreen> {
//   Future<FormResponse>? _formsResponse;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchFormsData();
//   }
//
//   Future<void> _fetchFormsData() async {
//     bool isConnected = await ConnectivityUtil.isConnected();
//     if (isConnected) {
//       _formsResponse = fetchFormsFromServer();
//     } else {
//       _formsResponse = fetchFormsFromHive();
//     }
//     setState(() {}); // Refresh the UI after setting _formsResponse
//   }
//
//   Future<FormResponse> fetchFormsFromServer() async {
//     final authService = AuthService();
//     String? userId = await authService.getCurrentUserId();
//
//     if (userId == null) {
//       throw Exception('User not authenticated. Please Re-Login.');
//     }
//
//     final token = await authService.getToken(userId);
//     if (token == null) {
//       throw Exception('Not authenticated, Please Re-Login.');
//     }
//
//     final String endpoint = '${dotenv.env['FIND_ALL_FORMS']}';
//     final response = await http.get(
//       Uri.parse(endpoint),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is List) {
//         List<FormData> formDataList = (jsonResponse['data'] as List)
//             .map((item) => FormData.fromJson(item))
//             .toList();
//
//         var box = await Hive.openBox<FormData>('formsBox');
//         await box.clear();
//         await box.addAll(formDataList);
//
//         return FormResponse.fromJson(jsonResponse);
//       } else {
//         debugPrint('Invalid response format or missing data field: $jsonResponse');
//         throw Exception('Invalid response format');
//       }
//     } else {
//       debugPrint('Server error: ${response.statusCode} - ${response.reasonPhrase}');
//       throw Exception('Failed to load forms: ${response.statusCode}');
//     }
//   }
//
//   Future<FormResponse> fetchFormsFromHive() async {
//     var box = await Hive.openBox<FormData>('formsBox');
//     List<FormData> formDataList = box.values.toList();
//
//     // Convert FormData list to FormModel list
//     List<FormModel> formModelList = formDataList.map((formData) => FormModel.fromFormData(formData)).toList();
//
//     return FormResponse(
//       statusCode: 200,
//       message: 'Fetched from local database',
//       data: formModelList,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Tasks', style: TextStyle(color: AppColors.titleTextColor)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundImage: AssetImage('assets/images/fcm_logo.png'),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<FormResponse>(
//           future: _formsResponse,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               debugPrint('Error in FutureBuilder: ${snapshot.error}');
//               return const Center(
//                 child: Text('Error loading forms. Please check your network and try again.'),
//               );
//             } else if (snapshot.hasData && snapshot.data!.statusCode == 200) {
//               int formCount = snapshot.data!.data.length;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '$formCount Task${formCount == 1 ? '' : 's'}',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: formCount,
//                       itemBuilder: (context, index) {
//                         final form = snapshot.data!.data[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FormBuild(formId: form.id),
//                               ),
//                             );
//                           },
//                           child: NoteCard(
//                             title: form.name,
//                             region: form.region,
//                             branchName: form.branchName,
//                             customer: form.customer,
//                             siteId: form.name,
//                             dateAssigned: form.dateAssigned,
//                             dateReceived: form.dateReceived,
//                             color: Colors.yellow.shade700,
//                             icon: Icons.task,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(child: Text('No Forms Found Currently'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }