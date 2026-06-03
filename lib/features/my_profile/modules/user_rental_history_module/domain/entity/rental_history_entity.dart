import 'package:equatable/equatable.dart';

class RentalHistoryEntity extends Equatable {
  final int id;
  final int propertyId;
  final String propertyTitle;
  final String propertyType;
  final String propertyCity;
  final String propertyState;
  final String propertyCountry;
  final String propertyImage;
  final double propertyArea;
  final String userRole;
  final String contractUrl;
  final String created;
  final String? startDate;
  final String? endDate;
  final String dealStatus;
  final String orderStatus;
  final String operation;
  final double totalAmount;
  final double paidAmount;
  final double? ownerPortion;
  final String paymentMethod;
  final String clientName;
  final String clientPhoneNumber;

  const RentalHistoryEntity({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyType,
    required this.propertyCity,
    required this.propertyState,
    required this.propertyCountry,
    required this.propertyImage,
    required this.propertyArea,
    required this.userRole,
    required this.contractUrl,
    required this.created,
    required this.startDate,
    required this.endDate,
    required this.dealStatus,
    required this.orderStatus,
    required this.operation,
    required this.totalAmount,
    required this.paidAmount,
    required this.ownerPortion,
    required this.paymentMethod,
    required this.clientName,
    required this.clientPhoneNumber,
  });

  @override
  List<Object?> get props => [
        id,
        propertyId,
        propertyTitle,
        propertyType,
        propertyCity,
        propertyState,
        propertyCountry,
        propertyImage,
        propertyArea,
        userRole,
        contractUrl,
        created,
        startDate,
        endDate,
        dealStatus,
        orderStatus,
        operation,
        totalAmount,
        paidAmount,
        ownerPortion,
        paymentMethod,
        clientName,
        clientPhoneNumber,
      ];
}
