import 'package:bloc/bloc.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/use_cases/get_user_data_use_case.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/use_cases/update_user_data_use_case.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/constants/local_keys.dart';
import '../../../../../../core/services/select_location_service/domain/entities/city_entity.dart';
import '../../../../../../core/services/select_location_service/domain/entities/country_entity.dart';
import '../../../../../../core/services/select_location_service/domain/entities/state_entity.dart';
import '../../domain/entity/user_data_entity.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit(this._getUserDataUseCase, this._updateUserDataUseCase)
      : super(UserDataState());

  final GetUserDataUseCase _getUserDataUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;

  void getRemoteUserData() async {
    emit(state.copyWith(getUserDataState: RequestState.loading));
    final result = await _getUserDataUseCase();
    result.fold(
          (error) {
        emit(state.copyWith(
          getUserDataState: RequestState.error,
          getUserDataErrorMessage: error.toString(),
        ));
      },
          (userDataEntity) {
        _saveUserData(userDataEntity);
        emit(state.copyWith(
          getUserDataState: RequestState.loaded,
          userDataEntity: userDataEntity,
        ));
      },
    );
  }

  void _saveUserData(UserDataEntity userDataEntity) {
    final sharedPrefs = SharedPreferencesService();

    if (userDataEntity.city != null) {
      sharedPrefs.storeValue(LocalKeys.userCity, userDataEntity.city!.name);
      sharedPrefs.storeValue(
          LocalKeys.userCityID, userDataEntity.city!.id.toString());
    }
    if (userDataEntity.state != null) {
      sharedPrefs.storeValue(LocalKeys.userState, userDataEntity.state!.name);
      sharedPrefs.storeValue(
          LocalKeys.userStateID, userDataEntity.state!.id.toString());
    }
    sharedPrefs.storeValue(LocalKeys.userName, userDataEntity.userName);
    sharedPrefs.storeValue(LocalKeys.userPhone, userDataEntity.phoneNumber);
    sharedPrefs.storeValue(
        LocalKeys.userNotificationEnabled, userDataEntity.notificationEnabled);
    sharedPrefs.storeValue(
        LocalKeys.userAvailableBalance, userDataEntity.availableBalance);
    sharedPrefs.storeValue(
        LocalKeys.userFrozenBalance, userDataEntity.frozenBalance);

    if (userDataEntity.idNumber != null) {
      sharedPrefs.storeValue(LocalKeys.userIdNumber, userDataEntity.idNumber!);
    }
    if (userDataEntity.dateOfBirth != null) {
      sharedPrefs.storeValue(
          LocalKeys.userDateOfBirth, userDataEntity.dateOfBirth!);
    }
    if (userDataEntity.idExpirationDate != null) {
      sharedPrefs.storeValue(
          LocalKeys.userIdExpirationDate, userDataEntity.idExpirationDate!);
    }

    emit(state.copyWith(userDataEntity: userDataEntity));
  }

  void getLocalUserData() async {
    emit(state.copyWith(getUserDataState: RequestState.loading));
    final sharedPrefs = SharedPreferencesService();

    final userDataEntity = UserDataEntity(
      phoneNumber: sharedPrefs.getValue(LocalKeys.userPhone),
      userName: sharedPrefs.getValue(LocalKeys.userName),
      city: sharedPrefs.getValue(LocalKeys.userCity) != null
          ? CityEntity(
        id: sharedPrefs.getValue(LocalKeys.userCityID).toString(),
        name: sharedPrefs.getValue(LocalKeys.userCity),
      )
          : null,
      state: sharedPrefs.getValue(LocalKeys.userState) != null
          ? StateEntity(
        id: sharedPrefs.getValue(LocalKeys.userStateID).toString(),
        name: sharedPrefs.getValue(LocalKeys.userState),
      )
          : null,
      country: sharedPrefs.getValue(LocalKeys.userCountry) != null
          ? CountryEntity(
        id: sharedPrefs.getValue(LocalKeys.userCountryID).toString(),
        name: sharedPrefs.getValue(LocalKeys.userCountry),
      )
          : null,
      notificationEnabled: sharedPrefs.getValue(
          LocalKeys.userNotificationEnabled,
          defaultValue: false),
      availableBalance: sharedPrefs.getValue(LocalKeys.userAvailableBalance,
          defaultValue: '0.00'),
      frozenBalance: sharedPrefs.getValue(LocalKeys.userFrozenBalance,
          defaultValue: '0.00'),
      idNumber: sharedPrefs.getValue(LocalKeys.userIdNumber),
      dateOfBirth: sharedPrefs.getValue(LocalKeys.userDateOfBirth),
      idExpirationDate: sharedPrefs.getValue(LocalKeys.userIdExpirationDate),
    );

    emit(state.copyWith(
      getUserDataState: RequestState.loaded,
      userDataEntity: userDataEntity,
    ));
  }

  void updateUserData(Map<String, dynamic> updatedData) async {
    final Map<String, dynamic> patchData = getUpdatedData(updatedData);

    emit(state.copyWith(updateUserDataState: RequestState.loading));
    if(patchData.isEmpty){
      CustomSnackBar.show(message: 'No data to update' , type: SnackBarType.success );
      emit(state.copyWith(updateUserDataState: RequestState.loaded));
      return;
    }

    final result = await _updateUserDataUseCase(patchData);
    result.fold(
          (error) {
        emit(state.copyWith(
          updateUserDataState: RequestState.error,
          updateUserDataErrorMessage: error.toString(),
        ));
      },
          (_) {
        final updatedUserDataEntity = state.userDataEntity?.copyWith(
          userName: updatedData['full_name'] ?? state.userDataEntity?.userName,
          phoneNumber:
          updatedData['phone_number'] ?? state.userDataEntity?.phoneNumber,
          idNumber: updatedData['id_number'] ?? state.userDataEntity?.idNumber,
          dateOfBirth:
          updatedData['date_of_birth'] ?? state.userDataEntity?.dateOfBirth,
          idExpirationDate: updatedData['id_expiry_date'] ??
              state.userDataEntity?.idExpirationDate,
        );

        if (updatedUserDataEntity != null) {
          _saveUserData(updatedUserDataEntity);
        }

        emit(state.copyWith(
          updateUserDataState: RequestState.loaded,
          userDataEntity: updatedUserDataEntity,
        ));
      },
    );
  }

  Map<String, dynamic> getUpdatedData(Map<String, dynamic> updatedData) {
    final Map<String, dynamic> patchData = {};

    if (updatedData['full_name'] != state.userDataEntity?.userName) {
      patchData['full_name'] = updatedData['full_name'];
    }
    if (updatedData['phone_number'] != state.userDataEntity?.phoneNumber) {
      patchData['phone_number'] = updatedData['phone_number'];
    }
    if (updatedData['id_number'] != state.userDataEntity?.idNumber) {
      patchData['id_number'] = updatedData['id_number'];
    }
    if (updatedData['date_of_birth'] != state.userDataEntity?.dateOfBirth) {
      patchData['date_of_birth'] = updatedData['date_of_birth'];
    }
    if (updatedData['id_expiry_date'] != state.userDataEntity?.idExpirationDate) {
      patchData['id_expiry_date'] = updatedData['id_expiry_date'];
    }

    return patchData;
  }
}