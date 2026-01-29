import 'package:dartz/dartz.dart';
 import '../../../../core/errors/failure.dart';
import '../entities/property_wish_list_entity.dart';



abstract class BaseWishListRepository {



  Future<Either<Failure, List<PropertyWishListEntity>>> getPropertiesWishList();
  Future<Either<Failure, void>> removePropertyFromWishList(String propertyId);
  Future<Either<Failure, PropertyWishListEntity>> addNewPropertyToWishList(String propertyId);


}