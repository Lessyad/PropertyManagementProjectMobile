part of 'rental_history_cubit.dart';

class RentalHistoryState extends Equatable {
  final RequestState requestState;
  final String errorMessage;
  final List<RentalHistoryEntity> rentals;
  final int offset;
  final int limit;
  final bool hasMore;

  const RentalHistoryState({
    this.requestState = RequestState.initial,
    this.errorMessage = '',
    this.rentals = const [],
    this.offset = 0,
    this.limit = 10,
    this.hasMore = true,
  });

  RentalHistoryState copyWith({
    RequestState? requestState,
    String? errorMessage,
    List<RentalHistoryEntity>? rentals,
    int? offset,
    int? limit,
    bool? hasMore,
  }) {
    return RentalHistoryState(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      rentals: rentals ?? this.rentals,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        requestState,
        errorMessage,
        rentals,
        offset,
        limit,
        hasMore,
      ];
}
