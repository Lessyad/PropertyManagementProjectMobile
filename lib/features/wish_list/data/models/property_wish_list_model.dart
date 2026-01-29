import '../../../real_estates/data/models/property_model.dart';
import '../../domain/entities/property_wish_list_entity.dart';

class PropertyWishListModel extends PropertyWishListEntity {
  const PropertyWishListModel({
    required super.id,
    required super.type,
    required super.objectId,
    required super.property,
  });

  factory PropertyWishListModel.fromJson(Map<String, dynamic> json) {
    return PropertyWishListModel(
      id: json['id'],
      type: json['type'],
      objectId: json['object_id'],
      property: json['property_data'] != null
          ? PropertyModel.fromJson(json['property_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'object_id': objectId,
      'property_data': property != null
          ? (property as dynamic).toJson()
          : null,
    };
  }

  PropertyWishListEntity toEntity() {
    return PropertyWishListEntity(
      id: id,
      type: type,
      objectId: objectId,
      property: property,
    );
  }

  static PropertyWishListModel fromEntity(PropertyWishListEntity entity) {
    return PropertyWishListModel(
      id: entity.id,
      type: entity.type,
      objectId: entity.objectId,
      property: entity.property,
    );
  }
}