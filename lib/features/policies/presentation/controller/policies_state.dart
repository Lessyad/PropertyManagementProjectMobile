part of 'policies_cubit.dart';

class PoliciesState extends Equatable {
  final RequestState getPoliciesState;
  final List<PolicyEntity> policies;
  final String errorMessage;

  const PoliciesState({
    this.getPoliciesState = RequestState.initial,
    this.policies = const [],
    this.errorMessage = '',
  });

  PoliciesState copyWith({
    RequestState? getPoliciesState,
    List<PolicyEntity>? policies,
    String? errorMessage,
  }) {
    return PoliciesState(
      getPoliciesState: getPoliciesState ?? this.getPoliciesState,
      policies: policies ?? this.policies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [getPoliciesState, policies, errorMessage];
}
