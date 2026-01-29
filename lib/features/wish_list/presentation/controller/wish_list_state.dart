part of 'wish_list_cubit.dart';

class WishListState extends Equatable {
  const WishListState(
  {
    this.propertyWishList = const <PropertyWishListEntity>[],
    this.getPropertyWishListState = RequestState.initial,
    this.getPropertyWishListFailureMessage = '',
}
      );

  final List<PropertyWishListEntity> propertyWishList ;
  final RequestState getPropertyWishListState;
  final String getPropertyWishListFailureMessage;

  WishListState copyWith({
    List<PropertyWishListEntity>? propertyWishList,
    RequestState? getPropertyWishListState,
    String? getPropertyWishListFailureMessage,
  }) {
    return WishListState(
      propertyWishList: propertyWishList ?? this.propertyWishList,
      getPropertyWishListState: getPropertyWishListState ?? this.getPropertyWishListState,
      getPropertyWishListFailureMessage: getPropertyWishListFailureMessage ?? this.getPropertyWishListFailureMessage,
    );
  }

  @override
   List<Object?> get props => [
    propertyWishList,
    getPropertyWishListState,
    getPropertyWishListFailureMessage,
  ];
}


