import 'package:bloc/bloc.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/entity/user_electronic_contract_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/use_cases/get_user_electronic_contracts_use_case.dart';
import 'package:equatable/equatable.dart';

part 'user_electronic_contracts_state.dart';

class UserElectronicContractsCubit extends Cubit<UserElectronicContractsState> {
  UserElectronicContractsCubit(this._getUserElectronicContractsUseCase)
      : super(const UserElectronicContractsState());

  final GetUserElectronicContractsUseCase _getUserElectronicContractsUseCase;

  Future<void> getUserElectronicContracts({
    bool refresh = false,
    Map<String, dynamic>? filters,
  }) async {
    if (refresh) {
      emit(state.copyWith(
        getContractsRequestState: RequestState.loading,
        offset: 0,
        hasMoreContracts: true,
      ));
    } else {
      if (state.getContractsRequestState == RequestState.loading ||
          !state.hasMoreContracts) {
        return;
      }
      emit(state.copyWith(getContractsRequestState: RequestState.loading));
    }

    final paginatedFilters = {
      ...?filters,
      'offset': state.offset,
      'limit': state.limit,
    };

    final result = await _getUserElectronicContractsUseCase(paginatedFilters);

    result.fold(
          (error) => emit(state.copyWith(
          getContractsRequestState: RequestState.error,
          getContractsRequestError: error.message
      )),
          (contracts) {
        final bool hasMore = contracts.length >= state.limit;
        final List<UserElectronicContractEntity> updatedContracts = refresh
            ? contracts
            : [...state.electronicContracts, ...contracts];

        emit(state.copyWith(
          getContractsRequestState: RequestState.loaded,
          electronicContracts: updatedContracts,
          offset: state.offset + contracts.length,
          hasMoreContracts: hasMore,
        ));
      },
    );
  }

  void loadMoreContracts({Map<String, dynamic>? filters}) {
    getUserElectronicContracts(filters: filters);
  }
}