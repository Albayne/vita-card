// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sti_test_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StiTestLogAdapter extends TypeAdapter<StiTestLog> {
  @override
  final int typeId = 1;

  @override
  StiTestLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StiTestLog(
      testDate: fields[0] as DateTime,
      testsIncluded: (fields[1] as List).cast<String>(),
      result: fields[2] as String,
      anonymousId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StiTestLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.testDate)
      ..writeByte(1)
      ..write(obj.testsIncluded)
      ..writeByte(2)
      ..write(obj.result)
      ..writeByte(3)
      ..write(obj.anonymousId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StiTestLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
