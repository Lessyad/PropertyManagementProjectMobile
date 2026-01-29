import 'package:dartz/dartz.dart';
   import '../../../../core/errors/failure.dart';
import '../entities/property_wish_list_entity.dart';
import '../repository/base_wish_list_repository.dart';

class GetPropertiesWishListUseCase {
  final BaseWishListRepository _baseWishListRepository ;

  GetPropertiesWishListUseCase(this._baseWishListRepository);

  Future<Either<Failure, List<PropertyWishListEntity>>> call() =>
      _baseWishListRepository.getPropertiesWishList( );
}