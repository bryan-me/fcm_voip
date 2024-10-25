// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormModelAdapter extends TypeAdapter<FormModel> {
  @override
  final int typeId = 0;

  @override
  FormModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormModel(
      id: fields[0] as String,
      name: fields[1] as String,
      version: fields[2] as int,
      formDetails: (fields[3] as List).cast<FormDetail>(),
      createdAt: fields[4] as DateTime?,
      createdBy: fields[5] as String,
      updatedAt: fields[6] as DateTime?,
      updatedBy: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FormModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.version)
      ..writeByte(3)
      ..write(obj.formDetails)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FormDetailAdapter extends TypeAdapter<FormDetail> {
  @override
  final int typeId = 1;

  @override
  FormDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormDetail(
      id: fields[0] as String,
      index: fields[1] as int,
      fieldLabel: fields[2] as String,
      fieldOptions: (fields[3] as List).cast<FieldOption>(),
      isRequired: fields[4] as bool,
      defaultValue: fields[5] as String,
      placeholder: fields[6] as String,
      fieldType: fields[7] as String,
      constraints: (fields[8] as List).cast<String>(),
      key: fields[9] as String,
      createdBy: fields[10] as String,
      createdAt: fields[11] as DateTime?,
      updatedBy: fields[12] as String,
      updatedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FormDetail obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.fieldLabel)
      ..writeByte(3)
      ..write(obj.fieldOptions)
      ..writeByte(4)
      ..write(obj.isRequired)
      ..writeByte(5)
      ..write(obj.defaultValue)
      ..writeByte(6)
      ..write(obj.placeholder)
      ..writeByte(7)
      ..write(obj.fieldType)
      ..writeByte(8)
      ..write(obj.constraints)
      ..writeByte(9)
      ..write(obj.key)
      ..writeByte(10)
      ..write(obj.createdBy)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedBy)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FieldOptionAdapter extends TypeAdapter<FieldOption> {
  @override
  final int typeId = 2;

  @override
  FieldOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldOption(
      options: (fields[0] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FieldOption obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
