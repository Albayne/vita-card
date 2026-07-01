import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/quitrr_provider.dart';

const _triggerOptions = ['Stress', 'Boredom', 'Social pressure', 'Loneliness', 'Celebration', 'Other'];

class QuitrrCheckinScreen extends ConsumerStatefulWidget {
  const QuitrrCheckinScreen({super.key});

  @override
  ConsumerState<QuitrrCheckinScreen> createState() => _QuitrrCheckinScreenState();
}

class _QuitrrCheckinScreenState extends ConsumerState<QuitrrCheckinScreen> {
  bool? _stayedClean;
  double _craving = 0;
  final Set<String> _triggers = {};
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(quitrrControllerProvider).logCheckIn(
          stayedClean: _stayedClean!,
          triggers: _triggers.toList(),
          cravingIntensity: _craving.round(),
        );
    if (!mounted) return;
    context.go('/quitrr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check in')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_stayedClean == null) ...[
              const Text('How did today go?', style: AppTextStyles.headingMedium),
              const SizedBox(height: 16),
              _ChoiceCard(
                label: 'I stayed clean today',
                icon: Icons.check_circle_outline,
                color: AppColors.success,
                onTap: () => setState(() => _stayedClean = true),
              ),
              const SizedBox(height: 12),
              _ChoiceCard(
                label: AppStrings.quitrrLogPrompt,
                icon: Icons.info_outline,
                color: AppColors.quittrrAmber,
                onTap: () => setState(() => _stayedClean = false),
              ),
            ] else if (_stayedClean == false) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.quittrrAmberLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(AppStrings.quitrrSlipMessage, style: AppTextStyles.headingSmall),
              ),
              const SizedBox(height: 20),
              const Text('Craving intensity', style: AppTextStyles.headingSmall),
              Slider(
                value: _craving,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: AppColors.quittrrAmber,
                label: _craving.round().toString(),
                onChanged: (value) => setState(() => _craving = value),
              ),
              const SizedBox(height: 12),
              const Text('What was happening?', style: AppTextStyles.headingSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final trigger in _triggerOptions)
                    FilterChip(
                      label: Text(trigger),
                      selected: _triggers.contains(trigger),
                      onSelected: (selected) => setState(() {
                        selected ? _triggers.add(trigger) : _triggers.remove(trigger);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save · ${AppStrings.quitrrRestartLabel}',
                onPressed: _saving ? null : _save,
              ),
            ] else ...[
              const Text('Craving intensity (optional)', style: AppTextStyles.headingSmall),
              Slider(
                value: _craving,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: AppColors.success,
                label: _craving.round().toString(),
                onChanged: (value) => setState(() => _craving = value),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Save', onPressed: _saving ? null : _save),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.headingSmall),
          ],
        ),
      ),
    );
  }
}
