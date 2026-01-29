import 'package:dartz/dartz.dart';
import 'package:enmaa/features/wallet/data/models/withdraw_request_model.dart';
import 'package:enmaa/features/wallet/domain/entities/wallet_data_entity.dart';
import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';
import '../../../../core/errors/failure.dart';

class WithdrawRequestUseCase {
  final BaseWalletRepository _baseWalletRepository ;

  WithdrawRequestUseCase(this._baseWalletRepository);

  Future<Either<Failure, void>> call(WithDrawRequestModel withDrawRequestModel ) =>
      _baseWalletRepository.withdrawRequest(withDrawRequestModel );
}