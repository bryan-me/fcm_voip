class BasedData {
  int id;
  int serviceRecordId;
  String client;
  int siteId;
  String siteName;
  String region;
  String taskType;
  String type;
  String teamEmail;
  String assignedTo;
  String project;
  String title;
  DateTime dateAssigned;
  DateTime dateReceived;
  DateTime dateStarted;

  BasedData({
    required this.id,
    required this.serviceRecordId,
    required this.client,
    required this.siteId,
    required this.siteName,
    required this.region,
    required this.taskType,
    required this.type,
    required this.teamEmail,
    required this.assignedTo,
    required this.project,
    required this.title,
    required this.dateAssigned,
    required this.dateReceived,
    required this.dateStarted,
  });

  factory BasedData.fromJson(Map<String, dynamic> json) {
    return BasedData(
      id: json['id'],
      serviceRecordId: json['serviceRecordId'],
      client: json['client'],
      siteId: json['siteId'],
      siteName: json['siteName'],
      region: json['region'],
      taskType: json['taskType'],
      type: json['type'],
      teamEmail: json['teamEmail'],
      assignedTo: json['assignedTo'],
      project: json['project'],
      title: json['title'],
      dateAssigned: DateTime.parse(json['dateAssigned']),
      dateReceived: DateTime.parse(json['dateReceived']),
      dateStarted: DateTime.parse(json['dateStarted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceRecordId': serviceRecordId,
      'client': client,
      'siteId': siteId,
      'siteName': siteName,
      'region': region,
      'taskType': taskType,
      'type': type,
      'teamEmail': teamEmail,
      'assignedTo': assignedTo,
      'project': project,
      'title': title,
      'dateAssigned': dateAssigned.toIso8601String(),
      'dateReceived': dateReceived.toIso8601String(),
      'dateStarted': dateStarted.toIso8601String(),
    };
  }
}