import 'package:enmaa/core/services/select_location_service/data/models/city_model.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';

import '../../../../../../core/services/select_location_service/data/models/country_model.dart';
import '../../../../../../core/services/select_location_service/data/models/state_model.dart';
import '../../domain/entity/user_data_entity.dart';

class UserDataModel extends UserDataEntity {
  const UserDataModel({
    required super.phoneNumber,
    required super.userName,
    super.city,
    super.state,
    super.country,
    required super.notificationEnabled,
    required super.availableBalance,
    required super.frozenBalance,
    super.idNumber,
    super.dateOfBirth,
    super.idExpirationDate,
    String? idImage,
    required String dateJoined,
  }) ;

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      phoneNumber: json['phone_number'],
      userName: json['full_name'],
      city: json['city'] != null ? CityModel.fromJson(json['city']) : null,
      state: json['city'] != null && json['city']['state'] != null
          ? StateModel.fromJson(json['city']['state'])
          : null,
      country: json['city'] != null ? CountryModel.fromJson(json['city']['state']['country']) : null,
      notificationEnabled: json['notifications_enabled'],
      // availableBalance: json['available_balance'],
      // frozenBalance: json['frozen_balance'],
      availableBalance: json['available_balance']?.toString() ?? '0', // Convert to string
    frozenBalance: json['frozen_balance']?.toString() ?? '0',
      idNumber: json['id_number'],
      dateOfBirth: json['date_of_birth']?.toString() ?? '0',
      idExpirationDate: json['id_expiry_date']?.toString() ?? '0',
      idImage: json['id_image'],
      dateJoined: json['date_joined'],
    );
  }

}