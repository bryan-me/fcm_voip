import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class OfflineFormManager {
  final Connectivity _connectivity = Connectivity();

  OfflineFormManager() {
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        await _processQueue();
      }
    });
  }

  Future<void> saveFormLocally(Map<String, dynamic> formData) async {
    var box = await Hive.openBox('formQueue');
    await box.add(formData);  // Save form data to Hive
  }

  Future<void> _processQueue() async {
    var box = await Hive.openBox('formQueue');
    for (var formData in box.values) {
      bool success = await _submitForm(formData);
      if (success) {
        await box.deleteAt(box.values.toList().indexOf(formData));
      }
    }
  }

  Future<bool> _submitForm(Map<String, dynamic> formData) async {
    try {
      final response = await http.post(
        Uri.parse('http://your-server-url/submit-task'),
        body: formData,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false; // Submission failed; form remains in queue
    }
  }
}