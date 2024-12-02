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
      id: fields[0] as String,
      serviceRecordId: fields[1] as int,
      client: fields[2] as String,
      siteId: fields[3] as String,
      siteName: fields[4] as String?,
      region: fields[5] as String?,
      taskType: fields[6] as String,
      type: fields[7] as String,
      technicianId: fields[8] as String,
      teamEmail: fields[9] as String?,
      assignedTo: fields[10] as String,
      project: fields[11] as String,
      title: fields[12] as String,
      dateAssigned: fields[13] as DateTime,
      dateReceived: fields[14] as DateTime?,
      dateStarted: fields[15] as DateTime?,
      formId: fields[16] as String,
      formDetailsId: fields[17] as String?,
      isFavorited: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BaseData obj) {
    writer
      ..writeByte(19)
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
      ..write(obj.technicianId)
      ..writeByte(9)
      ..write(obj.teamEmail)
      ..writeByte(10)
      ..write(obj.assignedTo)
      ..writeByte(11)
      ..write(obj.project)
      ..writeByte(12)
      ..write(obj.title)
      ..writeByte(13)
      ..write(obj.dateAssigned)
      ..writeByte(14)
      ..write(obj.dateReceived)
      ..writeByte(15)
      ..write(obj.dateStarted)
      ..writeByte(16)
      ..write(obj.formId)
      ..writeByte(17)
      ..write(obj.formDetailsId)
      ..writeByte(18)
      ..write(obj.isFavorited);
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
