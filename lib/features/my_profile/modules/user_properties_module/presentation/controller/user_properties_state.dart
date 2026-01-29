part of 'user_properties_cubit.dart';




class UserPropertiesState extends Equatable {
  const UserPropertiesState({
    this.limit = 10,
    this.properties = const {},
    this.offsets = const {},
    this.hasMore = const {},
    this.loadedStates = const {},
    this.errors = const {},
    this.currentStatus = 'pending',
    this.isLoadingMore = false,
  });

  final int limit;
  final Map<String, List<PropertyEntity>> properties;
  final Map<String, int> offsets;
  final Map<String, bool> hasMore;
  final Map<String, RequestState> loadedStates;
  final Map<String, String> errors;
  final String currentStatus;
  final bool isLoadingMore;

  List<PropertyEntity> getPropertiesByStatus(String status) => properties[status] ?? [];
  int getOffsetForStatus(String status) => offsets[status] ?? 0;
  bool hasMoreProperties(String status) => hasMore[status] ?? false;
  RequestState getStateByStatus(String status) => loadedStates[status] ?? RequestState.initial;
  String getErrorByStatus(String status) => errors[status] ?? '';

  UserPropertiesState copyWith({
    int? limit,
    Map<String, List<PropertyEntity>>? properties,
    Map<String, int>? offsets,
    Map<String, bool>? hasMore,
    Map<String, RequestState>? loadedStates,
    Map<String, String>? errors,
    String? currentStatus,
    bool? isLoadingMore,
  }) {
    return UserPropertiesState(
      limit: limit ?? this.limit,
      properties: properties ?? this.properties,
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
    properties,
    offsets,
    hasMore,
    loadedStates,
    errors,
    currentStatus,
    isLoadingMore,
  ];
}
