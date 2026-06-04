import '../../domain/entity/rental_history_entity.dart';
import '../../../../../../core/constants/api_constants.dart';

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

    final String image = _normalizeImageUrl(
      _firstStringFromList(vehicle['imageUrls']) ??
          _firstStringFromList(vehicle['imagesUrl']) ??
          vehicle['mainImageUrl']?.toString() ??
          vehicle['imageUrl']?.toString() ??
          '',
    );

    final String makeName = vehicle['makeName']?.toString() ?? '';
    final String modelName = vehicle['modelName']?.toString() ?? '';
    final int year = _toInt(vehicle['year']);
    final String vehicleLabel = [makeName, modelName, if (year > 0) year.toString()]
        .where((s) => s.isNotEmpty)
        .join(' ');

    final bool isActive = json['isActive'] == true;
    final paidAmount = _firstPositiveDouble([
      json['amountAlreadyPaid'],
      json['paidAmount'],
      json['amountPaid'],
      deal['amountAlreadyPaid'],
      deal['paidAmount'],
      deal['amountPaid'],
    ]);
    final totalAmount = _firstPositiveDouble([
      json['totalAmountDue'],
      json['totalAmount'],
      json['amount'],
      json['total'],
      deal['totalAmountDue'],
      deal['totalAmount'],
      deal['amount'],
      deal['total'],
    ]);

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
      totalAmount: totalAmount > 0 ? totalAmount : paidAmount,
      paidAmount: paidAmount,
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

  static String? _firstStringFromList(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final first = value.first?.toString();
      if (first != null && first.isNotEmpty) return first;
    }
    return null;
  }

  static double _firstPositiveDouble(List<dynamic> values) {
    for (final value in values) {
      final parsed = _toDouble(value);
      if (parsed > 0) return parsed;
    }
    return 0;
  }

  static String _normalizeImageUrl(String rawImage) {
    if (rawImage.isEmpty || rawImage.startsWith('http')) return rawImage;

    final String base = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/.*'), '');
    final String path = rawImage.startsWith('/') ? rawImage : '/$rawImage';
    return '$base$path';
  }
}
