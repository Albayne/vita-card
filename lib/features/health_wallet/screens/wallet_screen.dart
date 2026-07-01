import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/info_box.dart';

/// Phase 2 placeholder. Will hold patient-owned clinical records, encrypted
/// at rest, shared only with the patient's explicit per-record consent.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Wallet')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.folder_shared_outlined, size: 40, color: AppColors.navy, semanticLabel: 'Health Wallet'),
            SizedBox(height: 12),
            Text('Coming soon', style: AppTextStyles.headingMedium),
            SizedBox(height: 8),
            InfoBox(
              message: 'Your full clinical record, owned by you, will live '
                  'here in a future release. It will follow you between '
                  'clinics — never the other way around.',
              icon: Icons.lock_outline,
            ),
          ],
        ),
      ),
    );
  }
}
