import '../../domain/entity/rental_history_entity.dart';

class RentalHistoryModel extends RentalHistoryEntity {
  const RentalHistoryModel({
    required super.id,
    required super.propertyId,
    required super.propertyTitle,
    required super.propertyType,
    required super.propertyCity,
    required super.propertyState,
    required super.propertyCountry,
    required super.propertyImage,
    required super.propertyArea,
    required super.userRole,
    required super.contractUrl,
    required super.created,
    required super.startDate,
    required super.endDate,
    required super.dealStatus,
    required super.orderStatus,
    required super.operation,
    required super.totalAmount,
    required super.paidAmount,
    required super.ownerPortion,
    required super.paymentMethod,
    required super.clientName,
    required super.clientPhoneNumber,
  });

  factory RentalHistoryModel.fromJson(Map<String, dynamic> json) {
    final property = (json['property'] as Map<String, dynamic>?) ?? {};
    final city = (property['city'] as Map<String, dynamic>?) ?? {};
    final state = (city['state'] as Map<String, dynamic>?) ?? {};
    final country = (state['country'] as Map<String, dynamic>?) ?? {};

    return RentalHistoryModel(
      id: _toInt(json['id']),
      propertyId: _toInt(property['id']),
      propertyTitle: property['title']?.toString() ?? '',
      propertyType: property['property_type']?.toString() ?? '',
      propertyCity: city['name']?.toString() ?? '',
      propertyState: state['name']?.toString() ?? '',
      propertyCountry: country['name']?.toString() ?? '',
      propertyImage: property['mainImage']?.toString() ??
          property['main_image']?.toString() ??
          '',
      propertyArea: _toDouble(property['area']),
      userRole: json['user_role']?.toString() ?? '',
      contractUrl: json['contract_url']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      dealStatus: json['deal_status']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
      operation: json['operation']?.toString() ?? '',
      totalAmount: _toDouble(json['total_amount']),
      paidAmount: _toDouble(json['paid_amount']),
      ownerPortion: json['owner_portion'] == null
          ? null
          : _toDouble(json['owner_portion']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? '',
      clientPhoneNumber: json['client_phone_number']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
