part of 'user_electronic_contracts_cubit.dart';

class UserElectronicContractsState extends Equatable {
  final RequestState getContractsRequestState;
  final String getContractsRequestError;
  final List<UserElectronicContractEntity> electronicContracts;
  final int offset;
  final int limit;
  final bool hasMoreContracts;

  const UserElectronicContractsState({
    this.getContractsRequestState = RequestState.initial,
    this.getContractsRequestError = '',
    this.electronicContracts = const [],
    this.offset = 0,
    this.limit = 10,
    this.hasMoreContracts = true,
  });

  UserElectronicContractsState copyWith({
    RequestState? getContractsRequestState,
    String? getContractsRequestError,
    List<UserElectronicContractEntity>? electronicContracts,
    int? offset,
    int? limit,
    bool? hasMoreContracts,
  }) {
    return UserElectronicContractsState(
      getContractsRequestState: getContractsRequestState ?? this.getContractsRequestState,
      getContractsRequestError: getContractsRequestError ?? this.getContractsRequestError,
      electronicContracts: electronicContracts ?? this.electronicContracts,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMoreContracts: hasMoreContracts ?? this.hasMoreContracts,
    );
  }

  @override
  List<Object?> get props => [
    getContractsRequestState,
    getContractsRequestError,
    electronicContracts,
    offset,
    limit,
    hasMoreContracts,
  ];
}