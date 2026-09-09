import 'package:equatable/equatable.dart';

class UserElectronicContractEntity extends Equatable {
  final int id;
  final String contractUrl;
  final String contractName;
  final String propertyTitle;
  final String propertyType;
  final String propertyImage;
  final String cityName;
  final double area;
  final String operation;
  final String dateCreated;

  const UserElectronicContractEntity({
    required this.id,
    required this.contractUrl,
    required this.contractName,
    required this.propertyTitle,
    required this.propertyType,
    required this.propertyImage,
    required this.cityName,
    required this.area,
    required this.operation,
    required this.dateCreated,
  });

  @override
  List<Object> get props => [
        id,
        contractUrl,
        contractName,
        propertyTitle,
        propertyType,
        propertyImage,
        cityName,
        area,
        operation,
        dateCreated,
      ];
}
