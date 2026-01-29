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
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'].toString(),
      date: json['date'] as String,
      time: json['time'] as String,
      propertyId: json['property_id'].toString(),
      propertyType: json['property_type'] as String,
      propertyArea: json['property_area'].toString(),
      propertyCity: json['property_city'] as String,
      propertyState: json['property_state'] as String,
      propertyCountry: json['property_country'] as String,
      orderStatus: json['order_status'] as String,
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
    };
  }
}
