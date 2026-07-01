import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../../../shared/widgets/section_label.dart';
import '../models/fund_goal.dart';
import '../providers/fund_provider.dart';

class FundCalculatorScreen extends ConsumerStatefulWidget {
  const FundCalculatorScreen({super.key});

  @override
  ConsumerState<FundCalculatorScreen> createState() =>
      _FundCalculatorScreenState();
}

class _FundCalculatorScreenState extends ConsumerState<FundCalculatorScreen> {
  int _householdSize = 1;
  int _riskLevel = 1;
  int _frequencyDays = 30;

  @override
  Widget build(BuildContext context) {
    final preview = FundCalculator.calculate(
      householdSize: _householdSize,
      riskLevel: _riskLevel,
      frequencyDays: _frequencyDays,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Calculate my fund')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const PrivacyNoticeBanner(message: AppStrings.fundPrivacyNotice),
            const SizedBox(height: 16),
            const SectionLabel(text: 'Household size'),
            Slider(
              value: _householdSize.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: AppColors.fundGreen,
              label: '$_householdSize',
              onChanged: (value) =>
                  setState(() => _householdSize = value.round()),
            ),
            Text('$_householdSize ${_householdSize == 1 ? "person" : "people"}',
                style: AppTextStyles.caption),
            const SizedBox(height: 16),
            const SectionLabel(text: 'Risk level'),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Low')),
                ButtonSegment(value: 2, label: Text('Medium')),
                ButtonSegment(value: 3, label: Text('High')),
              ],
              selected: {_riskLevel},
              onSelectionChanged: (selection) =>
                  setState(() => _riskLevel = selection.first),
            ),
            const SizedBox(height: 16),
            const SectionLabel(text: 'Top-up frequency'),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('Weekly')),
                ButtonSegment(value: 14, label: Text('Fortnightly')),
                ButtonSegment(value: 30, label: Text('Monthly')),
              ],
              selected: {_frequencyDays},
              onSelectionChanged: (selection) =>
                  setState(() => _frequencyDays = selection.first),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your fund plan', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    _previewRow('GP visit coverage', preview.gpVisitCoverage),
                    _previewRow('Pharmacy coverage', preview.pharmacyCoverage),
                    _previewRow('Emergency buffer', preview.emergencyBuffer),
                    const Divider(height: 24),
                    _previewRow('Total goal', preview.totalGoal, bold: true),
                    const SizedBox(height: 8),
                    Text(
                      'Save ${CurrencyFormatter.format(preview.savingsPerPeriod)} every ${_frequencyLabel()}',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save this plan',
              onPressed: () async {
                await ref
                    .read(fundControllerProvider.notifier)
                    .saveCalculatedGoal(preview);
                if (context.mounted) context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _frequencyLabel() {
    switch (_frequencyDays) {
      case 7:
        return 'week';
      case 14:
        return 'fortnight';
      default:
        return 'month';
    }
  }

  Widget _previewRow(String label, double value, {bool bold = false}) {
    final style = bold
        ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)
        : AppTextStyles.body;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(CurrencyFormatter.format(value), style: style),
        ],
      ),
    );
  }
}
