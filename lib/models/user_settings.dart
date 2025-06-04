class UserSettings {
  final String workMode;
  final bool usesDrySterilizer;
  final bool usesAccountingSoftware;

  final int clientsPerUnit;
  final String clientsUnit; // 'day', 'week', or 'month'

  final int timePerClientMinutes;
  final double avgMaterialCost;
  final double rentTaxes;
  final double trainingCosts;
  final double insuranceCost;

  final int socialMediaMinutes;
  final bool usesOnlineBooking;

  final double desiredIncome;
  final String incomeUnit; // 'hour' or 'month'

  final String currency;

  UserSettings({
    required this.workMode,
    required this.usesDrySterilizer,
    required this.usesAccountingSoftware,
    required this.clientsPerUnit,
    required this.clientsUnit,
    required this.timePerClientMinutes,
    required this.avgMaterialCost,
    required this.rentTaxes,
    required this.trainingCosts,
    required this.insuranceCost,
    required this.socialMediaMinutes,
    required this.usesOnlineBooking,
    required this.desiredIncome,
    required this.incomeUnit,
    required this.currency,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      workMode: map['workMode'],
      usesDrySterilizer: map['usesDrySterilizer'] ?? false,
      usesAccountingSoftware: map['usesAccountingSoftware'] ?? false,
      clientsPerUnit: map['clientsPerUnit'],
      clientsUnit: map['clientsUnit'],
      timePerClientMinutes: map['timePerClientMinutes'],
      avgMaterialCost: map['avgMaterialCost'],
      rentTaxes: map['rentTaxes'],
      trainingCosts: map['trainingCosts'],
      insuranceCost: map['insuranceCost'],
      socialMediaMinutes: map['socialMediaMinutes'],
      usesOnlineBooking: map['usesOnlineBooking'] ?? false,
      desiredIncome: map['desiredIncome'],
      incomeUnit: map['incomeUnit'],
      currency: map['currency'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workMode': workMode,
      'usesDrySterilizer': usesDrySterilizer,
      'usesAccountingSoftware': usesAccountingSoftware,
      'clientsPerUnit': clientsPerUnit,
      'clientsUnit': clientsUnit,
      'timePerClientMinutes': timePerClientMinutes,
      'avgMaterialCost': avgMaterialCost,
      'rentTaxes': rentTaxes,
      'trainingCosts': trainingCosts,
      'insuranceCost': insuranceCost,
      'socialMediaMinutes': socialMediaMinutes,
      'usesOnlineBooking': usesOnlineBooking,
      'desiredIncome': desiredIncome,
      'incomeUnit': incomeUnit,
      'currency': currency,
    };
  }
}
