import 'package:equatable/equatable.dart';

class WalletDataEntity extends Equatable {
  final String currentBalance , totalBalance , pendingBalance;

  const WalletDataEntity({
    required this.currentBalance,
    required this.totalBalance,
    required this.pendingBalance,
  });

  @override
  List<Object> get props => [currentBalance, totalBalance ,pendingBalance ];
}