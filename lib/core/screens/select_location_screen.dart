import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/home_module/presentation/controller/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/add_new_real_estate/presentation/components/country_selector_component.dart';
import '../../features/add_new_real_estate/presentation/components/state_and_city_selector_component.dart';
import '../../features/home_module/home_imports.dart';
import '../components/custom_app_drop_down.dart';
import '../components/loading_overlay_component.dart';
import '../services/select_location_service/presentation/controller/select_location_service_cubit.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SelectLocationServiceCubit.getOrCreate()..removeSelectedData()
          ..getCountries();
      },
      child: BlocBuilder<SelectLocationServiceCubit, SelectLocationServiceState>(
  builder: (context, locationState) {
    return SizedBox(
        width: double.infinity,
        height: context.scale(290),
        child: BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country Selector
                const CountrySelectorComponent(),
            
                // State and City Selector
                const StateCitySelectorComponent(),
                SizedBox(height: context.scale(20)),
            
                SizedBox(
                  width: double.infinity,
                  height: context.scale(48),
                  child: ElevatedButton(
                    onPressed: () {
                      if(ServiceLocator.getIt<SelectLocationServiceCubit>().state.selectedCity != null){
                        context.read<HomeBloc>().add(UpdateUserLocation(
                            cityID: ServiceLocator.getIt<SelectLocationServiceCubit>().state.selectedCity!.id,
                            cityName: ServiceLocator.getIt<SelectLocationServiceCubit>().state.selectedCity!.name,
                        ));
                      }
            
            
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('ادخل الموقع ', style: getBoldStyle(
                        color: ColorManager.whiteColor, fontSize: FontSize.s12),),
            
                  ),
                ),
            
              ],
            ),
            
            if(state.updateUserLocationState.isLoading || locationState.getStatesState.isLoading || locationState.getCountriesState.isLoading || locationState.getCitiesState.isLoading)
              LoadingOverlayComponent(
                opacity: 0,
              ),
          ],
        );
  },
),
      );
  },
),
    );
  }

}
