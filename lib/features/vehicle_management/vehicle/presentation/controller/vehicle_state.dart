import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/vehicle_entity.dart';


class VehicleState extends Equatable {
  final List<VehicleEntity> vehicles;
  final RequestState getVehiclesState;
  final String getVehiclesMessage;
  final bool hasReachedMax;
  final int pageNumber;

  const VehicleState({
    this.vehicles = const [],
    this.getVehiclesState = RequestState.loading,
    this.getVehiclesMessage = '',
    this.hasReachedMax = false,
    this.pageNumber = 1,
  });

  VehicleState copyWith({
    List<VehicleEntity>? vehicles,
    RequestState? getVehiclesState,
    String? getVehiclesMessage,
    bool? hasReachedMax,
    int? pageNumber,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      getVehiclesState: getVehiclesState ?? this.getVehiclesState,
      getVehiclesMessage: getVehiclesMessage ?? this.getVehiclesMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [
    vehicles,
    getVehiclesState,
    getVehiclesMessage,
    hasReachedMax,
    pageNumber,
  ];
}