class BaseData {
  final String id;
  final int serviceRecordId;
  final String client;
  final String siteId;
  final String? siteName;
  final String? region;
  final String taskType;
  final String type;
  final String technicianId;
  final String? teamEmail;
  final String assignedTo;
  final String project;
  final String title;
  final DateTime dateAssigned;
  final DateTime? dateReceived;
  final DateTime? dateStarted;
  final String? formId;
  final String? formDetailsId;

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
    this.formId,
    this.formDetailsId,
  });

  factory BaseData.fromJson(Map<String, dynamic> json) {
    return BaseData(
      id: json['id'],
      serviceRecordId: json['serviceRecordId'],
      client: json['client'],
      siteId: json['siteId'],
      siteName: json['siteName'],
      region: json['region'],
      taskType: json['taskType'],
      type: json['type'],
      technicianId: json['technicianId'],
      teamEmail: json['teamEmail'],
      assignedTo: json['assignedTo'],
      project: json['project'],
      title: json['title'],
      dateAssigned: DateTime.parse(json['dateAssigned']),
      dateReceived: json['dateReceived'] != null
          ? DateTime.parse(json['dateReceived'])
          : null,
      dateStarted: json['dateStarted'] != null
          ? DateTime.parse(json['dateStarted'])
          : null,
      formId: json['formId'],
      formDetailsId: json['formDetailsId'],
    );
  }
}