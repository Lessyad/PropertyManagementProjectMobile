import 'package:enmaa/features/home_module/domain/entities/app_service_entity.dart';

class AppServiceModel extends AppServiceEntity {
  const AppServiceModel({
    required super.image,
    required super.text,
    super.routeKey,
  });

  factory AppServiceModel.fromJson(Map<String, dynamic> json) {
    return AppServiceModel(
      image: json['icon'],
      text: json['name'],
      routeKey: json['routeKey'],
    );
  }


}
