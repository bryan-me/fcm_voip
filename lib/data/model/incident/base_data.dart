import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

part 'base_data.g.dart';  // Necessary for Hive type adapter generation

// This is needed to generate unique IDs similar to UUID in Java.
const uuid = Uuid();


@HiveType(typeId: 0)  // Assign a unique typeId for Hive box
class BaseData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int serviceRecordId;

  @HiveField(2)
  String client;

  @HiveField(3)
  int siteId;

  @HiveField(4)
  String siteName;

  @HiveField(5)
  String region;

  @HiveField(6)
  String taskType;

  @HiveField(7)
  String type;

  @HiveField(8)
  String teamEmail;

  @HiveField(9)
  String assignedTo;

  @HiveField(10)
  String project;

  @HiveField(11)
  String title;

  @HiveField(12)
  bool isCompleted = false;

  @HiveField(13)
  String dateAssigned;

  @HiveField(14)
  String dateReceived;

  @HiveField(15)
  String dateStarted;

  BaseData({
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
    this.isCompleted = false,
    String? dateAssigned,
    String? dateReceived,
    String? dateStarted,
  }) : id = uuid.v4(),  // Automatically generate a UUID when an instance is created
        dateAssigned = dateAssigned ?? DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(DateTime.now()),
        dateReceived = dateReceived ?? '',
        dateStarted = dateStarted ?? '';

  // Getters and setters

  bool get completed => isCompleted;

  set completed(bool completed) {
    isCompleted = completed;
  }

  String get getId => id;

  set setId(String newId) {
    id = newId;
  }

  int get getServiceRecordId => serviceRecordId;

  set setServiceRecordId(int newServiceRecordId) {
    serviceRecordId = newServiceRecordId;
  }

  String get getClient => client;

  set setClient(String newClient) {
    client = newClient;
  }

  int get getSiteId => siteId;

  set setSiteId(int newSiteId) {
    siteId = newSiteId;
  }

  String get getSiteName => siteName;

  set setSiteName(String newSiteName) {
    siteName = newSiteName;
  }

  String get getRegion => region;

  set setRegion(String newRegion) {
    region = newRegion;
  }

  String get getTaskType => taskType;

  set setTaskType(String newTaskType) {
    taskType = newTaskType;
  }

  String get getType => type;

  set setType(String newType) {
    type = newType;
  }

  String get getTeamEmail => teamEmail;

  set setTeamEmail(String newTeamEmail) {
    teamEmail = newTeamEmail;
  }

  String get getAssignedTo => assignedTo;

  set setAssignedTo(String newAssignedTo) {
    assignedTo = newAssignedTo;
  }

  String get getProject => project;

  set setProject(String newProject) {
    project = newProject;
  }

  String get getTitle => title;

  set setTitle(String newTitle) {
    title = newTitle;
  }

  String get getDateAssigned => dateAssigned;

  set setDateAssigned(String newDateAssigned) {
    dateAssigned = newDateAssigned;
  }

  String get getDateReceived => dateReceived;

  set setDateReceived(String newDateReceived) {
    dateReceived = newDateReceived;
  }

  String get getDateStarted => dateStarted;

  set setDateStarted(String newDateStarted) {
    dateStarted = newDateStarted;
  }
}