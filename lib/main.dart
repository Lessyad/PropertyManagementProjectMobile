import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:enmaa/features/vehicle_management/vehicle_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configuration/routers/app_routers.dart';
import 'configuration/routers/route_names.dart';
import 'core/components/custom_snack_bar.dart';
import 'core/components/need_to_login_component.dart';
import 'core/core_dependencies.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/firebase_messaging_service.dart';
import 'core/services/navigator_observer.dart';
import 'core/services/service_locator.dart';
import 'core/services/shared_preferences_service.dart';
import 'core/services/app_initialization_service.dart';
import 'core/translation/codegen_loader.g.dart';
import 'features/my_profile/modules/user_appointments/presentation/controller/user_appointments_cubit.dart';
import 'features/my_profile/modules/user_appointments/user_appointments_DI.dart';
import 'features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'features/real_estates/real_estates_DI.dart';
import 'features/wish_list/domain/use_cases/add_new_property_to_wish_list_use_case.dart';
import 'features/wish_list/domain/use_cases/add_vehicle_to_wish_list_use_case.dart';
import 'features/wish_list/domain/use_cases/check_vehicle_in_wish_list_use_case.dart';
import 'features/wish_list/domain/use_cases/get_properties_wish_list_use_case.dart';
import 'features/wish_list/domain/use_cases/get_vehicles_wish_list_use_case.dart';
import 'features/wish_list/domain/use_cases/remove_property_from_wish_list_use_case.dart';
import 'features/wish_list/domain/use_cases/remove_vehicle_from_wish_list_use_case.dart';
import 'features/wish_list/presentation/controller/vehicle_wish_list_cubit.dart';
import 'features/wish_list/presentation/controller/wish_list_cubit.dart';
import 'features/wish_list/wish_list_DI.dart';
import 'firebase_options.dart';

bool isAuth = false;
Future<void> backgroundHandler(
    NotificationResponse notificationResponse) async {
  // ignore: unused_local_variable
  final payload = notificationResponse.payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [BACKGROUND] Notification reçue en arrière-plan');
  print('🔔 [BACKGROUND] Titre: ${message.notification?.title ?? "Pas de titre"}');
  print('🔔 [BACKGROUND] Corps: ${message.notification?.body ?? "Pas de corps"}');
  print('🔔 [BACKGROUND] Data: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CoreDependencies.init();
  await VehicleDependencies.init();
  await SharedPreferencesService().init();
  await setupServiceLocator();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  Bloc.observer = MyBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await AppInitializationService().initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.get('access_token');
  isAuth = token != null;

  bool isFirstLaunch = await SharedPreferencesService().isFirstLaunch();

  if (isFirstLaunch) {
    String deviceLanguage =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    await SharedPreferencesService()
        .setLanguage(['en', 'ar', 'fr'].contains(deviceLanguage)
            ? deviceLanguage
            : 'en');
  }

  String initialRoute;
  if (isFirstLaunch) {
    initialRoute = RoutersNames.onBoardingScreen;
  } else if (token != null) {
    initialRoute = RoutersNames.biometricScreen;
  } else {
    initialRoute = RoutersNames.authenticationFlow;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;
  @override
  Widget build(BuildContext context) {
    final currentLanguage = SharedPreferencesService().language;
    context.setLocale(Locale(currentLanguage));

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FilterPropertyCubit(),
          ),
          BlocProvider(
            create: (context) =>
                SelectLocationServiceCubit.getOrCreate()..getCountries(),
          ),
          BlocProvider(
            create: (context) {
              UserAppointmentsDi().setup();
              return UserAppointmentsCubit(
                ServiceLocator.getIt(),
                ServiceLocator.getIt(),
                ServiceLocator.getIt(),
              );
            },
          ),
          BlocProvider(
            create: (context) {
              WishListDi().setup();
              return WishListCubit(
                ServiceLocator.getIt<GetPropertiesWishListUseCase>(),
                ServiceLocator.getIt<RemovePropertyFromWishListUseCase>(),
                ServiceLocator.getIt<AddNewPropertyToWishListUseCase>(),
                // ServiceLocator.getIt<GetVehiclesWishListUseCase>(),
                // getIt<RemoveVehicleFromWishListUseCase>(),
                // getIt<AddVehicleToWishListUseCase>(),
                // getIt<CheckVehicleInWishListUseCase>(),
              )..getPropertyWishList();
            },
          ),
          BlocProvider(
            create: (context) {
              WishListDi().setup();
              return VehicleWishListCubit(
                ServiceLocator.getIt<GetVehiclesWishListUseCase>(),
                ServiceLocator.getIt<RemoveVehicleFromWishListUseCase>(),
                ServiceLocator.getIt<AddVehicleToWishListUseCase>(),
                ServiceLocator.getIt<CheckVehicleInWishListUseCase>(),
              );
            },
          ),
          BlocProvider(
              create: (context) {
                RealEstatesDi().setup();

                if (ServiceLocator.getIt.isRegistered<RealEstateCubit>()) {
                  final cubit = ServiceLocator.getIt<RealEstateCubit>();
                  if (cubit.isClosed) {
                    ServiceLocator.getIt.unregister<RealEstateCubit>();
                  }
                }

                if (!ServiceLocator.getIt.isRegistered<RealEstateCubit>()) {
                  ServiceLocator.getIt.registerLazySingleton<RealEstateCubit>(
                        () =>
                        RealEstateCubit(
                          ServiceLocator.getIt(),
                          ServiceLocator.getIt(),
                        ),
                  );
                }
                return ServiceLocator.getIt<RealEstateCubit>();
              }
          ),

        ],
        child: MaterialApp(
          scaffoldMessengerKey: CustomSnackBar.scaffoldMessengerKey,
          navigatorObservers: [RouteObserverService()],
          debugShowCheckedModeBanner: false,
          navigatorKey : LoginBottomSheet.navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: Locale(SharedPreferencesService().language),
          theme: ThemeData(
            fontFamily: null, // Cairo supprimé (fichiers absents). Remettre 'Cairo' quand les polices sont de nouveau dans assets/fonts/cairo/
            visualDensity: Platform.isIOS
                ? VisualDensity.standard
                : VisualDensity.adaptivePlatformDensity, // Adjust for iOS
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS:
                    CupertinoPageTransitionsBuilder(), // iOS-style transition
                TargetPlatform.android:
                    FadeUpwardsPageTransitionsBuilder(), // Android default
              },
            ),
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor:
                  ColorManager.primaryColor, // Customize iOS theme if needed
            ),
          ),
          onGenerateRoute: AppRouters().generateRoute,
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}
