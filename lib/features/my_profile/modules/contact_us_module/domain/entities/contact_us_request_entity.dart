import 'package:equatable/equatable.dart';

class ContactUsRequestEntity extends Equatable{
  final String name;
  final String phoneNumber;
  final String message;

  const ContactUsRequestEntity({
    required this.name,
    required this.phoneNumber,
    required this.message,
  });

  @override
   List<Object?> get props => [name, phoneNumber, message];
}