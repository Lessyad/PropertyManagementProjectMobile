import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_service.dart';
import '../models/vehicle_request_models.dart';

abstract class BaseAddNewVehicleDataSource {
  Future<void> createVehicle(CreateVehicleRequestModel body);
  Future<void> updateVehicle(int id, UpdateVehicleRequestModel body);
  Future<void> deleteVehicle(int id);
}

class AddNewVehicleRemoteDataSource implements BaseAddNewVehicleDataSource {
  final DioService dioService;
  AddNewVehicleRemoteDataSource({required this.dioService});

  @override
  Future<void> createVehicle(CreateVehicleRequestModel body) async {
    final form = await body.toFormData();
    await dioService.post(
      url: ApiConstants.vehicles,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> updateVehicle(int id, UpdateVehicleRequestModel body) async {
    final form = await body.toFormData();
    await dioService.put(
      url: '${ApiConstants.vehicles}/$id',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> deleteVehicle(int id) async {
    await dioService.delete(url: '${ApiConstants.vehicles}/$id');
  }
}


