import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/components/VehicleCardComponent.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/screens/home_vehicle_screen.dart';

import '../../core/translation/locale_keys.dart';
import '../home_module/home_imports.dart';
import '../real_estates/presentation/screens/real_estates_screen.dart';
import '../vehicle_management/vehicle/presentation/screens/vehicle_search_screen.dart';

final Map<String, Widget Function(BuildContext)> appServiceScreens = {
  LocaleKeys.realEstate: (context) => const RealStateScreen(),
  // LocaleKeys.cars: (context) =>   HomeVehicleScreen(),
  LocaleKeys.vehiclesSearchscreen: (context) => const  VehicleSearchScreen(),
};


