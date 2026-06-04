import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/enums.dart';
import '../../domain/entity/rental_history_entity.dart';
import '../../domain/use_cases/cancel_rental_use_case.dart';
import '../../domain/use_cases/get_rental_history_use_case.dart';

part 'rental_history_state.dart';

class RentalHistoryCubit extends Cubit<RentalHistoryState> {
  RentalHistoryCubit(
    this._getRentalHistoryUseCase,
    this._cancelRentalUseCase,
  ) : super(const RentalHistoryState());

  final GetRentalHistoryUseCase _getRentalHistoryUseCase;
  final CancelRentalUseCase _cancelRentalUseCase;

  Future<void> getRentalHistory({bool refresh = false}) async {
    if (refresh) {
      emit(state.copyWith(
        requestState: RequestState.loading,
        pageNumber: 1,
        hasMore: true,
        rentals: [],
      ));
    } else {
      if (state.requestState == RequestState.loading || !state.hasMore) {
        return;
      }
      emit(state.copyWith(requestState: RequestState.loading));
    }

    final int currentPage = refresh ? 1 : state.pageNumber;

    final result = await _getRentalHistoryUseCase({
      'pageNumber': currentPage,
      'pageSize': state.pageSize,
    });

    result.fold(
      (failure) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: failure.message,
      )),
      (rentals) {
        final loadedRentals = List<RentalHistoryEntity>.from(rentals);
        final updatedRentals = refresh
            ? loadedRentals
            : List<RentalHistoryEntity>.from([
                ...state.rentals,
                ...loadedRentals,
              ]);

        emit(state.copyWith(
          requestState: RequestState.loaded,
          rentals: updatedRentals,
          pageNumber: currentPage + 1,
          hasMore: rentals.length >= state.pageSize,
        ));
      },
    );
  }

  void loadMore() {
    getRentalHistory();
  }

  Future<void> cancelRental(int rentalId) async {
    emit(state.copyWith(cancelState: CancelState.loading, cancelError: ''));

    final result = await _cancelRentalUseCase(rentalId);

    result.fold(
      (failure) => emit(state.copyWith(
        cancelState: CancelState.error,
        cancelError: failure.message,
      )),
      (_) {
        final updated = state.rentals.map<RentalHistoryEntity>((r) {
          if (r.id == rentalId) {
            return RentalHistoryEntity(
              id: r.id,
              propertyId: r.propertyId,
              propertyTitle: r.propertyTitle,
              propertyType: r.propertyType,
              propertyCity: r.propertyCity,
              propertyState: r.propertyState,
              propertyCountry: r.propertyCountry,
              propertyImage: r.propertyImage,
              propertyArea: r.propertyArea,
              userRole: r.userRole,
              contractUrl: r.contractUrl,
              created: r.created,
              startDate: r.startDate,
              endDate: r.endDate,
              dealStatus: 'Cancelled',
              orderStatus: 'cancelled',
              operation: r.operation,
              totalAmount: r.totalAmount,
              paidAmount: r.paidAmount,
              ownerPortion: r.ownerPortion,
              paymentMethod: r.paymentMethod,
              clientName: r.clientName,
              clientPhoneNumber: r.clientPhoneNumber,
            );
          }
          return r;
        }).toList();

        emit(state.copyWith(
          cancelState: CancelState.success,
          rentals: updated,
        ));
      },
    );
  }

  void resetCancelState() {
    emit(state.copyWith(cancelState: CancelState.idle, cancelError: ''));
  }
}
