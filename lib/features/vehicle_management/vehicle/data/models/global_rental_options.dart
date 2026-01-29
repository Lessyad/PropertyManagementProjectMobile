class GlobalRentalOptions {
  final double addChildsChairAmount;
  final double allRiskCarInsuranceAmount;
  final double kilometerIllimitedPerDayAmount;
  final double secondDriverAmount;

  GlobalRentalOptions({
    required this.addChildsChairAmount,
    required this.allRiskCarInsuranceAmount,
    required this.kilometerIllimitedPerDayAmount,
    required this.secondDriverAmount,
  });

  factory GlobalRentalOptions.fromJson(Map<String, dynamic> json) {
    return GlobalRentalOptions(
      addChildsChairAmount: json['addChildsChairAmount']?.toDouble() ?? 0.0,
      allRiskCarInsuranceAmount: json['allRiskCarInsuranceAmount']?.toDouble() ?? 0.0,
      kilometerIllimitedPerDayAmount: json['kilometerIllimitedPerDayAmount']?.toDouble() ?? 0.0,
      secondDriverAmount: json['secondDriverAmount']?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addChildsChairAmount': addChildsChairAmount,
      'allRiskCarInsuranceAmount': allRiskCarInsuranceAmount,
      'kilometerIllimitedPerDayAmount': kilometerIllimitedPerDayAmount,
      'secondDriverAmount': secondDriverAmount,
    };
  }

  GlobalRentalOptions copyWith({
    double? addChildsChairAmount,
    double? allRiskCarInsuranceAmount,
    double? kilometerIllimitedPerDayAmount,
    double? secondDriverAmount,
  }) {
    return GlobalRentalOptions(
      addChildsChairAmount: addChildsChairAmount ?? this.addChildsChairAmount,
      allRiskCarInsuranceAmount: allRiskCarInsuranceAmount ?? this.allRiskCarInsuranceAmount,
      kilometerIllimitedPerDayAmount: kilometerIllimitedPerDayAmount ?? this.kilometerIllimitedPerDayAmount,
      secondDriverAmount: secondDriverAmount ?? this.secondDriverAmount,
    );
  }
}
