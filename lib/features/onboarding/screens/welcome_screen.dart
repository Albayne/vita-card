import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.favorite, size: 48, color: AppColors.teal, semanticLabel: 'VitaCard'),
              const SizedBox(height: 16),
              const Text('Welcome to VitaCard', style: AppTextStyles.headingLarge),
              const SizedBox(height: 8),
              const Text(
                'Your health, your record, your privacy. No name required — '
                'we never ask who you are, only how we can help.',
                style: AppTextStyles.body,
              ),
              const Spacer(),
              const Text('Phone number', style: AppTextStyles.headingSmall),
              const SizedBox(height: 4),
              const Text(
                'Used only to send you reminders. Never shown in the app or stored with your health data.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+263 7XX XXX XXX',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Continue',
                onPressed: () async {
                  final phone = _phoneController.text.trim();
                  if (phone.isEmpty) {
                    await AuthService.signInAnonymously();
                    if (!context.mounted) return;
                    context.push('/token-reveal');
                  } else if (context.mounted) {
                    context.push('/verify-phone', extra: phone);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
