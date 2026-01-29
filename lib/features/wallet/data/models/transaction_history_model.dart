import '../../domain/entities/transaction_history_entity.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  const TransactionHistoryModel({
    required super.id,
    required super.transactionType,
    required super.transactionDate,
    required super.paymentMethod,
    required super.amount,
    required super.currency,
    required super.direction,
    required super.transactionPurpose,
    required super.role,
    required super.property,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {

      return TransactionHistoryModel(
        id: json['id'],
        transactionType: json['transaction_type'] ?? '',
        transactionDate: json['transaction_date'] ?? '',
        paymentMethod: json['payment_method'] ?? '',
        amount: json['amount'].toString() ?? '',
        currency: json['currency'] ?? '',
        direction: json['direction'] ?? '',
        transactionPurpose: json['transaction_purpose'] ?? '',
        role: json['role'] ?? '',
        property: PropertyModel.fromJson(json['property'] ?? {}),
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_type': transactionType,
      'transaction_date': transactionDate,
      'payment_method': paymentMethod,
      'amount': amount,
      'currency': currency,
      'direction': direction,
      'transaction_purpose': transactionPurpose,
      'role': role,
      'property': (property as PropertyModel).toJson(),
    };
  }
}

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.propertyType,
    required super.subtype,
    required super.city,
    required super.country,
    required super.operation,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      propertyType: json['property_type'] ?? '',
      subtype: json['subtype'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      operation: json['operation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_type': propertyType,
      'subtype': subtype,
      'city': city,
      'country': country,
      'operation': operation,
    };
  }
}
