// // import 'package:get/get.dart';
// //
// // class FormController extends GetxController {
// //   var isFormSubmitted = false.obs; // Observed variable to track form submission status
// //   var formData = <String, dynamic>{}.obs; // Store the form data if needed
// //
// //   // Method to set form submission status
// //   void setFormSubmitted(bool value) {
// //     isFormSubmitted.value = value;
// //   }
// //
// //
// //   // Optionally, store the submitted data
// //   void setFormData(Map<String, dynamic> data) {
// //     formData.value = data;
// //   }
// // }
//
//
// import 'package:get/get.dart';
//
// class FormController extends GetxController {
//   var isFormSubmitted = false.obs; // Observed variable to track form submission status
//   var formData = <String, dynamic>{}.obs; // Store the form data if needed
//   var submittedForms = <String>[].obs; // List of IDs for submitted forms
//
//   // Method to set form submission status
//   void setFormSubmitted(bool value) {
//     isFormSubmitted.value = value;
//   }
//
//   // Store form data
//   void setFormData(Map<String, dynamic> data) {
//     formData.value = data;
//   }
//
//   // Method to add a form ID to the submitted list
//   void markFormAsSubmitted(String formId) {
//     if (!submittedForms.contains(formId)) {
//       submittedForms.add(formId);
//     }
//   }
//
//   // Method to check if a form has been submitted
//   bool isFormAlreadySubmitted(String formId) {
//     return submittedForms.contains(formId);
//   }
// }

import 'package:get/get.dart';

class FormController extends GetxController {
  var submittedForms = <String, Map<String, dynamic>>{}.obs; // Tracks submitted forms with their data

  // Method to mark a form as submitted and store its data
  void markFormAsSubmitted(String formId, Map<String, dynamic> data) {
    submittedForms[formId] = data; // Associate form data with its ID
  }

  // Method to check if a form has been submitted
  bool isFormAlreadySubmitted(String formId) {
    return submittedForms.containsKey(formId);
  }

  // Retrieve submitted form data
  Map<String, dynamic> getSubmittedFormData(String formId) {
    return submittedForms[formId] ?? {};
  }
}