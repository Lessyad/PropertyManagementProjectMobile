import 'package:bloc/bloc.dart';
import 'package:enmaa/core/errors/failure.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../domain/entities/vehicle_wish_list_entity.dart';
import '../../domain/use_cases/add_vehicle_to_wish_list_use_case.dart';
import '../../domain/use_cases/check_vehicle_in_wish_list_use_case.dart';
import '../../domain/use_cases/get_vehicles_wish_list_use_case.dart';
import '../../domain/use_cases/remove_vehicle_from_wish_list_use_case.dart';


part 'vehicle_wish_list_state.dart';

class VehicleWishListCubit extends HydratedCubit<VehicleWishListState> {
  final GetVehiclesWishListUseCase _getVehiclesWishListUseCase;
  final RemoveVehicleFromWishListUseCase _removeVehicleFromWishListUseCase;
  final AddVehicleToWishListUseCase _addVehicleToWishListUseCase;
  final CheckVehicleInWishListUseCase _checkVehicleInWishListUseCase;

  VehicleWishListCubit(
      this._getVehiclesWishListUseCase,
      this._removeVehicleFromWishListUseCase,
      this._addVehicleToWishListUseCase,
      this._checkVehicleInWishListUseCase,
      ) : super(VehicleWishListState());

  void getVehicleWishList() async {
    emit(state.copyWith(getVehicleWishListState: RequestState.loading));
    final result = await _getVehiclesWishListUseCase();
    result.fold(
          (failure) => emit(state.copyWith(
        getVehicleWishListState: RequestState.error,
        getVehicleWishListFailureMessage: failure.message,
      )),
          (vehicleWishList) => emit(state.copyWith(
        getVehicleWishListState: RequestState.loaded,
        vehicleWishList: vehicleWishList,
      )),
    );
  }

  // void removeVehicleFromWishList(int wishlistItemId) async {
  //   final updatedList = List<VehicleWishListEntity>.from(state.vehicleWishList)
  //     ..removeWhere((item) => item.id == wishlistItemId);
  //
  //   emit(state.copyWith(
  //     vehicleWishList: updatedList,
  //     getVehicleWishListState: RequestState.loading,
  //   ));
  //
  //   final result = await _removeVehicleFromWishListUseCase(wishlistItemId);
  //   result.fold(
  //         (failure) => emit(state.copyWith(
  //       vehicleWishList: state.vehicleWishList,
  //       getVehicleWishListState: RequestState.loaded,
  //     )),
  //         (_) => emit(state.copyWith(getVehicleWishListState: RequestState.loaded)),
  //   );
  // }
  // MODIFIEZ LA MÉTHODE removeVehicleFromWishList
  // Future<void> removeVehicleFromWishList(int vehicleId) async {
  //   // METTEZ À JOUR L'ÉTAT LOCAL IMMÉDIATEMENT
  //   updateVehicleWishlistStatus(vehicleId, false);
  //
  //   final result = await _removeVehicleFromWishListUseCase(vehicleId);
  //   result.fold(
  //         (failure) {
  //       // EN CAS D'ERREUR, ANNULER LE CHANGEMENT
  //       updateVehicleWishlistStatus(vehicleId, true);
  //       emit(state.copyWith(
  //         getVehicleWishListState: RequestState.error,
  //         getVehicleWishListFailureMessage: failure.message,
  //       ));
  //     },
  //         (success) {
  //       // if (!success) {
  //       //   // ANNULER SI L'API ÉCHOUE
  //       //   // updateVehicleWishlistStatus(vehicleId, true);
  //       // }
  //     },
  //   );
  // }
  // void removeVehicleFromWishList(int vehicleId) async {
  //   // Mettre à jour l'état local immédiatement
  //   updateVehicleWishlistStatus(vehicleId, false);
  //
  //   final result = await _removeVehicleFromWishListUseCase(vehicleId);
  //
  //   result.fold(
  //         (failure) {
  //       // En cas d'erreur, annuler le changement
  //       updateVehicleWishlistStatus(vehicleId, true);
  //       emit(state.copyWith(
  //         getVehicleWishListState: RequestState.error,
  //         getVehicleWishListFailureMessage: failure.message,
  //       ));
  //     },
  //         (success) {
  //       if (success != null && success) {
  //         // Recharger la liste si succès
  //         getVehicleWishList();
  //         emit(state.copyWith(
  //           getVehicleWishListState: RequestState.loaded,
  //         ));
  //       } else {
  //         // Gérer le cas où success est false ou null
  //         updateVehicleWishlistStatus(vehicleId, true);
  //         emit(state.copyWith(
  //           getVehicleWishListState: RequestState.error,
  //           getVehicleWishListFailureMessage: 'Failed to remove from wishlist',
  //         ));
  //       }
  //     },
  //   );
  // }

  // CORRECTION pour removeVehicleFromWishList
   Future<void> removeVehicleFromWishList(int vehicleId) async {
    updateVehicleWishlistStatus(vehicleId, false);

    final result = await _removeVehicleFromWishListUseCase(vehicleId);

    result.fold(
          (failure) {
        updateVehicleWishlistStatus(vehicleId, true);
        print('Error removing from wishlist: ${failure.message}');
        // Optionnel: émettre l'erreur seulement si nécessaire
      },
          (success) {
        // SIMPLIFIÉ - supposer que success est true si on arrive ici
        getVehicleWishList(); // Recharger la liste
      },
    );
  }

  // void addVehicleToWishList(int vehicleId) async {
  //   emit(state.copyWith(getVehicleWishListState: RequestState.loading));
  //   final result = await _addVehicleToWishListUseCase(vehicleId);
  //   result.fold(
  //         (failure) => emit(state.copyWith(
  //       getVehicleWishListState: RequestState.error,
  //       getVehicleWishListFailureMessage: failure.message,
  //     )),
  //         (newItem) => emit(state.copyWith(
  //       getVehicleWishListState: RequestState.loaded,
  //       vehicleWishList: [...state.vehicleWishList, newItem],
  //     )),
  //   );
  // }

  // Dans les méthodes
  // void addVehicleToWishList(int vehicleId) async {
  //   emit(state.copyWith(getVehicleWishListState: RequestState.loading));
  //   final result = await _addVehicleToWishListUseCase(vehicleId);
  //   result.fold(
  //         (failure) => emit(state.copyWith(
  //       getVehicleWishListState: RequestState.error,
  //       getVehicleWishListFailureMessage: failure.message,
  //     )),
  //         (success) {
  //       if (success) {
  //         // Recharger la liste après l'ajout
  //         getVehicleWishList();
  //         // Vérifier si le véhicule est dans la wishlist
  //         checkVehicleInWishList(vehicleId);
  //       } else {
  //         emit(state.copyWith(
  //           getVehicleWishListState: RequestState.error,
  //           getVehicleWishListFailureMessage: 'Erreur lors de l\'ajout à la wishlist',
  //         ));
  //       }
  //     },
  //   );
      // }

  // Future<void> addVehicleToWishList(int vehicleId) async {
  //       // METTEZ À JOUR L'ÉTAT LOCAL IMMÉDIATEMENT
  //   updateVehicleWishlistStatus(vehicleId, true);
  //
  //   final result = await _addVehicleToWishListUseCase(vehicleId);
  //   result.fold(
  //         (failure) {
  //       // EN CAS D'ERREUR, ANNULER LE CHANGEMENT
  //       updateVehicleWishlistStatus(vehicleId, false);
  //       emit(state.copyWith(
  //         getVehicleWishListState: RequestState.error,
  //         getVehicleWishListFailureMessage: failure.message,
  //       ));
  //     },
  //         (success) {
  //       if (success) {
  //         // RECHARGER LA VRAIE LISTE
  //         getVehicleWishList();
  //       } else {
  //         // ANNULER SI L'API ÉCHOUE
  //         updateVehicleWishlistStatus(vehicleId, false);
  //       }
  //     },
  //   );
  // }
  Future<void> addVehicleToWishList(int vehicleId) async {
    // Mettre à jour l'état local immédiatement
    updateVehicleWishlistStatus(vehicleId, true);

    final result = await _addVehicleToWishListUseCase(vehicleId);

    result.fold(
          (failure) {
        // En cas d'erreur, annuler le changement
        updateVehicleWishlistStatus(vehicleId, false);
        // Émettre l'erreur seulement si c'est une vraie erreur
        emit(state.copyWith(
          getVehicleWishListState: RequestState.error,
          getVehicleWishListFailureMessage: failure.message,
        ));
      },
          (success) {
        if (success) {
          // Recharger la liste si succès
          getVehicleWishList();
          // Émettre un état de succès
          emit(state.copyWith(
            getVehicleWishListState: RequestState.loaded,
          ));
        } else {
          // Annuler si l'API échoue silencieusement
          updateVehicleWishlistStatus(vehicleId, false);
          emit(state.copyWith(
            getVehicleWishListState: RequestState.error,
            getVehicleWishListFailureMessage: 'Failed to add to wishlist',
          ));
        }
      },
    );
  }
  void checkVehicleInWishList(int vehicleId) async {
    final result = await _checkVehicleInWishListUseCase(vehicleId);
    result.fold(
          (failure) => emit(state.copyWith(isVehicleInWishList: false)),
          (isInWishlist) => emit(state.copyWith(isVehicleInWishList: isInWishlist)),
    );
  }

  void updateVehicleWishlistStatus(int vehicleId, bool inWishlist) {
    final currentState = state;
    final updatedWishList = inWishlist
        ? [...currentState.vehicleWishList, _createWishlistItem(vehicleId)]
        : currentState.vehicleWishList.where((item) => item.vehicleId != vehicleId).toList();

    emit(currentState.copyWith(vehicleWishList: updatedWishList));
  }
  VehicleWishListEntity _createWishlistItem(int vehicleId) {
    return VehicleWishListEntity(
      id: vehicleId, // Utilisez l'ID du véhicule temporairement
      vehicleId: vehicleId,
      vehicleModel: '',
      vehicleBrand: '',
      dailyPrice: 0,
      imageUrl: [],
      addedDate: DateTime.now(),
      notes: null,
      isAvailable: true,
      year: 0,
      fuelType: '',
      transmission: '',
      seats: 0,
    );
  }

  @override
  VehicleWishListState? fromJson(Map<String, dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic>? toJson(VehicleWishListState state) {
    return null;
  }
}