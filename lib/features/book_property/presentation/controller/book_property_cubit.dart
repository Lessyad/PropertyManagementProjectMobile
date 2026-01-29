import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/constants/local_keys.dart';
import 'package:enmaa/core/extensions/buyer_type_extension.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/features/book_property/domain/entities/book_property_response_entity.dart';
import 'package:enmaa/features/book_property/domain/use_cases/get_property_sale_details_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:enmaa/core/services/paypal_payment_service.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../../../core/utils/enums.dart';
import '../../../home_module/home_imports.dart';
import '../../data/models/book_property_request_model.dart';
import '../../domain/entities/property_sale_details_entity.dart';
import '../../domain/use_cases/book_property_use_case.dart';

part 'book_property_state.dart';

class BookPropertyCubit extends Cubit<BookPropertyState> {

  final String currentCountryCode = SharedPreferencesService().getValue(LocalKeys.countryCodeNumber) ?? '+20' ;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController iDNumberController = TextEditingController();
  final TextEditingController bankilyPassCodeController = TextEditingController();

  // 🆕 Variables pour stocker les informations de la propriété
  final String? _propertyOperation;
  final String? _propertyMonthlyRentPeriod;

  BookPropertyCubit(
      this._getPropertySaleDetailsUseCase,
      this._bookPropertyUseCase,
      {
        String? operation, // 🆕 Paramètre optionnel
        String? monthlyRentPeriod, // 🆕 Paramètre optionnel
      }
  ) : _propertyOperation = operation,
      _propertyMonthlyRentPeriod = monthlyRentPeriod,
      super(BookPropertyState()){

    nameController.text = SharedPreferencesService().userName ;
    phoneNumberController.text = SharedPreferencesService().userPhone ;
    iDNumberController.text = SharedPreferencesService().getValue(LocalKeys.userIdNumber) ?? '';


    print('currentCountryCode: $currentCountryCode');
    emit(state.copyWith(
      userName: SharedPreferencesService().userName,
      phoneNumber: SharedPreferencesService().userPhone,
      userID: SharedPreferencesService().getValue(LocalKeys.userIdNumber) ?? '',
      birthDate: SharedPreferencesService().getValue(LocalKeys.userDateOfBirth) != null ? DateTime.parse(SharedPreferencesService().getValue(LocalKeys.userDateOfBirth)) : null,
      idExpirationDate: SharedPreferencesService().getValue(LocalKeys.userIdExpirationDate) != null ? DateTime.parse(SharedPreferencesService().getValue(LocalKeys.userIdExpirationDate)) : null,
      countryCode: currentCountryCode ,
    ));
  }


  Future<void> selectImage(int numberOfImages,  ) async {
    bool replace = state.selectedImages.isNotEmpty ;

    emit(state.copyWith(
      selectImagesState: RequestState.loading,
    ));

    final ImagePickerHelper imagePickerHelper = ImagePickerHelper();

    final result = await imagePickerHelper.pickImages(
      maxImages: numberOfImages,
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          selectImagesState: RequestState.loaded,
        ));
       },
          (xFiles) async {
        if (xFiles.isEmpty) {
          emit(state.copyWith(
            selectImagesState: RequestState.loaded,
            validateImages: true,
          ));
          return;
        }

        final processedFiles = await imagePickerHelper.processImagesWithResiliency(xFiles);

         final List<File> updatedImages = replace
            ? processedFiles
            : [...state.selectedImages, ...processedFiles];

        emit(state.copyWith(
          selectImagesState: RequestState.loaded,
          validateImages: true,
          selectedImages: updatedImages,
        ));
      },
    );
  }
  void removeImage(int index) {
    emit(state.copyWith(selectImagesState: RequestState.loading));

    final List<File> newImages = state.selectedImages;
    newImages.removeAt(index);
    emit(state.copyWith(selectedImages: newImages , selectImagesState: RequestState.loaded));
  }

  bool validateImages() {
    if(state.selectedImages.isEmpty) {
      emit(state.copyWith(validateImages: false));
    }
    else {
      emit(state.copyWith(validateImages: true));
    }

    return state.selectedImages.isNotEmpty;
  }


  void changeBuyerType(BuyerType buyerType) {
    emit(state.copyWith(buyerType: buyerType));
  }

  void setUserName(String userName) {
    emit(state.copyWith(userName: userName));
  }

  void setIDUserNumber(String userID) {
    emit(state.copyWith(userID: userID));
  }

  void setPhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void setCountryCode(String countryCode) {
    phoneNumberController.text = countryCode;
    emit(state.copyWith(countryCode: countryCode));
  }



  void changeBirthDatePickerVisibility() {
    emit(state.copyWith(showBirthDatePicker: !state.showBirthDatePicker, showIDExpirationDatePicker: false));
  }

  void selectBirthDate(DateTime date) {
    emit(state.copyWith(birthDate: date, showBirthDatePicker: false));
  }

   void changeIDExpirationDatePickerVisibility() {
    emit(state.copyWith(showIDExpirationDatePicker: !state.showIDExpirationDatePicker, showBirthDatePicker: false));
  }

  void selectIDExpirationDate(DateTime date) {
    emit(state.copyWith(idExpirationDate: date, showIDExpirationDatePicker: false));
  }

  void changePaymentMethod(String method) {
    emit(state.copyWith(currentPaymentMethod: method));
  }

  /// Traiter le paiement PayPal pour les propriétés
  Future<void> processPayPalPayment({
    required String propertyId,
    required String authToken,
  }) async {
    try {
      emit(state.copyWith(bookPropertyState: RequestState.loading));

      // Générer un ID de commande unique
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Créer le paiement PayPal
      final paymentResponse = await PayPalPaymentService.createPayment(
        amount: double.parse(state.propertySaleDetailsEntity!.bookingDeposit),
        currency: 'USD', // ou 'EGP' selon votre configuration
        orderId: orderId,
        description: 'Property Booking Payment - Property ID: $propertyId',
        returnUrl: 'https://inmaapi-gkgxdtc0c6ded3bk.spaincentral-01.azurewebsites.net/api/payments/paypal/success',
        cancelUrl: 'https://inmaapi-gkgxdtc0c6ded3bk.spaincentral-01.azurewebsites.net/api/payments/paypal/cancel',
        authToken: authToken,
      );

      if (paymentResponse.success && paymentResponse.approvalUrl != null) {
        // Ouvrir PayPal dans le navigateur
        final success = await PayPalPaymentService.openPayPalInBrowser(paymentResponse.approvalUrl!);
        
        if (success) {
          emit(state.copyWith(bookPropertyState: RequestState.loaded));
          // Ici vous pouvez ajouter une logique pour suivre le statut du paiement
          // ou rediriger vers une page de confirmation
        } else {
          emit(state.copyWith(
            bookPropertyState: RequestState.error,
            bookPropertyError: 'Impossible d\'ouvrir PayPal',
          ));
        }
      } else {
        emit(state.copyWith(
          bookPropertyState: RequestState.error,
          bookPropertyError: paymentResponse.errorMessage ?? 'Erreur lors de la création du paiement PayPal',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        bookPropertyState: RequestState.error,
        bookPropertyError: 'Erreur PayPal: $e',
      ));
    }
  }

  void setBankilyPassCode(String code) {
    emit(state.copyWith(bankilyPassCode: code));
  }





  final GetPropertySaleDetailsUseCase _getPropertySaleDetailsUseCase ;
  final BookPropertyUseCase _bookPropertyUseCase ;
  void getPropertySaleDetails(String propertyID){

    emit(state.copyWith(getPropertySaleDetailsState: RequestState.loading));
    _getPropertySaleDetailsUseCase.call(propertyID).then((result) {
      result.fold(
              (failure) => emit(state.copyWith(getPropertySaleDetailsState: RequestState.error, getPropertySaleDetailsError: failure.message)),
              (propertySaleDetails) => emit(state.copyWith(getPropertySaleDetailsState: RequestState.loaded, propertySaleDetailsEntity: propertySaleDetails))
      );
    });


  }


  Future<void> bookProperty(String propertyId) async {
    emit(state.copyWith(bookPropertyState: RequestState.loading));

    // Convert payment method to the string format expected by backend
    // Backend expects: "wallet", "credit", "bankily", "cash", "paypal"
    String paymentMethodValue;
    if (state.currentPaymentMethod == LocaleKeys.wallet.tr()) {
      paymentMethodValue = 'wallet';
    } else if (state.currentPaymentMethod == LocaleKeys.paypal.tr()) {
      paymentMethodValue = 'paypal';
    } else if (state.currentPaymentMethod == LocaleKeys.bankily.tr() || state.currentPaymentMethod == 'Bankily') {
      paymentMethodValue = 'bankily';
    } else {
      paymentMethodValue = 'paypal'; // default to paypal
    }

    // 🆕 Calculer automatiquement les dates selon le type de propriété
    DateTime? calculatedStartDate;
    DateTime? calculatedEndDate;

    if (_propertyOperation == 'for_rent') {
      // StartDate = Aujourd'hui
      calculatedStartDate = DateTime.now();
      
      // EndDate = StartDate + nombre de mois de la propriété
      int monthsToAdd = int.tryParse(_propertyMonthlyRentPeriod ?? '3') ?? 3;
      calculatedEndDate = DateTime(
        calculatedStartDate.year,
        calculatedStartDate.month + monthsToAdd,
        calculatedStartDate.day,
      );
      
      print('📅 Dates calculées pour location:');
      print('   Début: $calculatedStartDate');
      print('   Fin: $calculatedEndDate');
      print('   Durée: $monthsToAdd mois');
    } else {
      // Pour les ventes, pas de dates
      print('💰 Vente: pas de dates nécessaires');
    }

    final bookPropertyRequest = BookPropertyRequestModel(
      propertyId: int.parse(propertyId), // Convert String to int
      isUser: state.buyerType.amIABuyer,
      name: state.userName,
      phoneNumber: state.phoneNumber,
      idNumber: state.userID,
      dateOfBirth: state.birthDate ?? DateTime.now(), // Use DateTime directly
      idExpiryDate: state.idExpirationDate ?? DateTime.now(), // Use DateTime directly
      paymentMethod: paymentMethodValue, // Send as string: "wallet", "credit", "bankily"
      idImage: state.selectedImages[0],
      // ✅ Utiliser les dates calculées dynamiquement
      startDate: calculatedStartDate,
      endDate: calculatedEndDate,
    );

    final result = await _bookPropertyUseCase.call(bookPropertyRequest);

    result.fold(
          (failure) => emit(state.copyWith(
          bookPropertyState: RequestState.error,
          bookPropertyError: failure.message)),
          (response) => emit(state.copyWith(
          bookPropertyState: RequestState.loaded,
          bookPropertyResponse: response)),
    );
  }

  @override
  Future<void> close() {
    phoneNumberController.dispose();
    nameController.dispose();
    iDNumberController.dispose();
    bankilyPassCodeController.dispose();
    return super.close();
  }

}
