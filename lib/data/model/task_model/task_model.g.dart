// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'task_model.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class TaskModelAdapter extends TypeAdapter<TaskModel> {
//   @override
//   final int typeId = 0;
//
//   @override
//   TaskModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return TaskModel(
//       id: fields[0] as String,
//       serviceRecordId: fields[1] as int,
//       taskType: fields[2] as String,
//       project: fields[3] as String,
//       client: fields[4] as String,
//       siteId: fields[5] as int,
//       quantity: fields[6] as int,
//       remarks: fields[7] as String,
//       latitude: fields[8] as double,
//       type: fields[9] as String,
//       longitude: fields[10] as double,
//       accuracy: fields[11] as double,
//       location: fields[12] as String,
//       assignedTo: fields[13] as String,
//       stlEngineerName: fields[14] as String,
//       stlEngineerSign: fields[15] as String,
//       engineerSignDate: fields[16] as String,
//       customerName: fields[17] as String,
//       customerPhone: fields[18] as String,
//       customerEmail: fields[19] as String,
//       customerSign: fields[20] as String,
//       customerSignDate: fields[21] as String,
//       dateCompleted: fields[22] as DateTime,
//       dateReceived: fields[23] as DateTime,
//       dateAssigned: fields[24] as DateTime,
//       dateSent: fields[25] as DateTime,
//       dateStarted: fields[26] as DateTime,
//       createdBy: fields[27] as String,
//       createdAt: fields[28] as String,
//       teamEmail: fields[29] as String,
//       cableLength: fields[30] as String,
//       region: fields[31] as String,
//       customerEmailChecked: fields[32] as bool,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, TaskModel obj) {
//     writer
//       ..writeByte(33)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.serviceRecordId)
//       ..writeByte(2)
//       ..write(obj.taskType)
//       ..writeByte(3)
//       ..write(obj.project)
//       ..writeByte(4)
//       ..write(obj.client)
//       ..writeByte(5)
//       ..write(obj.siteId)
//       ..writeByte(6)
//       ..write(obj.quantity)
//       ..writeByte(7)
//       ..write(obj.remarks)
//       ..writeByte(8)
//       ..write(obj.latitude)
//       ..writeByte(9)
//       ..write(obj.type)
//       ..writeByte(10)
//       ..write(obj.longitude)
//       ..writeByte(11)
//       ..write(obj.accuracy)
//       ..writeByte(12)
//       ..write(obj.location)
//       ..writeByte(13)
//       ..write(obj.assignedTo)
//       ..writeByte(14)
//       ..write(obj.stlEngineerName)
//       ..writeByte(15)
//       ..write(obj.stlEngineerSign)
//       ..writeByte(16)
//       ..write(obj.engineerSignDate)
//       ..writeByte(17)
//       ..write(obj.customerName)
//       ..writeByte(18)
//       ..write(obj.customerPhone)
//       ..writeByte(19)
//       ..write(obj.customerEmail)
//       ..writeByte(20)
//       ..write(obj.customerSign)
//       ..writeByte(21)
//       ..write(obj.customerSignDate)
//       ..writeByte(22)
//       ..write(obj.dateCompleted)
//       ..writeByte(23)
//       ..write(obj.dateReceived)
//       ..writeByte(24)
//       ..write(obj.dateAssigned)
//       ..writeByte(25)
//       ..write(obj.dateSent)
//       ..writeByte(26)
//       ..write(obj.dateStarted)
//       ..writeByte(27)
//       ..write(obj.createdBy)
//       ..writeByte(28)
//       ..write(obj.createdAt)
//       ..writeByte(29)
//       ..write(obj.teamEmail)
//       ..writeByte(30)
//       ..write(obj.cableLength)
//       ..writeByte(31)
//       ..write(obj.region)
//       ..writeByte(32)
//       ..write(obj.customerEmailChecked);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TaskModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
