// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordAdapter extends TypeAdapter<HealthRecord> {
  @override
  final int typeId = 7;

  @override
  HealthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecord(
      recordDate: fields[0] as DateTime,
      category: fields[1] as String,
      encryptedSummary: fields[2] as String,
      anonymousId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.recordDate)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.encryptedSummary)
      ..writeByte(3)
      ..write(obj.anonymousId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
