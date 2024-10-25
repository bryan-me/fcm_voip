import 'package:hive/hive.dart';

part 'form_model.g.dart';

@HiveType(typeId: 0)
class FormModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int version;

  @HiveField(3)
  List<FormDetail> formDetails;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  String createdBy;

  @HiveField(6)
  DateTime? updatedAt;

  @HiveField(7)
  String updatedBy;

  FormModel({
    required this.id,
    required this.name,
    required this.version,
    required this.formDetails,
    this.createdAt,
    required this.createdBy,
    this.updatedAt,
    required this.updatedBy,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'] ?? '', // Default empty string if null
      name: json['name'] ?? '',
      version: json['version'] ?? 0,
      formDetails: (json['formDetails'] as List)
          .map((detail) => FormDetail.fromJson(detail))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      createdBy: json['createdBy'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  get region => null;

  get branchName => null;

  get customer => null;

  get dateAssigned => null;

  get dateReceived => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'formDetails': formDetails.map((detail) => detail.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }
}

@HiveType(typeId: 1)
class FormDetail extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int index;

  @HiveField(2)
  String fieldLabel;

  @HiveField(3)
  List<FieldOption> fieldOptions;

  @HiveField(4)
  bool isRequired;

  @HiveField(5)
  String defaultValue;

  @HiveField(6)
  String placeholder;

  @HiveField(7)
  String fieldType;

  @HiveField(8)
  List<String> constraints;

  @HiveField(9)
  String key;

  @HiveField(10)
  String createdBy;

  @HiveField(11)
  DateTime? createdAt;

  @HiveField(12)
  String updatedBy;

  @HiveField(13)
  DateTime? updatedAt;

  FormDetail({
    required this.id,
    required this.index,
    required this.fieldLabel,
    required this.fieldOptions,
    required this.isRequired,
    required this.defaultValue,
    required this.placeholder,
    required this.fieldType,
    required this.constraints,
    required this.key,
    required this.createdBy,
    this.createdAt,
    required this.updatedBy,
    this.updatedAt,
  });

  factory FormDetail.fromJson(Map<String, dynamic> json) {
    return FormDetail(
      id: json['id'] ?? '',
      index: json['index'] ?? 0,
      fieldLabel: json['fieldLabel'] ?? '',
      fieldOptions: (json['fieldOptions'] as List)
          .map((option) => FieldOption.fromJson(option))
          .toList(),
      isRequired: json['isRequired'] ?? false,
      defaultValue: json['defaultValue'] ?? '',
      placeholder: json['placeholder'] ?? '',
      fieldType: json['fieldType'] ?? '',
      constraints: List<String>.from(json['constraints'] ?? []),
      key: json['key'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedBy: json['updatedBy'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'fieldLabel': fieldLabel,
      'fieldOptions': fieldOptions.map((option) => option.toJson()).toList(),
      'isRequired': isRequired,
      'defaultValue': defaultValue,
      'placeholder': placeholder,
      'fieldType': fieldType,
      'constraints': constraints,
      'key': key,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
    @override
  String toString() {
    return 'FormDetail{id: $id, index: $index, fieldLabel: $fieldLabel, key: $key, required: $isRequired}';
  }
}

@HiveType(typeId: 2)
class FieldOption extends HiveObject {
  @HiveField(0)
  Map<String, String> options;

  FieldOption({required this.options});

  factory FieldOption.fromJson(Map<String, dynamic> json) {
    return FieldOption(
      options: Map<String, String>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    return options;
  }
}