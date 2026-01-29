
import 'package:enmaa/features/my_booking/data/data_source/my_booking_remote_data_source.dart';
import 'package:enmaa/features/my_booking/data/repository/my_booking_repository.dart';
import 'package:enmaa/features/my_booking/domain/repository/base_booking_repository.dart';
import 'package:enmaa/features/my_booking/domain/use_cases/get_my_booking_use_case.dart';

import '../../core/services/service_locator.dart';

class MyBookingDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();



  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseMyBookingRemoteData>()) return;
    sl.registerLazySingleton<BaseMyBookingRemoteData>(
          () => MyBookingRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseMyBookingRepository>()) return;
    sl.registerLazySingleton<BaseMyBookingRepository>(
          () => MyBookingRepository(baseMyBookingRemoteData: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetMyBookingUseCase>()) return;
    sl.registerLazySingleton(
          () => GetMyBookingUseCase(sl()),
    );


  }
}