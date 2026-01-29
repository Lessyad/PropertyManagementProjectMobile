import '../utils/enums.dart';

extension OperationTypePropertyExtension on PropertyOperationType {
  bool get isForSale => this == PropertyOperationType.forSale;
  bool get isForRent => this == PropertyOperationType.forRent;

  String get toEnglish {
    switch (this) {
      case PropertyOperationType.forSale:
        return 'For Sale';
      case PropertyOperationType.forRent:
        return 'For Rent';
    }
  }

  String get toArabic {
    switch (this) {
      case PropertyOperationType.forSale:
        return 'للبيع';
      case PropertyOperationType.forRent:
        return 'للإيجار';
    }
  }

  /// Returns the value expected by the API.
  String get toRequest {
    return isForSale ? 'for_sale' : 'for_rent';
  }
}

extension PropertyOperationTypeParsing on String {
  PropertyOperationType toPropertyOperationType() {
    switch (this) {
      case 'for_sale':
        return PropertyOperationType.forSale;
      case 'for_rent':
        return PropertyOperationType.forRent;
      default:
        throw Exception('Invalid property operation type: $this');
    }
  }
}
