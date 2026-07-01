import 'package:hive/hive.dart';

part 'fund_goal.g.dart';

@HiveType(typeId: 4)
class FundGoal extends HiveObject {
  FundGoal({
    required this.gpVisitCoverage,
    required this.pharmacyCoverage,
    required this.emergencyBuffer,
    required this.totalGoal,
    required this.savingsPerPeriod,
    required this.frequencyDays,
    required this.currentBalance,
  });

  @HiveField(0)
  late double gpVisitCoverage;

  @HiveField(1)
  late double pharmacyCoverage;

  @HiveField(2)
  late double emergencyBuffer;

  @HiveField(3)
  late double totalGoal;

  @HiveField(4)
  late double savingsPerPeriod;

  @HiveField(5)
  late int frequencyDays;

  @HiveField(6)
  late double currentBalance;
}

enum CoverageStatus { covered, partial, notCovered }

CoverageStatus getCoverageStatus(double currentBalance, double cost) {
  if (currentBalance >= cost) return CoverageStatus.covered;
  if (currentBalance >= cost * 0.5) return CoverageStatus.partial;
  return CoverageStatus.notCovered;
}

class FundCalculator {
  FundCalculator._();

  static const double baseGpVisit = 80.0;
  static const double basePharmacy = 60.0;
  static const double baseEmergency = 200.0;

  static FundGoal calculate({
    required int householdSize,
    required int riskLevel,
    required int frequencyDays,
    double currentBalance = 0,
  }) {
    final multiplier =
        1.0 + (riskLevel - 1) * 0.4 + (householdSize - 1) * 0.25;
    final gpCost = (baseGpVisit * multiplier).roundToDouble();
    final pharmCost = (basePharmacy * multiplier).roundToDouble();
    final emergCost = (baseEmergency * multiplier).roundToDouble();
    final goalTotal = gpCost + pharmCost + emergCost;
    final perPeriod = (goalTotal / (90 / frequencyDays)).roundToDouble();

    return FundGoal(
      gpVisitCoverage: gpCost,
      pharmacyCoverage: pharmCost,
      emergencyBuffer: emergCost,
      totalGoal: goalTotal,
      savingsPerPeriod: perPeriod,
      frequencyDays: frequencyDays,
      currentBalance: currentBalance,
    );
  }
}
