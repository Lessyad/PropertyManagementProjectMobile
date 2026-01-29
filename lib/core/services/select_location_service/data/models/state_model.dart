import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';

class StateModel extends StateEntity {
  const StateModel({
    required super.name,
    required super.id,
  }) ;

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      name: json['name'],
      id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}