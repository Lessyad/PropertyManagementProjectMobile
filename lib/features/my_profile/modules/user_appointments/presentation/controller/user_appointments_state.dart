part of 'user_appointments_cubit.dart';

class UserAppointmentsState extends Equatable {
  const UserAppointmentsState({
    this.limit = 10,
    this.appointments = const {},
    this.offsets = const {},
    this.hasMore = const {},
    this.loadedStates = const {},
    this.errors = const {},
    this.currentStatus = 'pending',
    this.isLoadingMore = false,
    this.cancelAppointmentState = RequestState.initial,
    this.updateAppointmentState = RequestState.initial,
    this.currentAppointmentId = '',
  });

  final int limit;
  final Map<String, List<AppointmentEntity>> appointments;
  final Map<String, int> offsets;
  final Map<String, bool> hasMore;
  final Map<String, RequestState> loadedStates;
  final Map<String, String> errors;
  final String currentStatus;
  final bool isLoadingMore;

  final RequestState cancelAppointmentState;
  final RequestState updateAppointmentState;
  final String currentAppointmentId;

  List<AppointmentEntity> getAppointmentsByStatus(String status) =>
      appointments[status] ?? [];
  int getOffsetForStatus(String status) => offsets[status] ?? 0;
  bool hasMoreAppointments(String status) => hasMore[status] ?? false;
  RequestState getStateByStatus(String status) =>
      loadedStates[status] ?? RequestState.initial;
  String getErrorByStatus(String status) => errors[status] ?? '';

  UserAppointmentsState copyWith({
    int? limit,
    Map<String, List<AppointmentEntity>>? appointments,
    Map<String, int>? offsets,
    Map<String, bool>? hasMore,
    Map<String, RequestState>? loadedStates,
    Map<String, String>? errors,
    String? currentStatus,
    bool? isLoadingMore,
    RequestState? cancelAppointmentState,
    RequestState? updateAppointmentState,
    String? currentAppointmentId,
  }) {
    return UserAppointmentsState(
      limit: limit ?? this.limit,
      appointments: appointments ?? this.appointments,
      offsets: offsets ?? this.offsets,
      hasMore: hasMore ?? this.hasMore,
      loadedStates: loadedStates ?? this.loadedStates,
      errors: errors ?? this.errors,
      currentStatus: currentStatus ?? this.currentStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      cancelAppointmentState:
          cancelAppointmentState ?? this.cancelAppointmentState,
      updateAppointmentState:
          updateAppointmentState ?? this.updateAppointmentState,
      currentAppointmentId: currentAppointmentId ?? this.currentAppointmentId,
    );
  }

  @override
  List<Object?> get props => [
        limit,
        appointments,
        offsets,
        hasMore,
        loadedStates,
        errors,
        currentStatus,
        isLoadingMore,
        cancelAppointmentState,
        updateAppointmentState,
        currentAppointmentId,
      ];
}
