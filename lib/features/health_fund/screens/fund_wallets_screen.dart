import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/info_box.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../../../shared/widgets/section_label.dart';
import '../widgets/wallet_selector.dart';

class FundWalletsScreen extends StatelessWidget {
  const FundWalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallets')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            PrivacyNoticeBanner(message: AppStrings.fundPrivacyNotice),
            SizedBox(height: 16),
            SectionLabel(text: 'Your wallets'),
            WalletSelector(),
            SizedBox(height: 16),
            InfoBox(
              message: 'Reminders are push notifications only — "Time to '
                  'top up your health fund. Open EcoCash and transfer ZWG '
                  '[amount]." VitaCard never connects to any wallet API, '
                  'stores an account number, or holds credentials.',
              icon: Icons.info_outline,
            ),
          ],
        ),
      ),
    );
  }
}
