import 'package:dartz/dartz.dart';
import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';
import '../../../../core/errors/failure.dart';

class GetUserBalanceUseCase {
  final BaseWalletRepository _baseWalletRepository;

  GetUserBalanceUseCase(this._baseWalletRepository);

  Future<Either<Failure, double>> call() =>
      _baseWalletRepository.getUserBalance();
}
