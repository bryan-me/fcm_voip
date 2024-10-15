import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart'; // Generated code for Hive type adapter

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  int serviceRecordId;

  @HiveField(2)
  String taskType;

  @HiveField(3)
  String project;

  @HiveField(4)
  String client;

  @HiveField(5)
  int siteId;

  @HiveField(6)
  int quantity;

  @HiveField(7)
  String remarks;

  @HiveField(8)
  double latitude;

  @HiveField(9)
  String type;

  @HiveField(10)
  double longitude;

  @HiveField(11)
  double accuracy;

  @HiveField(12)
  String location;

  @HiveField(13)
  String assignedTo;

  @HiveField(14)
  String stlEngineerName;

  @HiveField(15)
  String stlEngineerSign;

  @HiveField(16)
  String engineerSignDate;

  @HiveField(17)
  String customerName;

  @HiveField(18)
  String customerPhone;

  @HiveField(19)
  String customerEmail;

  @HiveField(20)
  String customerSign;

  @HiveField(21)
  String customerSignDate;

  @HiveField(22)
  DateTime dateCompleted;

  @HiveField(23)
  DateTime dateReceived;

  @HiveField(24)
  DateTime dateAssigned;

  @HiveField(25)
  DateTime dateSent;

  @HiveField(26)
  DateTime dateStarted;

  @HiveField(27)
  String createdBy;

  @HiveField(28)
  String createdAt;

  @HiveField(29)
  String teamEmail;

  @HiveField(30)
  String cableLength;

  @HiveField(31)
  String region;

  @HiveField(32)
  bool customerEmailChecked;

  // Constructor
  TaskModel({
    required this.id,
    required this.serviceRecordId,
    required this.taskType,
    required this.project,
    required this.client,
    required this.siteId,
    required this.quantity,
    required this.remarks,
    required this.latitude,
    required this.type,
    required this.longitude,
    required this.accuracy,
    required this.location,
    required this.assignedTo,
    required this.stlEngineerName,
    required this.stlEngineerSign,
    required this.engineerSignDate,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerSign,
    required this.customerSignDate,
    required this.dateCompleted,
    required this.dateReceived,
    required this.dateAssigned,
    required this.dateSent,
    required this.dateStarted,
    required this.createdBy,
    required this.createdAt,
    required this.teamEmail,
    required this.cableLength,
    required this.region,
    required this.customerEmailChecked,
  });

  // Factory constructor to create a new instance with a UUID
  factory TaskModel.create({
    required int serviceRecordId,
    required String taskType,
    required String project,
    required String client,
    required int siteId,
    required int quantity,
    required String remarks,
    required double latitude,
    required String type,
    required double longitude,
    required double accuracy,
    required String location,
    required String assignedTo,
    required String stlEngineerName,
    required String stlEngineerSign,
    required String engineerSignDate,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String customerSign,
    required String customerSignDate,
    required DateTime dateCompleted,
    required DateTime dateReceived,
    required DateTime dateAssigned,
    required DateTime dateSent,
    required DateTime dateStarted,
    required String createdBy,
    required String createdAt,
    required String teamEmail,
    required String cableLength,
    required String region,
    required bool customerEmailChecked,
  }) {
    return TaskModel(
      id: Uuid().v4(), 
      serviceRecordId: serviceRecordId,
      taskType: taskType,
      project: project,
      client: client,
      siteId: siteId,
      quantity: quantity,
      remarks: remarks,
      latitude: latitude,
      type: type,
      longitude: longitude,
      accuracy: accuracy,
      location: location,
      assignedTo: assignedTo,
      stlEngineerName: stlEngineerName,
      stlEngineerSign: stlEngineerSign,
      engineerSignDate: engineerSignDate,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      customerSign: customerSign,
      customerSignDate: customerSignDate,
      dateCompleted: dateCompleted,
      dateReceived: dateReceived,
      dateAssigned: dateAssigned,
      dateSent: dateSent,
      dateStarted: dateStarted,
      createdBy: createdBy,
      createdAt: createdAt,
      teamEmail: teamEmail,
      cableLength: cableLength,
      region: region,
      customerEmailChecked: customerEmailChecked,
    );
  }

}