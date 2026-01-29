import 'package:dartz/dartz.dart';
import 'package:enmaa/features/wallet/domain/entities/transaction_history_entity.dart';
 import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';
import '../../../../core/errors/failure.dart';

class GetTransactionHistoryDataUseCase {
  final BaseWalletRepository _baseWalletRepository ;

  GetTransactionHistoryDataUseCase(this._baseWalletRepository);

  Future<Either<Failure, List<TransactionHistoryEntity>>> call(Map<String ,dynamic> ? data) =>
      _baseWalletRepository.getTransactionHistoryData( data);
}