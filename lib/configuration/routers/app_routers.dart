 
import 'package:enmaa/features/authentication_module/presentation/screens/bio_metric_screen.dart';
 
import 'package:enmaa/features/book_property/presentation/screens/book_property_main_screen.dart';
import 'package:enmaa/features/home_module/presentation/controller/home_bloc.dart';
 
import 'package:enmaa/features/home_module/presentation/screens/home_search_screen.dart';
import 'package:enmaa/features/home_module/presentation/screens/notifications_screen.dart';
import 'package:enmaa/features/home_module/presentation/screens/see_all_screen.dart';
 import 'package:enmaa/features/my_profile/modules/user_appointments/presentation/screens/user_appointments_screen.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/user_data_DI.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/presentation/screens/user_properties_screen.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/user_properties_DI.dart';
import 'package:enmaa/features/my_profile/presentation/screens/change_password_screen.dart';
import 'package:enmaa/features/preview_property/presentation/screens/preview_property_main_screen.dart';
import 'package:enmaa/features/preview_property/preview_property_DI.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/screens/real_estate_details_screen.dart';
import 'package:enmaa/features/real_estates/presentation/screens/real_estates_map_screen.dart';
import 'package:enmaa/features/splash_and_on_boarding/screens/on_boarding_screen.dart';
import 'package:enmaa/features/wallet/presentation/controller/wallet_cubit.dart';
import 'package:enmaa/features/wallet/presentation/screens/withdraw_screen.dart';
import 'package:enmaa/features/wallet/wallet_DI.dart';
import 'package:enmaa/features/wish_list/presentation/screens/wish_list_screen.dart';
import 'package:enmaa/features/wish_list/vehicle_wish_list_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/biometric_bloc.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import 'package:enmaa/features/authentication_module/presentation/screens/create_new_password_screen.dart';
import 'package:enmaa/features/authentication_module/presentation/screens/login_screen.dart';
import 'package:enmaa/features/authentication_module/presentation/screens/otp_screen.dart';
import 'package:enmaa/features/authentication_module/presentation/screens/reset_password_screen.dart';
import 'package:enmaa/features/authentication_module/presentation/screens/sign_up_screen.dart';
import 'package:enmaa/features/authentication_module/authentication_flow_navigator.dart';
import 'package:enmaa/features/home_module/presentation/screens/home_screen.dart';
import 'package:enmaa/layout_screen.dart';
import 'package:enmaa/features/my_booking/presentation/screens/my_booking_screen.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/presenation/screens/contact_us_screen.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/presentation/screens/edit_user_data_screen.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/presentation/screens/user_electronic_contracts_screen.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/presentation/controller/user_data_cubit.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/user_data_DI.dart';
import 'package:enmaa/features/my_profile/presentation/controller/change_password_controller/change_password_cubit.dart';
import 'package:enmaa/features/preview_property/presentation/controller/preview_property_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:enmaa/features/real_estates/real_estates_DI.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/screens/vehicle_details_screen.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/screens/vehicles_screen.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/screens/rent_vehicle_main_screen.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/screens/location_picker_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/screens/add_new_real_estate_screen.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/presentation/controller/user_properties_cubit.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/user_electronic_contracts_DI.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/presentation/controller/user_electronic_contracts_cubit.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/contact_us_DI.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/presenation/controller/contact_us_cubit.dart';
 
import 'package:enmaa/features/wallet/presentation/screens/charge_wallet_screen.dart';
import 'package:enmaa/features/wallet/presentation/screens/see_all_transactions.dart';
 
import 'route_names.dart';
import '../../core/screens/splash_screen.dart';

class AppRouters {
  AppRouters();

  static final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutersNames.splash:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.splash),
          builder: (_) => const SplashScreen(),
        );

      case RoutersNames.layoutScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.layoutScreen),
          builder: (_) => BlocProvider(
            create: (context) {
              // S'assurer que les dépendances des véhicules sont configurées
              VehicleWishListDi().setup();
              
              if (ServiceLocator.getIt.isRegistered<HomeBloc>()) {
                final bloc = ServiceLocator.getIt<HomeBloc>();
                if (bloc.isClosed) {
                  ServiceLocator.getIt.unregister<HomeBloc>();
                }
              }

              if (!ServiceLocator.getIt.isRegistered<HomeBloc>()) {
                ServiceLocator.getIt.registerLazySingleton<HomeBloc>(
                  () => HomeBloc(
                    ServiceLocator.getIt(),
                    ServiceLocator.getIt(),
                    ServiceLocator.getIt(),
                    ServiceLocator.getIt(),
                    ServiceLocator.getIt(),
                    ServiceLocator.getIt(),
                    ServiceLocator.getIt(),
                  )
                    ..add(GetUserLocation())
                    ..add(GetNotifications()),
                );
              }

              return ServiceLocator.getIt<HomeBloc>()
                ..add(FetchBanners())
                ..add(FetchAppServices());
            },
            child: const LayoutScreen(initialIndex: 0),
          ),
        );
      case RoutersNames.seeAllPropertiesScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final String appBarTextMessage = args['appBarTextMessage'] as String;
        final PropertyType propertyType = args['propertyType'];
        final HomeBloc homeBloc = ServiceLocator.getIt<HomeBloc>();
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.seeAllPropertiesScreen),
          builder: (_) => BlocProvider.value(
            value: homeBloc,
            child: SeeAllScreen(
              appBarTextMessage: appBarTextMessage,
              propertyType: propertyType,
            ),
          ),
        );
      case RoutersNames.notificationsScreen:
        final numberOfNotifications = settings.arguments as int;

        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.notificationsScreen),
          builder: (_) => NotificationsScreen(
            numberOfNotifications: numberOfNotifications,
          ),
        );

      case RoutersNames.biometricScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.biometricScreen),
          builder: (_) => BlocProvider(
            create: (context) => BiometricBloc(
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
            ),
            child: const BioMetricScreen(),
          ),
        );
      case RoutersNames.myPropertiesScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.myPropertiesScreen),
          builder: (_) => BlocProvider(
            create: (context) {
              UserPropertiesDi().setup();

              return UserPropertiesCubit(
                ServiceLocator.getIt(),
                ServiceLocator.getIt(),
              );
            },
            child: const MyPropertiesScreen(),
          ),
        );
      case RoutersNames.userAppointmentsScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.userAppointmentsScreen),
          builder: (_) => const UserAppointmentsScreen(),
        );
      case RoutersNames.withdrawScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.withdrawScreen),
          builder: (_) => const WithdrawScreen(),
        );
      case RoutersNames.seeAllTransactionsScreen:
        final walletCubit = settings.arguments as WalletCubit;

        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.seeAllTransactionsScreen),
          builder: (_) => SeeAllTransactionsScreen(
            walletCubit: walletCubit,
          ),
        );
      case RoutersNames.changePasswordScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.changePasswordScreen),
          builder: (_) => BlocProvider(
            create: (context) => ChangePasswordCubit(),
            child: ChangePasswordScreen(),
          ),
        );
      case RoutersNames.userElectronicContracts:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.userElectronicContracts),
          builder: (_) => BlocProvider(
            create: (context) {
              UserElectronicContractsDi().setup();
              return UserElectronicContractsCubit(
                ServiceLocator.getIt(),
              )..getUserElectronicContracts();
            },
            child: UserElectronicContractsScreen(),
          ),
        );

      case RoutersNames.realEstateDetailsScreen:
        final args = (settings.arguments as int).toString();
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.realEstateDetailsScreen),
          builder: (_) => RealEstateDetailsScreen(propertyId: args),
        );
      case RoutersNames.contactUsScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.contactUsScreen),
          builder: (_) => BlocProvider(
            create: (context) {
              ContactUsDi().setup();
              return ContactUsCubit(ServiceLocator.getIt());
            },
            child: ContactUsScreen(),
          ),
        );

      case RoutersNames.addNewRealEstateScreen:
        final args = settings.arguments;
        String? propertyID;
        if (args != null) {
          propertyID = args as String;
        }

        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.addNewRealEstateScreen),
          builder: (_) => AddNewRealEstateScreen(
            propertyID: propertyID,
          ),
        );
      case RoutersNames.bookPropertyScreen:
        final args = settings.arguments;
        // 🆕 Accepter String ou Map pour la compatibilité
        String propertyId;
        String? operation;
        String? monthlyRentPeriod;
        
        if (args is Map<String, dynamic>) {
          propertyId = args['propertyId'] as String;
          operation = args['operation'] as String?;
          monthlyRentPeriod = args['monthlyRentPeriod'] as String?;
        } else {
          // Pour compatibilité avec l'ancien code
          propertyId = args as String;
        }
        
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.bookPropertyScreen),
          builder: (_) => BookPropertyMainScreen(
            propertyId: propertyId,
            operation: operation, // 🆕 Passer les paramètres
            monthlyRentPeriod: monthlyRentPeriod, // 🆕 Passer les paramètres
          ),
        );

      case RoutersNames.onBoardingScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.onBoardingScreen),
          builder: (_) => const OnBoardingScreen(),
        );
      case RoutersNames.authenticationFlow:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.authenticationFlow),
          builder: (_) => const AuthenticationNavigator(),
        );
      case RoutersNames.chargeWalletScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.chargeWalletScreen),
          builder: (_) => ChargeWalletScreen(),
        );

      case RoutersNames.editUserDataScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RoutersNames.editUserDataScreen),
          builder: (_) => BlocProvider(
            create: (context) {
              UserDataDi().setup();
              final userCubit = UserDataCubit(
                ServiceLocator.getIt(),
                ServiceLocator.getIt(),
              );
              return userCubit;
            },
            child: const EditUserDataScreen(),
          ),
        );
      case RoutersNames.previewPropertyScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final String propertyId = args['id'] as String;
        bool updateAppointment = false;
        if (args.containsKey('updateAppointment')) {
          updateAppointment = args['updateAppointment'] as bool;
        }
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.previewPropertyScreen),
          builder: (_) => BlocProvider(
            create: (context) {
              PreviewPropertyDi().setup();
              return PreviewPropertyCubit(
                ServiceLocator.getIt(),
                ServiceLocator.getIt(),
                ServiceLocator.getIt(),
              );
            },
            child: PreviewPropertyScreen(
              propertyId: propertyId,
              updateAppointment: updateAppointment,
            ),
          ),
        );
      case RoutersNames.realEstatesMapScreen:
        final args = settings.arguments as RealEstateCubit;
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.realEstatesMapScreen),
          builder: (_) => BlocProvider.value(
            value: args,
            child: RealEstateMapScreen(
            ),
          ),
        );
        case RoutersNames.homeSearchScreen:
        final args = settings.arguments as HomeBloc;
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.homeSearchScreen),
          builder: (_) => BlocProvider.value(
            value: args,
            child: HomeSearchScreen(),
          ),
        );
      case RoutersNames.vehiclesList:
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.vehiclesList),
          builder: (_) => VehiclesScreen(),
        );

      case RoutersNames.vehicleDetails:
        final vehicleId = settings.arguments as int;
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.vehicleDetails),
          builder: (_) => VehicleDetailsScreen(vehicleId: vehicleId),
        );
      case RoutersNames.vehicleDetailsScreen:
        final vehicleId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => VehicleDetailsScreen(vehicleId: vehicleId),
        );

      case RoutersNames.rentVehicleScreen:
        final vehicleId = settings.arguments as String;
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.rentVehicleScreen),
          builder: (_) => RentVehicleMainScreen(vehicleId: vehicleId),
        );

      case RoutersNames.locationPickerScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final String title = args['title'] as String;
        final String? initialAddress = args['initialAddress'] as String?;
        final LatLng? initialLocation = args['initialLocation'] as LatLng?;
        return MaterialPageRoute(
          settings: RouteSettings(name: RoutersNames.locationPickerScreen),
          builder: (_) => LocationPickerScreen(
            title: title,
            initialAddress: initialAddress,
            initialLocation: initialLocation,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
