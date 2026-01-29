import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/entites/image_entity.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/home_module/domain/use_cases/get_app_services_use_case.dart';
import 'package:enmaa/features/home_module/domain/use_cases/get_notifications_use_case.dart';
import 'package:enmaa/features/real_estates/domain/use_cases/get_properties_use_case.dart';
import 'package:enmaa/features/real_estates/real_estates_DI.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/json_keys.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/utils/enums.dart';
import '../../../real_estates/domain/entities/base_property_entity.dart';

import '../../../wish_list/domain/use_cases/add_vehicle_to_wish_list_use_case.dart';
import '../../../wish_list/domain/use_cases/remove_vehicle_from_wish_list_use_case.dart';
import '../../domain/entities/app_service_entity.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/get_banners_use_case.dart';
import '../../domain/use_cases/update_user_location_use_case.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBannersUseCase getBannersUseCase;
  final GetAppServicesUseCase getAppServicesUseCase;
  final GetPropertiesUseCase getRealEstatesUseCase;
  final UpdateUserLocationUseCase updateUserLocationUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;

  // AJOUT DES USE CASES POUR LES VÉHICULES
  final AddVehicleToWishListUseCase addVehicleToWishListUseCase;
  final RemoveVehicleFromWishListUseCase removeVehicleFromWishListUseCase;

  HomeBloc(
      this.getNotificationsUseCase,
      this.updateUserLocationUseCase,
      this.getBannersUseCase,
      this.getAppServicesUseCase,
      this.getRealEstatesUseCase,
      // AJOUT DES USE CASES VÉHICULES
      this.addVehicleToWishListUseCase,
      this.removeVehicleFromWishListUseCase,
      ) : super(const HomeState()) {

    on<FetchBanners>(_onFetchBanners);
    on<FetchAppServices>(_onFetchAppServices);
    on<FetchNearByProperties>(_onFetchNearByProperties);
    on<GetNotifications>(_onFetchNotifications);
    on<FetchAllPropertiesByType>(_onFetchAllPropertiesByType);

    on<AddPropertyToWishlist>(_onAddPropertyToWishlist);
    on<RemovePropertyFromWishlist>(_onRemovePropertyFromWishlist);

    // AJOUT DES ÉVÉNEMENTS VÉHICULES
    on<AddVehicleToWishlist>(_onAddVehicleToWishlist);
    on<RemoveVehicleFromWishlist>(_onRemoveVehicleFromWishlist);

    on<UpdateUserLocation>(_onUpdateUserLocation);
    on<GetUserLocation>(_onGetUserLocation);
    on<RemoveProperty>(_onRemoveProperty);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<SearchProperties>(_onSearchProperties);
  }

  // MÉTHODES EXISTANTES POUR LES PROPRIÉTÉS
  void _onUpdateSearchQuery(UpdateSearchQuery event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onSearchProperties(
      SearchProperties event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      searchPropertiesState: RequestState.loading,
      searchErrorMessage: '',
    ));

    final Either<Failure, List<PropertyEntity>> result = await getRealEstatesUseCase(
      filters: {
        'search': event.query,
      },
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          searchPropertiesState: RequestState.error,
          searchErrorMessage: failure.message,
        ));
      },
          (properties) {
        emit(state.copyWith(
          searchPropertiesState: RequestState.loaded,
          searchProperties: properties,
        ));
      },
    );
  }

  Future<void> _onFetchNotifications(
      GetNotifications event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(getNotificationsState: RequestState.loading));

    if(SharedPreferencesService().accessToken.isEmpty){
      emit(state.copyWith(
        getNotificationsState: RequestState.loaded,
        notifications: [],
      ));
      return;
    }
    final Either<Failure, List<NotificationEntity>> result =
    await getNotificationsUseCase();

    result.fold(
          (failure) => emit(state.copyWith(
        getNotificationsState: RequestState.error,
        errorMessage: failure.message,
      )),
          (notifications) {
        emit(state.copyWith(
          getNotificationsState: RequestState.loaded,
          notifications: notifications,
        ));
      },
    );
  }

  Future<void> _onRemoveProperty(
      RemoveProperty event,
      Emitter<HomeState> emit,
      ) async {
    final propertyId = event.propertyId;
    final propertyType = event.propertyType;

    final updatedProperties = Map<PropertyType, PropertyData>.from(state.properties);

    final propertyData = updatedProperties[propertyType];
    if (propertyData == null || propertyData.properties.isEmpty) {
      return;
    }

    final index = propertyData.properties.indexWhere(
          (property) => property.id.toString() == propertyId,
    );

    if (index == -1) {
      return;
    }

    final updatedPropertyList = List<PropertyEntity>.from(propertyData.properties);
    updatedPropertyList.removeAt(index);

    updatedProperties[propertyType] = propertyData.copyWith(
      properties: updatedPropertyList,
    );

    emit(state.copyWith(properties: updatedProperties));
  }

  Future<void> _onGetUserLocation(
      GetUserLocation event,
      Emitter<HomeState> emit,
      ) async {

    emit(state.copyWith(
      updateUserLocationState: RequestState.loading,
    ));
    SharedPreferences.getInstance().then((pref){
      String cityName = pref.getString('city_name')??'';

      emit(state.copyWith(
        selectedCityName: cityName,
        updateUserLocationState: RequestState.loaded,
      ));
    });
  }

  Future<void> _onUpdateUserLocation(
      UpdateUserLocation event,
      Emitter<HomeState> emit,
      ) async {
    emit (state.copyWith(updateUserLocationState: RequestState.loading));
    final Either<Failure, void> result = await updateUserLocationUseCase(event.cityID);

    result.fold(
          (failure) => emit(state.copyWith(
        updateUserLocationState: RequestState.error,
        errorMessage: failure.message,
      )),
          (_) {
        SharedPreferences.getInstance().then((pref){
          pref.setString('city_name', event.cityName);
          pref.setString('city_id', event.cityID);
        });
        emit(state.copyWith(
          selectedCityName: event.cityName,
          updateUserLocationState: RequestState.loaded,
        ));
      },
    );
  }

  Future<void> _onFetchBanners(
      FetchBanners event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(bannersState: RequestState.loading));

    final Either<Failure, List<ImageEntity>> result =
    await getBannersUseCase();

    result.fold(
          (failure) => emit(state.copyWith(
        bannersState: RequestState.error,
        errorMessage: failure.message,
      )),
          (banners) {
        emit(state.copyWith(
          bannersState: RequestState.loaded,
          banners: banners,
        ));
      },
    );
  }

  Future<void> _onFetchAppServices(
      FetchAppServices event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(appServicesState: RequestState.loading));

    final Either<Failure, List<AppServiceEntity>> result =
    await getAppServicesUseCase();

    result.fold(
          (failure) {
        emit(state.copyWith(
          appServicesState: RequestState.error,
          errorMessage: failure.message,
        ));
      },
          (appServices) {
        List<AppServiceEntity> appServicessList = [
          AppServiceEntity(
            text: LocaleKeys.realEstate,
            image: AppAssets.aqarIcon,
          ),
          AppServiceEntity(
            text: LocaleKeys.vehiclesSearchscreen,
            image: AppAssets.carIcon,
          ),
          AppServiceEntity(
            text:  LocaleKeys.halls,
            image: AppAssets.hallIcon,
          ),
          AppServiceEntity(
            text: LocaleKeys.hotels,
            image: AppAssets.hotelIcon,
          ),
        ];

        emit(state.copyWith(
          appServicesState: RequestState.loaded,
          appServices: appServicessList,
        ));
      },
    );
  }

  Future<void> _onFetchNearByProperties(
      FetchNearByProperties event, Emitter<HomeState> emit) async {
    final propertyType = event.propertyType;

    emit(state.copyWith(
      properties: {
        ...state.properties,
        propertyType: PropertyData(state: RequestState.loading),
      },
    ));

    final Either<Failure, List<PropertyEntity>> result = await getRealEstatesUseCase(
        filters:
        {
          JsonKeys.propertyTypeName: propertyType.toEnglish,
          JsonKeys.limit : event.numberOfProperties,
          JsonKeys.offset  : 0,
          JsonKeys.country : event.location,
        }
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          properties: {
            ...state.properties,
            propertyType: PropertyData(
              state: RequestState.error,
              errorMessage: failure.message,
            ),
          },
        ));
      },
          (properties) {
        emit(state.copyWith(
          properties: {
            ...state.properties,
            propertyType: PropertyData(
              state: RequestState.loaded,
              properties: properties,
            ),
          },
        ));
      },
    );
  }

  Future<void> _onAddPropertyToWishlist(
      AddPropertyToWishlist event, Emitter<HomeState> emit) async {
    final propertyType = event.propertyType;
    final propertyId = event.propertyId;

    final PropertyData? propertyData = state.properties[propertyType];

    if (propertyData == null || propertyData.state != RequestState.loaded) {
      return;
    }

    final List<PropertyEntity> updatedProperties = propertyData.properties.map((property) {
      if (property.id.toString() == propertyId) {
        return property.copyWith(isInWishlist: true);
      }
      return property;
    }).toList();

    emit(state.copyWith(
      properties: {
        ...state.properties,
        propertyType: PropertyData(
          state: RequestState.loaded,
          properties: updatedProperties,
          errorMessage: propertyData.errorMessage,
        ),
      },
    ));
  }

  Future<void> _onRemovePropertyFromWishlist(
      RemovePropertyFromWishlist event, Emitter<HomeState> emit) async {
    final propertyType = event.propertyType;
    final propertyId = event.propertyId;

    final PropertyData? propertyData = state.properties[propertyType];

    if (propertyData == null || propertyData.state != RequestState.loaded) {
      return;
    }

    final List<PropertyEntity> updatedProperties = propertyData.properties.map((property) {
      if (property.id.toString() == propertyId) {
        return property.copyWith(isInWishlist: false);
      }
      return property;
    }).toList();

    emit(state.copyWith(
      properties: {
        ...state.properties,
        propertyType: PropertyData(
          state: RequestState.loaded,
          properties: updatedProperties,
          errorMessage: propertyData.errorMessage,
        ),
      },
    ));
  }

  Future<void> _onFetchAllPropertiesByType(
      FetchAllPropertiesByType event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      allPropertiesState: RequestState.loading,
    ));

    final Either<Failure, List<PropertyEntity>> result = await getRealEstatesUseCase(
        filters: {
          JsonKeys.propertyTypeName: event.propertyType.toEnglish,
          JsonKeys.limit: event.limit,
          JsonKeys.offset: event.offset,
          JsonKeys.country: event.location,
        }
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          allPropertiesState: RequestState.error,
          errorMessage: failure.message,
        ));
      },
          (properties) {
        emit(state.copyWith(
          allPropertiesState: RequestState.loaded,
          allProperties: properties,
        ));
      },
    );
  }

  // NOUVELLES MÉTHODES POUR LES VÉHICULES
  Future<void> _onAddVehicleToWishlist(
      AddVehicleToWishlist event, Emitter<HomeState> emit) async {
    try {
      final result = await addVehicleToWishListUseCase(int.parse(event.vehicleId));

      result.fold(
            (failure) {
          // Vous pouvez logger l'erreur ou mettre à jour l'état d'erreur
          print('Erreur lors de l\'ajout du véhicule à la wishlist: ${failure.message}');
        },
            (success) {
          if (success) {
            print('Véhicule ajouté à la wishlist avec succès');
            // Ici vous pourriez mettre à jour l'état local des véhicules si nécessaire
          } else {
            print('Échec de l\'ajout du véhicule à la wishlist');
          }
        },
      );
    } catch (e) {
      print('Exception dans _onAddVehicleToWishlist: $e');
    }
  }

  Future<void> _onRemoveVehicleFromWishlist(
      RemoveVehicleFromWishlist event, Emitter<HomeState> emit) async {
    try {
      final result = await removeVehicleFromWishListUseCase(int.parse(event.vehicleId));

      result.fold(
            (failure) {
          // Vous pouvez logger l'erreur ou mettre à jour l'état d'erreur
          print('Erreur lors du retrait du véhicule de la wishlist: ${failure.message}');
        },
            (success) {
          // if (success) {
          //   print('Véhicule retiré de la wishlist avec succès');
          //   // Ici vous pourriez mettre à jour l'état local des véhicules si nécessaire
          // } else {
          //   print('Échec du retrait du véhicule de la wishlist');
          // }
        },
      );
    } catch (e) {
      print('Exception dans _onRemoveVehicleFromWishlist: $e');
    }
  }
}