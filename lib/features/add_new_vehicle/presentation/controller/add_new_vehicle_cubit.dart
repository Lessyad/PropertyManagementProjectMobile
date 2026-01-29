import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle_request_models.dart';
import '../../domain/use_cases/use_cases.dart';

part 'add_new_vehicle_state.dart';

class AddNewVehicleCubit extends Cubit<AddNewVehicleState> {
  final CreateVehicleUseCase createVehicle;
  final UpdateVehicleUseCase updateVehicle;
  final DeleteVehicleUseCase deleteVehicle;

  AddNewVehicleCubit({
    required this.createVehicle,
    required this.updateVehicle,
    required this.deleteVehicle,
  }) : super(AddNewVehicleState.initial());

  Future<void> submitCreate(CreateVehicleRequestModel body) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await createVehicle(body);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  Future<void> submitUpdate(int id, UpdateVehicleRequestModel body) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await updateVehicle(id, body);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  Future<void> submitDelete(int id) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await deleteVehicle(id);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}

// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../core/errors/failure.dart';
// import '../../../../core/services/image_picker_service.dart';
// import '../../../../core/utils/enums.dart';
//
// class AddNewVehicleCubit extends Cubit<AddNewVehicleState> {
//   final AddNewVehicleUseCase _addNewVehicleUseCase;
//   final UpdateVehicleUseCase _updateVehicleUseCase;
//   final ImagePickerHelper _imagePickerHelper;
//
//   AddNewVehicleCubit(
//       this._addNewVehicleUseCase,
//       this._updateVehicleUseCase,
//       this._imagePickerHelper,
//       ) : super(const AddNewVehicleState());
//
//   // Méthodes pour mettre à jour l'état
//   void updateLicensePlate(String licensePlate) {
//     emit(state.copyWith(licensePlate: licensePlate));
//   }
//
//   void updateColor(String color) {
//     emit(state.copyWith(color: color));
//   }
//
//   void updateDailyPrice(double dailyPrice) {
//     emit(state.copyWith(dailyPrice: dailyPrice));
//   }
//
//   // ... autres méthodes update
//
//   Future<void> selectImages() async {
//     emit(state.copyWith(addVehicleState: RequestState.loading));
//
//     final result = await _imagePickerHelper.pickImages(maxImages: 5);
//
//     result.fold(
//           (failure) => emit(state.copyWith(
//         addVehicleState: RequestState.error,
//         errorMessage: failure.message,
//       )),
//           (images) => emit(state.copyWith(
//         selectedImages: [...state.selectedImages, ...images],
//         addVehicleState: RequestState.loaded,
//       )),
//     );
//   }
//
//   Future<void> addNewVehicle() async {
//     emit(state.copyWith(addVehicleState: RequestState.loading));
//
//     final requestModel = CreateVehicleRequestModel(
//       vehicleModelId: state.selectedModel!.id,
//       licensePlate: state.licensePlate,
//       color: state.color,
//       dailyPrice: state.dailyPrice,
//       weeklyPrice: state.weeklyPrice,
//       mileage: state.mileage,
//       fuelType: state.fuelType,
//       transmission: state.transmission,
//       hasAirConditioning: state.hasAirConditioning,
//       seats: state.seats,
//       vin: state.vin,
//       images: state.selectedImages.map((file) => PropertyImage(
//         filePath: file.path,
//         isMain: false,
//       )).toList(),
//       latitude: state.latitude,
//       longitude: state.longitude,
//     );
//
//     final result = await _addNewVehicleUseCase(requestModel);
//
//     result.fold(
//           (failure) => emit(state.copyWith(
//         addVehicleState: RequestState.error,
//         errorMessage: failure.message,
//       )),
//           (_) => emit(state.copyWith(addVehicleState: RequestState.loaded)),
//     );
//   }
//
//   Future<void> updateVehicle(int vehicleId) async {
//     emit(state.copyWith(updateVehicleState: RequestState.loading));
//
//     final requestModel = UpdateVehicleRequestModel(
//       licensePlate: state.licensePlate,
//       color: state.color,
//       dailyPrice: state.dailyPrice,
//       weeklyPrice: state.weeklyPrice,
//       hasAirConditioning: state.hasAirConditioning,
//       images: state.selectedImages.map((file) => PropertyImage(
//         filePath: file.path,
//         isMain: false,
//       )).toList(),
//       latitude: state.latitude,
//       longitude: state.longitude,
//     );
//
//     final result = await _updateVehicleUseCase(vehicleId, requestModel);
//
//     result.fold(
//           (failure) => emit(state.copyWith(
//         updateVehicleState: RequestState.error,
//         errorMessage: failure.message,
//       )),
//           (_) => emit(state.copyWith(updateVehicleState: RequestState.loaded)),
//     );
//   }
// }