import 'package:hive/hive.dart';

part 'base_data.g.dart';

@HiveType(typeId: 0)
class BaseData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int serviceRecordId;

  @HiveField(2)
  final String client;

  @HiveField(3)
  final String siteId;

  @HiveField(4)
  final String? siteName;

  @HiveField(5)
  final String? region;

  @HiveField(6)
  final String taskType;

  @HiveField(7)
  final String type;

  @HiveField(8)
  final String technicianId;

  @HiveField(9)
  final String? teamEmail;

  @HiveField(10)
  final String assignedTo;

  @HiveField(11)
  final String project;

  @HiveField(12)
  final String title;

  @HiveField(13)
  final DateTime dateAssigned;

  @HiveField(14)
  final DateTime? dateReceived;

  @HiveField(15)
  final DateTime? dateStarted;

  @HiveField(16)
  final String formId;

  @HiveField(17)
  final String? formDetailsId;

  @HiveField(18)
  bool isFavorited;

  BaseData({
    required this.id,
    required this.serviceRecordId,
    required this.client,
    required this.siteId,
    this.siteName,
    this.region,
    required this.taskType,
    required this.type,
    required this.technicianId,
    this.teamEmail,
    required this.assignedTo,
    required this.project,
    required this.title,
    required this.dateAssigned,
    this.dateReceived,
    this.dateStarted,
    required this.formId,
    this.formDetailsId,
    this.isFavorited = false,
  });

  factory BaseData.fromJson(Map<String, dynamic> json) {
    return BaseData(
      id: json['id'] ?? '',
      serviceRecordId: json['serviceRecordId'] ?? 0,
      client: json['client'] ?? '',
      siteId: json['siteId'] ?? '',
      siteName: json['siteName'],
      region: json['region'],
      taskType: json['taskType'] ?? '',
      type: json['type'] ?? '',
      technicianId: json['technicianId'] ?? '',
      teamEmail: json['teamEmail'],
      assignedTo: json['assignedTo'] ?? '',
      project: json['project'] ?? '',
      title: json['title'] ?? '',
      dateAssigned: DateTime.parse(json['dateAssigned']),
      dateReceived: json['dateReceived'] != null
          ? DateTime.parse(json['dateReceived'])
          : null,
      dateStarted: json['dateStarted'] != null
          ? DateTime.parse(json['dateStarted'])
          : null,
      formId: json['formId'] ?? '',
      formDetailsId: json['formDetailsId'],
      isFavorited: json['isFavorited'] ?? false, // Provide default value
    );
  }
}