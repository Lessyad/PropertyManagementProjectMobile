part of 'rental_history_cubit.dart';

enum CancelState { idle, loading, success, error }

class RentalHistoryState extends Equatable {
  final RequestState requestState;
  final String errorMessage;
  final List<RentalHistoryEntity> rentals;
  final int pageNumber;
  final int pageSize;
  final bool hasMore;
  final CancelState cancelState;
  final String cancelError;

  const RentalHistoryState({
    this.requestState = RequestState.initial,
    this.errorMessage = '',
    this.rentals = const [],
    this.pageNumber = 1,
    this.pageSize = 10,
    this.hasMore = true,
    this.cancelState = CancelState.idle,
    this.cancelError = '',
  });

  RentalHistoryState copyWith({
    RequestState? requestState,
    String? errorMessage,
    List<RentalHistoryEntity>? rentals,
    int? pageNumber,
    int? pageSize,
    bool? hasMore,
    CancelState? cancelState,
    String? cancelError,
  }) {
    return RentalHistoryState(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      rentals: rentals ?? this.rentals,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      cancelState: cancelState ?? this.cancelState,
      cancelError: cancelError ?? this.cancelError,
    );
  }

  @override
  List<Object?> get props => [
        requestState,
        errorMessage,
        rentals,
        pageNumber,
        pageSize,
        hasMore,
        cancelState,
        cancelError,
      ];
}
