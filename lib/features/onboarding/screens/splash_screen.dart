import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/storage/secure_key_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final onboarded = await SecureKeyStore.hasCompletedOnboarding();
    if (!mounted) return;
    context.go(onboarded ? '/dashboard' : '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 56, color: AppColors.teal, semanticLabel: 'VitaCard'),
            SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              AppStrings.tagline,
              style: TextStyle(color: AppColors.tealLight, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
