import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_key_store.dart';

class OnboardingState {
  const OnboardingState({
    this.healthWalletId,
    this.mentalHealthToken,
    this.phoneNumber,
  });

  final String? healthWalletId;
  final String? mentalHealthToken;
  final String? phoneNumber;

  OnboardingState copyWith({
    String? healthWalletId,
    String? mentalHealthToken,
    String? phoneNumber,
  }) {
    return OnboardingState(
      healthWalletId: healthWalletId ?? this.healthWalletId,
      mentalHealthToken: mentalHealthToken ?? this.mentalHealthToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState());

  Future<void> setPhoneNumber(String phoneNumber) async {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  Future<void> generateTokens() async {
    final healthWalletId = await SecureKeyStore.getOrCreateHealthWalletId();
    final mentalHealthToken = await SecureKeyStore.getOrCreateMentalHealthToken();
    state = state.copyWith(
      healthWalletId: healthWalletId,
      mentalHealthToken: mentalHealthToken,
    );
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(),
);

final hasOnboardedProvider = FutureProvider<bool>((ref) {
  return SecureKeyStore.hasCompletedOnboarding();
});
