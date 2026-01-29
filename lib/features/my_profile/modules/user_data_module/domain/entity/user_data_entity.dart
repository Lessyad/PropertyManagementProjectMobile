import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';
import 'package:equatable/equatable.dart';

class UserDataEntity extends Equatable {
  final String phoneNumber;
  final String userName;
  final CityEntity? city;
  final StateEntity? state;
  final CountryEntity? country;
  final bool notificationEnabled;
  final String availableBalance;
  final String frozenBalance;
  final String? idNumber;
  final String? dateOfBirth;
  final String? idExpirationDate;

  const UserDataEntity({
    required this.phoneNumber,
    required this.userName,
    this.city,
    this.state,
    this.country,
    required this.notificationEnabled,
    required this.availableBalance,
    required this.frozenBalance,
    this.idNumber,
    this.dateOfBirth,
    this.idExpirationDate,
  });

  UserDataEntity copyWith({
    String? phoneNumber,
    String? userName,
    CityEntity? city,
    StateEntity? state,
    CountryEntity? country,
    bool? notificationEnabled,
    String? availableBalance,
    String? frozenBalance,
    String? idNumber,
    String? dateOfBirth,
    String? idExpirationDate,
  }) {
    return UserDataEntity(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      availableBalance: availableBalance ?? this.availableBalance,
      frozenBalance: frozenBalance ?? this.frozenBalance,
      idNumber: idNumber ?? this.idNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      idExpirationDate: idExpirationDate ?? this.idExpirationDate,
    );
  }

  @override
  List<Object?> get props => [
    phoneNumber,
    userName,
    city,
    state,
    country,
    notificationEnabled,
    availableBalance,
    frozenBalance,
    idNumber,
    dateOfBirth,
    idExpirationDate,
  ];
}