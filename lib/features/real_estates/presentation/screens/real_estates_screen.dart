import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/components/custom_bottom_sheet.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/screens/real_estate_filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/components/app_text_field.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/components/card_listing_shimmer.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/components/custom_tab.dart';
import '../../../../core/components/need_to_login_component.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/screens/property_empty_screen.dart';
import '../../../../core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/utils/enums.dart';
import '../../../../main.dart';
import '../../../home_module/presentation/components/real_state_card_component.dart';
import '../../../home_module/presentation/controller/home_bloc.dart';
import '../../domain/entities/base_property_entity.dart';
import '../components/real_estate_filteration_components/active_filters_component.dart';
import 'package:easy_localization/easy_localization.dart';

class RealStateScreen extends StatefulWidget {
  const RealStateScreen({super.key});

  @override
  State<RealStateScreen> createState() => _RealStateScreenState();
}

class _RealStateScreenState extends State<RealStateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _saleScrollController = ScrollController();
  final ScrollController _rentScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final currentOperationType =
        context.read<FilterPropertyCubit>().state.currentPropertyOperationType;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex:
          currentOperationType == PropertyOperationType.forSale ? 0 : 1,
    );

    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RealEstateCubit>().loadTabData(currentOperationType);
    });

    _setupScrollControllers();
  }

  void _setupScrollControllers() {
    _saleScrollController.addListener(() {
      if (_saleScrollController.position.pixels >=
          _saleScrollController.position.maxScrollExtent - 200) {
        final filterData =
            context.read<FilterPropertyCubit>().prepareDataForApi();
        context.read<RealEstateCubit>().loadMoreProperties(
              PropertyOperationType.forSale,
              filters: filterData,
            );
      }
    });

    _rentScrollController.addListener(() {
      if (_rentScrollController.position.pixels >=
          _rentScrollController.position.maxScrollExtent - 200) {
        final filterData =
            context.read<FilterPropertyCubit>().prepareDataForApi();
        context.read<RealEstateCubit>().loadMoreProperties(
              PropertyOperationType.forRent,
              filters: filterData,
            );
      }
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _tabController.previousIndex) {
      final PropertyOperationType type = _tabController.index == 0
          ? PropertyOperationType.forSale
          : PropertyOperationType.forRent;

      context.read<FilterPropertyCubit>().changePropertyOperationType(type);

      final filterData =
          context.read<FilterPropertyCubit>().prepareDataForApi();
      context.read<RealEstateCubit>().loadTabData(type, filters: filterData);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _saleScrollController.dispose();
    _rentScrollController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: ColorManager.greyShade,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return CustomBottomSheet(
          widget: BlocProvider.value(
            value: ServiceLocator.getIt<RealEstateCubit>(),
            child: RealEstateFilterScreen(),
          ),
          headerText: LocaleKeys.filter.tr(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterPropertyCubit, FilterPropertyState>(
      listener: (context, state) {
        final newIndex =
            state.currentPropertyOperationType == PropertyOperationType.forSale
                ? 0
                : 1;
        if (_tabController.index != newIndex) {
          _tabController.removeListener(_onTabChanged);
          _tabController.index = newIndex;
          _tabController.addListener(_onTabChanged);

          final filterData =
              context.read<FilterPropertyCubit>().prepareDataForApi();
          context.read<RealEstateCubit>().loadTabData(
                state.currentPropertyOperationType,
                filters: filterData,
              );
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.greyShade,
        body: Stack(
          children: [
            Column(
              children: [
                AppBarComponent(
                  appBarTextMessage: LocaleKeys.choosePerfectProperty.tr(),
                  homeBloc: context.read<HomeBloc>(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _openFilterBottomSheet,
                        child: AppTextField(
                          width: context.scale(235),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scale(16),
                            vertical: context.scale(8),
                          ),
                          hintText: LocaleKeys.searchForProperty.tr(),
                          prefixIcon: Icon(Icons.search,
                              color: ColorManager.blackColor),
                          editable: false,
                        ),
                      ),
                    ),
                    ButtonAppComponent(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      width: context.scale(111),
                      onTap: () {
                        if (isAuth) {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(RoutersNames.addNewRealEstateScreen);
                        } else {
                          LoginBottomSheet.show();
                        }
                      },
                      buttonContent: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgImageComponent(
                            iconPath: AppAssets.plusIcon,
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              LocaleKeys.addYourProperty.tr(),
                              style: getBoldStyle(
                                  color: ColorManager.whiteColor,
                                  fontSize: FontSize.s12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ActiveFiltersComponent(
                  selectLocationServiceCubit:
                      context.read<SelectLocationServiceCubit>(),
                ),
                Builder(
                  builder: (context) {
                    return TabBar(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scale(8),
                        vertical: context.scale(6),
                      ),
                      controller: _tabController,
                      indicator: const BoxDecoration(color: Colors.transparent),
                      dividerColor: Colors.transparent,
                      tabs: [
                        CustomTab(
                          text: LocaleKeys.forSale.tr(),
                          isSelected: _tabController.index == 0,
                        ),
                        CustomTab(
                          text: LocaleKeys.forRent.tr(),
                          isSelected: _tabController.index == 1,
                        ),
                      ],
                    );
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSaleTab(),
                      _buildRentTab(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      RoutersNames.realEstatesMapScreen,
                      arguments: context.read<RealEstateCubit>(),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgImageComponent(iconPath: AppAssets.locationIcon),
                          const SizedBox(width: 8),
                          Text(
                            'الخريطة',
                            style: getMediumStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleTab() {
    return BlocBuilder<RealEstateCubit, RealEstateState>(
      builder: (context, state) {
        return _buildPropertyList(
          state.getPropertiesSaleState,
          state.saleProperties,
          state.getPropertiesSaleError,
          state.hasMoreSaleProperties,
          PropertyOperationType.forSale,
          _saleScrollController,
        );
      },
    );
  }

  Widget _buildRentTab() {
    return BlocBuilder<RealEstateCubit, RealEstateState>(
      builder: (context, state) {
        return _buildPropertyList(
          state.getPropertiesRentState,
          state.rentProperties,
          state.getPropertiesRentError,
          state.hasMoreRentProperties,
          PropertyOperationType.forRent,
          _rentScrollController,
        );
      },
    );
  }

  Widget _buildPropertyList(
    RequestState state,
    List<PropertyEntity> properties,
    String errorMessage,
    bool hasMore,
    PropertyOperationType type,
    ScrollController scrollController,
  ) {
    if (state == RequestState.loading && properties.isEmpty) {
      return CardShimmerList(
        scrollDirection: Axis.vertical,
        cardHeight: context.scale(282),
        cardWidth: context.screenWidth,
        numberOfCards: 3,
      );
    } else if (state == RequestState.error && properties.isEmpty) {
      return ErrorAppScreen(
        showBackButton: false,
        showActionButton: false,
        backgroundColor: ColorManager.greyShade,
      );
    }
      // else if (properties.isEmpty) {
    //   return EmptyScreen(
    //     alertText1: LocaleKeys.didntFindSuitableProperty.tr(),
    //     alertText2: LocaleKeys.contactUsForBestOptions.tr(),
    //     buttonText: LocaleKeys.contactUs.tr(),
    //     onTap: () async {
    //       final Uri url = Uri.parse('https://github.com/AmrAbdElHamed26');
    //       if (await canLaunchUrl(url)) {
    //         await launchUrl(url, mode: LaunchMode.externalApplication);
    //       } else {
    //         CustomSnackBar.show(
    //           message: LocaleKeys.errorOpeningLink.tr(),
    //           type: SnackBarType.error,
    //         );
    //       }
    //     },
    //   );
    // }

    return RefreshIndicator(
      onRefresh: () async {
        final filterData =
            context.read<FilterPropertyCubit>().prepareDataForApi();
        await context.read<RealEstateCubit>().fetchProperties(
              operationType: type,
              filters: filterData,
              refresh: true,
            );
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: properties.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == properties.length) {
            return CardListingShimmer(
              width: context.screenWidth,
              height: context.scale(282),
            );
          }

          final property = properties[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RealStateCardComponent(
              width: MediaQuery.of(context).size.width,
              height: context.scale(290),
              currentProperty: property,
            ),
          );
        },
      ),
    );
  }
}
