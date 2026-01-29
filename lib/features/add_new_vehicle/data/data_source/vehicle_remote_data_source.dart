// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:enmaa/core/services/dio_service.dart';
// import 'package:enmaa/core/constants/api_constants.dart';
//
// abstract class BaseAddNewVehicleDataSource {
//   Future<void> addVehicle(CreateVehicleRequestModel vehicle);
//   Future<void> updateVehicle(int vehicleId, UpdateVehicleRequestModel vehicle);
// }
//
// class AddNewVehicleRemoteDataSource extends BaseAddNewVehicleDataSource {
//   final DioService dioService;
//
//   AddNewVehicleRemoteDataSource({required this.dioService});
//
//   @override
//   Future<void> addVehicle(CreateVehicleRequestModel vehicle) async {
//     final formData = await vehicle.toFormData();
//
//     await dioService.post(
//       url: ApiConstants.vehicles,
//       data: formData,
//       options: Options(contentType: 'multipart/form-data'),
//     );
//   }
//
//   @override
//   Future<void> updateVehicle(int vehicleId, UpdateVehicleRequestModel vehicle) async {
//     final formData = await vehicle.toFormData();
//
//     await dioService.put(
//       url: '${ApiConstants.vehicles}$vehicleId/',
//       data: formData,
//       options: Options(contentType: 'multipart/form-data'),
//     );
//   }
// }