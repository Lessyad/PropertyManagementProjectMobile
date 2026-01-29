import 'package:enmaa/features/wish_list/domain/use_cases/get_properties_wish_list_use_case.dart';
import 'package:enmaa/features/wish_list/domain/use_cases/remove_property_from_wish_list_use_case.dart';
import '../../core/services/service_locator.dart';
import 'data/data_source/wish_list_remote_data_source.dart';
import 'data/repository/wish_list_repository.dart';
import 'domain/repository/base_wish_list_repository.dart';
import 'domain/use_cases/add_new_property_to_wish_list_use_case.dart';

class WishListDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerDataSources() {
    if (sl.isRegistered<BaseWishListDataSource>()) return;

    sl.registerLazySingleton<BaseWishListDataSource>(
      () => WishListRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if (sl.isRegistered<BaseWishListRepository>()) return;

    sl.registerLazySingleton<BaseWishListRepository>(
      () => WishListRepository(
        baseWishListDataSource: sl(),
      ),
    );
  }

  void _registerUseCases() {
    if (sl.isRegistered<GetPropertiesWishListUseCase>()) return;

    sl.registerLazySingleton(
      () => GetPropertiesWishListUseCase(sl()),
    );
    sl.registerLazySingleton(
      () => RemovePropertyFromWishListUseCase(sl()),
    );
    sl.registerLazySingleton(
      () => AddNewPropertyToWishListUseCase(sl()),
    );
  }
}
