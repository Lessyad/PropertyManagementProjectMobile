import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../domain/entities/app_service_entity.dart';
import '../../home_imports.dart';
import '../controller/home_bloc.dart';
import 'banners_shimmer_widget.dart';
import 'banners_widget.dart';
import 'services_list_shimmer.dart';
import 'service_component.dart';

class ServicesList extends StatelessWidget  {
  final Function(String serviceName) onServicePressed;

  const ServicesList({super.key, required this.onServicePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
          previous.appServicesState != current.appServicesState,
          builder: (context, state) {
            if (state.appServicesState.isLoaded) {
              return SizedBox(
                height: context.scale(100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.appServices.length,
                  itemBuilder: (context, index) {
                    final category = state.appServices[index];
                    return ServiceComponent(
                      category: category,
                      onTap: () {
                        onServicePressed(category.text);
                      },
                    );
                  },
                ),
              );
            } else if (state.appServicesState.isError) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else {
              return SizedBox(
                height: context.scale(100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return const CategoryShimmer();
                  },
                ),
              );
            }
          },
        ),
        SizedBox(height: context.scale(16)),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
          previous.bannersState != current.bannersState,
          builder: (context, state) {
            if (state.bannersState.isLoaded) {
              return BannersWidget(banners: state.banners,
                  padding : const EdgeInsets.symmetric(horizontal: 16) ,
                height: 150,
                borderRadius: 16,
                bottomLeftRadius: 16,
                bottomRightRadius: 16,
              );
            } else {
              return const BannersShimmerWidget();
            }
          },
        ),
        /*ButtonAppComponent(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RoutersNames.addNewRealEstateScreen);
          },
          buttonContent: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImageComponent(
                iconPath: AppAssets.plusIcon,
              ),
              Text(
                LocaleKeys.addYourRealState.tr(),
                style: getMediumStyle(
                  color: ColorManager.whiteColor,
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }
}