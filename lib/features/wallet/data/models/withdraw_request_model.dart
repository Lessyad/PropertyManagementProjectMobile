import '../../domain/entities/withdraw_request_entity.dart';

class WithDrawRequestModel extends WithdrawRequestEntity{
  const WithDrawRequestModel({
    required super.amount,
    required super.bankId,
    required super.ibanNumber,
  });

  factory WithDrawRequestModel.fromJson(Map<String, dynamic> json) {
    return WithDrawRequestModel(
      amount: (json['amount'] as num).toDouble(),
      bankId: json['bankId'],
      ibanNumber: json['ibanNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'bankId': bankId,
      'ibanNumber': ibanNumber,
    };
  }
}