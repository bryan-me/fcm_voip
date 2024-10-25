class FormDetails {
  final String id;
  final int index;
  final String fieldLabel;
  final List<Map<String, dynamic>> fieldOptions;
  final bool isRequired;
  final String defaultValue;
  final String placeholder;
  final String fieldType;
    final String? formDetailId; // Add this property

  final List<String> constraints;
  final String key;
  final String? createdBy;
  final String? createdAt;
  final String? updatedBy;
  final String? updatedAt;

  FormDetails({
    required this.id,
    required this.index,
    required this.fieldLabel,
    required this.fieldOptions,
    required this.isRequired,
    required this.defaultValue,
    required this.placeholder,
    required this.fieldType,
    required this.formDetailId,
    required this.constraints,
    required this.key,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory FormDetails.fromJson(Map<String, dynamic> json) {
    return FormDetails(
      id: json['id'] ?? '',
      index: json['index'] ?? 0,
      fieldLabel: json['fieldLabel'] ?? '',
      fieldOptions: (json['fieldOptions'] as List).map((e) => e as Map<String, dynamic>).toList(),
      isRequired: json['isRequired'] ?? false,
      defaultValue: json['defaultValue'] ?? '',
      placeholder: json['placeholder'] ?? '',
      fieldType: json['fieldType'] ?? '',
            formDetailId: json['form_detail_id'], // Deserialize this property

      constraints: List<String>.from(json['constraints'] ?? []),
      key: json['key'] ?? '',
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt'],
    );
  }
}