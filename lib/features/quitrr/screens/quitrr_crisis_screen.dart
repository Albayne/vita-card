import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class QuitrrCrisisScreen extends StatelessWidget {
  const QuitrrCrisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        title: const Text('Crisis support'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.zacroCrisisName, style: AppTextStyles.headingMedium),
                  const SizedBox(height: 8),
                  SelectableText(
                    AppStrings.zacroCrisisLine,
                    style: AppTextStyles.headingLarge.copyWith(color: AppColors.danger),
                  ),
                  const SizedBox(height: 4),
                  const Text(AppStrings.zacroCrisisNote, style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Try a grounding exercise',
              style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const _BreathingExercise(),
          ],
        ),
      ),
    );
  }
}

class _BreathingExercise extends StatefulWidget {
  const _BreathingExercise();

  @override
  State<_BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<_BreathingExercise> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _inhale = Duration(seconds: 4);
  static const _hold = Duration(seconds: 7);
  static const _exhale = Duration(seconds: 8);
  static final _total = _inhale + _hold + _exhale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _total)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _phaseLabel(double t) {
    final elapsedMs = t * _total.inMilliseconds;
    if (elapsedMs < _inhale.inMilliseconds) return 'Breathe in';
    if (elapsedMs < _inhale.inMilliseconds + _hold.inMilliseconds) return 'Hold';
    return 'Breathe out';
  }

  double _scaleFor(double t) {
    final elapsedMs = t * _total.inMilliseconds;
    const minScale = 0.6;
    const maxScale = 1.0;
    if (elapsedMs < _inhale.inMilliseconds) {
      final phaseT = elapsedMs / _inhale.inMilliseconds;
      return minScale + (maxScale - minScale) * phaseT;
    }
    if (elapsedMs < _inhale.inMilliseconds + _hold.inMilliseconds) {
      return maxScale;
    }
    final exhaleElapsed = elapsedMs - _inhale.inMilliseconds - _hold.inMilliseconds;
    final phaseT = exhaleElapsed / _exhale.inMilliseconds;
    return maxScale - (maxScale - minScale) * phaseT;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final scale = _scaleFor(t);
        return Column(
          children: [
            SizedBox(
              height: 180,
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.teal.withValues(alpha: 0.25),
                      border: Border.all(color: AppColors.teal, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _phaseLabel(t),
              style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }
}
