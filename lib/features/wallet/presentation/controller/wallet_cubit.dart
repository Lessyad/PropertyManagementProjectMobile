import 'package:bloc/bloc.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/wallet/data/models/withdraw_request_model.dart';
import 'package:enmaa/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:enmaa/features/wallet/domain/entities/bank_entity.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_transaction_history_data_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_wallet_data_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/withdraw_request_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_banks_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_user_balance_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/wallet_data_entity.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(
      this._withdrawRequestUseCase,
      this._getWalletDataUseCase,
      this._getTransactionHistoryDataUseCase,
      this._getBanksUseCase,
      this._getUserBalanceUseCase) : super(WalletState());

  final GetWalletDataUseCase _getWalletDataUseCase;
  final GetTransactionHistoryDataUseCase _getTransactionHistoryDataUseCase;
  final WithdrawRequestUseCase _withdrawRequestUseCase;
  final GetBanksUseCase _getBanksUseCase;
  final GetUserBalanceUseCase _getUserBalanceUseCase;

  final int _limit = 15;

  void getWalletData() async {
    print('🚀 [WalletCubit] Début de getWalletData()');
    emit(state.copyWith(getWalletDataState: RequestState.loading));

    final result = await _getWalletDataUseCase();
    result.fold(
          (failure) {
            print('🔴 [WalletCubit] Erreur lors de la récupération des données du wallet: ${failure.message}');
            emit(state.copyWith(
              getWalletDataState: RequestState.error,
              getWalletDataErrorMessage: failure.message
            ));
          },
          (data) {
            print('🟢 [WalletCubit] Données du wallet récupérées avec succès:');
            print('   - currentBalance: "${data.currentBalance}"');
            print('   - totalBalance: "${data.totalBalance}"');
            print('   - pendingBalance: "${data.pendingBalance}"');
            emit(state.copyWith(
              getWalletDataState: RequestState.loaded,
              walletDataEntity: data
            ));
          },
    );
  }

  void resetAndFetchTransactions() {
    emit(state.copyWith(
      getTransactionHistoryDataState: RequestState.loading,
      currentOffset: 0,
      hasReachedMax: false,
      allTransactions: [],
    ));

    _fetchTransactions(isInitial: true);
  }

  void loadMoreTransactions() {
    if (state.isLoadingMore || state.hasReachedMax) return;

    emit(state.copyWith(
      isLoadingMore: true,
      currentOffset: state.currentOffset + _limit,
    ));

    _fetchTransactions(isInitial: false);
  }

  void _fetchTransactions({required bool isInitial}) async {

    print('[WalletCubit] 🚀 Début de _fetchTransactions (isInitial: $isInitial)');
    print('📌 Offset actuel: ${state.currentOffset}');
    print('📌 Transactions existantes: ${state.transactions.length}');

    try {
      final result = await _getTransactionHistoryDataUseCase({
        'limit': _limit,
        'offset': state.currentOffset,
      });

      result.fold(
            (failure) {
          print('🔴 Erreur: ${failure.message}');
          emit(state.copyWith(
            getTransactionHistoryDataState: RequestState.error,
            getTransactionHistoryDataErrorMessage: failure.message,
            isLoadingMore: false,
          ));
          print('🔄 Nouvel état après erreur: ${state.toString()}');
        },
            (newTransactions) {
          print('🟢 ${newTransactions.length} nouvelles transactions reçues:');
          newTransactions.take(2).forEach((t) => print('   - ${t.id}: ${t.amount} ${t.currency}'));

          final hasReachedMax = newTransactions.length < _limit;
          final updatedTransactions = isInitial
              ? newTransactions
              : [...state.transactions, ...newTransactions];

          print('📊 Total transactions après merge: ${updatedTransactions.length}');
          print('⏸️ HasReachedMax: $hasReachedMax');

          emit(state.copyWith(
            getTransactionHistoryDataState: RequestState.loaded,
            allTransactions: updatedTransactions,
            transactions: isInitial ? newTransactions : [...state.transactions, ...newTransactions],
            hasReachedMax: hasReachedMax,
            isLoadingMore: false,
          ));

          print('🔄 Nouvel état après succès: ${state.toString()}');
        },
      );
    } catch (e, stack) {
      print('💥 ERREUR NON GÉRÉE: $e');
      print('Stack trace: $stack');
    }
  }

  void getTransactionHistoryData({int limit = 15, int offset = 0}) async {
    if (offset == 0) {
      resetAndFetchTransactions();
    } else {
      loadMoreTransactions();
    }
  }

  void withdrawRequest(WithDrawRequestModel withDrawRequestModel) async {
    emit(state.copyWith(withdrawRequestState: RequestState.loading));
    final result = await _withdrawRequestUseCase(withDrawRequestModel);
    result.fold(
          (failure) => emit(state.copyWith(
        withdrawRequestState: RequestState.error,
        withdrawRequestErrorMessage: failure.message,
      )),
          (data) => emit(state.copyWith(
        withdrawRequestState: RequestState.loaded,
      )),
    );
  }

  void getBanks() async {
    emit(state.copyWith(getBanksState: RequestState.loading));
    final result = await _getBanksUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        getBanksState: RequestState.error,
        getBanksErrorMessage: failure.message,
      )),
      (banks) => emit(state.copyWith(
        getBanksState: RequestState.loaded,
        banks: banks,
      )),
    );
  }

  void getUserBalance() async {
    emit(state.copyWith(getUserBalanceState: RequestState.loading));
    final result = await _getUserBalanceUseCase();
    result.fold(
      (failure) {
        // Si l'endpoint balance n'est pas disponible (404), on utilise le solde du wallet
        print('⚠️ [WalletCubit] Erreur lors de la récupération du solde: ${failure.message}');
        emit(state.copyWith(
          getUserBalanceState: RequestState.error,
          getUserBalanceErrorMessage: failure.message,
        ));
      },
      (balance) {
        print('✅ [WalletCubit] Solde récupéré avec succès: $balance');
        emit(state.copyWith(
          getUserBalanceState: RequestState.loaded,
          userBalance: balance,
        ));
      },
    );
  }
}