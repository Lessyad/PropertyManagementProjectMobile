class PropertySaleSummaryModel {
  const PropertySaleSummaryModel({
    required this.id,
    required this.orderId,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.sellerName,
    required this.sellerPhoneNumber,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyCity,
    required this.propertyKind,
    required this.propertyStatus,
    required this.commercialPropertyStatus,
    required this.operation,
    required this.dealDate,
    required this.status,
    required this.orderStatus,
    required this.totalAmount,
    required this.paidAmount,
    required this.platformProfit,
    required this.ownerPortion,
    required this.sellerPayoutPaid,
  });

  final int id;
  final int orderId;
  final String clientName;
  final String clientPhoneNumber;
  final String sellerName;
  final String sellerPhoneNumber;
  final int propertyId;
  final String propertyTitle;
  final String propertyCity;
  final String propertyKind;
  final String propertyStatus;
  final String commercialPropertyStatus;
  final String operation;
  final DateTime? dealDate;
  final String status;
  final String orderStatus;
  final double totalAmount;
  final double paidAmount;
  final double platformProfit;
  final double ownerPortion;
  final bool sellerPayoutPaid;

  double get remainingAmount {
    final remaining = totalAmount - paidAmount;
    return remaining < 0 ? 0 : remaining;
  }

  double get systemPaidAmount => sellerPayoutPaid ? ownerPortion : 0;

  double get systemRemainingAmount => sellerPayoutPaid ? 0 : ownerPortion;

  bool get isPaid => sellerPayoutPaid;

  bool get isReserved {
    final normalizedPropertyStatus = effectivePropertyStatus;
    final normalizedDealStatus = status.toLowerCase();

    return normalizedPropertyStatus == 'reserved' ||
        normalizedPropertyStatus == 'booked' ||
        (normalizedPropertyStatus.isEmpty &&
            (normalizedDealStatus == 'pending' ||
                normalizedDealStatus == 'confirmed'));
  }

  bool get isSold {
    return effectivePropertyStatus == 'sold';
  }

  String get effectivePropertyStatus {
    final normalizedCommercialStatus = commercialPropertyStatus.toLowerCase();
    if (normalizedCommercialStatus.isNotEmpty) {
      return normalizedCommercialStatus;
    }

    return propertyStatus.toLowerCase();
  }

  factory PropertySaleSummaryModel.fromJson(Map<String, dynamic> json) {
    return PropertySaleSummaryModel(
      id: _readInt(json, 'id'),
      orderId: _readInt(json, 'orderId'),
      clientName: _readString(json, 'clientName'),
      clientPhoneNumber: _readString(json, 'clientPhoneNumber'),
      sellerName: _readString(json, 'sellerName'),
      sellerPhoneNumber: _readString(json, 'sellerPhoneNumber'),
      propertyId: _readInt(json, 'propertyId'),
      propertyTitle: _readString(json, 'propertyTitle'),
      propertyCity: _readString(json, 'propertyCity'),
      propertyKind: _readString(json, 'propertyKind'),
      propertyStatus: _readString(json, 'propertyStatus'),
      commercialPropertyStatus: _readString(json, 'commercialPropertyStatus'),
      operation: _readString(json, 'operation'),
      dealDate: DateTime.tryParse(_readString(json, 'dealDate')),
      status: _readString(json, 'status'),
      orderStatus: _readString(json, 'orderStatus'),
      totalAmount: _readDouble(json, 'totalAmount'),
      paidAmount: _readDouble(json, 'paidAmount'),
      platformProfit: _readDouble(json, 'platformProfit'),
      ownerPortion: _readDouble(json, 'ownerPortion'),
      sellerPayoutPaid: _readBool(json, 'sellerPayoutPaid'),
    );
  }

  static Object? _read(Map<String, dynamic> json, String key) {
    final pascalKey = key[0].toUpperCase() + key.substring(1);
    return json[key] ?? json[pascalKey];
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = _read(json, key);
    return value?.toString() ?? '';
  }

  static int _readInt(Map<String, dynamic> json, String key) {
    final value = _read(json, key);
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _readDouble(Map<String, dynamic> json, String key) {
    final value = _read(json, key);
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _readBool(Map<String, dynamic> json, String key) {
    final value = _read(json, key);
    if (value is bool) return value;
    return value?.toString().toLowerCase() == 'true';
  }
}
