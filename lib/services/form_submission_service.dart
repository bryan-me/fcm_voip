import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class FormSubmissionService {
  final Box formBox = Hive.box('forms');
  final Connectivity connectivity = Connectivity();

  FormSubmissionService() {
     // Start monitoring connectivity changes
    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      for (var result in results) {
        if (result != ConnectivityResult.none) {
          print('Internet connected');
          _submitPendingForms();
        } else {
          print('Internet disconnected');
        }
      }
    });
  }

  Future<void> submitForm(Map<String, dynamic> formData) async {
    // Save the form data locally
    await formBox.add(formData);
    
    // Try submitting immediately if online
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _submitPendingForms();
    }
  }

  Future<void> _submitPendingForms() async {
    // Iterate over all stored forms and attempt to send each one
    for (int i = 0; i < formBox.length; i++) {
      final formData = formBox.getAt(i);
      if (formData != null) {
        // Use Isolate to send the form to the server
        final success = await _sendFormToServerUsingIsolate(formData);
        if (success) {
          // If successfully sent, remove it from local storage
          await formBox.deleteAt(i);
        }
      }
    }
  }

   // This function will use an Isolate to send the form data to the server
  Future<bool> _sendFormToServerUsingIsolate(Map<String, dynamic> formData) async {
    final response = await compute(_sendFormToServer, formData);
    return response;
  }


  // The actual function to be executed in the Isolate
  static Future<bool> _sendFormToServer(Map<String, dynamic> formData) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-server.com/api/submit-form'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );
      return response.statusCode == 200;
    } catch (e) {
      // Handle any errors here
      print('Failed to submit form: $e');
      return false;
    }
  }
}
