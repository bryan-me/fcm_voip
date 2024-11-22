import 'package:hive/hive.dart';

// Assuming you're using a model to represent the form data
class FormDataModel extends HiveObject {
  final String formId;
  final String formName;
  final List<Map<String, dynamic>> payload;

  FormDataModel({required this.formId, required this.formName, required this.payload});
}

void saveFormData(String formId, String formName, List<Map<String, dynamic>> payload) async {
  var box = await Hive.openBox('formDataBox');

  // Creating a new FormDataModel instance
  FormDataModel formData = FormDataModel(
    formId: formId,
    formName: formName,
    payload: payload,
  );

  // Saving the form data to Hive
  await box.put(formId, formData);
}