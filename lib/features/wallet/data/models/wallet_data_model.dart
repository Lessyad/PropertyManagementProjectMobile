import 'package:enmaa/features/wallet/domain/entities/wallet_data_entity.dart';

class WalletDataModel extends WalletDataEntity {
  const WalletDataModel({
    required super.currentBalance,
    required super.totalBalance,
    required super.pendingBalance,
  });

  factory WalletDataModel.fromJson(Map<String, dynamic> json) {
    print('🔍 [WalletDataModel] JSON reçu: $json');
    
    final currentBalance = json['available_balance']?.toString() ?? '';
    final totalBalance = json['totalBalance']?.toString() ?? '';
    final pendingBalance = json['frozen_balance']?.toString() ?? '';
    
    print('🔍 [WalletDataModel] currentBalance: "$currentBalance"');
    print('🔍 [WalletDataModel] totalBalance: "$totalBalance"');
    print('🔍 [WalletDataModel] pendingBalance: "$pendingBalance"');
    
    return WalletDataModel(
      currentBalance: currentBalance,
      totalBalance: totalBalance,
      pendingBalance: pendingBalance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentBalance': currentBalance,
      'totalBalance': totalBalance,
      'pendingBalance': pendingBalance,
    };
  }
}