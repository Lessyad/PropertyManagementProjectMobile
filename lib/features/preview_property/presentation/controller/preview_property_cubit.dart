import 'package:bloc/bloc.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/preview_property/data/models/add_new_preview_time_request_model.dart';
import 'package:enmaa/features/preview_property/domain/entities/day_and_hours_entity.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/add_new_preview_time_use_case.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/get_inspection_amount_to_be_paid_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:enmaa/core/services/paypal_payment_service.dart';
import '../../domain/use_cases/get_available_hours_for_specific_property_use_case.dart';

part 'preview_property_state.dart';

class PreviewPropertyCubit extends Cubit<PreviewPropertyState> {
  PreviewPropertyCubit(this._availableHoursForSpecificPropertyUseCase, this._addNewPreviewTimeUseCase,
      this._getInspectionAmountToBePaidUseCase)
      : super(PreviewPropertyState());

  final GetAvailableHoursForSpecificPropertyUseCase
      _availableHoursForSpecificPropertyUseCase;

  final GetInspectionAmountToBePaidUseCase _getInspectionAmountToBePaidUseCase;

  final AddNewPreviewTimeUseCase _addNewPreviewTimeUseCase;

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

  /// Traiter le paiement PayPal pour les viewing requests
  Future<void> processPayPalPayment({
    required String propertyId,
    required String authToken,
  }) async {
    try {
      emit(state.copyWith(addNewPreviewTimeState: RequestState.loading));

      // Générer un ID de commande unique
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Créer le paiement PayPal
      final paymentResponse = await PayPalPaymentService.createPayment(
        amount: double.parse(state.inspectionAmount),
        currency: 'USD', // ou 'EGP' selon votre configuration
        orderId: orderId,
        description: 'Viewing Request Payment - Property ID: $propertyId',
        returnUrl: 'https://inmaapi-gkgxdtc0c6ded3bk.spaincentral-01.azurewebsites.net/api/payments/paypal/success',
        cancelUrl: 'https://inmaapi-gkgxdtc0c6ded3bk.spaincentral-01.azurewebsites.net/api/payments/paypal/cancel',
        authToken: authToken,
      );

      if (paymentResponse.success && paymentResponse.approvalUrl != null) {
        // Ouvrir PayPal dans le navigateur
        final success = await PayPalPaymentService.openPayPalInBrowser(paymentResponse.approvalUrl!);
        
        if (success) {
          emit(state.copyWith(addNewPreviewTimeState: RequestState.loaded));
          // Ici vous pouvez ajouter une logique pour suivre le statut du paiement
          // ou rediriger vers une page de confirmation
        } else {
          emit(state.copyWith(
            addNewPreviewTimeState: RequestState.error,
            addNewPreviewTimeErrorMessage: 'Impossible d\'ouvrir PayPal',
          ));
        }
      } else {
        emit(state.copyWith(
          addNewPreviewTimeState: RequestState.error,
          addNewPreviewTimeErrorMessage: paymentResponse.errorMessage ?? 'Erreur lors de la création du paiement PayPal',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        addNewPreviewTimeState: RequestState.error,
        addNewPreviewTimeErrorMessage: 'Erreur PayPal: $e',
      ));
    }
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

  Future<void> addPreviewTimeForSpecificProperty(
      AddNewPreviewRequestModel data) async {
    emit(state.copyWith(addNewPreviewTimeState: RequestState.loading));

    final result = await _addNewPreviewTimeUseCase(data);
    result.fold(
      (failure) {
        emit(state.copyWith(
            addNewPreviewTimeState: RequestState.error,
            addNewPreviewTimeErrorMessage: failure.message));
      },
      (_) => emit(state.copyWith(addNewPreviewTimeState: RequestState.loaded)),
    );
  }
}
