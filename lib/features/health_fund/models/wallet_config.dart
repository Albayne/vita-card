import 'package:hive/hive.dart';

part 'wallet_config.g.dart';

/// VitaCard stores nothing about the wallet beyond name, selection, and
/// split. No account number. No credentials. No API connection.
@HiveType(typeId: 5)
class WalletConfig extends HiveObject {
  WalletConfig({
    required this.name,
    required this.selected,
    required this.splitPercentage,
  });

  @HiveField(0)
  late String name;

  @HiveField(1)
  late bool selected;

  @HiveField(2)
  late double splitPercentage;

  static List<WalletConfig> defaults() => [
        WalletConfig(name: 'EcoCash', selected: false, splitPercentage: 0),
        WalletConfig(name: 'InnBucks', selected: false, splitPercentage: 0),
        WalletConfig(name: 'OneMoney', selected: false, splitPercentage: 0),
        WalletConfig(name: 'Zimswitch', selected: false, splitPercentage: 0),
      ];
}
