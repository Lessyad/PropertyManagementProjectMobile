import 'package:enmaa/core/services/firebase_messaging_service.dart';
import 'package:enmaa/core/services/service_locator.dart';

class CoreServicesDI {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerServices();
  }

  void _registerServices() {
    // Enregistrer le service Firebase Messaging
    sl.registerLazySingleton<BaseFireBaseMessaging>(
      () => FireBaseMessaging(),
    );
  }
}

