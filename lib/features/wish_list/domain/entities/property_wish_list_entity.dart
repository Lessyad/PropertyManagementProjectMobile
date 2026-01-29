import 'package:equatable/equatable.dart';
import '../../../real_estates/domain/entities/base_property_entity.dart';


class PropertyWishListEntity extends Equatable {
  final int id;
  final String type;
  final int objectId;
  final PropertyEntity? property;

  const PropertyWishListEntity({
    required this.id,
    required this.type,
    required this.objectId,
    required this.property,
  });

  @override
  List<Object?> get props => [id, type, objectId, property];
}
