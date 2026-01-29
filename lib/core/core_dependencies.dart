
import 'package:dio/dio.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:get/get.dart';
import '../features/vehicle_management/vehicle_dependencies.dart';


class CoreDependencies {

  static Future<void> init() async {
    // await UserDependencies.init();
    // await AuthDependencies.init();
    await VehicleDependencies.init();
    Get.lazyPut(() => DioService(dio: Dio()));
  }
}
