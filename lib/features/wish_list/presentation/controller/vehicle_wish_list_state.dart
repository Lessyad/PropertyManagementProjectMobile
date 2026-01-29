part of 'vehicle_wish_list_cubit.dart';



class VehicleWishListState extends Equatable {
  const VehicleWishListState({
    this.vehicleWishList = const <VehicleWishListEntity>[],
    this.getVehicleWishListState = RequestState.initial,
    this.getVehicleWishListFailureMessage = '',
    this.isVehicleInWishList = false,
  });

  final List<VehicleWishListEntity> vehicleWishList;
  final RequestState getVehicleWishListState;
  final String getVehicleWishListFailureMessage;
  final bool isVehicleInWishList;

  VehicleWishListState copyWith({
    List<VehicleWishListEntity>? vehicleWishList,
    RequestState? getVehicleWishListState,
    String? getVehicleWishListFailureMessage,
    bool? isVehicleInWishList,
  }) {
    return VehicleWishListState(
      vehicleWishList: vehicleWishList ?? this.vehicleWishList,
      getVehicleWishListState: getVehicleWishListState ?? this.getVehicleWishListState,
      getVehicleWishListFailureMessage: getVehicleWishListFailureMessage ?? this.getVehicleWishListFailureMessage,
      isVehicleInWishList: isVehicleInWishList ?? this.isVehicleInWishList,
    );
  }

  @override
  List<Object?> get props => [
    vehicleWishList,
    getVehicleWishListState,
    getVehicleWishListFailureMessage,
    isVehicleInWishList,
  ];
}