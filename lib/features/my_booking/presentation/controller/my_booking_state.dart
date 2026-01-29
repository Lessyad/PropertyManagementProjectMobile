part of 'my_booking_cubit.dart';

class MyBookingState extends Equatable {
  const MyBookingState({
    this.limit = 10,
    this.bookings = const {},
    this.offsets = const {},
    this.hasMore = const {},
    this.loadedStates = const {},
    this.errors = const {},
    this.currentStatus = 'pending',
    this.isLoadingMore = false,
  });

  final int limit;
  final Map<String, List<PropertyEntity>> bookings;
  final Map<String, int> offsets;
  final Map<String, bool> hasMore;
  final Map<String, RequestState> loadedStates;
  final Map<String, String> errors;
  final String currentStatus;
  final bool isLoadingMore;

  List<PropertyEntity> getBookingsByStatus(String status) => bookings[status] ?? [];
  int getOffsetForStatus(String status) => offsets[status] ?? 0;
  bool hasMoreBookings(String status) => hasMore[status] ?? false;
  RequestState getStateByStatus(String status) => loadedStates[status] ?? RequestState.initial;
  String getErrorByStatus(String status) => errors[status] ?? '';

  MyBookingState copyWith({
    int? limit,
    Map<String, List<PropertyEntity>>? bookings,
    Map<String, int>? offsets,
    Map<String, bool>? hasMore,
    Map<String, RequestState>? loadedStates,
    Map<String, String>? errors,
    String? currentStatus,
    bool? isLoadingMore,
  }) {
    return MyBookingState(
      limit: limit ?? this.limit,
      bookings: bookings ?? this.bookings,
      offsets: offsets ?? this.offsets,
      hasMore: hasMore ?? this.hasMore,
      loadedStates: loadedStates ?? this.loadedStates,
      errors: errors ?? this.errors,
      currentStatus: currentStatus ?? this.currentStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    limit,
    bookings,
    offsets,
    hasMore,
    loadedStates,
    errors,
    currentStatus,
    isLoadingMore,
  ];
}