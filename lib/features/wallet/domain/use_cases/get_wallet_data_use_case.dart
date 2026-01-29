import 'package:dartz/dartz.dart';
import 'package:enmaa/features/wallet/domain/entities/wallet_data_entity.dart';
import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';
import '../../../../core/errors/failure.dart';

class GetWalletDataUseCase {
  final BaseWalletRepository _baseWalletRepository ;

  GetWalletDataUseCase(this._baseWalletRepository);

  Future<Either<Failure, WalletDataEntity>> call() =>
      _baseWalletRepository.getWalletData( );
}