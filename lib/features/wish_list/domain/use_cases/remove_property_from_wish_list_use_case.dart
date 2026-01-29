import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
 import '../repository/base_wish_list_repository.dart';

class RemovePropertyFromWishListUseCase {
  final BaseWishListRepository _baseWishListRepository ;

  RemovePropertyFromWishListUseCase(this._baseWishListRepository);

  Future<Either<Failure, void>> call(String propertyId) =>
      _baseWishListRepository.removePropertyFromWishList(propertyId );
}