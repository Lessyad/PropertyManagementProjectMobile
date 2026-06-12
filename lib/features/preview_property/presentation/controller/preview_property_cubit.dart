import 'package:bloc/bloc.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/preview_property/data/models/add_new_preview_time_request_model.dart';
import 'package:enmaa/features/preview_property/domain/entities/day_and_hours_entity.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/add_new_preview_time_use_case.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/get_inspection_amount_to_be_paid_use_case.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/initiate_paypal_viewing_request_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:enmaa/core/services/paypal_payment_service.dart';
import '../../domain/use_cases/get_available_hours_for_specific_property_use_case.dart';

part 'preview_property_state.dart';

class PreviewPropertyCubit extends Cubit<PreviewPropertyState> {
  PreviewPropertyCubit(
    this._availableHoursForSpecificPropertyUseCase,
    this._addNewPreviewTimeUseCase,
    this._getInspectionAmountToBePaidUseCase,
    this._initiatePayPalViewingRequestUseCase,
  ) : super(PreviewPropertyState());

  final GetAvailableHoursForSpecificPropertyUseCase _availableHoursForSpecificPropertyUseCase;
  final GetInspectionAmountToBePaidUseCase _getInspectionAmountToBePaidUseCase;
  final AddNewPreviewTimeUseCase _addNewPreviewTimeUseCase;
  final InitiatePayPalViewingRequestUseCase _initiatePayPalViewingRequestUseCase;

  void changePreviewDateVisibility() {
    emit(state.copyWith(showPreviewDate: !state.showPreviewDate));
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void changePaymentMethod(String method) {
    emit(state.copyWith(currentPaymentMethod: method));
  }

  void setBankilyPassCode(String code) {
    emit(state.copyWith(bankilyPassCode: code));
  }

  void setClientBankilyPhoneNumber(String value) {
    emit(state.copyWith(clientBankilyPhoneNumber: value));
  }

  void selectDate(DateTime? date) {
    final String selectedDay = formatDate(date!);
    List<String> availableHours = [];

    for (var data in state.availableHours) {
      if (data.currentDay == selectedDay) {
        availableHours = data.hours;
        break;
      }
    }

    emit(state.copyWith(
      selectedDate: date,
      currentAvailableHours: availableHours,
      selectedTime: null,
    ));
  }

  void selectTime(String? time) {
    if (state.selectedTime == time) {
      emit(state.copyWith(makeSelectedTimeNull: true));
    } else {
      emit(state.copyWith(selectedTime: time));
    }
  }

  void getAvailableHoursForSpecificProperty(String propertyId) async {
    emit(state.copyWith(getAvailableHoursState: RequestState.loading));
    final result = await _availableHoursForSpecificPropertyUseCase(propertyId);
    result.fold(
      (failure) => emit(state.copyWith(
          getAvailableHoursState: RequestState.error,
          getAvailableHoursErrorMessage: failure.message)),
      (hours) => emit(state.copyWith(
          getAvailableHoursState: RequestState.loaded, availableHours: hours)),
    );
  }

  void getInspectionAmountToBePaid(String propertyId) async {
    emit(state.copyWith(getInspectionAmountState: RequestState.loading));
    final result = await _getInspectionAmountToBePaidUseCase(propertyId);
    result.fold(
      (failure) => emit(state.copyWith(
          getInspectionAmountState: RequestState.error,
          getInspectionAmountErrorMessage: failure.message)),
      (amount) => emit(state.copyWith(
          getInspectionAmountState: RequestState.loaded,
          inspectionAmount: amount)),
    );
  }

  Future<void> addPreviewTimeForSpecificProperty(AddNewPreviewRequestModel data) async {
    emit(state.copyWith(addNewPreviewTimeState: RequestState.loading));

    if (data.paymentMethod?.toLowerCase() == 'paypal') {
      // PayPal-first : initier le paiement AVANT de créer la viewing request
      final result = await _initiatePayPalViewingRequestUseCase(data);
      result.fold(
        (failure) => emit(state.copyWith(
            addNewPreviewTimeState: RequestState.error,
            addNewPreviewTimeErrorMessage: failure.message)),
        (paypalData) async {
          emit(state.copyWith(addNewPreviewTimeState: RequestState.paypalPending));
          await PayPalPaymentService.openPayPalInBrowser(paypalData.approvalUrl);
        },
      );
    } else {
      // Paiement non-PayPal : créer directement la viewing request
      final result = await _addNewPreviewTimeUseCase(data);
      result.fold(
        (failure) => emit(state.copyWith(
            addNewPreviewTimeState: RequestState.error,
            addNewPreviewTimeErrorMessage: failure.message)),
        (_) => emit(state.copyWith(addNewPreviewTimeState: RequestState.loaded)),
      );
    }
  }
}
