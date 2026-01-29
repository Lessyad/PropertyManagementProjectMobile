import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/errors/failure.dart';

import '../../../../../../core/services/shared_preferences_service.dart';
import '../../data/models/contact_us_request_model.dart';
import '../../domain/entities/contact_us_request_entity.dart';
import '../../domain/use_cases/send_contact_us_use_case.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final SendContactUsUseCase _sendContactUsUseCase;

  ContactUsCubit(this._sendContactUsUseCase)
      : super(const ContactUsState()){
    String name = SharedPreferencesService().userName ;
    String phoneNumber = SharedPreferencesService().userPhone ;


    emit(state.copyWith(
      name: name,
      phoneNumber: phoneNumber,
    ));


  }

  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  void changePhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void changeMessage(String message) {
    emit(state.copyWith(message: message));
  }

  void setCountryCode(String countryCode) {
    emit(state.copyWith(currentCountryCode: countryCode));
  }

  Future<void> sendContactUsRequest() async {
    emit(state.copyWith(contactUsRequestState: RequestState.loading));

    final contactUsRequest = ContactUsRequestModel(
      name: state.name,
      phoneNumber: state.phoneNumber,
      message: state.message,
    );

    final Either<Failure, void> result =
    await _sendContactUsUseCase(contactUsRequest);

    result.fold(
          (failure) => emit(state.copyWith(
          contactUsRequestState: RequestState.error,
          contactUsErrorMessage: failure.message)),
          (success) => emit(state.copyWith(
          contactUsRequestState: RequestState.loaded,
          )),
    );
  }
}