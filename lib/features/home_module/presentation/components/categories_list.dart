import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/translation/locale_keys.dart';
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
                    final isEnabled = category.text != LocaleKeys.halls &&
                        category.text != LocaleKeys.hotels;
                    return ServiceComponent(
                      category: category,
                      isEnabled: isEnabled,
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
