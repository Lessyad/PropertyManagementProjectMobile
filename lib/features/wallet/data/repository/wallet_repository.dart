import 'package:dartz/dartz.dart';
import 'package:enmaa/features/wallet/data/data_source/wallet_remote_data_source.dart';
import 'package:enmaa/features/wallet/data/models/withdraw_request_model.dart';
import 'package:enmaa/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:enmaa/features/wallet/domain/entities/wallet_data_entity.dart';
import 'package:enmaa/features/wallet/domain/entities/bank_entity.dart';
import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';


class WalletRepository extends BaseWalletRepository {
  final BaseWalletRemoteDataSource baseWalletRemoteDataSource;

  WalletRepository({required this.baseWalletRemoteDataSource});





  @override
  Future<Either<Failure, WalletDataEntity>> getWalletData() async{
    return  await HandleRequestService.handleApiCall<WalletDataEntity>(() async {
      return await baseWalletRemoteDataSource.getWalletData(  );
    });
  }

  @override
  Future<Either<Failure, List<TransactionHistoryEntity>>> getTransactionHistoryData(Map<String ,dynamic> ? data)async {
    return  await HandleRequestService.handleApiCall<List<TransactionHistoryEntity>>(() async {
      return await baseWalletRemoteDataSource.getTransactionHistoryData(  data);
    });
  }

  @override
  Future<Either<Failure, void>> withdrawRequest(WithDrawRequestModel withDrawRequestModel) async{
    return HandleRequestService.handleApiCall<void>(() async {
      return await baseWalletRemoteDataSource.withdrawRequest(withDrawRequestModel);
    });
  }

  @override
  Future<Either<Failure, List<BankEntity>>> getBanks() async {
    return HandleRequestService.handleApiCall<List<BankEntity>>(() async {
      return await baseWalletRemoteDataSource.getBanks();
    });
  }

  @override
  Future<Either<Failure, double>> getUserBalance() async {
    return HandleRequestService.handleApiCall<double>(() async {
      return await baseWalletRemoteDataSource.getUserBalance();
    });
  }
}
