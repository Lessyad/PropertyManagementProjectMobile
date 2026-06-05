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
    final deal = _mapFromAny(_value(json, ['vehicleDealData', 'VehicleDealData']));
    final vehicle = _mapFromAny(_value(deal, ['vehicle', 'Vehicle']));
    final clientInfo = _mapFromAny(_value(deal, ['clientInfo', 'ClientInfo']));

    final String image = _normalizeImageUrl(
      _firstStringFromList(_value(vehicle, ['imageUrls', 'ImageUrls'])) ??
          _firstStringFromList(_value(vehicle, ['imagesUrl', 'ImagesUrl'])) ??
          _firstStringFromList(_value(json, ['imageUrls', 'ImageUrls'])) ??
          _firstStringFromList(_value(json, ['imagesUrl', 'ImagesUrl'])) ??
          _value(vehicle, ['mainImageUrl', 'MainImageUrl'])?.toString() ??
          _value(vehicle, ['imageUrl', 'ImageUrl'])?.toString() ??
          _value(json, ['mainImageUrl', 'MainImageUrl'])?.toString() ??
          _value(json, ['imageUrl', 'ImageUrl'])?.toString() ??
          '',
    );

    final String makeName = _value(vehicle, ['makeName', 'MakeName'])?.toString() ?? '';
    final String modelName =
        _value(vehicle, ['modelName', 'ModelName', 'model', 'Model'])?.toString() ?? '';
    final int year = _toInt(_value(vehicle, ['year', 'Year']));
    final String vehicleLabel = [makeName, modelName, if (year > 0) year.toString()]
        .where((s) => s.isNotEmpty)
        .join(' ');

    final bool isActive = _value(json, ['isActive', 'IsActive']) == true;
    final paidAmount = _firstPositiveDouble([
      _value(json, ['amountAlreadyPaid', 'AmountAlreadyPaid']),
      _value(json, ['paidAmount', 'PaidAmount']),
      _value(json, ['amountPaid', 'AmountPaid']),
      _value(deal, ['amountAlreadyPaid', 'AmountAlreadyPaid']),
      _value(deal, ['paidAmount', 'PaidAmount']),
      _value(deal, ['amountPaid', 'AmountPaid']),
    ]);
    final totalAmount = _firstPositiveDouble([
      _value(json, ['totalAmountDue', 'TotalAmountDue']),
      _value(json, ['totalAmount', 'TotalAmount']),
      _value(json, ['amount', 'Amount']),
      _value(json, ['total', 'Total']),
      _value(deal, ['totalAmountDue', 'TotalAmountDue']),
      _value(deal, ['totalAmount', 'TotalAmount']),
      _value(deal, ['amount', 'Amount']),
      _value(deal, ['total', 'Total']),
    ]);

    return RentalHistoryModel(
      id: _toInt(_value(json, ['id', 'Id'])),
      propertyId: _toInt(_value(deal, ['vehicleId', 'VehicleId'])),
      propertyTitle: vehicleLabel,
      propertyType: makeName,
      propertyCity: '',
      propertyState: '',
      propertyCountry: '',
      propertyImage: image,
      propertyArea: 0,
      userRole: 'Client',
      contractUrl: _value(deal, ['contractPath', 'ContractPath'])?.toString() ?? '',
      created: _value(json, ['dateAtStartOfRent', 'DateAtStartOfRent'])?.toString() ?? '',
      startDate: _value(deal, ['startDate', 'StartDate'])?.toString(),
      endDate: _value(deal, ['endDate', 'EndDate'])?.toString(),
      dealStatus: _value(deal, ['status', 'Status'])?.toString() ?? '',
      orderStatus: isActive ? 'active' : 'completed',
      operation: '',
      totalAmount: totalAmount > 0 ? totalAmount : paidAmount,
      paidAmount: paidAmount,
      ownerPortion: null,
      paymentMethod: '',
      clientName: _value(clientInfo, ['name', 'Name'])?.toString() ?? '',
      clientPhoneNumber:
          _value(clientInfo, ['phoneNumber', 'PhoneNumber'])?.toString() ?? '',
    );
  }

  static Map<String, dynamic> _mapFromAny(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  static dynamic _value(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) return json[key];
    }
    return null;
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
