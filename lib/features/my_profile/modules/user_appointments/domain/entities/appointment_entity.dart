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
  final String propertyTitle;
  final String propertyImage;
  final String clientName;
  final String clientPhone;
  final String ownerName;
  final String ownerPhone;
  final String partnerName;
  final String partnerPhone;

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
    this.propertyTitle = '',
    this.propertyImage = '',
    this.clientName = '',
    this.clientPhone = '',
    this.ownerName = '',
    this.ownerPhone = '',
    this.partnerName = '',
    this.partnerPhone = '',
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
    String? propertyTitle,
    String? propertyImage,
    String? clientName,
    String? clientPhone,
    String? ownerName,
    String? ownerPhone,
    String? partnerName,
    String? partnerPhone,
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
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyImage: propertyImage ?? this.propertyImage,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      partnerName: partnerName ?? this.partnerName,
      partnerPhone: partnerPhone ?? this.partnerPhone,
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
    propertyTitle,
    propertyImage,
    clientName,
    clientPhone,
    ownerName,
    ownerPhone,
    partnerName,
    partnerPhone,
  ];
}
