import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../domain/entity/user_electronic_contract_entity.dart';

class UserElectronicContractModel extends UserElectronicContractEntity {
  const UserElectronicContractModel({
    required super.id,
    required super.contractUrl,
    required super.contractName,
    required super.propertyTitle,
    required super.propertyType,
    required super.propertyImage,
    required super.cityName,
    required super.area,
    required super.operation,
    required super.dateCreated,
  });

  factory UserElectronicContractModel.fromJson(Map<String, dynamic> json) {
    final propertyJson = json['property'] as Map<String, dynamic>? ?? {};
    final rawPropertyType = propertyJson['property_type']?.toString() ?? '';
    final propertyType = _formatPropertyType(rawPropertyType);

    final area = (propertyJson['area'] as num?)?.toDouble() ??
        double.tryParse(propertyJson['area']?.toString() ?? '') ??
        0;
    final cityJson = propertyJson['city'] as Map<String, dynamic>? ?? {};
    final cityName = cityJson['name']?.toString() ?? '';
    final propertyTitle = propertyJson['title']?.toString() ?? '';
    final propertyImage = propertyJson['mainImage']?.toString() ??
        propertyJson['main_image']?.toString() ??
        '';
    final operation = json['operation']?.toString() ??
        json['Operation']?.toString() ??
        propertyJson['operation']?.toString() ??
        propertyJson['Operation']?.toString() ??
        '';

    final contractName =
        '$propertyType $area ${LocaleKeys.areaUnit.tr()}  $cityName';
    return UserElectronicContractModel(
      id: json['id'],
      contractUrl: json['contract_url'] ?? '',
      contractName: contractName,
      propertyTitle: propertyTitle,
      propertyType: propertyType,
      propertyImage: propertyImage,
      cityName: cityName,
      area: area,
      operation: operation,
      dateCreated: json['created'] ?? '',
    );
  }

  static String _formatPropertyType(String rawPropertyType) {
    if (rawPropertyType.isEmpty) return '';

    switch (rawPropertyType.toLowerCase()) {
      case 'apartment':
        return getPropertyType('apartment').toName;
      case 'building':
        return getPropertyType('building').toName;
      case 'land':
        return getPropertyType('land').toName;
      case 'villa':
        return getPropertyType('villa').toName;
      default:
        return rawPropertyType;
    }
  }
}
