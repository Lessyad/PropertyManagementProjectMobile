import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_wish_list_entity.dart';
import '../repository/base_wish_list_repository.dart';

class AddNewPropertyToWishListUseCase {
  final BaseWishListRepository _baseWishListRepository ;

  AddNewPropertyToWishListUseCase(this._baseWishListRepository);

  Future<Either<Failure, PropertyWishListEntity>> call(String propertyID) =>
      _baseWishListRepository.addNewPropertyToWishList( propertyID);
}