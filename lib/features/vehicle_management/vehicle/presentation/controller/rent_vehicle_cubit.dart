import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/services/image_picker_service.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../data/models/create_vehicle_deal_dto.dart';
import '../../domain/use_cases/create_vehicle_deal_usecase.dart';

part 'rent_vehicle_state.dart';

class RentVehicleCubit extends Cubit<RentVehicleState> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController vehicleReceptionLatController = TextEditingController();
  final TextEditingController vehicleReceptionPlaceController = TextEditingController();
  final TextEditingController vehicleReturnLatController = TextEditingController();
  final TextEditingController vehicleReturnPlaceController = TextEditingController();

  // Use case pour créer le deal
  final CreateVehicleDealUseCase _createVehicleDealUseCase = CreateVehicleDealUseCase();

  RentVehicleCubit() : super(RentVehicleState()) {
    // Initialiser avec les données utilisateur existantes
    nameController.text = SharedPreferencesService().userName ?? '';
    phoneNumberController.text = SharedPreferencesService().userPhone ?? '';
    idNumberController.text = SharedPreferencesService().getValue('userIdNumber') ?? '';
    
    emit(state.copyWith(
      userName: SharedPreferencesService().userName ?? '',
      phoneNumber: SharedPreferencesService().userPhone ?? '',
      userID: SharedPreferencesService().getValue('userIdNumber') ?? '',
    ));
  }

  void setUserName(String value) {
    emit(state.copyWith(userName: value));
  }

  void setPhoneNumber(String value) {
    emit(state.copyWith(phoneNumber: value));
  }

  void setIDUserNumber(String value) {
    emit(state.copyWith(userID: value));
  }

  void setAge(String value) {
    emit(state.copyWith(age: value));
  }

  void setVehicleReceptionLat(String value) {
    print('🟢 setVehicleReceptionLat: $value');
    emit(state.copyWith(vehicleReceptionLat: value));
  }

  void setVehicleReceptionPlace(String value) {
    emit(state.copyWith(vehicleReceptionPlace: value));
  }

  void setVehicleReturnLat(String value) {
    print('🟢 setVehicleReturnLat: $value');
    emit(state.copyWith(vehicleReturnLat: value));
  }

  void setVehicleReturnPlace(String value) {
    emit(state.copyWith(vehicleReturnPlace: value));
  }

  void selectBirthDate(DateTime date) {
    emit(state.copyWith(birthDate: date));
  }

  void selectIDExpirationDate(DateTime date) {
    emit(state.copyWith(idExpirationDate: date));
  }

  void selectRentalDate(DateTime date) {
    emit(state.copyWith(rentalDate: date));
  }

  void selectReturnDate(DateTime date) {
    emit(state.copyWith(returnDate: date));
  }

  void setDrivingLicenseNumber(String value) {
    emit(state.copyWith(drivingLicenseNumber: value));
  }

  void selectDrivingLicenseExpiry(DateTime date) {
    emit(state.copyWith(drivingLicenseExpiry: date));
  }

  // void setVehicleReceptionLat(double value) {
  //   emit(state.copyWith(vehicleReceptionLat: value.toString()));
  // }

  void setVehicleReceptionLng(double value) {
    print('🟢 setVehicleReceptionLng: $value');
    emit(state.copyWith(vehicleReceptionLng: value.toString()));
  }

  // void setVehicleReturnLat(double value) {
  //   emit(state.copyWith(vehicleReturnLat: value.toString()));
  // }

  void setVehicleReturnLng(double value) {
    print('🟢 setVehicleReturnLng: $value');
    emit(state.copyWith(vehicleReturnLng: value.toString()));
  }

  Future<void> selectIDImage() async {
    emit(state.copyWith(selectIDImageState: RequestState.loading));

    final ImagePickerHelper imagePickerHelper = ImagePickerHelper();
    final result = await imagePickerHelper.pickImages(maxImages: 1);

    result.fold(
      (failure) {
        emit(state.copyWith(selectIDImageState: RequestState.loaded));
      },
      (xFiles) async {
        if (xFiles.isEmpty) {
          emit(state.copyWith(
            selectIDImageState: RequestState.loaded,
            validateIDImage: false,
          ));
          return;
        }

        final processedFiles = await imagePickerHelper.processImagesWithResiliency(xFiles);
        emit(state.copyWith(
          selectIDImageState: RequestState.loaded,
          validateIDImage: true,
          idImage: processedFiles.isNotEmpty ? processedFiles.first : null,
        ));
      },
    );
  }

  Future<void> selectDriveLicenseImage() async {
    emit(state.copyWith(selectDriveLicenseImageState: RequestState.loading));

    final ImagePickerHelper imagePickerHelper = ImagePickerHelper();
    final result = await imagePickerHelper.pickImages(maxImages: 1);

    result.fold(
      (failure) {
        emit(state.copyWith(selectDriveLicenseImageState: RequestState.loaded));
      },
      (xFiles) async {
        if (xFiles.isEmpty) {
          emit(state.copyWith(
            selectDriveLicenseImageState: RequestState.loaded,
            validateDriveLicenseImage: false,
          ));
          return;
        }

        final processedFiles = await imagePickerHelper.processImagesWithResiliency(xFiles);
        emit(state.copyWith(
          selectDriveLicenseImageState: RequestState.loaded,
          validateDriveLicenseImage: true,
          driveLicenseImage: processedFiles.isNotEmpty ? processedFiles.first : null,
        ));
      },
    );
  }

  void removeIDImage() {
    emit(state.copyWith(
      idImage: null,
      validateIDImage: false,
    ));
  }

  void removeDriveLicenseImage() {
    emit(state.copyWith(
      driveLicenseImage: null,
      validateDriveLicenseImage: false,
    ));
  }

  bool validateIDImage() {
    final isValid = state.idImage != null;
    emit(state.copyWith(validateIDImage: isValid));
    return isValid;
  }

  bool validateDriveLicenseImage() {
    final isValid = state.driveLicenseImage != null;
    emit(state.copyWith(validateDriveLicenseImage: isValid));
    return isValid;
  }

  void confirmPayment({
    required String vehicleId,
    required String paymentMethod,
    required double totalAmount,
    String? passCode,
  }) async {
    print('🎯 confirmPayment CALLED with vehicleId: $vehicleId');
    if (state.idImage == null) {
      throw Exception('ID image is required');
    }
    emit(state.copyWith(paymentState: RequestState.loading));


    try {
      print('📦 Creating DTO...');
      // VÉRIFIEZ que les données sont présentes
      print('User Name: ${state.userName}');
      print('Phone: ${state.phoneNumber}');
      print('User ID: ${state.userID}');
      print('ID Image: ${state.idImage?.path}');
      print('Drive License Image: ${state.driveLicenseImage?.path}');
      print('Driving License Number: ${state.drivingLicenseNumber}');
      print('Driving License Expiry: ${state.drivingLicenseExpiry}');
      print('Driver lat : ${state.vehicleReturnLat}');
      print('Driver Long: ${state.vehicleReturnLng}');
      print('Driver recpetion lat ${state.vehicleReceptionLat}');
      print('Driver recpetion lng : ${state.vehicleReceptionLng}');


      if (state.idImage == null) {
        print('❌ ID Image is NULL!');
        emit(state.copyWith(paymentState: RequestState.error));
        return;
      }

      if (state.driveLicenseImage == null) {
        print('❌ Drive License Image is NULL!');
        emit(state.copyWith(paymentState: RequestState.error));
        return;
      }
      // Créer le DTO pour l'API
      final CreateVehicleDealDto dto = CreateVehicleDealDto(
        vehicleId: vehicleId,
        isUser: true, // L'utilisateur est connecté
        name: state.userName,
        phoneNumber: state.phoneNumber,
        nni: state.userID,
        birthDate: state.birthDate?.toIso8601String() ?? '',
        idCardExpiryDate: state.idExpirationDate?.toIso8601String() ?? '',
        paymentMethod: paymentMethod,
        passCode: passCode,
        idCardImage: state.idImage?.path ?? '',
        driveLicenseImage: state.driveLicenseImage?.path ?? '',
        numberOfRentalDays: _calculateRentalDays(),
        drivingLicenseNumber: state.drivingLicenseNumber,
        drivingLicenseExpiry: state.drivingLicenseExpiry?.toIso8601String() ?? '',
        vehicleReceptionPlace: state.vehicleReceptionPlace,
        vehicleReturnPlace: state.vehicleReturnPlace,
        vehicleReceptionLat: double.tryParse(state.vehicleReceptionLat), // ← AJOUTEZ
        vehicleReceptionLng: double.tryParse(state.vehicleReceptionLng), // ← AJOUTEZ
        vehicleReturnLat: double.tryParse(state.vehicleReturnLat),       // ← AJOUTEZ
        vehicleReturnLng: double.tryParse(state.vehicleReturnLng),
        totalAmount: totalAmount,
      );

      // Appeler l'API pour créer le deal
      final result = await _createVehicleDealUseCase.execute(dto);

      emit(state.copyWith(paymentState: RequestState.loaded));

      // TODO: Naviguer vers l'écran de succès ou retourner au menu principal
      // Le résultat de l'API est disponible dans 'result'

    } catch (e) {
      emit(state.copyWith(paymentState: RequestState.error));
      // TODO: Gérer l'erreur et afficher un message à l'utilisateur
    }
  }

  // Méthode utilitaire pour calculer le nombre de jours de location
  int _calculateRentalDays() {
    if (state.rentalDate != null && state.returnDate != null) {
      return state.returnDate!.difference(state.rentalDate!).inDays;
    }
    return 1; // Valeur par défaut
  }

  @override
  Future<void> close() {
    phoneNumberController.dispose();
    nameController.dispose();
    idNumberController.dispose();
    ageController.dispose();
    vehicleReceptionLatController.dispose();
    vehicleReceptionPlaceController.dispose();
    vehicleReturnLatController.dispose();
    vehicleReturnPlaceController.dispose();
    return super.close();
  }
}
