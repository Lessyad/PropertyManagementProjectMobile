import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import 'package:equatable/equatable.dart';

class UserElectronicContractEntity extends Equatable {
  final int id;
  final String contractUrl;
  final String contractName;
  final String dateCreated;

  const UserElectronicContractEntity({
    required this.id,
    required this.contractUrl,
    required this.contractName,
    required this.dateCreated,
  });

  @override
  List<Object> get props => [id, contractUrl, contractName, dateCreated];
}
