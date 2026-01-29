import 'package:enmaa/features/add_new_real_estate/data/data_source/add_new_real_estate_remote_data_source.dart';
import 'package:enmaa/features/add_new_real_estate/data/repository/add_new_real_estate_repository.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_new_apartment_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_new_building_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_new_land_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/add_villa_use_case.dart';
import 'package:enmaa/features/add_new_real_estate/domain/use_cases/get_property_amenities_use_case.dart';
import 'package:enmaa/features/book_property/data/data_source/book_property_remote_data_source.dart';
import 'package:enmaa/features/book_property/data/repository/book_property_repository.dart';
import 'package:enmaa/features/book_property/domain/repository/base_book_property_repository.dart';
import 'package:enmaa/features/book_property/domain/use_cases/get_property_sale_details_use_case.dart';

import '../../core/services/service_locator.dart';
import 'domain/use_cases/book_property_use_case.dart';


class BookPropertyDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerDataSources();
    _registerRepositories();
    _registerUseCases();


  }


  void _registerDataSources() {

    if(sl.isRegistered<BaseBookPropertyRemoteDataSource>()) return;

    sl.registerLazySingleton<BaseBookPropertyRemoteDataSource>(
          () => BookPropertyRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseBookPropertyRepository>()) return;

    sl.registerLazySingleton<BaseBookPropertyRepository>(
          () => BookPropertyRepository(baseBookPropertyRemoteDataSource: sl(), ),
    );
  }

  void _registerUseCases() {

    if(sl.isRegistered<GetPropertySaleDetailsUseCase>()) return;

    sl.registerLazySingleton(
          () => GetPropertySaleDetailsUseCase (sl()),
    );
    sl.registerLazySingleton(
          () => BookPropertyUseCase (sl()),
    );


  }
}