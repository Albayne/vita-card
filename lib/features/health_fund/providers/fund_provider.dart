import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';
import '../models/fund_goal.dart';
import '../models/wallet_config.dart';

class FundController extends StateNotifier<FundGoal?> {
  FundController() : super(_readGoal());

  static FundGoal? _readGoal() {
    final box = HiveService.fundGoal;
    return box.isEmpty ? null : box.getAt(0);
  }

  Future<void> saveCalculatedGoal(FundGoal goal) async {
    final box = HiveService.fundGoal;
    await box.clear();
    await box.put(0, goal);
    state = goal;
  }

  Future<void> updateBalance(double newBalance) async {
    final box = HiveService.fundGoal;
    if (box.isEmpty) return;
    final goal = box.getAt(0)!;
    goal.currentBalance = newBalance;
    await goal.save();
    state = goal;
  }
}

final fundControllerProvider =
    StateNotifierProvider<FundController, FundGoal?>(
  (ref) => FundController(),
);

final currentGoalProvider = Provider<FundGoal?>((ref) {
  return ref.watch(fundControllerProvider);
});

class WalletController extends StateNotifier<List<WalletConfig>> {
  WalletController() : super(_readWallets());

  static List<WalletConfig> _readWallets() {
    final box = HiveService.walletConfig;
    if (box.isEmpty) {
      final defaults = WalletConfig.defaults();
      for (final wallet in defaults) {
        box.add(wallet);
      }
    }
    return box.values.toList();
  }

  Future<void> toggleWallet(int index) async {
    final wallet = state[index];
    wallet.selected = !wallet.selected;
    await wallet.save();
    state = HiveService.walletConfig.values.toList();
  }

  Future<void> setSplitPercentage(int index, double pct) async {
    final wallet = state[index];
    wallet.splitPercentage = pct;
    await wallet.save();
    state = HiveService.walletConfig.values.toList();
  }
}

final walletControllerProvider =
    StateNotifierProvider<WalletController, List<WalletConfig>>(
  (ref) => WalletController(),
);

final walletsProvider = Provider<List<WalletConfig>>((ref) {
  return ref.watch(walletControllerProvider);
});
