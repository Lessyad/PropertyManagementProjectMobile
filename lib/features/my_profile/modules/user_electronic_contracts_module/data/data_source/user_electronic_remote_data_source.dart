import 'package:dio/dio.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/data/model/user_data_model.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/data/models/user_electronic_contract_model.dart';
import 'package:enmaa/features/real_estates/data/models/property_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/services/convert_string_to_enum.dart';
import '../../../../../../core/services/dio_service.dart';

abstract class BaseUserElectronicContractsDataSource {
  Future<List<UserElectronicContractModel>> getUserElectronicContracts(Map<String, dynamic> data );
 }

class UserElectronicRemoteDataSource extends BaseUserElectronicContractsDataSource {
  DioService dioService;

  UserElectronicRemoteDataSource({required this.dioService});







  @override
  Future<List<UserElectronicContractModel>> getUserElectronicContracts(Map<String, dynamic> data)async {

    final response = await dioService.get(
      url: ApiConstants.contracts,
      queryParameters: data,
      options: Options(
        headers: {
          "Accept": "application/json", // 
        },
        // contentType: 'multipart/form-data'

      ),
    );

    List<UserElectronicContractModel> contracts = [];
    for (var contract in response.data['results']) {
      contracts.add(UserElectronicContractModel.fromJson(contract));
    }

    return contracts ;
  }



}