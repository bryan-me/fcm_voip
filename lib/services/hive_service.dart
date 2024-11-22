// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:fcm_voip/data/model/task_model/form_model.dart';
//
// class HiveService {
//   static final HiveService _instance = HiveService._internal();
//   Box<FormModel>? _formBox;
//
//   factory HiveService() {
//     return _instance;
//   }
//
//   HiveService._internal();
//
//   /// Initialize Hive and open the 'forms' box if it's not already open
//   Future<void> initHive() async {
//     if (!Hive.isAdapterRegistered(0)) {
//       Hive.registerAdapter(FormModelAdapter()); // Register the adapter once
//     }
//     if (_formBox == null || !_formBox!.isOpen) {
//       final dir = await getApplicationDocumentsDirectory();
//       Hive.init(dir.path);
//       _formBox = await Hive.openBox<FormModel>('forms');
//     }
//   }
//
//   /// Get all forms from the Hive box
//   Future<List<FormModel>> getForms() async {
//     await initHive(); // Ensure Hive is initialized
//     return _formBox!.values.toList();
//   }
//
//   /// Save a list of forms to the Hive box
//   Future<void> saveForms(List<FormModel> forms) async {
//     await initHive(); // Ensure Hive is initialized
//     await _formBox!.clear(); // Clear previous entries
//     for (var form in forms) {
//       await _formBox!.add(form); // Add new entries
//     }
//   }
//
//   /// Delete all forms from the Hive box
//   Future<void> clearForms() async {
//     await initHive(); // Ensure Hive is initialized
//     await _formBox!.clear();
//   }
//
//   /// Close the Hive box when no longer needed
//   Future<void> closeHive() async {
//     if (_formBox != null && _formBox!.isOpen) {
//       await _formBox!.close();
//       _formBox = null;
//     }
//   }
// }
import 'package:hive/hive.dart';

class HiveBoxHelper {
  // A map to hold references to already opened boxes
  static final Map<String, Box> _openBoxes = {};

  // Updated openBox method to check if the box is already open
  Future<Box<T>> openBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      // If the box is already open, return it
      return _openBoxes[boxName] as Box<T>;
    } else {
      // If not open, open the box and add it to _openBoxes map
      var box = await Hive.openBox<T>(boxName);
      _openBoxes[boxName] = box;
      return box;
    }
  }

  // method to close the box if needed
  Future<void> closeBox(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      await _openBoxes[boxName]?.close();
      _openBoxes.remove(boxName);
    }
  }
}