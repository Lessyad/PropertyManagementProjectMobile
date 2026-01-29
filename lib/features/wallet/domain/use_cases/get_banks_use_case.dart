import 'package:dartz/dartz.dart';
import 'package:enmaa/features/wallet/domain/entities/bank_entity.dart';
import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';
import '../../../../core/errors/failure.dart';

class GetBanksUseCase {
  final BaseWalletRepository _baseWalletRepository;

  GetBanksUseCase(this._baseWalletRepository);

  Future<Either<Failure, List<BankEntity>>> call() =>
      _baseWalletRepository.getBanks();
}
