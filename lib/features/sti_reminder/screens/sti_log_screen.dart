import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/sti_provider.dart';

const _testOptions = ['HIV', 'Chlamydia', 'Gonorrhea', 'Syphilis', 'Hepatitis B'];

class StiLogScreen extends ConsumerStatefulWidget {
  const StiLogScreen({super.key});

  @override
  ConsumerState<StiLogScreen> createState() => _StiLogScreenState();
}

class _StiLogScreenState extends ConsumerState<StiLogScreen> {
  final Set<String> _selectedTests = {};
  String? _result;
  bool _saving = false;

  Future<void> _save() async {
    if (_selectedTests.isEmpty || _result == null) return;
    setState(() => _saving = true);
    await ref.read(stiControllerProvider.notifier).addLog(
          testsIncluded: _selectedTests.toList(),
          result: _result!,
        );
    if (!mounted) return;
    context.go('/sti');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log a check')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('What did you check?', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final test in _testOptions)
                  FilterChip(
                    label: Text(test),
                    selected: _selectedTests.contains(test),
                    onSelected: (selected) => setState(() {
                      selected ? _selectedTests.add(test) : _selectedTests.remove(test);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (_result != 'positive') ...[
              const Text('Result', style: AppTextStyles.headingSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _ResultCard(
                      label: 'Clear',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                      selected: _result == 'clear',
                      onTap: () => setState(() => _result = 'clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ResultCard(
                      label: 'Positive',
                      icon: Icons.info_outline,
                      color: AppColors.grayDark,
                      selected: false,
                      onTap: () => setState(() => _result = 'positive'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_result == 'clear')
                PrimaryButton(
                  label: 'Save',
                  onPressed: _selectedTests.isEmpty || _saving ? null : _save,
                ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.tealLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.stiPositiveMessage,
                      style: AppTextStyles.headingSmall,
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'See support resources',
                      onPressed: () => context.push('/mind'),
                    ),
                    const SizedBox(height: 12),
                    GhostButton(
                      label: 'Save and close',
                      onPressed: _saving ? null : _save,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : AppColors.grayBorder, width: selected ? 1.5 : 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.headingSmall),
          ],
        ),
      ),
    );
  }
}
