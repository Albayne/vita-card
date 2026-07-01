import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/onboarding_provider.dart';

class TokenRevealScreen extends ConsumerStatefulWidget {
  const TokenRevealScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  ConsumerState<TokenRevealScreen> createState() => _TokenRevealScreenState();
}

class _TokenRevealScreenState extends ConsumerState<TokenRevealScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
        await ref.read(onboardingControllerProvider.notifier).setPhoneNumber(widget.phoneNumber!);
      }
      await ref.read(onboardingControllerProvider.notifier).generateTokens();
      try {
        await AuthService.registerFcmToken();
      } catch (_) {
        // FCM registration is best-effort; onboarding must not block on it.
      }
    });
  }

  void _copy(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('These are yours. Forever.', style: AppTextStyles.headingLarge),
              const SizedBox(height: 8),
              const Text(
                'VitaCard generated two anonymous tokens on this device. No '
                'name, no phone number, no student ID is attached to either '
                'one. Save them — you will use them instead of your name.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 24),
              _TokenCard(
                label: 'Health Wallet ID',
                description: 'Use for STI/HIV checks, fund tracking and records.',
                token: state.healthWalletId,
                color: AppColors.teal,
                onCopy: _copy,
              ),
              const SizedBox(height: 16),
              _TokenCard(
                label: 'Mental Health Token',
                description: 'Use to book confidential counselling sessions.',
                token: state.mentalHealthToken,
                color: AppColors.mhBlue,
                onCopy: _copy,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'I have saved my tokens',
                onPressed: state.healthWalletId == null
                    ? null
                    : () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  const _TokenCard({
    required this.label,
    required this.description,
    required this.token,
    required this.color,
    required this.onCopy,
  });

  final String label;
  final String description;
  final String? token;
  final Color color;
  final void Function(String) onCopy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.headingSmall),
            const SizedBox(height: 4),
            Text(description, style: AppTextStyles.caption),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: token == null ? null : () => onCopy(token!),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color, width: 1),
                ),
                child: Center(
                  child: Text(
                    token ?? 'Generating…',
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            if (token != null) ...[
              const SizedBox(height: 4),
              const Text('Tap to copy', style: AppTextStyles.caption),
            ],
          ],
        ),
      ),
    );
  }
}
