import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String tasksEndpoint = 'https://your-server.com/api/tasks';
  final Box tasksBox = Hive.box('tasks');

  // Method to fetch tasks from the server
  Future<void> fetchTasks() async {
    final token = Hive.box('auth').get('access_token');
    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Fetch tasks in a separate isolate
      final List<dynamic> fetchedTasks = await compute(_fetchTasksInIsolate as ComputeCallback<dynamic, List>, token);
      // Save fetched tasks locally in Hive
      for (var task in fetchedTasks) {
        await tasksBox.put(task['id'], task);
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  // The actual function to be executed in the Isolate
  static Future<List<dynamic>> _fetchTasksInIsolate(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://your-server.com/api/tasks'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      print('Failed in isolate: $e');
      return [];
    }
  }

  // Get a task by ID
  Map<String, dynamic>? getTaskById(String taskId) {
    return tasksBox.get(taskId);
  }

  // Get all tasks
  List<Map<String, dynamic>> getAllTasks() {
    return tasksBox.values.cast<Map<String, dynamic>>().toList();
  }
}
