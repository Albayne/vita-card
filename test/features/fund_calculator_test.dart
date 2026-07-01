import 'package:flutter_test/flutter_test.dart';
import 'package:vitacard/features/health_fund/models/fund_goal.dart';

void main() {
  group('FundCalculator', () {
    test('low risk, single person produces base costs', () {
      final plan = FundCalculator.calculate(
        householdSize: 1,
        riskLevel: 1,
        frequencyDays: 30,
      );

      expect(plan.gpVisitCoverage, 80.0);
      expect(plan.pharmacyCoverage, 60.0);
      expect(plan.emergencyBuffer, 200.0);
      expect(plan.totalGoal, 340.0);
    });

    test('higher risk and household size scale costs up', () {
      final plan = FundCalculator.calculate(
        householdSize: 3,
        riskLevel: 3,
        frequencyDays: 30,
      );

      // multiplier = 1.0 + (3-1)*0.4 + (3-1)*0.25 = 2.3
      expect(plan.gpVisitCoverage, (80.0 * 2.3).roundToDouble());
      expect(plan.pharmacyCoverage, (60.0 * 2.3).roundToDouble());
      expect(plan.emergencyBuffer, (200.0 * 2.3).roundToDouble());
    });

    test('savings per period scales with frequency', () {
      final weekly = FundCalculator.calculate(
        householdSize: 1,
        riskLevel: 1,
        frequencyDays: 7,
      );
      final monthly = FundCalculator.calculate(
        householdSize: 1,
        riskLevel: 1,
        frequencyDays: 30,
      );

      expect(weekly.savingsPerPeriod, lessThan(monthly.savingsPerPeriod));
    });
  });

  group('getCoverageStatus', () {
    test('covered when balance meets or exceeds cost', () {
      expect(getCoverageStatus(100, 80), CoverageStatus.covered);
    });

    test('partial when balance is at least half the cost', () {
      expect(getCoverageStatus(45, 80), CoverageStatus.partial);
    });

    test('not covered when balance is below half the cost', () {
      expect(getCoverageStatus(10, 80), CoverageStatus.notCovered);
    });
  });
}
