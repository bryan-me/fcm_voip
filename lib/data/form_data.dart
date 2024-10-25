import 'package:fcm_voip/data/form_details.dart';

class FormData {
  final String id;
  final String name;
  final int version;
  final List<FormDetails> formDetails;
  final bool? isEnabled;

  FormData({
    required this.id,
    required this.name,
    required this.version,
    required this.formDetails,
    this.isEnabled,
  });


  factory FormData.fromJson(Map<String, dynamic> json) {
    var list = json['formDetails'] as List;
    List<FormDetails> formDetailsList = list.map((i) => FormDetails.fromJson(i)).toList();

    return FormData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      version: json['version'] ?? 0,
      formDetails: formDetailsList,
      isEnabled: json['isEnabled'],
      // title: json['title'],
    );
  }
}

