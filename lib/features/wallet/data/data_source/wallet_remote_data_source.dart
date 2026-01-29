import 'dart:async';
 import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/features/wallet/data/models/transaction_history_model.dart';
import 'package:enmaa/features/wallet/data/models/wallet_data_model.dart';
import 'package:enmaa/features/wallet/data/models/bank_model.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/withdraw_request_model.dart';




abstract class BaseWalletRemoteDataSource {



  Future<WalletDataModel> getWalletData( );
  Future<List<TransactionHistoryModel>> getTransactionHistoryData( Map<String ,dynamic> ? data);

  Future<void> withdrawRequest(WithDrawRequestModel withDrawRequestModel );
  Future<List<BankModel>> getBanks();
  Future<double> getUserBalance();

}

class WalletRemoteDataSource extends BaseWalletRemoteDataSource {
  DioService dioService;

  WalletRemoteDataSource({required this.dioService});



  @override
  Future<WalletDataModel> getWalletData() async{
    final response = await dioService.get(
      url: ApiConstants.user,
    );

    return WalletDataModel.fromJson(response.data);


  }

  @override
  Future<List<TransactionHistoryModel>> getTransactionHistoryData(Map<String ,dynamic> ? data) async {

    final response = await dioService.get(
      url: '${ApiConstants.transactions}history/',
      queryParameters: data,
    );
    final List<dynamic> results = response.data['results'] ?? [];
    List<TransactionHistoryModel> transactions = results.map((json) {
      return TransactionHistoryModel.fromJson(json);
    }).toList();
    return transactions;
  }

  @override
  Future<void> withdrawRequest(WithDrawRequestModel withDrawRequestModel) async{
    final response = await dioService.post(
      url: '${ApiConstants.payments}withdrawal_request/',
      data: withDrawRequestModel.toJson(),
    );
    
    // La réponse est vide pour un retrait, on vérifie juste le statut
    if (response.statusCode != 201) {
      throw Exception('Failed to create withdrawal request');
    }
  }

  @override
  Future<List<BankModel>> getBanks() async {
    final response = await dioService.get(
      url: ApiConstants.banks,
    );
    
    final List<dynamic> banksJson = response.data;
    return banksJson.map((json) => BankModel.fromJson(json)).toList();
  }

  @override
  Future<double> getUserBalance() async {
    final response = await dioService.get(
      url: ApiConstants.balance,
    );
    
    return (response.data['Balance'] as num).toDouble();
  }
}
