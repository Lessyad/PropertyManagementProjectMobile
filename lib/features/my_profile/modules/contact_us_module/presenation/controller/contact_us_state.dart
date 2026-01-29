part of 'contact_us_cubit.dart';

class ContactUsState extends Equatable {
  const ContactUsState({
    this.contactUsRequestState = RequestState.initial,
    this.contactUsErrorMessage = '',
    this.name = '',
    this.phoneNumber = '',
    this.message = '',
    this.currentCountryCode = '+20',
  });

  final RequestState contactUsRequestState;
  final String contactUsErrorMessage;
  final String name;
  final String phoneNumber;
  final String message;
  final String currentCountryCode;

  ContactUsState copyWith({
    RequestState? contactUsRequestState,
    String? contactUsErrorMessage,
    bool? isContactUsSent,
    String? name,
    String? phoneNumber,
    String? message,
    String? currentCountryCode,
  }) {
    return ContactUsState(
      contactUsRequestState: contactUsRequestState ?? this.contactUsRequestState,
      contactUsErrorMessage: contactUsErrorMessage ?? this.contactUsErrorMessage,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message ?? this.message,
      currentCountryCode: currentCountryCode ?? this.currentCountryCode,
    );
  }

  @override
  List<Object> get props => [
    contactUsRequestState,
    contactUsErrorMessage,
    name,
    phoneNumber,
    message,
    currentCountryCode,
  ];
}