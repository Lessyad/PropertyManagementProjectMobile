import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String date;
  final String time;
  final String propertyId;
  final String propertyType;
  final String propertyArea;
  final String propertyCity;
  final String propertyState;
  final String propertyCountry;
  final String orderStatus;

  const AppointmentEntity({
    required this.id,
    required this.date,
    required this.time,
    required this.propertyId,
    required this.propertyType,
    required this.propertyArea,
    required this.propertyCity,
    required this.propertyState,
    required this.propertyCountry,
    required this.orderStatus,
  });

  // Add copyWith method
  AppointmentEntity copyWith({
    String? id,
    String? date,
    String? time,
    String? propertyId,
    String? propertyType,
    String? propertyArea,
    String? propertyCity,
    String? propertyState,
    String? propertyCountry,
    String? orderStatus,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      propertyId: propertyId ?? this.propertyId,
      propertyType: propertyType ?? this.propertyType,
      propertyArea: propertyArea ?? this.propertyArea,
      propertyCity: propertyCity ?? this.propertyCity,
      propertyState: propertyState ?? this.propertyState,
      propertyCountry: propertyCountry ?? this.propertyCountry,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  @override
  List<Object> get props => [
    id,
    date,
    time,
    propertyId,
    propertyType,
    propertyArea,
    propertyCity,
    propertyState,
    propertyCountry,
    orderStatus,
  ];
}