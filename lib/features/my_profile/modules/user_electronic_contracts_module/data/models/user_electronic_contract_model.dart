import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/features/real_estates/data/models/property_model.dart';

import '../../domain/entity/user_electronic_contract_entity.dart';

class UserElectronicContractModel extends UserElectronicContractEntity {
  const UserElectronicContractModel({
    required super.id,
    required super.contractUrl,
    required super.contractName,
    required super.dateCreated,
  }) ;

  factory UserElectronicContractModel.fromJson(Map<String, dynamic> json) {
    final propertyJson = json['property'] as Map<String, dynamic>;
    final propertyType = getPropertyType(propertyJson['property_type'] as String).toName;

    final area = propertyJson['area'].toString();
    final cityJson = propertyJson['city'] as Map<String, dynamic>;
    final cityName = cityJson['name'] as String;

    String contractName = '$propertyType $area ${LocaleKeys.areaUnit.tr()}  $cityName';
    return UserElectronicContractModel(
      id: json['id'],
      contractUrl: json['contract_url'],
      contractName:contractName ,
      dateCreated:json['created'] ,
    );
  }

}