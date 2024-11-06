import 'dart:convert';
import 'dart:io';

import 'package:fcm_voip/data/form_data.dart';
import 'package:fcm_voip/data/form_details.dart';
import 'package:fcm_voip/data/model/task_model/form_model.dart';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

 class FormBuild extends StatefulWidget{
  final String formId;

  FormBuild({required this.formId});

  @override
  _FormBuildState createState() => _FormBuildState();
  
}

class _FormBuildState extends State<FormBuild> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  Future<FormData>? _formResponse;
  Map<String, String> _textFieldValues = {};
  Map<String, dynamic> _radioGroupValues = {};
  Map<String, String?> _dropdownGroupValues = {};

  Map<String, Map<String, bool>> _checkboxGroupValues = {};
  List<SignatureController> _signatureControllers = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _images = List<XFile?>.filled(6, null, growable: false);
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formResponse = fetchFormData(widget.formId);
    _loadFormData(widget.formId);
    // _startConnectivityListener();
  }

  Future<http.Response> _fetchFromApi(String formId) async {
    String? userId = await authService.getCurrentUserId();
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
    }

    return response; 
  }

// Location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _longitudeController.text = position.longitude.toString();
    _latitudeController.text = position.latitude.toString();
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

  Widget buildForm(List<FormDetails> formDetails) {
    List<Widget> formFields = [];

    for (var field in formDetails) {
      formFields.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add padding at the top
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              field.fieldLabel,
              style: const TextStyle(
                fontSize: 18.0, // Increase the font size
                fontWeight: FontWeight.bold, // Optional: Make the text bold
              ),
            ),
          ),
        ),
      );

      switch (field.fieldType.toUpperCase()) {
        case 'DATE':
          final TextEditingController dateController = TextEditingController(
            text: _textFieldValues[field.fieldLabel] ?? '',
          );

          formFields.add(
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: field.placeholder,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (selectedDate != null) {
                  setState(() {
                    String formattedDate =
                        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                    dateController.text = formattedDate;
                    _textFieldValues[field.fieldLabel] = formattedDate;
                  });
                  _saveFormData(widget.formId);
                }
              },
            ),
          );
          break;
        case 'RADIO':
          _radioGroupValues[field.fieldLabel] ??= null;
          formFields.addAll(field.fieldOptions.map((option) {
            String optionKey = option.keys.first;
            String optionValue = option.values.first;
            return RadioListTile<String>(
              title: Text(optionValue),
              value: optionKey,
              groupValue: _radioGroupValues[field.fieldLabel],
              onChanged: (value) {
                setState(() {
                  _radioGroupValues[field.fieldLabel] = value;
                });
              },
            );
          }).toList());
          break;
        case 'TEXTAREA':
        case 'INPUT':
          formFields.add(TextFormField(
            initialValue: _textFieldValues[field.fieldLabel] ?? '',
            decoration: InputDecoration(
              hintText: field.placeholder,
            ),
            onChanged: (value) {
              setState(() {
                _textFieldValues[field.fieldLabel] = value;
              });
              _saveFormData(widget.formId);
            },
          ));
          break;
        case 'DROPDOWN':
          _dropdownGroupValues[field.fieldLabel] ??= null;
          formFields.add(DropdownButtonFormField<String>(
            items: field.fieldOptions.map((option) {
              String optionKey = option.keys.first;
              String optionValue = option.values.first;
              return DropdownMenuItem<String>(
                value: optionKey,
                child: Text(optionValue),
              );
            }).toList(),
            onChanged: (value) {
              // Handle dropdown change
              _dropdownGroupValues[field.fieldLabel] = value;
              _saveFormData(widget.formId);
            },
            hint: Text(field.placeholder),
          ));
          break;
        case 'CHECKBOX':
          _checkboxGroupValues[field.fieldLabel] ??= {};
          formFields.addAll(field.fieldOptions.map((option) {
            String optionKey = option.keys.first;
            String optionValue = option.values.first;
            return CheckboxListTile(
              title: Text(optionValue),
              value:
                  _checkboxGroupValues[field.fieldLabel]?[optionKey] ?? false,
              onChanged: (value) {
                setState(() {
                  _checkboxGroupValues[field.fieldLabel]?[optionKey] =
                      value ?? false;
                  _saveFormData(widget.formId);
                });
              },
            );
          }).toList());
          break;
        case 'LOCATION':
          formFields.add(Column(
            children: [
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                onChanged: (value) {
                  _saveFormData(widget.formId);
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                onChanged: (value) {
                  _saveFormData(widget.formId);
                },
              ),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Get Current Location'),
              ),
            ],
          ));
          break;
        case 'SIGNATURE':
          // Initialize a new SignatureController for each SIGNATURE field
          SignatureController signatureController = SignatureController(
            penStrokeWidth: 5,
            penColor: Colors.black,
            exportBackgroundColor: Colors.white,
          );
          _signatureControllers.add(signatureController);

          formFields.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Signature(
                controller: signatureController,
                height: 150,
                backgroundColor: Colors.grey[200]!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        signatureController.clear();
                      });
                    },
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save or handle the signature
                      _saveFormData(widget.formId);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ));
          break;
        case 'IMAGE':
          formFields.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Take Pictures (at least 3, up to 6)'),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        if (image != null) {
                          _images[index] = image;
                        }
                      });
                      _saveFormData(widget.formId);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      color: Colors.grey[300],
                      child: _images[index] == null
                          ? const Icon(Icons.camera_alt)
                          : Image.file(File(_images[index]!.path)),
                    ),
                  );
                },
              ),
            ],
          ));
          break;
        default:
          formFields.add(Text('Unsupported input type: ${field.fieldType}'));
          break;
      }
    }

    formFields.add(
      ElevatedButton(
        onPressed: () {
          _submitForm();
        },
        child: const Text('Submit'),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: formFields,
        ),
      ),
    );
  }

  int _getByteSize(Uint8List? bytes) {
    return bytes?.lengthInBytes ?? 0;
  }

  // Method to capture the signature as a byte array
  Future<Uint8List?> _captureSignature(SignatureController controller) async {
    if (controller.isNotEmpty) {
      final Uint8List? signatureBytes = await controller.toPngBytes();
      return signatureBytes;
    }
    return null;
  }

  // Method to compress the signature byte array
  Future<Uint8List?> _compressSignature(Uint8List signatureBytes) async {
    final Uint8List? compressedBytes =
        await FlutterImageCompress.compressWithList(
      signatureBytes,
      quality: 70, // Adjust quality as needed
    );
    return compressedBytes;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Fetch form details from the endpoint
        FormModel? formModel = await _fetchFormDetails(widget.formId);

        if (formModel == null) {
          throw Exception('Failed to fetch form details.');
        }

        final List<Map<String, dynamic>> payload = [];

        // Include text field data
        _textFieldValues.forEach((key, value) {
          // Find the corresponding form detail by field label
          FormDetail? formDetail = formModel.formDetails.firstWhere(
              (detail) => detail.fieldLabel == key,
              orElse: () => FormDetail(
                  id: '',
                  index: 0,
                  fieldLabel: '',
                  fieldOptions: [],
                  isRequired: false,
                  defaultValue: '',
                  placeholder: '',
                  fieldType: '',
                  constraints: [],
                  key: '',
                  createdBy: '',
                  updatedBy: ''));

          if (formDetail.id.isNotEmpty) {
            payload.add({
              'fieldLabel': formDetail.fieldLabel,
              'fieldType': formDetail.fieldType,
              'answer': value,
              'formId': widget.formId.toString(),
              'formDetailId': formDetail.id,
              'created_by': 'username',
              'created_at': DateTime.now().toUtc().toString(),
            });
          }
        });

        // Include radio button data
        _radioGroupValues.forEach((key, value) {
          FormDetail? formDetail = formModel.formDetails.firstWhere(
              (detail) => detail.fieldLabel == key,
              orElse: () => FormDetail(
                  id: '',
                  index: 0,
                  fieldLabel: '',
                  fieldOptions: [],
                  isRequired: false,
                  defaultValue: '',
                  placeholder: '',
                  fieldType: '',
                  constraints: [],
                  key: '',
                  createdBy: '',
                  updatedBy: ''));

          if (formDetail.id.isNotEmpty) {
            payload.add({
              'fieldLabel': formDetail.fieldLabel,
              'fieldType': formDetail.fieldType,
              'answer': value,
              'formId': widget.formId.toString(),
              'formDetailId': formDetail.id,
              'created_by': 'username',
              'created_at': DateTime.now().toUtc().toString(),
            });
          }
        });

        // Include drop-down data
        _dropdownGroupValues.forEach((key, value) {
          FormDetail? formDetail = formModel.formDetails.firstWhere(
              (detail) => detail.fieldLabel == key,
              orElse: () => FormDetail(
                  id: '',
                  index: 0,
                  fieldLabel: '',
                  fieldOptions: [],
                  isRequired: false,
                  defaultValue: '',
                  placeholder: '',
                  fieldType: '',
                  constraints: [],
                  key: '',
                  createdBy: '',
                  updatedBy: ''));

          if (formDetail.id.isNotEmpty) {
            payload.add({
              'fieldLabel': formDetail.fieldLabel,
              'fieldType': formDetail.fieldType,
              'answer': value,
              'formId': widget.formId.toString(),
              'formDetailId': formDetail.id,
              'created_by': 'username',
              'created_at': DateTime.now().toUtc().toString(),
            });
          }
        });

        // Include checkbox data
        _checkboxGroupValues.forEach((key, value) {
          FormDetail? formDetail = formModel.formDetails.firstWhere(
              (detail) => detail.fieldLabel == key,
              orElse: () => FormDetail(
                  id: '',
                  index: 0,
                  fieldLabel: '',
                  fieldOptions: [],
                  isRequired: false,
                  defaultValue: '',
                  placeholder: '',
                  fieldType: '',
                  constraints: [],
                  key: '',
                  createdBy: '',
                  updatedBy: ''));

          if (formDetail.id.isNotEmpty) {
            payload.add({
              'fieldLabel': formDetail.fieldLabel,
              'fieldType': formDetail.fieldType,
              'answer': value.entries
                  .where((e) => e.value)
                  .map((e) => e.key)
                  .toList()
                  .toString(),
              'formId': widget.formId.toString(),
              'formDetailId': formDetail.id,
              'created_by': 'username',
              'created_at': DateTime.now().toUtc().toString(),
            });
          }
        });

        // Include signature fields if applicable
        for (int i = 0; i < _signatureControllers.length; i++) {
          SignatureController controller = _signatureControllers[i];
          final originalSignatureBytes = await _captureSignature(controller);
          if (originalSignatureBytes != null) {
            final originalSize = _getByteSize(originalSignatureBytes);
            final compressedSignatureBytes =
                await _compressSignature(originalSignatureBytes);
            final compressedSize = _getByteSize(compressedSignatureBytes);

            payload.add({
              'field_label': 'signature_$i',
              'answer': base64Encode(compressedSignatureBytes!),
              'original_size': originalSize,
              'compressed_size': compressedSize,
              'form_id': widget.formId.toString(),
              'created_by': 'username',
              'created_at': DateTime.now().toUtc().toString(),
            });
          }
        }

        // Include image data
        for (int i = 0; i < _images.length; i++) {
          if (_images[i] != null) {
            final File imageFile = File(_images[i]!.path);
            final List<int> imageBytes = await imageFile.readAsBytes();
            final String encodedImage = base64Encode(imageBytes);

            payload.add({
              'field_label': 'image_$i',
              'answer': encodedImage,
              'form_id': widget.formId.toString(),
              'created_by': 'username',
              'created_at': DateTime.now().toUtc().toString(),
            });
          }
        }

        // Print payload for debugging
        print('Payload: ${jsonEncode(payload)}');

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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
        } else {
          // Print and show error message from the response
          print(
              'Failed to submit form: ${response.statusCode}\n${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to submit form: ${response.statusCode}\n${response.body}')),
          );
        }
      } catch (e) {
        // Catch and print any other errors
        print('Error during form submission: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
    }
  }

  Future<FormModel?> _fetchFormDetails(String formId) async {
    final response = await _fetchFromApi(formId);
    try {
      if (response.statusCode == 200) {
        final formData = jsonDecode(response.body);
        return FormModel.fromJson(formData['data']);
      } else {
        print('Failed to fetch form details: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching form details: $e');
      return null;
    }
  }

  Future<FormData> fetchFormData(String formId) async {
    final response = await _fetchFromApi(formId);

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['data'] is Map<String, dynamic>) {
          return FormData.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse form data');
      }
    } else {
      print('Failed to load form data: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load form data: ${response.statusCode}');
    }
  }

  // State Data in SharedPreferences
  Future<void> _saveFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert images to their paths or other identifiers
    List<String?> imagePaths = _images.map((xFile) => xFile?.path).toList();

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
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: FutureBuilder<FormData>(
        future: _formResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Wrap the dynamically generated form fields with a Form widget
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: buildForm(snapshot.data!.formDetails),
              ),
            );
          } else {
            return const Center(child: Text('No form data'));
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _submitForm,
      //   child: Icon(Icons.save),
      // ),
    );
  }
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
