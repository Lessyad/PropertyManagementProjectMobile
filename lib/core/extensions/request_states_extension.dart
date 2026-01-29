import '../utils/enums.dart';

extension RequestStateExtension on RequestState {
  bool get isInitial => this == RequestState.initial;

  bool get isLoading => this == RequestState.loading;

  bool get isLoaded => this == RequestState.loaded;

  bool get isError => this == RequestState.error;


}