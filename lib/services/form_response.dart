import 'package:fcm_voip/data/model/task_model/form_model.dart';

class FormResponse {
  final int statusCode;
  final String message;
  final List<FormModel> data;

  FormResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FormResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<FormModel> forms = list.map((i) => FormModel.fromJson(i)).toList();

    return FormResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: forms,
    );
  }
}