import 'package:equatable/equatable.dart';

class WithdrawRequestEntity extends Equatable{
  final double amount;
  final int bankId;
  final String ibanNumber;

  const WithdrawRequestEntity({
    required this.amount,
    required this.bankId,
    required this.ibanNumber,
  });

  @override
  List<Object?> get props => [
    amount,
    bankId,
    ibanNumber,
  ];
}