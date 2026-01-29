import 'package:enmaa/features/preview_property/data/data_source/preview_property_remote_data_source.dart';
import 'package:enmaa/features/preview_property/domain/repository/base_preview_property_repository.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/add_new_preview_time_use_case.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/get_available_hours_for_specific_property_use_case.dart';
import 'package:enmaa/features/preview_property/domain/use_cases/get_inspection_amount_to_be_paid_use_case.dart';
import '../../core/services/service_locator.dart';
import 'data/repository/preview_property_repository.dart';

class PreviewPropertyDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerDataSources() {
    if (sl.isRegistered<BasePreviewPropertyDataSource>()) {
      return;
    }
    sl.registerLazySingleton<BasePreviewPropertyDataSource>(
        () => PreviewPropertyRemoteDataSource(dioService: sl()));
  }

  void _registerRepositories() {
    if (sl.isRegistered<BasePreviewPropertyRepository>()) {
      return;
    }
    sl.registerLazySingleton<BasePreviewPropertyRepository>(
        () => PreviewPropertyRepository(basePreviewPropertyDataSource: sl()));
  }

  void _registerUseCases() {
    if (sl.isRegistered<GetAvailableHoursForSpecificPropertyUseCase>()) {
      return;
    }

    sl.registerLazySingleton<GetAvailableHoursForSpecificPropertyUseCase>(
        () => GetAvailableHoursForSpecificPropertyUseCase(sl()));
    sl.registerLazySingleton<GetInspectionAmountToBePaidUseCase>(
        () => GetInspectionAmountToBePaidUseCase(sl()));
    sl.registerLazySingleton<AddNewPreviewTimeUseCase>(
        () => AddNewPreviewTimeUseCase(sl()));
  }
}
