import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fcm_voip/data/form_data.dart';
import 'package:fcm_voip/data/form_details.dart';
import 'package:fcm_voip/data/model/task_model/form_model.dart';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/services/offline_form_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

import '../controllers/form_controller.dart';
import '../services/form_response.dart';
import '../services/hive_service.dart';
import 'exception.dart';
import 'network.dart';

 class FormBuild extends StatefulWidget{
  final String formId;

  FormBuild({required this.formId});

  @override
  _FormBuildState createState() => _FormBuildState();

}

class _FormBuildState extends State<FormBuild> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  bool _isLoading = false;
  List<File> _imageList = [];
  bool _showImageError = false;
  final int requiredImages = 3;
  final int maxImages = 6;
  // Future<FormData>? _formResponse;

  Map<String, String> _textFieldValues = {};
  Map<String, dynamic> _radioGroupValues = {};
  Map<String, String?> _dropdownGroupValues = {};
  Map<String, Map<String, bool>> _checkboxGroupValues = {};
  List<SignatureController> _signatureControllers = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _images = List<XFile?>.filled(6, null, growable: false);
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();


  late Future<Map<String, dynamic>> _formData;



  @override
  void initState() {
    super.initState();
    // _formResponse = fetchFormData(widget.formId);
    _formData = fetchFormData(widget.formId);
    _loadFormData(widget.formId);
    _startNetworkListener();


    // _startConnectivityListener();
    // Assuming you know the form ID
    printFormDataFromHive('3c33daae-e233-48a2-339c-357cab9f5538');
  }


  // Future<http.Response> _fetchFromApi(String formId) async {
  //   String? userId = await authService.getCurrentUserId();
  //   if (userId == null) {
  //     throw Exception('User not authenticated');
  //   }
  //
  //   final token = await authService.getToken(userId);
  //   if (token == null) {
  //     throw Exception('Not authenticated');
  //   }
  //
  //   final String endpoint = '${dotenv.env['FORM_ENDPOINT']}/$formId';
  //
  //   final response = await http.get(
  //     Uri.parse(endpoint),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to load form data: ${response.statusCode}');
  //   }
  //
  //
  //
  //   // Log the response body for debugging
  //   print('Response Body: ${response.body}');
  //   return response;
  // }

  // Future<FormData> fetchForm(String formId) async {
  //   bool isConnected = await ConnectivityUtil.isConnected();
  // if(!isConnected) {
  //   _fetchHiveForm(formId: formId);
  // }else{
  //   _fetchFromApi(formId: formId);
  // }
  // }

  ///New
  Future<Map<String, dynamic>> fetchFormData(String formId) async {
    String? userId = await authService.getCurrentUserId();
    bool isConnected = await ConnectivityUtil.isConnected();

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final token = await authService.getToken(userId);
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final String endpoint = '${dotenv.env['FORM_ENDPOINT']}/$formId';

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load form data: ${response.statusCode}');
    } else {
      // Parse the response body into a Map<String, dynamic> and return it
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Assuming 'data' contains the form model data
      var form = FormModel.fromJson(responseData['data']);

      // Open the Hive box where you want to save the form
      var formBox = await Hive.openBox<FormModel>('formBox');

      // Save the form to Hive using its id as the key
      await formBox.put(form.id, form);

      print('Form saved successfully to Hive');

      // Return the parsed data
      return responseData;
    }
  }


  ///Old
  // Future<http.Response> _fetchFromApi(String formId) async {
  //   String? userId = await authService.getCurrentUserId();
  //   bool isConnected = await ConnectivityUtil.isConnected();
  //
  //   if (userId == null) {
  //     throw Exception('User not authenticated');
  //   }
  //
  //   final token = await authService.getToken(userId);
  //   if (token == null) {
  //     throw Exception('Not authenticated');
  //   }
  //
  //   final String endpoint = '${dotenv.env['FORM_ENDPOINT']}/$formId';
  //
  //   final response = await http.get(
  //     Uri.parse(endpoint),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to load form data: ${response.statusCode}');
  //   }
  //
  //   // Log the response body for debugging
  //   // print('Response Body: ${response.body}');
  //
  //   // Parse the response body to JSON
  //   final Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //   // Assuming 'data' contains the form model data
  //   var form = FormModel.fromJson(responseData['data']);
  //
  //   // Open the Hive box where you want to save the form
  //   var formBox = await Hive.openBox<FormModel>('formBox');
  //
  //   // Save the form to Hive using its id as the key
  //   await formBox.put(form.id, form);
  //
  //   print('Form saved successfully to Hive');
  //
  //   return response;
  // }


  ///Old
  // Future<FormResponse> fetchForms(String formId) async {
  //   var hiveBoxHelper = HiveBoxHelper();
  //   var formBox = await hiveBoxHelper.openBox<FormModel>('forms');
  //
  //   // Check for internet connection
  //   bool isConnected = await ConnectivityUtil.isConnected();
  //   print("Internet connection status: $isConnected");
  //
  //   if (isConnected) {
  //     // Online: Fetch from server and update Hive
  //     try {
  //       print("Fetching form data from server.");
  //       var response = await _fetchFromApi(formId);
  //       print("Form data fetched from server successfully.");
  //
  //       // Update the local Hive database
  //       var responseData = jsonDecode(response.body);
  //       var form = FormModel.fromJson(responseData['data']);
  //       await formBox.put(form.id, form);
  //       print("Form data saved to Hive successfully.");
  //
  //       return FormResponse(data: [form], statusCode: response.statusCode, message: 'Fetched from server');
  //     } catch (e) {
  //       print("Error fetching from server: $e");
  //       if (e.toString().contains('401')) {
  //         print("Unauthorized (401). Redirecting to login.");
  //         // _promptReLogin();
  //         throw UnauthorizedException("Session expired. Please log in again.");
  //       } else {
  //         throw Exception("Failed to fetch forms from the server.");
  //       }
  //     }
  //   } else {
  //     // Offline: Retrieve from Hive
  //     print("Fetching form data from Hive due to no internet connection.");
  //     if (formBox.containsKey(formId)) {
  //       var form = formBox.get(formId);
  //       print("Form data fetched from Hive successfully.");
  //       return FormResponse(data: [form!], statusCode: 200, message: 'Fetched from Hive');
  //     } else {
  //       print("No form data found in Hive for formId: $formId.");
  //       throw Exception("No form data available offline.");
  //     }
  //   }
  // }

///New fetchForms
  Future<FormResponse> fetchForms(String formId) async {
    var hiveBoxHelper = HiveBoxHelper();
    var formBox = await hiveBoxHelper.openBox<FormModel>('forms');

    // Check for internet connection
    bool isConnected = await ConnectivityUtil.isConnected();
    print("Internet connection status: $isConnected");

    if (isConnected) {
      // Online: Fetch from server and update Hive
      try {
        print("Fetching form data from server.");
        var responseData = await fetchFormData(formId); // Assuming this returns Map<String, dynamic>
        print("Form data fetched from server successfully.");

        // Get the form from the response
        var form = FormModel.fromJson(responseData['data']);

        // Update the local Hive database
        await formBox.put(form.id, form);
        print("Form data saved to Hive successfully.");

        return FormResponse(data: [form], statusCode: 200, message: 'Fetched from server');
      } catch (e) {
        print("Error fetching from server: $e");
        if (e.toString().contains('401')) {
          print("Unauthorized (401). Redirecting to login.");
          throw UnauthorizedException("Session expired. Please log in again.");
        } else {
          throw Exception("Failed to fetch forms from the server.");
        }
      }
    } else {
      // Offline: Retrieve from Hive
      print("Fetching form data from Hive due to no internet connection.");
      if (formBox.containsKey(formId)) {
        var form = formBox.get(formId);
        print("Form data fetched from Hive successfully.");
        return FormResponse(data: [form!], statusCode: 200, message: 'Fetched from Hive');
      } else {
        print("No form data found in Hive for formId: $formId.");
        throw Exception("No form data available offline.");
      }
    }
  }

  Future<void> printFormDataFromHive(String formId) async {
    // Open the Hive box
    var formBox = await Hive.openBox<FormModel>('formBox');

    // Retrieve the form by its id
    var form = formBox.get(formId);

    // Check if the form is found and print the details
    if (form != null) {
      print('Form ID: ${form.id}');
      print('Form Name: ${form.name}');
      print('Form Version: ${form.version}');
      print('Form Details: ${form.formDetails.map((detail) => detail.toString()).join(', ')}');
    } else {
      print('Form not found in Hive');
    }
  }

  // Future<FormData> _fetchHiveForm(String formId) async {
  //   var box = await Hive.openBox<FormModel>('formBox');
  //   var formModel = box.get(formId);
  //
  //   if (formModel != null) {
  //     return FormData.fromJson(formModel.toJson());
  //   } else {
  //     throw Exception('Form not found in local storage');
  //   }
  // }

// Location
  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Notify the user that location services are not enabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled.')),
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Notify the user that location permissions are denied
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permissions are denied.')),
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Notify the user that location permissions are permanently denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are permanently denied.')),
        );
        return null;
      }

      // Fetch and return the current position
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      // Handle any errors
      print("Error fetching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
      return null;
    }
  }

  @override
  void dispose() {
    // Dispose all signature controllers
    for (var controller in _signatureControllers) {
      controller.dispose();
    }
    _saveFormData(widget.formId); // Save form data when disposing
    super.dispose();
  }

///Old buildForm
//   Widget buildForm(List<FormDetails> formDetails) {
//     List<Widget> formFields = [];
//
//     for (var field in formDetails) {
//       formFields.add(
//         Padding(
//           padding: const EdgeInsets.only(top: 16.0),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               field.fieldLabel,
//               style: const TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ),
//       );
//
//       switch (field.fieldType.toUpperCase()) {
//         case 'DATE':
//           final TextEditingController dateController = TextEditingController(
//             text: _textFieldValues[field.fieldLabel] ?? '',
//           );
//
//           formFields.add(
//             TextFormField(
//               controller: dateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 hintText: field.placeholder,
//                 suffixIcon: const Icon(Icons.calendar_today),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: BorderSide(
//                     color: _textFieldValues[field.fieldLabel]?.isEmpty ?? true ? Colors.red : Colors.grey,
//                     width: 1.0,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(
//                     color: Colors.blue,
//                     width: 2.0,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: const BorderSide(
//                     color: Colors.red,
//                     width: 2.0,
//                   ),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select a date';
//                 }
//                 return null;
//               },
//               onTap: () async {
//                 DateTime? selectedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime(2100),
//                 );
//
//                 if (selectedDate != null) {
//                   String formattedDate =
//                       "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
//                   setState(() {
//                     _textFieldValues[field.fieldLabel] = formattedDate;
//                   });
//                   _saveFormData(widget.formId);
//                 }
//               },
//             ),
//           );
//           break;
//
//         case 'RADIO':
//           _radioGroupValues[field.fieldLabel] ??= null;
//
//           formFields.add(
//             FormField<String>(
//               initialValue: _radioGroupValues[field.fieldLabel],
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please select an option';
//                 }
//                 return null;
//               },
//               builder: (FormFieldState<String> state) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ...field.fieldOptions.map((option) {
//                       String optionKey = option.keys.first;
//                       String optionValue = option.values.first;
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 4.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         elevation: 5,
//                         child: RadioListTile<String>(
//                           title: Text(optionValue),
//                           value: optionKey,
//                           groupValue: state.value,
//                           onChanged: (value) {
//                             setState(() {
//                               _radioGroupValues[field.fieldLabel] = value;
//                               state.didChange(value);
//                             });
//                             _saveFormData(widget.formId);
//                           },
//                         ),
//                       );
//                     }).toList(),
//                     if (state.hasError)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           state.errorText ?? '',
//                           style: const TextStyle(color: Colors.red, fontSize: 12.0),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           );
//           break;
//
//         // case 'TEXTAREA':
//         // case 'INPUT':
//         //   formFields.add(
//         //     TextFormField(
//         //       initialValue: _textFieldValues[field.fieldLabel] ?? '',
//         //       decoration: InputDecoration(
//         //         hintText: field.placeholder,
//         //         filled: true,
//         //         fillColor: Colors.white,
//         //         border: OutlineInputBorder(
//         //           borderRadius: BorderRadius.circular(12.0),
//         //           borderSide: BorderSide(
//         //             color: _textFieldValues[field.fieldLabel]?.isEmpty ?? true ? Colors.red : Colors.grey,
//         //             width: 1.0,
//         //           ),
//         //         ),
//         //         focusedBorder: OutlineInputBorder(
//         //           borderRadius: BorderRadius.circular(12.0),
//         //           borderSide: BorderSide(
//         //             color: Colors.blue,
//         //             width: 2.0,
//         //           ),
//         //         ),
//         //         errorBorder: OutlineInputBorder(
//         //           borderRadius: BorderRadius.circular(12.0),
//         //           borderSide: BorderSide(
//         //             color: Colors.red,
//         //             width: 2.0,
//         //           ),
//         //         ),
//         //         contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//         //       ),
//         //       validator: (value) {
//         //         if (value == null || value.isEmpty) {
//         //           return 'Please enter a value';
//         //         }
//         //         return null;
//         //       },
//         //       onChanged: (value) {
//         //         setState(() {
//         //           _textFieldValues[field.fieldLabel] = value;
//         //         });
//         //         _saveFormData(widget.formId);
//         //       },
//         //     ),
//         //   );
//         //   break;
//
//         case 'TEXTAREA':
//         case 'INPUT':
//           // bool isPhoneField = field.fieldLabel.toLowerCase().contains('phone'); // Check if the label indicates a phone field
//         bool isPhoneField = field.fieldLabel == 'Phone'; // Check if the label is exactly "Phone"
//
//         formFields.add(
//           TextFormField(
//             initialValue: _textFieldValues[field.fieldLabel] ?? '',
//             keyboardType: isPhoneField ? TextInputType.phone : TextInputType.text, // Show numeric dialer for phone
//             maxLength: isPhoneField ? 10 : null, // Restrict to 10 characters for phone
//             inputFormatters: isPhoneField
//                 ? [FilteringTextInputFormatter.digitsOnly] // Allow only numeric input
//                 : [],
//             decoration: InputDecoration(
//               hintText: field.placeholder,
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide(
//                   color: (_textFieldValues[field.fieldLabel]?.isEmpty ?? true) ? Colors.red : Colors.grey,
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide(
//                   color: Colors.blue,
//                   width: 2.0,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide(
//                   color: Colors.red,
//                   width: 2.0,
//                 ),
//               ),
//               contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//               counterText: isPhoneField ? "" : null, // Hide counter for phone fields
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a value';
//               }
//               if (isPhoneField && value.length != 10) {
//                 return 'Phone number must be exactly 10 digits';
//               }
//               return null;
//             },
//             onChanged: (value) {
//               setState(() {
//                 _textFieldValues[field.fieldLabel] = value;
//               });
//               _saveFormData(widget.formId);
//             },
//           ),
//         );
//         break;
//
//
//         case 'DROPDOWN':
//         // Initialize dropdown value to null if it's not already set
//           _dropdownGroupValues[field.fieldLabel] ??= null;
//
//           // Add the Dropdown widget to the form fields list
//           formFields.add(
//             DropdownButtonFormField<String>(
//               // Convert the field options to DropdownMenuItem
//               items: field.fieldOptions.map((option) {
//                 String optionKey = option.keys.first;
//                 String optionValue = option.values.first;
//                 return DropdownMenuItem<String>(
//                   value: optionKey,
//                   child: Text(optionValue),
//                 );
//               }).toList(),
//               // OnChanged callback to update the dropdown value
//               onChanged: (value) {
//                 setState(() {
//                   _dropdownGroupValues[field.fieldLabel] = value; // Update state
//                   _saveFormData(widget.formId); // Save form data
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: field.placeholder,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: BorderSide(
//                     color: _dropdownGroupValues[field.fieldLabel] == null
//                         ? Colors.red // Red border if value is null (invalid)
//                         : Colors.grey, // Grey border if valid
//                     width: 1.0,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: BorderSide(
//                     color: Colors.blue, // Blue border when focused
//                     width: 2.0,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Red border when validation fails
//                     width: 2.0,
//                   ),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//               ),
//               validator: (value) {
//                 // Validation to ensure user selects a valid option
//                 if (value == null) {
//                   return 'Please select an option';
//                 }
//                 return null; // Return null if the value is valid
//               },
//             ),
//           );
//           break;
//
//         case 'CHECKBOX':
//           _checkboxGroupValues[field.fieldLabel] ??= {};
//
//           formFields.add(
//             FormField<Map<String, bool>>(
//               initialValue: _checkboxGroupValues[field.fieldLabel],
//               validator: (value) {
//                 if (value == null || value.values.every((isChecked) => !isChecked)) {
//                   return 'Please select at least one option';
//                 }
//                 return null;
//               },
//               builder: (FormFieldState<Map<String, bool>> state) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ...field.fieldOptions.map((option) {
//                       String optionKey = option.keys.first;
//                       String optionValue = option.values.first;
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 4.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         elevation: 5,
//                         child: CheckboxListTile(
//                           title: Text(optionValue),
//                           value: _checkboxGroupValues[field.fieldLabel]?[optionKey] ?? false,
//                           onChanged: (isChecked) {
//                             setState(() {
//                               _checkboxGroupValues[field.fieldLabel]![optionKey] = isChecked ?? false;
//                               _saveFormData(widget.formId);
//
//                               // Trigger form state validation
//                               state.didChange(_checkboxGroupValues[field.fieldLabel]);
//                             });
//                           },
//                         ),
//                       );
//                     }).toList(),
//                     if (state.hasError)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           state.errorText ?? '',
//                           style: const TextStyle(color: Colors.red, fontSize: 12.0),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           );
//           break;
//
//           break;
//
//         case 'LOCATION':
//           formFields.add(Column(
//             children: [
//               Card(
//                 child: TextFormField(
//                   controller: _longitudeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Longitude',
//                     contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//                   ),
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Longitude is required.';
//                     }
//                     double? longitude = double.tryParse(value);
//                     if (longitude == null || longitude < -180 || longitude > 180) {
//                       return 'Enter a valid longitude (-180 to 180).';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     _saveFormData(widget.formId);
//                   },
//                 ),
//               ),
//               Card(
//                 child: TextFormField(
//                   controller: _latitudeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Latitude',
//                     contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//                   ),
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Latitude is required.';
//                     }
//                     double? latitude = double.tryParse(value);
//                     if (latitude == null || latitude < -90 || latitude > 90) {
//                       return 'Enter a valid latitude (-90 to 90).';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     _saveFormData(widget.formId);
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
//                   backgroundColor: Colors.blueAccent,
//                 ),
//                 onPressed: _getCurrentLocation,
//                 child: const Text('Get Current Location'),
//               ),
//             ],
//           ));
//           break;
//
//         case 'SIGNATURE':
//           SignatureController signatureController = SignatureController(
//             penStrokeWidth: 5,
//             penColor: Colors.black,
//             exportBackgroundColor: Colors.white,
//           );
//           _signatureControllers.add(signatureController);
//
//           formFields.add(Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Signature(
//                 controller: signatureController,
//                 height: 150,
//                 backgroundColor: Colors.grey[200]!,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       backgroundColor: Colors.grey,
//                       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         signatureController.clear();
//                       });
//                     },
//                     child: const Text('Clear'),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//                       backgroundColor: Colors.green,
//                     ),
//                     onPressed: () async {
//                       if (signatureController.isNotEmpty) {
//                         final signatureBytes = await signatureController.toPngBytes();
//                         if (signatureBytes != null) {
//                           debugPrint("Signature saved successfully.");
//                           _saveFormData(widget.formId);
//                         }
//                       } else {
//                         debugPrint("No signature to save.");
//                       }
//                     },
//                     child: const Text('Save'),
//                   ),
//                 ],
//               ),
//             ],
//           ));
//           break;
//
//         // case 'IMAGE':
//         //   formFields.add(Column(
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     children: [
//         //       const Text('Upload Image:'),
//         //       ElevatedButton(
//         //         style: ElevatedButton.styleFrom(
//         //           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
//         //           backgroundColor: Colors.blueAccent,
//         //           shape: RoundedRectangleBorder(
//         //             borderRadius: BorderRadius.circular(8.0),
//         //           ),
//         //         ),
//         //         onPressed: () {
//         //           // Implement image picker
//         //         },
//         //         child: const Text('Select Image'),
//         //       ),
//         //     ],
//         //   ));
//         //   break;
//
//         // case 'IMAGE':
//         //
//         //   formFields.add(
//         //     Column(
//         //       crossAxisAlignment: CrossAxisAlignment.start,
//         //       children: [
//         //         // const Text(
//         //         //   'Upload Images (at least 3, up to 6):',
//         //         //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
//         //         // ),
//         //         const SizedBox(height: 8.0),
//         //         Wrap(
//         //           spacing: 8.0,
//         //           runSpacing: 8.0,
//         //           children: List.generate(maxImages, (index) {
//         //             bool isEmptySlot = index >= _imageList.length;
//         //
//         //             return GestureDetector(
//         //               onTap: () async {
//         //                 if (isEmptySlot && _imageList.length < maxImages) {
//         //                   // Pick a new image
//         //                   final XFile? pickedImage = await ImagePicker().pickImage(
//         //                     source: ImageSource.camera,
//         //                     maxWidth: 800,
//         //                     maxHeight: 800,
//         //                   );
//         //                   if (pickedImage != null) {
//         //                     setState(() {
//         //                       _imageList.add(File(pickedImage.path));
//         //                       _saveFormData(widget.formId);
//         //                     });
//         //                   }
//         //
//         //                   print('Image list: ${_imageList.map((e) => e.path).toList()}');
//         //                 } else if (!isEmptySlot) {
//         //                   // Optional: Implement logic to replace or delete the existing image
//         //                 }
//         //               },
//         //               child: Container(
//         //                 width: 130.0,
//         //                 height: 130.0,
//         //                 decoration: BoxDecoration(
//         //                   borderRadius: BorderRadius.circular(8.0),
//         //                   color: isEmptySlot ? Colors.grey[300] : Colors.transparent,
//         //                   border: Border.all(
//         //                     color: Colors.blueAccent,
//         //                     width: 1.5,
//         //                   ),
//         //                   image: isEmptySlot
//         //                       ? null
//         //                       : DecorationImage(
//         //                     image: FileImage(_imageList[index]),
//         //                     fit: BoxFit.cover,
//         //                   ),
//         //                 ),
//         //                 child: isEmptySlot
//         //                     ? Icon(Icons.add_a_photo, color: Colors.grey[600])
//         //                     : null,
//         //               ),
//         //             );
//         //           }),
//         //         ),
//         //         if (_showImageError && _imageList.length < requiredImages)
//         //           Padding(
//         //             padding: const EdgeInsets.only(top: 8.0),
//         //             child: Text(
//         //               'Please upload at least $requiredImages images.',
//         //               style: const TextStyle(color: Colors.red, fontSize: 12.0),
//         //             ),
//         //           ),
//         //       ],
//         //     ),
//         //   );
//         //   break;
//
//         case 'IMAGE':
//           formFields.add(
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 8.0),
//                 Wrap(
//                   spacing: 8.0,
//                   runSpacing: 8.0,
//                   children: List.generate(maxImages, (index) {
//                     bool isEmptySlot = index >= _imageList.length;
//
//                     return GestureDetector(
//                       onTap: () async {
//                         if (isEmptySlot && _imageList.length < maxImages) {
//                           // Pick a new image
//                           final XFile? pickedImage = await ImagePicker().pickImage(
//                             source: ImageSource.camera,
//                             maxWidth: 800,
//                             maxHeight: 800,
//                           );
//                           if (pickedImage != null) {
//                             setState(() {
//                               _imageList.add(File(pickedImage.path));
//                               _saveFormData(widget.formId);
//                             });
//                           }
//                         } else if (!isEmptySlot) {
//                           // Show image in a dialog with a delete option
//                           await showDialog(
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16.0),
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(16.0),
//                                       child: Image.file(
//                                         _imageList[index],
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 8.0,
//                                       right: 8.0,
//                                       child: IconButton(
//                                         icon: const Icon(Icons.delete, color: Colors.red),
//                                         onPressed: () {
//                                           setState(() {
//                                             _imageList.removeAt(index);
//                                             _saveFormData(widget.formId);
//                                           });
//                                           Navigator.pop(context);
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         }
//                       },
//                       child: Container(
//                         width: 130.0,
//                         height: 130.0,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           color: isEmptySlot ? Colors.grey[300] : Colors.transparent,
//                           border: Border.all(
//                             color: Colors.blueAccent,
//                             width: 1.5,
//                           ),
//                           image: isEmptySlot
//                               ? null
//                               : DecorationImage(
//                             image: FileImage(_imageList[index]),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: isEmptySlot
//                             ? Icon(Icons.add_a_photo, color: Colors.grey[600])
//                             : null,
//                       ),
//                     );
//                   }),
//                 ),
//                 if (_showImageError && _imageList.length < requiredImages)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       'Please upload at least $requiredImages images.',
//                       style: const TextStyle(color: Colors.red, fontSize: 12.0),
//                     ),
//                   ),
//               ],
//             ),
//           );
//           break;
//
//         default:
//           formFields.add(Text('Unsupported input type: ${field.fieldType}'));
//           break;
//       }
//     }
//
//     // formFields.add(
//     //   ElevatedButton(
//     //     onPressed: () {
//     //       _submitForm();
//     //     },
//     //     child: const Text('Submit'),
//     //   ),
//     // );
//
//     formFields.add(
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20.0), // Add vertical spacing
//         child: ElevatedButton(
//           onPressed: () {
//             _submitForm();
//           },
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, // Text color
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30.0), // Rounded corners
//             ),
//             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Larger padding for button
//             elevation: 5, // Shadow for button
//           ),
//           child: const Text(
//             'Submit',
//             style: TextStyle(
//               fontSize: 18.0, // Font size for better readability
//               fontWeight: FontWeight.bold, // Bold text
//             ),
//           ),
//         ),
//       ),
//     );
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: formFields,
//         ),
//       ),
//     );
//   }

  ///New 1 buildForm
  // Widget buildForm(List<dynamic> formDetails) {
  //   List<Widget> formFields = [];
  //   return ListView.builder(
  //       itemCount: formDetails.length,
  //       itemBuilder: (context, index) {
  //         final field = formDetails[index];
  //
  //
  //
  //     switch (field['fieldType'].toUpperCase()) {
  //       case 'DATE':
  //         final TextEditingController dateController = TextEditingController(
  //           text: _textFieldValues[field['fieldLabel']] ?? '',          );
  //
  //         formFields.add(
  //           TextFormField(
  //             controller: dateController,
  //             readOnly: true,
  //             decoration: InputDecoration(
  //               hintText: field['placeholder'] ?? 'Enter value',
  //               suffixIcon: const Icon(Icons.calendar_today),
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: _textFieldValues[field['fieldLabel']]?.isEmpty ?? true ? Colors.red : Colors.grey,
  //                   width: 1.0,
  //                 ),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: const BorderSide(
  //                   color: Colors.blue,
  //                   width: 2.0,
  //                 ),
  //               ),
  //               errorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: const BorderSide(
  //                   color: Colors.red,
  //                   width: 2.0,
  //                 ),
  //               ),
  //               contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please select a date';
  //               }
  //               return null;
  //             },
  //             onTap: () async {
  //               DateTime? selectedDate = await showDatePicker(
  //                 context: context,
  //                 initialDate: DateTime.now(),
  //                 firstDate: DateTime(1900),
  //                 lastDate: DateTime(2100),
  //               );
  //
  //               if (selectedDate != null) {
  //                 String formattedDate =
  //                     "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
  //                 setState(() {
  //                   _textFieldValues[field['fieldLabel']] = formattedDate;
  //                 });
  //                 _saveFormData(widget.formId);
  //               }
  //             },
  //           ),
  //         );
  //         break;
  //
  //       case 'RADIO':
  //         _radioGroupValues[field['fieldLabel']] ??= null;
  //         formFields.add(
  //           FormField<String>(
  //             initialValue: _radioGroupValues[field['fieldLabel']],
  //             validator: (value) {
  //               if (value == null) {
  //                 return 'Please select an option';
  //               }
  //               return null;
  //             },
  //             builder: (FormFieldState<String> state) {
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ...field.fieldOptions.map((option) {
  //                     String optionKey = option.keys.first;
  //                     String optionValue = option.values.first;
  //                     return Card(
  //                       margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       elevation: 5,
  //                       child: RadioListTile<String>(
  //                         title: Text(optionValue),
  //                         value: optionKey,
  //                         groupValue: state.value,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             _radioGroupValues[field['fieldLabel']] = value;
  //                             state.didChange(value);
  //                           });
  //                           _saveFormData(widget.formId);
  //                         },
  //                       ),
  //                     );
  //                   }).toList(),
  //                   if (state.hasError)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 8.0),
  //                       child: Text(
  //                         state.errorText ?? '',
  //                         style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                       ),
  //                     ),
  //                 ],
  //               );
  //             },
  //           ),
  //         );
  //         break;
  //
  //     // case 'TEXTAREA':
  //     // case 'INPUT':
  //     //   formFields.add(
  //     //     TextFormField(
  //     //       initialValue: _textFieldValues[field.fieldLabel] ?? '',
  //     //       decoration: InputDecoration(
  //     //         hintText: field.placeholder,
  //     //         filled: true,
  //     //         fillColor: Colors.white,
  //     //         border: OutlineInputBorder(
  //     //           borderRadius: BorderRadius.circular(12.0),
  //     //           borderSide: BorderSide(
  //     //             color: _textFieldValues[field.fieldLabel]?.isEmpty ?? true ? Colors.red : Colors.grey,
  //     //             width: 1.0,
  //     //           ),
  //     //         ),
  //     //         focusedBorder: OutlineInputBorder(
  //     //           borderRadius: BorderRadius.circular(12.0),
  //     //           borderSide: BorderSide(
  //     //             color: Colors.blue,
  //     //             width: 2.0,
  //     //           ),
  //     //         ),
  //     //         errorBorder: OutlineInputBorder(
  //     //           borderRadius: BorderRadius.circular(12.0),
  //     //           borderSide: BorderSide(
  //     //             color: Colors.red,
  //     //             width: 2.0,
  //     //           ),
  //     //         ),
  //     //         contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //     //       ),
  //     //       validator: (value) {
  //     //         if (value == null || value.isEmpty) {
  //     //           return 'Please enter a value';
  //     //         }
  //     //         return null;
  //     //       },
  //     //       onChanged: (value) {
  //     //         setState(() {
  //     //           _textFieldValues[field.fieldLabel] = value;
  //     //         });
  //     //         _saveFormData(widget.formId);
  //     //       },
  //     //     ),
  //     //   );
  //     //   break;
  //
  //       case 'TEXTAREA':
  //       case 'INPUT':
  //       // bool isPhoneField = field.fieldLabel.toLowerCase().contains('phone'); // Check if the label indicates a phone field
  //     bool isPhoneField = field['fieldLabel'] == 'Phone';
  //         formFields.add(
  //           TextFormField(
  //             initialValue: _textFieldValues[field['fieldLabel']] ?? '',
  //             keyboardType: isPhoneField ? TextInputType.phone : TextInputType.text, // Show numeric dialer for phone
  //             maxLength: isPhoneField ? 10 : null, // Restrict to 10 characters for phone
  //             inputFormatters: isPhoneField
  //                 ? [FilteringTextInputFormatter.digitsOnly] // Allow only numeric input
  //                 : [],
  //             decoration: InputDecoration(
  //               hintText: field['placeholder'] ?? 'Enter value',
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true) ? Colors.red : Colors.grey,
  //                   width: 1.0,
  //                 ),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: Colors.blue,
  //                   width: 2.0,
  //                 ),
  //               ),
  //               errorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: Colors.red,
  //                   width: 2.0,
  //                 ),
  //               ),
  //               contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //               counterText: isPhoneField ? "" : null, // Hide counter for phone fields
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter a value';
  //               }
  //               if (isPhoneField && value.length != 10) {
  //                 return 'Phone number must be exactly 10 digits';
  //               }
  //               return null;
  //             },
  //             onChanged: (value) {
  //               setState(() {
  //                 _textFieldValues[field['fieldLabel']] = value;
  //               });
  //               _saveFormData(widget.formId);
  //             },
  //           ),
  //         );
  //         break;
  //
  //
  //       case 'DROPDOWN':
  //       // Initialize dropdown value to null if it's not already set
  //         _dropdownGroupValues[field['fieldLabel']] ??= null;
  //
  //         // Add the Dropdown widget to the form fields list
  //         formFields.add(
  //           DropdownButtonFormField<String>(
  //             // Convert the field options to DropdownMenuItem
  //             items: field.fieldOptions.map((option) {
  //               String optionKey = option.keys.first;
  //               String optionValue = option.values.first;
  //               return DropdownMenuItem<String>(
  //                 value: optionKey,
  //                 child: Text(optionValue),
  //               );
  //             }).toList(),
  //             // OnChanged callback to update the dropdown value
  //             onChanged: (value) {
  //               setState(() {
  //                 _dropdownGroupValues[field['fieldLabel']] = value;
  //                 _saveFormData(widget.formId);
  //               });
  //             },
  //             decoration: InputDecoration(
  //               hintText: field['placeholder'] ?? 'Enter value',
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: _dropdownGroupValues[field['fieldLabel']] == null
  //                       ? Colors.red // Red border if value is null (invalid)
  //                       : Colors.grey, // Grey border if valid
  //                   width: 1.0,
  //                 ),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: Colors.blue, // Blue border when focused
  //                   width: 2.0,
  //                 ),
  //               ),
  //               errorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //                 borderSide: BorderSide(
  //                   color: Colors.red, // Red border when validation fails
  //                   width: 2.0,
  //                 ),
  //               ),
  //               contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //             ),
  //             validator: (value) {
  //               // Validation to ensure user selects a valid option
  //               if (value == null) {
  //                 return 'Please select an option';
  //               }
  //               return null; // Return null if the value is valid
  //             },
  //           ),
  //         );
  //         break;
  //
  //       case 'CHECKBOX':
  //         _checkboxGroupValues[field['fieldLabel']] ??= {};
  //
  //         formFields.add(
  //           FormField<Map<String, bool>>(
  //             initialValue: _checkboxGroupValues[field['fieldLabel']],
  //             validator: (value) {
  //               if (value == null || value.values.every((isChecked) => !isChecked)) {
  //                 return 'Please select at least one option';
  //               }
  //               return null;
  //             },
  //             builder: (FormFieldState<Map<String, bool>> state) {
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ...field.fieldOptions.map((option) {
  //                     String optionKey = option.keys.first;
  //                     String optionValue = option.values.first;
  //                     return Card(
  //                       margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       elevation: 5,
  //                       child: CheckboxListTile(
  //                         title: Text(optionValue),
  //                         value: _checkboxGroupValues[field['fieldLabel']]?[optionKey] ?? false,
  //                         onChanged: (isChecked) {
  //                           setState(() {
  //                             _checkboxGroupValues[field['fieldLabel']]![optionKey] = isChecked ?? false;
  //                             _saveFormData(widget.formId);
  //
  //                             // Trigger form state validation
  //                             state.didChange(_checkboxGroupValues[field['fieldLabel']]);
  //                           });
  //                         },
  //                       ),
  //                     );
  //                   }).toList(),
  //                   if (state.hasError)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 8.0),
  //                       child: Text(
  //                         state.errorText ?? '',
  //                         style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                       ),
  //                     ),
  //                 ],
  //               );
  //             },
  //           ),
  //         );
  //         break;
  //
  //         break;
  //
  //       case 'LOCATION':
  //         formFields.add(Column(
  //           children: [
  //             Card(
  //               child: TextFormField(
  //                 controller: _longitudeController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Longitude',
  //                   contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                 ),
  //                 keyboardType: TextInputType.number,
  //                 inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))],
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Longitude is required.';
  //                   }
  //                   double? longitude = double.tryParse(value);
  //                   if (longitude == null || longitude < -180 || longitude > 180) {
  //                     return 'Enter a valid longitude (-180 to 180).';
  //                   }
  //                   return null;
  //                 },
  //                 onChanged: (value) {
  //                   _saveFormData(widget.formId);
  //                 },
  //               ),
  //             ),
  //             Card(
  //               child: TextFormField(
  //                 controller: _latitudeController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Latitude',
  //                   contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                 ),
  //                 keyboardType: TextInputType.number,
  //                 inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))],
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Latitude is required.';
  //                   }
  //                   double? latitude = double.tryParse(value);
  //                   if (latitude == null || latitude < -90 || latitude > 90) {
  //                     return 'Enter a valid latitude (-90 to 90).';
  //                   }
  //                   return null;
  //                 },
  //                 onChanged: (value) {
  //                   _saveFormData(widget.formId);
  //                 },
  //               ),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8.0),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
  //                 backgroundColor: Colors.blueAccent,
  //               ),
  //               onPressed: _getCurrentLocation,
  //               child: const Text('Get Current Location'),
  //             ),
  //           ],
  //         ));
  //         break;
  //
  //       case 'SIGNATURE':
  //         SignatureController signatureController = SignatureController(
  //           penStrokeWidth: 5,
  //           penColor: Colors.black,
  //           exportBackgroundColor: Colors.white,
  //         );
  //         _signatureControllers.add(signatureController);
  //
  //         formFields.add(Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Signature(
  //               controller: signatureController,
  //               height: 150,
  //               backgroundColor: Colors.grey[200]!,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8.0),
  //                     ),
  //                     backgroundColor: Colors.grey,
  //                     padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       signatureController.clear();
  //                     });
  //                   },
  //                   child: const Text('Clear'),
  //                 ),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8.0),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  //                     backgroundColor: Colors.green,
  //                   ),
  //                   onPressed: () async {
  //                     if (signatureController.isNotEmpty) {
  //                       final signatureBytes = await signatureController.toPngBytes();
  //                       if (signatureBytes != null) {
  //                         debugPrint("Signature saved successfully.");
  //                         _saveFormData(widget.formId);
  //                       }
  //                     } else {
  //                       debugPrint("No signature to save.");
  //                     }
  //                   },
  //                   child: const Text('Save'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ));
  //         break;
  //
  //     // case 'IMAGE':
  //     //   formFields.add(Column(
  //     //     crossAxisAlignment: CrossAxisAlignment.start,
  //     //     children: [
  //     //       const Text('Upload Image:'),
  //     //       ElevatedButton(
  //     //         style: ElevatedButton.styleFrom(
  //     //           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
  //     //           backgroundColor: Colors.blueAccent,
  //     //           shape: RoundedRectangleBorder(
  //     //             borderRadius: BorderRadius.circular(8.0),
  //     //           ),
  //     //         ),
  //     //         onPressed: () {
  //     //           // Implement image picker
  //     //         },
  //     //         child: const Text('Select Image'),
  //     //       ),
  //     //     ],
  //     //   ));
  //     //   break;
  //
  //     // case 'IMAGE':
  //     //
  //     //   formFields.add(
  //     //     Column(
  //     //       crossAxisAlignment: CrossAxisAlignment.start,
  //     //       children: [
  //     //         // const Text(
  //     //         //   'Upload Images (at least 3, up to 6):',
  //     //         //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  //     //         // ),
  //     //         const SizedBox(height: 8.0),
  //     //         Wrap(
  //     //           spacing: 8.0,
  //     //           runSpacing: 8.0,
  //     //           children: List.generate(maxImages, (index) {
  //     //             bool isEmptySlot = index >= _imageList.length;
  //     //
  //     //             return GestureDetector(
  //     //               onTap: () async {
  //     //                 if (isEmptySlot && _imageList.length < maxImages) {
  //     //                   // Pick a new image
  //     //                   final XFile? pickedImage = await ImagePicker().pickImage(
  //     //                     source: ImageSource.camera,
  //     //                     maxWidth: 800,
  //     //                     maxHeight: 800,
  //     //                   );
  //     //                   if (pickedImage != null) {
  //     //                     setState(() {
  //     //                       _imageList.add(File(pickedImage.path));
  //     //                       _saveFormData(widget.formId);
  //     //                     });
  //     //                   }
  //     //
  //     //                   print('Image list: ${_imageList.map((e) => e.path).toList()}');
  //     //                 } else if (!isEmptySlot) {
  //     //                   // Optional: Implement logic to replace or delete the existing image
  //     //                 }
  //     //               },
  //     //               child: Container(
  //     //                 width: 130.0,
  //     //                 height: 130.0,
  //     //                 decoration: BoxDecoration(
  //     //                   borderRadius: BorderRadius.circular(8.0),
  //     //                   color: isEmptySlot ? Colors.grey[300] : Colors.transparent,
  //     //                   border: Border.all(
  //     //                     color: Colors.blueAccent,
  //     //                     width: 1.5,
  //     //                   ),
  //     //                   image: isEmptySlot
  //     //                       ? null
  //     //                       : DecorationImage(
  //     //                     image: FileImage(_imageList[index]),
  //     //                     fit: BoxFit.cover,
  //     //                   ),
  //     //                 ),
  //     //                 child: isEmptySlot
  //     //                     ? Icon(Icons.add_a_photo, color: Colors.grey[600])
  //     //                     : null,
  //     //               ),
  //     //             );
  //     //           }),
  //     //         ),
  //     //         if (_showImageError && _imageList.length < requiredImages)
  //     //           Padding(
  //     //             padding: const EdgeInsets.only(top: 8.0),
  //     //             child: Text(
  //     //               'Please upload at least $requiredImages images.',
  //     //               style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //     //             ),
  //     //           ),
  //     //       ],
  //     //     ),
  //     //   );
  //     //   break;
  //
  //       case 'IMAGE':
  //         formFields.add(
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 8.0),
  //               Wrap(
  //                 spacing: 8.0,
  //                 runSpacing: 8.0,
  //                 children: List.generate(maxImages, (index) {
  //                   bool isEmptySlot = index >= _imageList.length;
  //
  //                   return GestureDetector(
  //                     onTap: () async {
  //                       if (isEmptySlot && _imageList.length < maxImages) {
  //                         // Pick a new image
  //                         final XFile? pickedImage = await ImagePicker().pickImage(
  //                           source: ImageSource.camera,
  //                           maxWidth: 800,
  //                           maxHeight: 800,
  //                         );
  //                         if (pickedImage != null) {
  //                           setState(() {
  //                             _imageList.add(File(pickedImage.path));
  //                             _saveFormData(widget.formId);
  //                           });
  //                         }
  //                       } else if (!isEmptySlot) {
  //                         // Show image in a dialog with a delete option
  //                         await showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return Dialog(
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(16.0),
  //                               ),
  //                               child: Stack(
  //                                 children: [
  //                                   ClipRRect(
  //                                     borderRadius: BorderRadius.circular(16.0),
  //                                     child: Image.file(
  //                                       _imageList[index],
  //                                       fit: BoxFit.contain,
  //                                     ),
  //                                   ),
  //                                   Positioned(
  //                                     top: 8.0,
  //                                     right: 8.0,
  //                                     child: IconButton(
  //                                       icon: const Icon(Icons.delete, color: Colors.red),
  //                                       onPressed: () {
  //                                         setState(() {
  //                                           _imageList.removeAt(index);
  //                                           _saveFormData(widget.formId);
  //                                         });
  //                                         Navigator.pop(context);
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                         );
  //                       }
  //                     },
  //                     child: Container(
  //                       width: 130.0,
  //                       height: 130.0,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8.0),
  //                         color: isEmptySlot ? Colors.grey[300] : Colors.transparent,
  //                         border: Border.all(
  //                           color: Colors.blueAccent,
  //                           width: 1.5,
  //                         ),
  //                         image: isEmptySlot
  //                             ? null
  //                             : DecorationImage(
  //                           image: FileImage(_imageList[index]),
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                       child: isEmptySlot
  //                           ? Icon(Icons.add_a_photo, color: Colors.grey[600])
  //                           : null,
  //                     ),
  //                   );
  //                 }),
  //               ),
  //               if (_showImageError && _imageList.length < requiredImages)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0),
  //                   child: Text(
  //                     'Please upload at least $requiredImages images.',
  //                     style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         );
  //         break;
  //
  //       default:
  //         formFields.add(Text('Unsupported input type: ${field.fieldType}'));
  //         break;
  //     }
  //   }
  //
  //   // formFields.add(
  //   //   ElevatedButton(
  //   //     onPressed: () {
  //   //       _submitForm();
  //   //     },
  //   //     child: const Text('Submit'),
  //   //   ),
  //   // );
  //
  //
  //       ///Submit button
  //   // formFields.add(
  //   //   Padding(
  //   //     padding: const EdgeInsets.symmetric(vertical: 20.0), // Add vertical spacing
  //   //     child: ElevatedButton(
  //   //       onPressed: () {
  //   //         _submitForm();
  //   //       },
  //   //       style: ElevatedButton.styleFrom(
  //   //         foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, // Text color
  //   //         shape: RoundedRectangleBorder(
  //   //           borderRadius: BorderRadius.circular(30.0), // Rounded corners
  //   //         ),
  //   //         padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Larger padding for button
  //   //         elevation: 5, // Shadow for button
  //   //       ),
  //   //       child: const Text(
  //   //         'Submit',
  //   //         style: TextStyle(
  //   //           fontSize: 18.0, // Font size for better readability
  //   //           fontWeight: FontWeight.bold, // Bold text
  //   //         ),
  //   //       ),
  //   //     ),
  //   //   ),
  //   );
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: formFields,
  //       ),
  //     ),
  //   );
  // }

  ///New 2 buildForm
  // Widget buildForm(List<dynamic> formDetails) {
  //   List<Widget> formFields = [];
  //   return
  //     Padding(padding: EdgeInsets.all(10),
  //       child: ListView.builder(
  //         itemCount: formDetails.length,
  //         itemBuilder: (context, index) {
  //           final field = formDetails[index];
  //           switch (field['fieldType']) {
  //
  //           ///INPUT DATA
  //             case 'input':
  //             case 'textarea':
  //               bool isPhoneField = field['fieldLabel'] == 'Phone';
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding for spacing
  //                 child: TextFormField(
  //                   initialValue: _textFieldValues[field['fieldLabel']] ?? '',
  //                   keyboardType: isPhoneField ? TextInputType.phone : TextInputType.text,
  //                   maxLength: isPhoneField ? 10 : null,
  //                   inputFormatters: isPhoneField ? [FilteringTextInputFormatter.digitsOnly] : [],
  //                   decoration: InputDecoration(
  //                     hintText: field['placeholder'] ?? 'Enter value',
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       borderSide: BorderSide(
  //                         color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true) ? Colors.red : Colors.grey,
  //                         width: 1.0,
  //                       ),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       borderSide: const BorderSide(
  //                         color: Colors.blue,
  //                         width: 2.0,
  //                       ),
  //                     ),
  //                     errorBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       borderSide: const BorderSide(
  //                           color: Colors.red,
  //                           width: 2.0
  //                       ),
  //                     ),
  //                     contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                     counterText: isPhoneField ? "" : null,
  //                     labelText: field['fieldLabel'],
  //                   ),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter a value';
  //                     }
  //                     if (isPhoneField && value.length != 10) {
  //                       return 'Phone number must be exactly 10 digits';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _textFieldValues[field['fieldLabel']] = value;
  //                     });
  //                     _saveFormData(widget.formId); // Save the form data
  //                   },
  //                 ),
  //               );
  //
  //           ///DROPDOWN DATA
  //             case 'dropdown':
  //               _dropdownGroupValues[field['fieldLabel']] ??= null;
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: DropdownButtonFormField<String>(
  //                   items: field['fieldOptions']?.map<DropdownMenuItem<String>>((option) {
  //                     String optionKey = option.keys.first;
  //                     String optionValue = option.values.first;
  //                     return DropdownMenuItem<String>(
  //                       value: optionKey,
  //                       child: Text(optionValue),
  //                     );
  //                   }).toList(),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _dropdownGroupValues[field['fieldLabel']] = value;
  //                       _saveFormData(widget.formId); // Save the form data
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                     hintText: field['placeholder'] ?? 'Enter value',
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       borderSide: BorderSide(
  //                         color: _dropdownGroupValues[field['fieldLabel']] == null
  //                             ? Colors.red
  //                             : Colors.grey,
  //                         width: 1.0,
  //                       ),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       borderSide: BorderSide(
  //                         color: Colors.blue,
  //                         width: 2.0,
  //                       ),
  //                     ),
  //                     errorBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       borderSide: BorderSide(
  //                         color: Colors.red,
  //                         width: 2.0,
  //                       ),
  //                     ),
  //                     contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                   ),
  //                   validator: (value) {
  //                     if (value == null) {
  //                       return 'Please select an option';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               );
  //
  //           ///RADIO DATA
  //             case 'radio':
  //               _radioGroupValues[field['fieldLabel']] ??= null;
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: FormField<String>(
  //                   initialValue: _radioGroupValues[field['fieldLabel']],
  //                   validator: (value) {
  //                     if (value == null) {
  //                       return 'Please select an option';
  //                     }
  //                     return null;
  //                   },
  //                   builder: (FormFieldState<String> state) {
  //                     return Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         ...field['fieldOptions']?.map((option) {
  //                           String optionKey = option.keys.first;
  //                           String optionValue = option.values.first;
  //                           return Card(
  //                             margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8.0),
  //                             ),
  //                             elevation: 5,
  //                             child: RadioListTile<String>(
  //                               title: Text(optionValue),
  //                               value: optionKey,
  //                               groupValue: state.value,
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   _radioGroupValues[field['fieldLabel']] = value;
  //                                   state.didChange(value);
  //                                 });
  //                                 _saveFormData(widget.formId);
  //                               },
  //                             ),
  //                           );
  //                         }).toList() ?? [],
  //                         if (state.hasError)
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 8.0),
  //                             child: Text(
  //                               state.errorText ?? '',
  //                               style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                             ),
  //                           ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               );
  //
  //           ///DATE DATA
  //             case 'date':
  //               final TextEditingController dateController = TextEditingController(
  //                 text: _textFieldValues[field['fieldLabel']] ?? '',
  //               );
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: GestureDetector(
  //                   onTap: () async {
  //                     DateTime? selectedDate = await showDatePicker(
  //                       context: context,
  //                       initialDate: DateTime.now(),
  //                       firstDate: DateTime(1900),
  //                       lastDate: DateTime(2100),
  //                     );
  //                     if (selectedDate != null) {
  //                       String formattedDate =
  //                           "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
  //                       setState(() {
  //                         _textFieldValues[field['fieldLabel']] = formattedDate;
  //                         dateController.text = formattedDate;
  //                       });
  //                       _saveFormData(widget.formId);
  //                     }
  //                   },
  //                   child: AbsorbPointer(
  //                     child: TextFormField(
  //                       controller: dateController,
  //                       decoration: InputDecoration(
  //                         hintText: field['placeholder'] ?? 'Select a date',
  //                         suffixIcon: const Icon(Icons.calendar_today),
  //                         filled: true,
  //                         fillColor: Colors.white,
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12.0),
  //                           borderSide: BorderSide(
  //                             color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true)
  //                                 ? Colors.red
  //                                 : Colors.grey,
  //                             width: 1.0,
  //                           ),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12.0),
  //                           borderSide: const BorderSide(
  //                             color: Colors.blue,
  //                             width: 2.0,
  //                           ),
  //                         ),
  //                         errorBorder: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12.0),
  //                           borderSide: const BorderSide(
  //                             color: Colors.red,
  //                             width: 2.0,
  //                           ),
  //                         ),
  //                         contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please select a date';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               );
  //
  //           ///CHECKBOX DATA
  //             case 'checkbox':
  //               _checkboxGroupValues[field['fieldLabel']] ??= {};
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: FormField<Map<String, bool>>(
  //                   initialValue: _checkboxGroupValues[field['fieldLabel']],
  //                   validator: (value) {
  //                     if (value == null || value.values.every((isChecked) => !isChecked)) {
  //                       return 'Please select at least one option';
  //                     }
  //                     return null;
  //                   },
  //                   builder: (FormFieldState<Map<String, bool>> state) {
  //                     return Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         ...field['fieldOptions'].map((option) {
  //                           String optionKey = option.keys.first;
  //                           String optionValue = option.values.first;
  //
  //                           return Card(
  //                             margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8.0),
  //                             ),
  //                             elevation: 5,
  //                             child: CheckboxListTile(
  //                               title: Text(optionValue),
  //                               value: state.value?[optionKey] ?? false,
  //                               onChanged: (bool? value) {
  //                                 setState(() {
  //                                   state.value![optionKey] = value ?? false;
  //                                 });
  //                                 _saveFormData(widget.formId);
  //                               },
  //                             ),
  //                           );
  //                         }).toList(),
  //                         if (state.hasError)
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 8.0),
  //                             child: Text(
  //                               state.errorText ?? '',
  //                               style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                             ),
  //                           ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               );
  //
  //             default:
  //               return Container(); // Return empty container for unsupported field types
  //           }
  //         },
  //       ),
  //     );
  // }

  ///New 3
  // Widget buildForm(List<dynamic> formDetails) {
  //   // Check if formDetails is null or empty, and return an empty form or message
  //   if (formDetails == null || formDetails.isEmpty) {
  //     return const Padding(
  //       padding: EdgeInsets.all(17),
  //       child: Center(child: Text('No form details available.')),
  //     );
  //   }
  //
  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  //   return Padding(
  //     padding: EdgeInsets.all(17),
  //     child: ListView.builder(
  //       itemCount: formDetails.length,
  //       itemBuilder: (context, index) {
  //         final field = formDetails[index];
  //
  //         switch (field['fieldType']) {
  //         ///INPUT DATA
  //           case 'input':
  //           case 'textarea':
  //             bool isPhoneField = field['fieldLabel'] == 'Phone';
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding for spacing
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
  //                 children: [
  //                   // Field Label at the top
  //                   Text(
  //                     field['fieldLabel'] ?? '',
  //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                   TextFormField(
  //                     initialValue: _textFieldValues[field['fieldLabel']] ?? '',
  //                     keyboardType: isPhoneField ? TextInputType.phone : TextInputType.text,
  //                     maxLength: isPhoneField ? 10 : null,
  //                     inputFormatters: isPhoneField ? [FilteringTextInputFormatter.digitsOnly] : [],
  //                     decoration: InputDecoration(
  //                       hintText: field['placeholder'] ?? 'Enter value',
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12.0),
  //                         borderSide: BorderSide(
  //                           color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true)
  //                               ? Colors.red
  //                               : Colors.grey,
  //                           width: 1.0,
  //                         ),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12.0),
  //                         borderSide: const BorderSide(
  //                           color: Colors.blue,
  //                           width: 2.0,
  //                         ),
  //                       ),
  //                       errorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12.0),
  //                         borderSide: const BorderSide(
  //                             color: Colors.red,
  //                             width: 2.0),
  //                       ),
  //                       contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                       counterText: isPhoneField ? "" : null,
  //                     ),
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter a value';
  //                       }
  //                       if (isPhoneField && value.length != 10) {
  //                         return 'Phone number must be exactly 10 digits';
  //                       }
  //                       return null;
  //                     },
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _textFieldValues[field['fieldLabel']] = value;
  //                       });
  //                       _saveFormData(widget.formId); // Save the form data
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //
  //         ///DROPDOWN DATA
  //           case 'dropdown':
  //             _dropdownGroupValues[field['fieldLabel']] ??= null;
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
  //                 children: [
  //                   // Field Label at the top
  //                   Text(
  //                     field['fieldLabel'] ?? '',
  //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                   DropdownButtonFormField<String>(
  //                     items: field['fieldOptions']?.map<DropdownMenuItem<String>>((option) {
  //                       String optionKey = option.keys.first;
  //                       String optionValue = option.values.first;
  //                       return DropdownMenuItem<String>(
  //                         value: optionKey,
  //                         child: Text(optionValue),
  //                       );
  //                     }).toList(),
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _dropdownGroupValues[field['fieldLabel']] = value;
  //                         _saveFormData(widget.formId); // Save the form data
  //                       });
  //                     },
  //                     decoration: InputDecoration(
  //                       hintText: field['placeholder'] ?? 'Enter value',
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12.0),
  //                         borderSide: BorderSide(
  //                           color: _dropdownGroupValues[field['fieldLabel']] == null
  //                               ? Colors.red
  //                               : Colors.grey,
  //                           width: 1.0,
  //                         ),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12.0),
  //                         borderSide: BorderSide(
  //                           color: Colors.blue,
  //                           width: 2.0,
  //                         ),
  //                       ),
  //                       errorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12.0),
  //                         borderSide: BorderSide(
  //                           color: Colors.red,
  //                           width: 2.0,
  //                         ),
  //                       ),
  //                       contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                     ),
  //                     validator: (value) {
  //                       if (value == null) {
  //                         return 'Please select an option';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //
  //         ///RADIO DATA
  //           case 'radio':
  //             _radioGroupValues[field['fieldLabel']] ??= null;
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
  //                 children: [
  //                   // Field Label at the top
  //                   Text(
  //                     field['fieldLabel'] ?? '',
  //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                   FormField<String>(
  //                     initialValue: _radioGroupValues[field['fieldLabel']],
  //                     validator: (value) {
  //                       if (value == null) {
  //                         return 'Please select an option';
  //                       }
  //                       return null;
  //                     },
  //                     builder: (FormFieldState<String> state) {
  //                       return Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           ...field['fieldOptions']?.map((option) {
  //                             String optionKey = option.keys.first;
  //                             String optionValue = option.values.first;
  //                             return Card(
  //                               margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8.0),
  //                               ),
  //                               elevation: 5,
  //                               child: RadioListTile<String>(
  //                                 title: Text(optionValue),
  //                                 value: optionKey,
  //                                 groupValue: state.value,
  //                                 onChanged: (value) {
  //                                   setState(() {
  //                                     _radioGroupValues[field['fieldLabel']] = value;
  //                                     state.didChange(value);
  //                                   });
  //                                   _saveFormData(widget.formId);
  //                                 },
  //                               ),
  //                             );
  //                           }).toList() ?? [],
  //                           if (state.hasError)
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 8.0),
  //                               child: Text(
  //                                 state.errorText ?? '',
  //                                 style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                               ),
  //                             ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //
  //         ///DATE DATA
  //           case 'date':
  //             final TextEditingController dateController = TextEditingController(
  //               text: _textFieldValues[field['fieldLabel']] ?? '',
  //             );
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
  //                 children: [
  //                   // Field Label at the top
  //                   Text(
  //                     field['fieldLabel'] ?? '',
  //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () async {
  //                       DateTime? selectedDate = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(1900),
  //                         lastDate: DateTime(2100),
  //                       );
  //                       if (selectedDate != null) {
  //                         String formattedDate =
  //                             "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
  //                         setState(() {
  //                           _textFieldValues[field['fieldLabel']] = formattedDate;
  //                           dateController.text = formattedDate;
  //                         });
  //                         _saveFormData(widget.formId);
  //                       }
  //                     },
  //                     child: AbsorbPointer(
  //                       child: TextFormField(
  //                         controller: dateController,
  //                         decoration: InputDecoration(
  //                           hintText: field['placeholder'] ?? 'Select a date',
  //                           suffixIcon: const Icon(Icons.calendar_today),
  //                           filled: true,
  //                           fillColor: Colors.white,
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12.0),
  //                             borderSide: BorderSide(
  //                               color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true)
  //                                   ? Colors.red
  //                                   : Colors.grey,
  //                               width: 1.0,
  //                             ),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12.0),
  //                             borderSide: const BorderSide(
  //                               color: Colors.blue,
  //                               width: 2.0,
  //                             ),
  //                           ),
  //                           errorBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12.0),
  //                             borderSide: const BorderSide(
  //                               color: Colors.red,
  //                               width: 2.0,
  //                             ),
  //                           ),
  //                           contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  //                         ),
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please select a date';
  //                           }
  //                           return null;
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //
  //         ///CHECKBOX DATA
  //           case 'checkbox':
  //             _checkboxGroupValues[field['fieldLabel']] ??= {};
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
  //                 children: [
  //                   // Field Label at the top
  //                   Text(
  //                     field['fieldLabel'] ?? '',
  //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                   FormField<Map<String, bool>>(
  //                     initialValue: _checkboxGroupValues[field['fieldLabel']],
  //                     validator: (value) {
  //                       if (value == null || value.values.every((isChecked) => !isChecked)) {
  //                         return 'Please select at least one option';
  //                       }
  //                       return null;
  //                     },
  //                     builder: (FormFieldState<Map<String, bool>> state) {
  //                       return Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           ...field['fieldOptions'].map((option) {
  //                             String optionKey = option.keys.first;
  //                             String optionValue = option.values.first;
  //
  //                             return Card(
  //                               margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8.0),
  //                               ),
  //                               elevation: 5,
  //                               child: CheckboxListTile(
  //                                 title: Text(optionValue),
  //                                 value: state.value?[optionKey] ?? false,
  //                                 onChanged: (bool? value) {
  //                                   setState(() {
  //                                     state.value![optionKey] = value ?? false;
  //                                   });
  //                                   _saveFormData(widget.formId);
  //                                 },
  //                               ),
  //                             );
  //                           }).toList(),
  //                           if (state.hasError)
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 8.0),
  //                               child: Text(
  //                                 state.errorText ?? '',
  //                                 style: const TextStyle(color: Colors.red, fontSize: 12.0),
  //                               ),
  //                             ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //
  //           default:
  //             return const SizedBox.shrink();
  //         }
  //       },
  //
  //     ),
  //   );
  // }


  Widget buildForm(List<dynamic> formDetails) {
    // Check if formDetails is null or empty, and return an empty form or message
    if (formDetails == null || formDetails.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(17),
        child: Center(child: Text('No form details available.')),
      );
    }

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.all(17),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
                key: _formKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: formDetails.length,
                  itemBuilder: (context, index) {
                    final field = formDetails[index];

                    switch (field['fieldType']) {
                      case 'input':
                      case 'textarea':
                      // Existing input field logic
                        bool isPhoneField = field['fieldLabel'] == 'Phone';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                field['fieldLabel'] ?? '',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                initialValue: _textFieldValues[field['fieldLabel']] ?? '',
                                keyboardType: isPhoneField ? TextInputType.phone : TextInputType.text,
                                maxLength: isPhoneField ? 10 : null,
                                inputFormatters: isPhoneField
                                    ? [FilteringTextInputFormatter.digitsOnly]
                                    : [],
                                decoration: InputDecoration(
                                  hintText: field['placeholder'] ?? 'Enter value',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true)
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  counterText: isPhoneField ? "" : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  if (isPhoneField && value.length != 10) {
                                    return 'Phone number must be exactly 10 digits';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _textFieldValues[field['fieldLabel']] = value;
                                  });
                                  _saveFormData(widget.formId); // Save the form data
                                },
                              ),
                            ],
                          ),
                        );

                    ///DROPDOWN DATA
                      case 'dropdown':
                        _dropdownGroupValues[field['fieldLabel']] ??= null;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
                            children: [
                              // Field Label at the top
                              Text(
                                field['fieldLabel'] ?? '',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              DropdownButtonFormField<String>(
                                items: field['fieldOptions']?.map<DropdownMenuItem<String>>((option) {
                                  String optionKey = option.keys.first;
                                  String optionValue = option.values.first;
                                  return DropdownMenuItem<String>(
                                    value: optionKey,
                                    child: Text(optionValue),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _dropdownGroupValues[field['fieldLabel']] = value;
                                    _saveFormData(widget.formId); // Save the form data
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: field['placeholder'] ?? 'Enter value',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: _dropdownGroupValues[field['fieldLabel']] == null
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select an option';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        );

                    ///RADIO DATA
                      case 'radio':
                        _radioGroupValues[field['fieldLabel']] ??= null;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
                            children: [
                              // Field Label at the top
                              Text(
                                field['fieldLabel'] ?? '',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              FormField<String>(
                                initialValue: _radioGroupValues[field['fieldLabel']],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select an option';
                                  }
                                  return null;
                                },
                                builder: (FormFieldState<String> state) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...field['fieldOptions']?.map((option) {
                                        String optionKey = option.keys.first;
                                        String optionValue = option.values.first;
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          elevation: 5,
                                          child: RadioListTile<String>(
                                            title: Text(optionValue),
                                            value: optionKey,
                                            groupValue: state.value,
                                            onChanged: (value) {
                                              setState(() {
                                                _radioGroupValues[field['fieldLabel']] = value;
                                                state.didChange(value);
                                              });
                                              _saveFormData(widget.formId);
                                            },
                                          ),
                                        );
                                      }).toList() ?? [],
                                      if (state.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            state.errorText ?? '',
                                            style: const TextStyle(color: Colors.red, fontSize: 12.0),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );

                    ///DATE DATA
                      case 'date':
                        final TextEditingController dateController = TextEditingController(
                          text: _textFieldValues[field['fieldLabel']] ?? '',
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
                            children: [
                              // Field Label at the top
                              Text(
                                field['fieldLabel'] ?? '',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDate != null) {
                                    String formattedDate =
                                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                    setState(() {
                                      _textFieldValues[field['fieldLabel']] = formattedDate;
                                      dateController.text = formattedDate;
                                    });
                                    _saveFormData(widget.formId);
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      hintText: field['placeholder'] ?? 'Select a date',
                                      suffixIcon: const Icon(Icons.calendar_today),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color: (_textFieldValues[field['fieldLabel']]?.isEmpty ?? true)
                                              ? Colors.red
                                              : Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                    ///CHECKBOX DATA
                      case 'checkbox':
                        _checkboxGroupValues[field['fieldLabel']] ??= {};
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
                            children: [
                              // Field Label at the top
                              Text(
                                field['fieldLabel'] ?? '',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              FormField<Map<String, bool>>(
                                initialValue: _checkboxGroupValues[field['fieldLabel']],
                                validator: (value) {
                                  if (value == null || value.values.every((isChecked) => !isChecked)) {
                                    return 'Please select at least one option';
                                  }
                                  return null;
                                },
                                builder: (FormFieldState<Map<String, bool>> state) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...field['fieldOptions'].map((option) {
                                        String optionKey = option.keys.first;
                                        String optionValue = option.values.first;

                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          elevation: 5,
                                          child: CheckboxListTile(
                                            title: Text(optionValue),
                                            value: state.value?[optionKey] ?? false,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                state.value![optionKey] = value ?? false;
                                              });
                                              _saveFormData(widget.formId);
                                            },
                                          ),
                                        );
                                      }).toList(),
                                      if (state.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            state.errorText ?? '',
                                            style: const TextStyle(color: Colors.red, fontSize: 12.0),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );


                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            const SizedBox(height: 20), // Add spacing before the button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Submit the form
                    _submitForm(); // Implement this method to handle form submission
                  } else {
                    // Handle validation errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all required fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      )
    );
  }


  int _getByteSize(Uint8List? bytes) {
    return bytes?.lengthInBytes ?? 0;
  }

  // Method to capture the signature as a byte array
  Future<Uint8List?> _captureSignature(SignatureController controller) async {
    if (controller.isNotEmpty) {
      return await controller.toPngBytes(); // Converts the signature to PNG
    }
    return null;
  }

  // Method to compress the signature byte array
  Future<Uint8List> _compressSignature(Uint8List originalBytes) async {
    final img.Image? signatureImage = img.decodeImage(originalBytes);
    if (signatureImage != null) {
      // Compress to JPEG with 70% quality
      return Uint8List.fromList(img.encodeJpg(signatureImage, quality: 70));
    }
    return originalBytes; // Fallback to original if compression fails
  }

  void _submitForm() async {

    bool isConnected = await ConnectivityUtil.isConnected();

    if (isConnected) {
      // _submitToServer();
    }else {
      _savePayloadToHive();
    }
  }

  void _savePayloadToHive() async {
    try {
      final List<Map<String, dynamic>> payload = await _buildPayload();

      // Save payload in Hive with a "pending" status
      var box = await Hive.openBox('formPayloadQueue');
      final dataToStore = {
        'payload': payload,
        'status': 'pending',
        'created_at': DateTime.now().toUtc().toString(),
      };
      await box.add(dataToStore);

      Navigator.pop(context);

      // Print to console
      print('Data stored in Hive: $dataToStore');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection. Form will be sent when connection is established.')),
      );
    } catch (e) {
      print('Error saving form payload to Hive: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _buildPayload() async {
    // Build your payload (like in your _submitForm method)
    // This part should be the same as your existing logic for preparing the payload
    final List<Map<String, dynamic>> payload = [];

    // Example of adding form data to payload
    _textFieldValues.forEach((key, value) {
      payload.add({
        'fieldLabel': key,
        'answer': value,
        'formId': widget.formId.toString(),
        'created_at': DateTime.now().toUtc().toString(),
      });
    });

    _dropdownGroupValues.forEach((key, value) {
      payload.add({
        'fieldLabel': key,
        'answer': value,
        'formId': widget.formId.toString(),
        'created_at': DateTime.now().toUtc().toString(),
      });
    });

    _radioGroupValues.forEach((key, value) {
      payload.add({
        'fieldLabel': key,
        'answer': value,
        'formId': widget.formId.toString(),
        'created_at': DateTime.now().toUtc().toString(),
      });
    });

    return payload;
  }

  void _startNetworkListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Iterate over the list of connectivity results (even though there is usually only one result)
      for (var result in results) {
        // if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
          // Check if the internet is available
          ConnectivityUtil.isConnected().then((isConnected) {
            // isConnected().then((isConnected) {
            if (isConnected) {
              // Network is restored, retry sending pending payloads
              _retryPendingPayloads();
            }
          });
        // }
      }
    });
  }

  // void _retryPendingPayloads() async {
  //   // var box = await Hive.openBox('payloadBox');
  //   var hiveBoxHelper = HiveBoxHelper();
  //
  //   try {
  //     // Fetch pending payloads from Hive
  //     List<Map<String, dynamic>>? pendingPayloads = await OfflineFormManager.getPendingPayloads();
  //
  //     if (pendingPayloads != null && pendingPayloads.isNotEmpty) {
  //       // Process the payloads and send them to the server
  //           for (var entry in pendingPayloads) {
  //             var payload = entry['payload'];
  //             await _sendPayloadToServer(payload);
  //
  //             // Update status after successful submission
  //             var box = await hiveBoxHelper.openBox('payloadBox');
  //             await box.put(entry.keys, {...entry, 'status': 'submitted'});
  //           }
  //
  //       // Optionally clear the pending payloads after successful submission
  //       final box = await Hive.openBox('payloadBox');
  //       await box.delete('pendingPayloads');
  //     }
  //   } catch (e) {
  //     print("Error retrying pending payloads: $e");
  //   }
  // }

  Future<void> _retryPendingPayloads() async {
    try {
      var box = await Hive.openBox('formPayloadQueue');
      var pendingPayloads = box.values.where((item) => item['status'] == 'pending').toList();

      for (var payloadData in pendingPayloads) {
        final payload = payloadData['payload'];

        try {
          String? userId = await authService.getUserId();

          if (userId == null) {
            throw Exception('User not authenticated');
          }

          final token = await authService.getToken(userId);
          if (token == null) {
            throw Exception('Not authenticated');
          }
          final String endpoint =
              '${dotenv.env['SUBMIT_ANSWER_ENDPOINT']}/${widget.formId}';



          final response = await http.post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(payload),
          );

          if (response.statusCode == 200) {
            final formController = Get.find<FormController>();
            // Update the status of the payload to 'submitted'
            final index = box.values.toList().indexOf(payloadData);
            if (index != -1) {
              await box.putAt(index, {
                ...payloadData,
                'status': 'submitted',
                'submitted_at': DateTime.now().toUtc().toString(),
              });
              print('Payload submitted successfully: $payload');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pending form sent successfully!')),
              );
            }
          } else {
            print('Failed to submit payload: ${response.statusCode}');
          }
        } catch (e) {
          print('Error sending payload: $e');
        }
      }
    } catch (e) {
      print('Error retrying pending payloads: $e');
    }
  }

  // Future<void> _sendPayloadToServer(List<Map<String, dynamic>> payload) async {
  //   try {
  //     String? userId = await authService.getUserId();
  //     final token = await authService.getToken(userId!);
  //     final String endpoint = '${dotenv.env['SUBMIT_ANSWER_ENDPOINT']}/${widget.formId}';
  //
  //     final response = await http.post(
  //       Uri.parse(endpoint),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(payload),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Payload submitted successfully.');
  //     } else {
  //       print('Failed to submit payload: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error sending payload to server: $e');
  //   }
  // }


  ///submitToServer
  // void _submitToServer() async {
  //   // setState(() {
  //   //   _isLoading = true; // Show the progress indicator
  //   // });
  //
  //
  //   setState(() {
  //     _showImageError = _imageList.length < requiredImages;
  //   });
  //
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     try {
  //       // Fetch form details from the endpoint
  //       FormModel? formModel = await _fetchFormDetails(widget.formId);
  //       String? userId = await authService.getCurrentUserId();
  //
  //
  //       if (formModel == null) {
  //         throw Exception('Failed to fetch form details.');
  //       }
  //
  //       final List<Map<String, dynamic>> payload = [];
  //
  //       print("This is the payload structure $payload");
  //
  //       // Include text field data
  //       _textFieldValues.forEach((key, value) {
  //         // Find the corresponding form detail by field label
  //         FormDetail? formDetail = formModel.formDetails.firstWhere(
  //             (detail) => detail.fieldLabel == key,
  //             orElse: () => FormDetail(
  //                 id: '',
  //                 index: 0,
  //                 fieldLabel: '',
  //                 fieldOptions: [],
  //                 isRequired: false,
  //                 defaultValue: '',
  //                 placeholder: '',
  //                 fieldType: '',
  //                 constraints: [],
  //                 key: '',
  //                 createdBy: '',
  //                 updatedBy: ''));
  //
  //         if (formDetail.id.isNotEmpty) {
  //           payload.add({
  //             'fieldLabel': formDetail.fieldLabel,
  //             'fieldType': formDetail.fieldType,
  //             'answer': value,
  //             'formId': widget.formId.toString(),
  //             'formDetailId': formDetail.id,
  //             'created_by': userId.toString(),
  //             'created_at': DateTime.now().toUtc().toString(),
  //           });
  //         }
  //       });
  //
  //       // Include radio button data
  //       _radioGroupValues.forEach((key, value) {
  //         FormDetail? formDetail = formModel.formDetails.firstWhere(
  //               (detail) => detail.fieldLabel == key,
  //           orElse: () => FormDetail(
  //             id: '',
  //             index: 0,
  //             fieldLabel: '',
  //             fieldOptions: [],
  //             isRequired: false,
  //             defaultValue: '',
  //             placeholder: '',
  //             fieldType: '',
  //             constraints: [],
  //             key: '',
  //             createdBy: '',
  //             updatedBy: '',
  //           ),
  //         );
  //
  //         if (formDetail.id.isNotEmpty) {
  //           final actualAnswer = (formDetail.fieldOptions.isNotEmpty && value is String)
  //               ? formDetail.fieldOptions.firstWhere(
  //                 (option) => option.options.containsKey(value),
  //             orElse: () => FieldOption(options: {value: value}),
  //           ).options[value]
  //               : value;
  //
  //           payload.add({
  //             'fieldLabel': formDetail.fieldLabel,
  //             'fieldType': formDetail.fieldType,
  //             'answer': actualAnswer,
  //             'formId': widget.formId.toString(),
  //             'formDetailId': formDetail.id,
  //             'created_by': userId.toString(),
  //             'created_at': DateTime.now().toUtc().toString(),
  //           });
  //         }
  //       });
  //
  //       // Include drop-down data
  //       _dropdownGroupValues.forEach((key, value) {
  //         FormDetail? formDetail = formModel.formDetails.firstWhere(
  //               (detail) => detail.fieldLabel == key,
  //           orElse: () => FormDetail(
  //             id: '',
  //             index: 0,
  //             fieldLabel: '',
  //             fieldOptions: [],
  //             isRequired: false,
  //             defaultValue: '',
  //             placeholder: '',
  //             fieldType: '',
  //             constraints: [],
  //             key: '',
  //             createdBy: '',
  //             updatedBy: '',
  //           ),
  //         );
  //
  //         if (formDetail.id.isNotEmpty) {
  //           // Map the selected value to its corresponding label
  //           final selectedLabel = formDetail.fieldOptions
  //               .map((option) => option.options[value])
  //               .firstWhere(
  //                 (label) => label != null,
  //             orElse: () => value, // Fallback to the key itself if no label is found
  //           );
  //
  //           payload.add({
  //             'fieldLabel': formDetail.fieldLabel,
  //             'fieldType': formDetail.fieldType,
  //             'answer': selectedLabel ?? 'N/A',
  //             'formId': widget.formId.toString(),
  //             'formDetailId': formDetail.id,
  //             'created_by': userId.toString(),
  //             'created_at': DateTime.now().toUtc().toString(),
  //           });
  //         }
  //       });
  //
  //       // Include checkbox data
  //       _checkboxGroupValues.forEach((key, value) {
  //         FormDetail? formDetail = formModel.formDetails.firstWhere(
  //               (detail) => detail.fieldLabel == key,
  //           orElse: () => FormDetail(
  //             id: '',
  //             index: 0,
  //             fieldLabel: '',
  //             fieldOptions: [],
  //             isRequired: false,
  //             defaultValue: '',
  //             placeholder: '',
  //             fieldType: '',
  //             constraints: [],
  //             key: '',
  //             createdBy: '',
  //             updatedBy: '',
  //           ),
  //         );
  //
  //         if (formDetail.id.isNotEmpty) {
  //           // Map selected keys to their labels
  //           final selectedAnswers = value.entries
  //               .where((entry) => entry.value) // Filter selected checkboxes
  //               .map((entry) {
  //             final matchingOption = formDetail.fieldOptions.firstWhere(
  //                   (option) => option.options.containsKey(entry.key),
  //               orElse: () => FieldOption(options: {entry.key: entry.key}), // Fallback
  //             );
  //             return matchingOption.options[entry.key] ?? entry.key;
  //           })
  //               .toList();
  //
  //           payload.add({
  //             'fieldLabel': formDetail.fieldLabel,
  //             'fieldType': formDetail.fieldType,
  //             'answer': selectedAnswers.join(', '), // Store as comma-separated labels
  //             'formId': widget.formId.toString(),
  //             'formDetailId': formDetail.id,
  //             'created_by': userId.toString(),
  //             'created_at': DateTime.now().toUtc().toString(),
  //           });
  //         }
  //       });
  //
  //       // Include signature fields if applicable
  //       for (int i = 0; i < _signatureControllers.length; i++) {
  //         SignatureController controller = _signatureControllers[i];
  //         final originalSignatureBytes = await _captureSignature(controller);
  //
  //         if (originalSignatureBytes != null) {
  //           // Original size in bytes
  //           final originalSize = _getByteSize(originalSignatureBytes);
  //
  //           // Compress the signature
  //           final compressedSignatureBytes = await _compressSignature(originalSignatureBytes);
  //           final compressedSize = _getByteSize(compressedSignatureBytes);
  //
  //           // Encode compressed bytes to base64
  //           final encodedSignature = base64Encode(compressedSignatureBytes);
  //
  //           // Add to the payload
  //           payload.add({
  //             'field_label': 'signature_$i',
  //             'answer': encodedSignature,
  //             'original_size': originalSize,
  //             'compressed_size': compressedSize,
  //             'form_id': widget.formId.toString(),
  //             'created_by': userId.toString(),
  //             'created_at': DateTime.now().toUtc().toString(),
  //           });
  //         }
  //       }
  //
  //       // Convert images to Base64 and add to payload
  //       for (int i = 0; i < _imageList.length; i++) {
  //         File imageFile = _imageList[i];
  //         if (await imageFile.exists()) {
  //           final bytes = await imageFile.readAsBytes();
  //           final base64String = base64Encode(bytes);
  //
  //           payload.add({
  //             'field_label': 'image_$i',
  //             'answer': base64String,
  //             'form_id': widget.formId.toString(),
  //             'created_by': userId.toString(),
  //             'created_at': DateTime.now().toUtc().toString(),
  //           });
  //         }
  //       }
  //
  //
  //       if (userId == null) {
  //         throw Exception('User not authenticated');
  //       }
  //
  //       final token = await authService.getToken(userId);
  //       if (token == null) {
  //         throw Exception('Not authenticated');
  //       }
  //       final String endpoint =
  //         '${dotenv.env['SUBMIT_ANSWER_ENDPOINT']}/${widget.formId}';
  //
  //
  //
  //       final response = await http.post(
  //         Uri.parse(endpoint),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //         body: json.encode(payload),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         // setState(() {
  //         //   _isLoading = false; // Hide the progress indicator
  //         // });
  //
  //         final formController = Get.find<FormController>();
  //
  //         // Mark the form as submitted with its ID and data
  //         formController.markFormAsSubmitted(
  //           formModel.id, // Pass the form ID
  //           {
  //             'formId': formModel.id,
  //             'formName': formModel.name,
  //             'payload': payload,
  //             // Add more fields if necessary
  //           },
  //         );
  //
  //         print('Submitted Forms: ${formController.submittedForms}');
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Form submitted successfully!')),
  //         );
  //
  //         Navigator.pop(context);
  //       } else {
  //         // Print and show error message from the response
  //         // setState(() {
  //         //   _isLoading = false; // Hide the progress indicator
  //         // });
  //         print(
  //             'Failed to submit form: ${response.statusCode}\n${response.body}');
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'Failed to submit form: ${response.statusCode}\n${response.body}')),
  //         );
  //       }
  //     } catch (e) {
  //       // Catch and print any other errors
  //       print('Error during form submission: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error submitting form: $e')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please fill in all required fields.')),
  //     );
  //   }
  // }


///_fetchFormDetails old
//   Future<FormModel?> _fetchFormDetails(String formId) async {
//     final response = await _fetchFromApi(formId);
//     try {
//       if (response.statusCode == 200) {
//         final formData = jsonDecode(response.body);
//         return FormModel.fromJson(formData['data']);
//       } else {
//         print('Failed to fetch form details: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching form details: $e');
//       return null;
//     }
//   }

///fetchFormData old
//   Future<FormData> fetchFormData(String formId) async {
//     // Fetch form data using the fetchForms method
//     final response = await fetchForms(formId);
//
//     if (response.statusCode == 200) {
//       try {
//         // Extract the first form data from the response
//         if (response.data.isNotEmpty) {
//           return FormData.fromJson(response.data.first.toJson());
//         } else {
//           throw Exception('Form data is empty');
//         }
//       } catch (e) {
//         print('Error parsing response data: $e');
//         throw Exception('Failed to parse form data');
//       }
//     } else {
//       print('Failed to load form data: ${response.statusCode}');
//       throw Exception('Failed to load form data: ${response.statusCode}');
//     }
//   }

  // State Data in SharedPreferences
  Future<void> _saveFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert images to their paths or other identifiers
    List<String?> imagePaths = _images.map((xFile) => xFile?.path).toList();


    // Save signatures as Base64 strings
    List<String> signatureData = [];
    for (var controller in _signatureControllers) {
      if (controller.isNotEmpty) {
        final signatureBytes = await controller.toPngBytes();
        if (signatureBytes != null) {
          signatureData.add(base64Encode(signatureBytes));
        } else {
          signatureData.add(''); // Empty if no signature
        }
      } else {
        signatureData.add(''); // Empty if controller is not filled
      }
    }

    prefs.setString(
        'formData_$formId',
        json.encode({
          'radioGroupValues': _radioGroupValues,
          'dropdownGroupValues': _dropdownGroupValues,
          'checkboxGroupValues': _checkboxGroupValues.map((key, value) =>
              MapEntry(key, value.map((k, v) => MapEntry(k, v)))),
          'longitude': _longitudeController.text,
          'latitude': _latitudeController.text,
          'images': imagePaths,
          'textFieldValues': _textFieldValues, // Save text field values
          'signatures': signatureData,
          // You need to handle saving signatures as bytes or another suitable format
          // Add other fields like text inputs, signatures, images, etc.
        }));
  }

  Future<void> _loadFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    String? formData = prefs.getString('formData_$formId');

    if (formData != null) {
      try {
        final data = json.decode(formData);

        // Validate the structure of the loaded data
        if (data is Map<String, dynamic>) {
          setState(() {
            _radioGroupValues =
                Map<String, dynamic>.from(data['radioGroupValues'] ?? {});
            _checkboxGroupValues = Map<String, Map<String, bool>>.from(
                (data['checkboxGroupValues'] ?? {}).map((key, value) =>
                    MapEntry(key, Map<String, bool>.from(value))));
            _textFieldValues =
                Map<String, String>.from(data['textFieldValues'] ?? {});
            // Safely load dropdown values by ensuring they are strings
            _dropdownGroupValues = (data['dropdownGroupValues'] ?? {}).map(
                  (key, value) => MapEntry(key, value?.toString() ?? null),
            ).cast<String, String?>();
            // Load other fields like text inputs, signatures, images, etc.
          });
        } else {
          throw Exception('Invalid local data structure');
        }
      } catch (e) {
        print('Error loading saved form data: $e');
        // Handle the error by clearing the invalid local data
        await _clearFormData(formId);
      }
    }
  }

  Future<void> _clearFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('formData_$formId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Detail',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold, // Make the font bold
        ),),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _formData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final formDetails = snapshot.data!['data']['formDetails'];
            return buildForm(formDetails);
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Form'),
  //     ),
  //     body: Center(
  //       child: _isLoading
  //           ? const CircularProgressIndicator()
  //           : FutureBuilder<FormData>(
  //         future: _formResponse,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const Center(child: CircularProgressIndicator());
  //           } else if (snapshot.hasError) {
  //             return Center(child: Text('Error: ${snapshot.error}'));
  //           } else if (snapshot.hasData) {
  //             // Wrap the dynamically generated form fields with a Form widget
  //             return Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Form(
  //                 key: _formKey,
  //                 child: buildForm(snapshot.data!.formDetails),
  //               ),
  //             );
  //           } else {
  //             return const Center(child: Text('No form data'));
  //           }
  //         },
  //       ),
  //     )
  //     // floatingActionButton: FloatingActionButton(
  //     //   onPressed: _submitForm,
  //     //   child: Icon(Icons.save),
  //     // ),
  //   );
  // }
//   Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Form'),
//     ),
//     body: FutureBuilder<FormData>(
//       future: _formResponse,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.hasData) {
//           // Determine the form type (you can customize this logic)
//           BaseForm form;
//           if (snapshot.data!.formType == 'task') {
//             form = TaskForm();
//           } else if (snapshot.data!.formType == 'survey') {
//             form = SurveyForm();
//           } else {
//             return const Center(child: Text('Unknown form type'));
//           }

//           // Wrap the dynamically generated form fields with a Form widget
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: form.buildForm(snapshot.data!.formDetails),
//             ),
//           );
//         } else {
//           return const Center(child: Text('No form data'));
//         }
//       },
//     ),
//   );
// }
}
