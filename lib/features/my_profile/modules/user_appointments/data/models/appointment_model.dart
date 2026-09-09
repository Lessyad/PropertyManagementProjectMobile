import 'package:enmaa/features/my_profile/modules/user_appointments/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    required super.propertyId,
    required super.propertyType,
    required super.propertyArea,
    required super.propertyCity,
    required super.propertyState,
    required super.propertyCountry,
    required super.orderStatus,
    super.propertyTitle,
    super.propertyImage,
    super.clientName,
    super.clientPhone,
    super.ownerName,
    super.ownerPhone,
    super.partnerName,
    super.partnerPhone,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: _readString(json, 'id'),
      date: _readString(json, 'date'),
      time: _readString(json, 'time'),
      propertyId: _readString(json, 'property_id'),
      propertyType: _readString(json, 'property_type'),
      propertyArea: _readString(json, 'property_area'),
      propertyCity: _readString(json, 'property_city'),
      propertyState: _readString(json, 'property_state'),
      propertyCountry: _readString(json, 'property_country'),
      orderStatus: _readString(json, 'order_status'),
      propertyTitle: _readString(json, 'property_title'),
      propertyImage: _readString(json, 'property_image'),
      clientName: _readString(json, 'client_name'),
      clientPhone: _readString(json, 'client_phone'),
      ownerName: _readString(json, 'owner_name'),
      ownerPhone: _readString(json, 'owner_phone'),
      partnerName: _readString(json, 'partner_name'),
      partnerPhone: _readString(json, 'partner_phone'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'property_id': propertyId,
      'property_type': propertyType,
      'property_area': propertyArea,
      'property_city': propertyCity,
      'property_state': propertyState,
      'property_country': propertyCountry,
      'order_status': orderStatus,
      'property_title': propertyTitle,
      'property_image': propertyImage,
      'client_name': clientName,
      'client_phone': clientPhone,
      'owner_name': ownerName,
      'owner_phone': ownerPhone,
      'partner_name': partnerName,
      'partner_phone': partnerPhone,
    };
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value == null ? '' : value.toString();
  }
}
