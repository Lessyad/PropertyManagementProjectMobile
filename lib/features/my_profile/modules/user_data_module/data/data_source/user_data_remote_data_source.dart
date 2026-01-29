import 'package:dio/dio.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/data/model/user_data_model.dart';
import 'package:enmaa/features/real_estates/data/models/property_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/services/convert_string_to_enum.dart';
import '../../../../../../core/services/dio_service.dart';

abstract class BaseUserDataRemoteDataSource {
  Future<UserDataModel> getUserData( );
  Future<void> updateUserData(Map<String , dynamic> updatedData);
}

class UserDataRemoteDataSource extends BaseUserDataRemoteDataSource {
  DioService dioService;

  UserDataRemoteDataSource({required this.dioService});




  @override
  Future<UserDataModel> getUserData()async {
    final response = await dioService.get(
      url: ApiConstants.user,
    );

     print('Réponse brute user: ${response.data}');
  try {
    final user = UserDataModel.fromJson(response.data);
    print('UserDataModel créé: $user');
    print('Birthday: ${user.dateOfBirth}');

    return user;
  } catch (e, stack) {
    print('Erreur de parsing user: $e');
    print('JSON problématique: ${response.data}');
    print(stack);
    rethrow;
  }
  }

  @override
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {

    FormData formData = FormData.fromMap(updatedData);
      print('Type de updatedData : ${updatedData.runtimeType}');
      print('Contenu de updatedData : $updatedData');
    try { 
       final response = await dioService.patch(
      url: ApiConstants.user,
      data: updatedData,
      // options: Options(contentType: 'multipart/form-data'),
      options: Options(contentType: 'application/json'),

    );
     } catch (e, stack) {
    print('Erreur Dio complète : $e');
    print(stack);
    rethrow;
  }
   
  }
}