import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity{
  const BannerModel({
    required super.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      image: json['image'],
    );
  }

}