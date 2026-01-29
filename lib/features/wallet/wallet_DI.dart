import 'package:enmaa/features/wallet/data/data_source/wallet_remote_data_source.dart';
import 'package:enmaa/features/wallet/data/repository/wallet_repository.dart';
import 'package:enmaa/features/wallet/domain/repository/base_wallet_repository.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_transaction_history_data_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_wallet_data_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/withdraw_request_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_banks_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_user_balance_use_case.dart';
  import '../../core/services/service_locator.dart';

class WalletDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerDataSources() {
    if (sl.isRegistered<BaseWalletRemoteDataSource>()) return;

    sl.registerLazySingleton<BaseWalletRemoteDataSource>(
          () => WalletRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if (sl.isRegistered<BaseWalletRepository>()) return;

    sl.registerLazySingleton<BaseWalletRepository>(
          () => WalletRepository(
        baseWalletRemoteDataSource: sl(),
      ),
    );
  }

  void _registerUseCases() {
    if (sl.isRegistered<GetWalletDataUseCase>()) return;

    sl.registerLazySingleton(
          () => GetWalletDataUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => GetTransactionHistoryDataUseCase(sl()),
    );

    sl.registerLazySingleton(
          () => WithdrawRequestUseCase(sl()),
    );

    sl.registerLazySingleton(
          () => GetBanksUseCase(sl()),
    );

    sl.registerLazySingleton(
          () => GetUserBalanceUseCase(sl()),
    );

  }
}
