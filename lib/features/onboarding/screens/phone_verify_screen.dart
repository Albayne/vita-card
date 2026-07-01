import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/primary_button.dart';

/// Verifies the phone number entered on the welcome screen via Firebase
/// Auth OTP. The number is never persisted by VitaCard — it is handed
/// straight to Firebase Auth and forgotten. Skipping at any point falls
/// back to an anonymous sign-in, per the privacy-first design.
class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  final _codeController = TextEditingController();
  String? _verificationId;
  String? _error;
  bool _sending = false;
  bool _verifying = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!mounted) return;
    context.go('/token-reveal', extra: widget.phoneNumber);
  }

  Future<void> _skip() async {
    await AuthService.signInAnonymously();
    _continue();
  }

  Future<void> _sendCode() async {
    final phone = widget.phoneNumber;
    if (phone == null || phone.isEmpty) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    await AuthService.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          _sending = false;
        });
      },
      onError: (message) {
        if (!mounted) return;
        setState(() {
          _error = message;
          _sending = false;
        });
      },
      onAutoVerified: () async => _continue(),
    );
  }

  Future<void> _confirmCode() async {
    final verificationId = _verificationId;
    if (verificationId == null || _codeController.text.trim().isEmpty) return;
    setState(() {
      _verifying = true;
      _error = null;
    });
    final success = await AuthService.confirmCode(
      verificationId: verificationId,
      smsCode: _codeController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      _continue();
    } else {
      setState(() {
        _verifying = false;
        _error = 'That code didn\'t match. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final codeSent = _verificationId != null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                codeSent ? 'Enter the code' : 'Verify your number',
                style: AppTextStyles.headingLarge,
              ),
              const SizedBox(height: 8),
              Text(
                codeSent
                    ? 'We sent a 6-digit code to ${widget.phoneNumber}.'
                    : 'We\'ll text a one-time code to ${widget.phoneNumber} to confirm it\'s yours. We never store this number.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 24),
              if (codeSent)
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    hintText: '123456',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
              ],
              const SizedBox(height: 16),
              if (codeSent)
                PrimaryButton(
                  label: 'Verify',
                  onPressed: _verifying ? null : _confirmCode,
                )
              else
                PrimaryButton(
                  label: 'Send code',
                  onPressed: _sending ? null : _sendCode,
                ),
              const SizedBox(height: 12),
              if (codeSent)
                GhostButton(label: 'Resend code', onPressed: _sending ? null : _sendCode),
              const Spacer(),
              GhostButton(label: 'Skip — continue anonymously', onPressed: _skip),
            ],
          ),
        ),
      ),
    );
  }
}
