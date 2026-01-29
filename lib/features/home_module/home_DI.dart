// import 'package:enmaa/features/home_module/data/repository/home_repository.dart';
// import 'package:enmaa/features/home_module/domain/repository/base_home_repository.dart';
// import 'package:enmaa/features/home_module/domain/use_cases/get_app_services_use_case.dart';
// import 'package:enmaa/features/home_module/domain/use_cases/get_banners_use_case.dart';
// import 'package:enmaa/features/home_module/presentation/controller/home_bloc.dart';
// import 'package:enmaa/features/real_estates/domain/use_cases/get_properties_use_case.dart';
//
// import '../../core/services/service_locator.dart';
// import '../real_estates/real_estates_DI.dart';
// import 'data/data_source/remote_data/home_remote_data_source.dart';
// import 'domain/use_cases/get_notifications_use_case.dart';
// import 'domain/use_cases/update_user_location_use_case.dart';
//
// class HomeDi {
//   final sl = ServiceLocator.getIt;
//
//   Future<void> setup() async {
//
//     _registerRemoteDataSource();
//     _registerRepositories();
//     _registerUseCases();
//
//
//
//
//
//   }
//
//
//   void _registerRemoteDataSource() {
//     sl.registerLazySingleton<BaseHomeRemoteData>(
//           () => HomeRemoteDataSource(dioService: sl()),
//     );
//   }
//
//   void _registerRepositories() {
//     sl.registerLazySingleton<BaseHomeRepository>(
//           () => HomeRepository(baseHomeRemoteData: sl()),
//     );
//   }
//
//   void _registerUseCases() {
//     sl.registerLazySingleton(
//           () => GetBannersUseCase(sl()),
//     );
//     sl.registerLazySingleton(
//           () => GetAppServicesUseCase(sl()),
//     );
//     sl.registerLazySingleton(
//           () => UpdateUserLocationUseCase(sl()),
//     );
//     sl.registerLazySingleton(
//           () => GetNotificationsUseCase(sl()),
//     );
//     if(!sl.isRegistered<GetPropertiesUseCase>()){
//       RealEstatesDi().setup();
//     }
//
//
//   }
// }

import 'package:enmaa/features/home_module/data/repository/home_repository.dart';
import 'package:enmaa/features/home_module/domain/repository/base_home_repository.dart';
import 'package:enmaa/features/home_module/domain/use_cases/get_app_services_use_case.dart';
import 'package:enmaa/features/home_module/domain/use_cases/get_banners_use_case.dart';
import 'package:enmaa/features/home_module/domain/use_cases/get_notifications_use_case.dart';
import 'package:enmaa/features/home_module/domain/use_cases/update_user_location_use_case.dart';
import 'package:enmaa/features/home_module/presentation/controller/home_bloc.dart';
import 'package:enmaa/features/real_estates/domain/use_cases/get_properties_use_case.dart';


import '../../core/services/service_locator.dart';
import '../real_estates/real_estates_DI.dart';
import '../wish_list/domain/use_cases/add_vehicle_to_wish_list_use_case.dart';
import '../wish_list/domain/use_cases/remove_vehicle_from_wish_list_use_case.dart';
import '../wish_list/vehicle_wish_list_di.dart';
import 'data/data_source/remote_data/home_remote_data_source.dart';

class HomeDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();
    _registerBloc(); // AJOUT DE CETTE LIGNE
  }

  void _registerRemoteDataSource() {
    sl.registerLazySingleton<BaseHomeRemoteData>(
          () => HomeRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    sl.registerLazySingleton<BaseHomeRepository>(
          () => HomeRepository(baseHomeRemoteData: sl()),
    );
  }

  void _registerUseCases() {
    sl.registerLazySingleton(() => GetBannersUseCase(sl()));
    sl.registerLazySingleton(() => GetAppServicesUseCase(sl()));
    sl.registerLazySingleton(() => UpdateUserLocationUseCase(sl()));
    sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));

    if (!sl.isRegistered<GetPropertiesUseCase>()) {
      RealEstatesDi().setup();
    }

    // ASSUREZ-VOUS QUE LES USE CASES VÉHICULES SONT ENREGISTRÉS
    if (!sl.isRegistered<AddVehicleToWishListUseCase>() ||
        !sl.isRegistered<RemoveVehicleFromWishListUseCase>()) {
      VehicleWishListDi().setup();
    }
  }

  // NOUVELLE MÉTHODE POUR ENREGISTRER LE BLOC
  void _registerBloc() {
    sl.registerFactory(() => HomeBloc(
      sl<GetNotificationsUseCase>(),
      sl<UpdateUserLocationUseCase>(),
      sl<GetBannersUseCase>(),
      sl<GetAppServicesUseCase>(),
      sl<GetPropertiesUseCase>(),
      // AJOUT DES USE CASES VÉHICULES
      sl<AddVehicleToWishListUseCase>(),
      sl<RemoveVehicleFromWishListUseCase>(),
    ));
  }
}