import 'package:enmaa/features/home_module/domain/use_cases/get_app_services_use_case.dart';
import 'package:enmaa/features/home_module/domain/use_cases/get_banners_use_case.dart';
import 'package:enmaa/features/home_module/presentation/controller/home_bloc.dart';
import 'package:enmaa/features/real_estates/data/data_source/remote_data/real_estate_remote_data_source.dart';
import 'package:enmaa/features/real_estates/domain/repository/base_real_estate_repository.dart';
import 'package:enmaa/features/real_estates/domain/use_cases/get_properties_use_case.dart';
import 'package:enmaa/features/real_estates/domain/use_cases/get_property_details_use_case.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';

import '../../core/services/service_locator.dart';
import 'data/repository/real_estate_repository.dart';

class RealEstatesDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();


    if(sl.isRegistered<RealEstateCubit>()) return;
    sl.registerLazySingleton<RealEstateCubit>(
          () => RealEstateCubit(
        sl<GetPropertiesUseCase>(),
        sl<GetPropertyDetailsUseCase>(),
      ),
    );


  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseRealEstateRemoteData>()) return;
    sl.registerLazySingleton<BaseRealEstateRemoteData>(
          () => RealEstateRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseRealEstateRepository>()) return;
    sl.registerLazySingleton<BaseRealEstateRepository>(
          () => RealEstateRepository(baseRealEstateRemoteData: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetPropertiesUseCase>()) return;
    sl.registerLazySingleton(
          () => GetPropertiesUseCase(sl()),
    );

    if(sl.isRegistered<GetPropertyDetailsUseCase>()) return;
    sl.registerLazySingleton(
          () => GetPropertyDetailsUseCase(sl()),
    );

  }
}