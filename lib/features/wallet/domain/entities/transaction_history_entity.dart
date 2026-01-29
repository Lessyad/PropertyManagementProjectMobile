import 'package:equatable/equatable.dart';

class TransactionHistoryEntity extends Equatable {
  final int id;
  final String transactionType;
  final String transactionDate;
  final String paymentMethod;
  final String amount;
  final String currency;
  final String direction;
  final String transactionPurpose;
  final String role;
  final PropertyEntity property;

  const TransactionHistoryEntity({
    required this.id,
    required this.transactionType,
    required this.transactionDate,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.direction,
    required this.transactionPurpose,
    required this.role,
    required this.property,
  });

  @override
  List<Object?> get props => [
    id,
    transactionType,
    transactionDate,
    paymentMethod,
    amount,
    currency,
    direction,
    transactionPurpose,
    role,
    property,
  ];
}

class PropertyEntity extends Equatable {
  final String propertyType;
  final String subtype;
  final String city;
  final String country;
  final String operation;

  const PropertyEntity({
    required this.propertyType,
    required this.subtype,
    required this.city,
    required this.country,
    required this.operation,
  });

  @override
  List<Object?> get props => [propertyType, subtype, city, country, operation];
}
