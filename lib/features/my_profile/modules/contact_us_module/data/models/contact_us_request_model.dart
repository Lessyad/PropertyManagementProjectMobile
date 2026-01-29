import '../../domain/entities/contact_us_request_entity.dart';

class ContactUsRequestModel extends ContactUsRequestEntity {
  const ContactUsRequestModel({
    required super.name,
    required super.phoneNumber,
    required super.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile_number': phoneNumber,
      'message': message,
    };
  }
}