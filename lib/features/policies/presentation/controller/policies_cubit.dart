import 'package:bloc/bloc.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/policy_entity.dart';
import '../../domain/use_cases/get_policies_use_case.dart';

part 'policies_state.dart';

class PoliciesCubit extends Cubit<PoliciesState> {
  PoliciesCubit(this._getPoliciesUseCase) : super(const PoliciesState());

  final GetPoliciesUseCase _getPoliciesUseCase;

  Future<void> getPolicies() async {
    emit(state.copyWith(getPoliciesState: RequestState.loading));
    final result = await _getPoliciesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        getPoliciesState: RequestState.error,
        errorMessage: failure.message,
      )),
      (policies) => emit(state.copyWith(
        getPoliciesState: RequestState.loaded,
        policies: policies,
      )),
    );
  }
}
