import 'dart:convert';

import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/services/form_response.dart';
import 'package:fcm_voip/utilities/form.dart';
import 'package:fcm_voip/utilities/note_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
  String? userId = await authService.getCurrentUserId(); // Fetch current user ID
    print(userId);

    if (userId == null) {
      throw Exception('User not authenticated. Please Re-Login.');
    }

    final token = await authService.getToken(userId);
    if (token == null) {
      throw Exception('Not authenticated, Please Re-Login.');
    }

    // Make the API call directly to fetch forms
    final String endpoint = '${dotenv.env['FIND_ALL_FORMS']}';
    
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
    }
    if (kDebugMode) {
      print('Response body: ${response.body}');
    } // Log the response body

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse['data'] is List) {
        return FormResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      if (kDebugMode) {
        print('Failed to load forms: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      throw Exception('Failed to load forms: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Tasks', style: TextStyle(color: Colors.black)),
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
              onPressed: () {},
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
                                     color: Colors.green.shade100,
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
