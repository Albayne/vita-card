// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FundGoalAdapter extends TypeAdapter<FundGoal> {
  @override
  final int typeId = 4;

  @override
  FundGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FundGoal(
      gpVisitCoverage: fields[0] as double,
      pharmacyCoverage: fields[1] as double,
      emergencyBuffer: fields[2] as double,
      totalGoal: fields[3] as double,
      savingsPerPeriod: fields[4] as double,
      frequencyDays: fields[5] as int,
      currentBalance: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FundGoal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.gpVisitCoverage)
      ..writeByte(1)
      ..write(obj.pharmacyCoverage)
      ..writeByte(2)
      ..write(obj.emergencyBuffer)
      ..writeByte(3)
      ..write(obj.totalGoal)
      ..writeByte(4)
      ..write(obj.savingsPerPeriod)
      ..writeByte(5)
      ..write(obj.frequencyDays)
      ..writeByte(6)
      ..write(obj.currentBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
