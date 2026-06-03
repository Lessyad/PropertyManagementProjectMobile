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

  /// Parse une réponse de GET /api/Vehicles/rentals
  factory RentalHistoryModel.fromVehicleJson(Map<String, dynamic> json) {
    final deal = (json['vehicleDealData'] as Map<String, dynamic>?) ?? {};
    final vehicle = (deal['vehicle'] as Map<String, dynamic>?) ?? {};
    final clientInfo = (deal['clientInfo'] as Map<String, dynamic>?) ?? {};

    final images = (vehicle['imageUrls'] as List<dynamic>?) ?? [];
    final String image = images.isNotEmpty ? images.first.toString() : '';

    final String makeName = vehicle['makeName']?.toString() ?? '';
    final String modelName = vehicle['modelName']?.toString() ?? '';
    final int year = _toInt(vehicle['year']);
    final String vehicleLabel = [makeName, modelName, if (year > 0) year.toString()]
        .where((s) => s.isNotEmpty)
        .join(' ');

    final bool isActive = json['isActive'] == true;

    return RentalHistoryModel(
      id: _toInt(json['id']),
      propertyId: _toInt(deal['vehicleId']),
      propertyTitle: vehicleLabel,
      propertyType: makeName,
      propertyCity: '',
      propertyState: '',
      propertyCountry: '',
      propertyImage: image,
      propertyArea: 0,
      userRole: 'Client',
      contractUrl: deal['contractPath']?.toString() ?? '',
      created: json['dateAtStartOfRent']?.toString() ?? '',
      startDate: deal['startDate']?.toString(),
      endDate: deal['endDate']?.toString(),
      dealStatus: deal['status']?.toString() ?? '',
      orderStatus: isActive ? 'active' : 'completed',
      operation: '',
      totalAmount: _toDouble(json['totalAmountDue']),
      paidAmount: _toDouble(json['amountAlreadyPaid']),
      ownerPortion: null,
      paymentMethod: '',
      clientName: clientInfo['name']?.toString() ?? '',
      clientPhoneNumber: clientInfo['phoneNumber']?.toString() ?? '',
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
