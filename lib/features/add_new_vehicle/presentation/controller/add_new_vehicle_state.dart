part of 'add_new_vehicle_cubit.dart';

class AddNewVehicleState {
  final bool isSubmitting;
  final bool success;
  final String? error;

  AddNewVehicleState({
    required this.isSubmitting,
    required this.success,
    this.error,
  });

  factory AddNewVehicleState.initial() => AddNewVehicleState(
        isSubmitting: false,
        success: false,
      );

  AddNewVehicleState copyWith({
    bool? isSubmitting,
    bool? success,
    String? error,
  }) {
    return AddNewVehicleState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      error: error,
    );
  }
}


