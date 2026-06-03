import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/enums.dart';
import '../../domain/entity/rental_history_entity.dart';
import '../../domain/use_cases/get_rental_history_use_case.dart';

part 'rental_history_state.dart';

class RentalHistoryCubit extends Cubit<RentalHistoryState> {
  RentalHistoryCubit(this._getRentalHistoryUseCase)
      : super(const RentalHistoryState());

  final GetRentalHistoryUseCase _getRentalHistoryUseCase;

  Future<void> getRentalHistory({bool refresh = false}) async {
    if (refresh) {
      emit(state.copyWith(
        requestState: RequestState.loading,
        offset: 0,
        hasMore: true,
      ));
    } else {
      if (state.requestState == RequestState.loading || !state.hasMore) {
        return;
      }
      emit(state.copyWith(requestState: RequestState.loading));
    }

    final result = await _getRentalHistoryUseCase({
      'offset': refresh ? 0 : state.offset,
      'limit': state.limit,
    });

    result.fold(
      (failure) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: failure.message,
      )),
      (rentals) {
        final updatedRentals =
            refresh ? rentals : [...state.rentals, ...rentals];

        emit(state.copyWith(
          requestState: RequestState.loaded,
          rentals: updatedRentals,
          offset: (refresh ? 0 : state.offset) + rentals.length,
          hasMore: rentals.length >= state.limit,
        ));
      },
    );
  }

  void loadMore() {
    getRentalHistory();
  }
}
