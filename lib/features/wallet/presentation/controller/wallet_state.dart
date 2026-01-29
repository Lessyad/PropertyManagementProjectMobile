part of 'wallet_cubit.dart';

class WalletState extends Equatable {
  const WalletState({
    this.walletDataEntity,
    this.getWalletDataState = RequestState.initial,
    this.getWalletDataErrorMessage = '',
    this.transactions = const [],
    this.allTransactions = const [],
    this.getTransactionHistoryDataState = RequestState.initial,
    this.getTransactionHistoryDataErrorMessage = '',
    this.withdrawRequestState = RequestState.initial,
    this.withdrawRequestErrorMessage = '',
    this.getBanksState = RequestState.initial,
    this.getBanksErrorMessage = '',
    this.banks = const [],
    this.getUserBalanceState = RequestState.initial,
    this.getUserBalanceErrorMessage = '',
    this.userBalance = 0.0,
    this.currentOffset = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  final WalletDataEntity? walletDataEntity;
  final RequestState getWalletDataState;
  final String getWalletDataErrorMessage;

  final List<TransactionHistoryEntity> transactions;
  final List<TransactionHistoryEntity> allTransactions;
  final RequestState getTransactionHistoryDataState;
  final String getTransactionHistoryDataErrorMessage;

  final int currentOffset;
  final bool hasReachedMax;
  final bool isLoadingMore;

  final RequestState withdrawRequestState;
  final String withdrawRequestErrorMessage;

  final RequestState getBanksState;
  final String getBanksErrorMessage;
  final List<BankEntity> banks;

  final RequestState getUserBalanceState;
  final String getUserBalanceErrorMessage;
  final double userBalance;

  WalletState copyWith({
    WalletDataEntity? walletDataEntity,
    RequestState? getWalletDataState,
    String? getWalletDataErrorMessage,
    List<TransactionHistoryEntity>? transactions,
    List<TransactionHistoryEntity>? allTransactions,
    RequestState? getTransactionHistoryDataState,
    String? getTransactionHistoryDataErrorMessage,
    RequestState? withdrawRequestState,
    String? withdrawRequestErrorMessage,
    RequestState? getBanksState,
    String? getBanksErrorMessage,
    List<BankEntity>? banks,
    RequestState? getUserBalanceState,
    String? getUserBalanceErrorMessage,
    double? userBalance,
    int? currentOffset,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return WalletState(
      walletDataEntity: walletDataEntity ?? this.walletDataEntity,
      getWalletDataState: getWalletDataState ?? this.getWalletDataState,
      getWalletDataErrorMessage: getWalletDataErrorMessage ?? this.getWalletDataErrorMessage,
      transactions: transactions ?? this.transactions,
      allTransactions: allTransactions ?? this.allTransactions,
      getTransactionHistoryDataState: getTransactionHistoryDataState ?? this.getTransactionHistoryDataState,
      getTransactionHistoryDataErrorMessage: getTransactionHistoryDataErrorMessage ?? this.getTransactionHistoryDataErrorMessage,
      withdrawRequestState: withdrawRequestState ?? this.withdrawRequestState,
      withdrawRequestErrorMessage: withdrawRequestErrorMessage ?? this.withdrawRequestErrorMessage,
      getBanksState: getBanksState ?? this.getBanksState,
      getBanksErrorMessage: getBanksErrorMessage ?? this.getBanksErrorMessage,
      banks: banks ?? this.banks,
      getUserBalanceState: getUserBalanceState ?? this.getUserBalanceState,
      getUserBalanceErrorMessage: getUserBalanceErrorMessage ?? this.getUserBalanceErrorMessage,
      userBalance: userBalance ?? this.userBalance,
      currentOffset: currentOffset ?? this.currentOffset,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    walletDataEntity,
    getWalletDataState,
    getWalletDataErrorMessage,
    transactions,
    allTransactions,
    getTransactionHistoryDataState,
    getTransactionHistoryDataErrorMessage,
    withdrawRequestState,
    withdrawRequestErrorMessage,
    getBanksState,
    getBanksErrorMessage,
    banks,
    getUserBalanceState,
    getUserBalanceErrorMessage,
    userBalance,
    currentOffset,
    hasReachedMax,
    isLoadingMore,
  ];
}