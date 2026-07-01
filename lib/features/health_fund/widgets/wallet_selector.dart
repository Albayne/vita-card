import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/fund_provider.dart';

class WalletSelector extends ConsumerWidget {
  const WalletSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);

    return Column(
      children: [
        for (var i = 0; i < wallets.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: wallets[i].selected,
                        onChanged: (_) => ref
                            .read(walletControllerProvider.notifier)
                            .toggleWallet(i),
                      ),
                      Expanded(
                        child: Text(wallets[i].name, style: AppTextStyles.body),
                      ),
                      Text(
                        '${wallets[i].splitPercentage.round()}%',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  if (wallets[i].selected)
                    Slider(
                      value: wallets[i].splitPercentage.clamp(0, 100),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      activeColor: AppColors.fundGreen,
                      label: '${wallets[i].splitPercentage.round()}%',
                      onChanged: (value) => ref
                          .read(walletControllerProvider.notifier)
                          .setSplitPercentage(i, value),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
