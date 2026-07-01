// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counsellor_slot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MhBookingAdapter extends TypeAdapter<MhBooking> {
  @override
  final int typeId = 6;

  @override
  MhBooking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MhBooking(
      slotId: fields[0] as String,
      dateTime: fields[1] as DateTime,
      mhToken: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MhBooking obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.slotId)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.mhToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MhBookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
