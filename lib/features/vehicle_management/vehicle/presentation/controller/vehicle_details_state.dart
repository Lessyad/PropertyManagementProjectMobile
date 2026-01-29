import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/vehicle_details_entity.dart';

class VehicleDetailsState extends Equatable {
  final VehicleDetailsEntity? vehicleDetails;
  final RequestState getVehicleDetailsState;
  final String getVehicleDetailsMessage;

  const VehicleDetailsState({
    this.vehicleDetails,
    this.getVehicleDetailsState = RequestState.loading,
    this.getVehicleDetailsMessage = '',
  });

  VehicleDetailsState copyWith({
    VehicleDetailsEntity? vehicleDetails,
    RequestState? getVehicleDetailsState,
    String? getVehicleDetailsMessage,
  }) {
    return VehicleDetailsState(
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
      getVehicleDetailsState: getVehicleDetailsState ?? this.getVehicleDetailsState,
      getVehicleDetailsMessage: getVehicleDetailsMessage ?? this.getVehicleDetailsMessage,
    );
  }

  @override
  List<Object?> get props => [
    vehicleDetails,
    getVehicleDetailsState,
    getVehicleDetailsMessage,
  ];
}