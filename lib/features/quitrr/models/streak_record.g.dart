// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayLogAdapter extends TypeAdapter<DayLog> {
  @override
  final int typeId = 3;

  @override
  DayLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayLog(
      date: fields[0] as DateTime,
      stayedClean: fields[1] as bool,
      triggers: (fields[2] as List).cast<String>(),
      cravingIntensity: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DayLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.stayedClean)
      ..writeByte(2)
      ..write(obj.triggers)
      ..writeByte(3)
      ..write(obj.cravingIntensity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
