// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodLogAdapter extends TypeAdapter<MoodLog> {
  @override
  final int typeId = 2;

  @override
  MoodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodLog(
      logDate: fields[0] as DateTime,
      moodScore: fields[1] as int,
      stressors: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoodLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.logDate)
      ..writeByte(1)
      ..write(obj.moodScore)
      ..writeByte(2)
      ..write(obj.stressors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
