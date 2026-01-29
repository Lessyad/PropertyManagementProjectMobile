// lib/features/vehicle_management/vehicle_bindings.dart
import 'package:enmaa/features/vehicle_management/vehicle/presentation/controller/vehicle_controller.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/controller/vehicle_details_controller.dart';
import 'package:get/get.dart';

class VehicleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleController(Get.find()));
    Get.lazyPut(() => VehicleDetailsController(Get.find()));
  }
}