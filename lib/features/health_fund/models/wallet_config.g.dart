// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletConfigAdapter extends TypeAdapter<WalletConfig> {
  @override
  final int typeId = 5;

  @override
  WalletConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletConfig(
      name: fields[0] as String,
      selected: fields[1] as bool,
      splitPercentage: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalletConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.selected)
      ..writeByte(2)
      ..write(obj.splitPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
