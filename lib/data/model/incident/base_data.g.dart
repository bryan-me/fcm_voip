// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseDataAdapter extends TypeAdapter<BaseData> {
  @override
  final int typeId = 0;

  @override
  BaseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseData(
      serviceRecordId: fields[1] as int,
      client: fields[2] as String,
      siteId: fields[3] as int,
      siteName: fields[4] as String,
      region: fields[5] as String,
      taskType: fields[6] as String,
      type: fields[7] as String,
      teamEmail: fields[8] as String,
      assignedTo: fields[9] as String,
      project: fields[10] as String,
      title: fields[11] as String,
      isCompleted: fields[12] as bool,
      dateAssigned: fields[13] as String?,
      dateReceived: fields[14] as String?,
      dateStarted: fields[15] as String?,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, BaseData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceRecordId)
      ..writeByte(2)
      ..write(obj.client)
      ..writeByte(3)
      ..write(obj.siteId)
      ..writeByte(4)
      ..write(obj.siteName)
      ..writeByte(5)
      ..write(obj.region)
      ..writeByte(6)
      ..write(obj.taskType)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.teamEmail)
      ..writeByte(9)
      ..write(obj.assignedTo)
      ..writeByte(10)
      ..write(obj.project)
      ..writeByte(11)
      ..write(obj.title)
      ..writeByte(12)
      ..write(obj.isCompleted)
      ..writeByte(13)
      ..write(obj.dateAssigned)
      ..writeByte(14)
      ..write(obj.dateReceived)
      ..writeByte(15)
      ..write(obj.dateStarted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
