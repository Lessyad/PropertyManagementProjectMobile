import 'package:bloc/bloc.dart';
import 'package:enmaa/core/extensions/status_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/my_booking/domain/use_cases/get_my_booking_use_case.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import 'package:equatable/equatable.dart';

part 'my_booking_state.dart';

class MyBookingCubit extends Cubit<MyBookingState> {
  MyBookingCubit(this.getMyBookingUseCase) : super(const MyBookingState());

  final GetMyBookingUseCase getMyBookingUseCase;

  Future<void> getMyBookings({
    required String status,
    required bool isRefresh,
  }) async {
    if (!isRefresh && !state.hasMoreBookings(status)) {
      return;
    }

    final offset = isRefresh ? 0 : state.getOffsetForStatus(status);
    _updateStateBeforeRequest(status, isRefresh);

    String currentStatus = getStatus(status).toJson();
    // Convertir en format attendu par le backend (première lettre en majuscule)
    String backendStatus = currentStatus[0].toUpperCase() + currentStatus.substring(1);

    final filters = {
      'client': 'true',
      'client_order_status': [backendStatus],
      'offset': offset,
      'limit': state.limit,
    };

    final result = await getMyBookingUseCase(filters: filters);

    result.fold(
          (failure) => _handleFailure(status, failure.message),
          (newBookings) => _handleSuccess(status, List<PropertyEntity>.from(newBookings), isRefresh),
    );
  }

  void _updateStateBeforeRequest(String status, bool isRefresh) {
    if (!isRefresh) {
      emit(state.copyWith(isLoadingMore: true));
      return;
    }

    emit(state.copyWith(
      loadedStates: {...state.loadedStates, status: RequestState.loading},
      currentStatus: status,
    ));
  }

  void _handleFailure(String status, String errorMessage) {
    emit(state.copyWith(
      loadedStates: {...state.loadedStates, status: RequestState.error},
      errors: {...state.errors, status: errorMessage},
      isLoadingMore: false,
    ));
  }

  void _handleSuccess(String status, List<PropertyEntity> newBookings, bool isRefresh) {
    final hasReachedMax = newBookings.length < state.limit;
    final currentBookings = isRefresh ? <PropertyEntity>[] : [...state.getBookingsByStatus(status)];
    final updatedBookings = [...currentBookings, ...newBookings];
    final newOffset = isRefresh ? newBookings.length : state.getOffsetForStatus(status) + newBookings.length;

    emit(state.copyWith(
      bookings: {...state.bookings, status: updatedBookings},
      offsets: {...state.offsets, status: newOffset},
      hasMore: {...state.hasMore, status: !hasReachedMax},
      loadedStates: {...state.loadedStates, status: RequestState.loaded},
      isLoadingMore: false,
    ));
  }
}