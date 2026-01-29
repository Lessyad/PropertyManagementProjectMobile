import 'package:dartz/dartz.dart';

 import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../../domain/entities/property_wish_list_entity.dart';
import '../../domain/repository/base_wish_list_repository.dart';
import '../data_source/wish_list_remote_data_source.dart';

class WishListRepository extends BaseWishListRepository {
  final BaseWishListDataSource baseWishListDataSource;

  WishListRepository({required this.baseWishListDataSource});



  @override
  Future<Either<Failure, List<PropertyWishListEntity>>> getPropertiesWishList()async {
    return await HandleRequestService.handleApiCall<List<PropertyWishListEntity>>(() async {
      return await baseWishListDataSource.getPropertiesWishList( );
    });
  }

  @override
  Future<Either<Failure, void>> removePropertyFromWishList(String propertyId)async {
      return  await HandleRequestService.handleApiCall<void>(() async {
        return await baseWishListDataSource.removePropertyFromWishList( propertyId);
    });
  }

  @override
  Future<Either<Failure, PropertyWishListEntity>> addNewPropertyToWishList(String propertyId) async{
    return await HandleRequestService.handleApiCall<PropertyWishListEntity>(() async {
      return await baseWishListDataSource.addPropertyToWishList( propertyId);
    });
  }
}
