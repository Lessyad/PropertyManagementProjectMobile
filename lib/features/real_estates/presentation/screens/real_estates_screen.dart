import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/components/custom_bottom_sheet.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/constants/local_keys.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/screens/real_estate_filter_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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
  bool _saleChangingPage = false;
  bool _rentChangingPage = false;

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
  }

  void _goToPage(PropertyOperationType type, int page) {
    final isSale = type == PropertyOperationType.forSale;
    // Shimmer immédiat + cache pagination avant tout appel API
    setState(() {
      if (isSale) {
        _saleChangingPage = true;
      } else {
        _rentChangingPage = true;
      }
    });
    final filterData = context.read<FilterPropertyCubit>().prepareDataForApi();
    context.read<RealEstateCubit>().goToPage(type, page, filters: filterData);
    final ctrl = isSale ? _saleScrollController : _rentScrollController;
    if (ctrl.hasClients) {
      ctrl.animateTo(0,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
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

  List<int?> _getVisiblePages(int current, int total) {
    if (total <= 0) return [current];
    if (total <= 7) return List.generate(total, (i) => i + 1);
    if (current <= 4) return [1, 2, 3, 4, 5, null, total];
    if (current >= total - 3) {
      return [1, null, total - 4, total - 3, total - 2, total - 1, total];
    }
    return [1, null, current - 1, current, current + 1, null, total];
  }

  Widget _buildPaginationBar({
    required int currentPage,
    required int totalCount,
    required int limit,
    required bool hasMore,
    required PropertyOperationType type,
  }) {
    final totalPages = (totalCount / limit).ceil();
    final hasPrev = currentPage > 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (totalCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                LocaleKeys.propertyResultCount.tr(namedArgs: {'count': '$totalCount'}),
                textDirection: ui.TextDirection.ltr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.grey2,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavArrow(
                icon: Icons.chevron_left_rounded,
                enabled: hasPrev,
                onTap: () => _goToPage(type, currentPage - 1),
              ),
              const SizedBox(width: 6),
              ..._getVisiblePages(currentPage, totalPages).map((page) {
                if (page == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      width: 28,
                      child: Text(
                        '···',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorManager.grey2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                final isActive = page == currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: isActive ? null : () => _goToPage(type, page),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive ? ColorManager.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive ? ColorManager.primaryColor : ColorManager.grey3,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? Colors.white : ColorManager.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 6),
              _buildNavArrow(
                icon: Icons.chevron_right_rounded,
                enabled: hasMore,
                onTap: () => _goToPage(type, currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? ColorManager.primaryColor : ColorManager.greyShade,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 22,
            color: enabled ? Colors.white : ColorManager.grey2),
      ),
    );
  }

  void _openFilterBottomSheet() {
    // Reset location to user's country only — no GPS city pre-filled
    final locationCubit = context.read<SelectLocationServiceCubit>();
    locationCubit.removeSelectedData();
    final countryId = SharedPreferencesService()
        .getValue(LocalKeys.userCountryID)
        ?.toString();
    if (countryId != null && countryId.isNotEmpty) {
      if (locationCubit.state.countries.isNotEmpty) {
        locationCubit.setUserCountryOnly(countryId);
      } else {
        locationCubit.getCountries().then((_) {
          locationCubit.setUserCountryOnly(countryId);
        });
      }
    }

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
                            tr(LocaleKeys.mapLabel),
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
        // Réinitialiser le flag de changement de page quand les données arrivent
        if (_saleChangingPage &&
            state.getPropertiesSaleState == RequestState.loaded) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => setState(() => _saleChangingPage = false));
        }
        return _buildPropertyList(
          requestState: state.getPropertiesSaleState,
          properties: state.saleProperties,
          errorMessage: state.getPropertiesSaleError,
          hasMore: state.hasMoreSaleProperties,
          type: PropertyOperationType.forSale,
          scrollController: _saleScrollController,
          totalCount: state.saleTotalCount,
          currentPage: state.saleCurrentPage,
          limit: state.limit,
          isChangingPage: _saleChangingPage,
        );
      },
    );
  }

  Widget _buildRentTab() {
    return BlocBuilder<RealEstateCubit, RealEstateState>(
      builder: (context, state) {
        if (_rentChangingPage &&
            state.getPropertiesRentState == RequestState.loaded) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => setState(() => _rentChangingPage = false));
        }
        return _buildPropertyList(
          requestState: state.getPropertiesRentState,
          properties: state.rentProperties,
          errorMessage: state.getPropertiesRentError,
          hasMore: state.hasMoreRentProperties,
          type: PropertyOperationType.forRent,
          scrollController: _rentScrollController,
          totalCount: state.rentTotalCount,
          currentPage: state.rentCurrentPage,
          limit: state.limit,
          isChangingPage: _rentChangingPage,
        );
      },
    );
  }

  Widget _buildPropertyList({
    required RequestState requestState,
    required List<PropertyEntity> properties,
    required String errorMessage,
    required bool hasMore,
    required PropertyOperationType type,
    required ScrollController scrollController,
    required int totalCount,
    required int currentPage,
    required int limit,
    bool isChangingPage = false,
  }) {
    // Shimmer immédiat dès le clic sur une page (isChangingPage)
    // ou au premier chargement (loading + liste vide)
    if (isChangingPage ||
        (requestState == RequestState.loading && properties.isEmpty)) {
      return CardShimmerList(
        scrollDirection: Axis.vertical,
        cardHeight: context.scale(282),
        cardWidth: context.screenWidth,
        numberOfCards: 3,
      );
    } else if (requestState == RequestState.error && properties.isEmpty) {
      return ErrorAppScreen(
        showBackButton: false,
        showActionButton: false,
        backgroundColor: ColorManager.greyShade,
        errorMessage: errorMessage,
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
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
              itemCount: properties.length,
              itemBuilder: (context, index) {
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
          ),
        ),
        if (limit > 0 && (totalCount / limit).ceil() > 1)
          _buildPaginationBar(
            currentPage: currentPage,
            totalCount: totalCount,
            limit: limit,
            hasMore: hasMore,
            type: type,
          ),
      ],
    );
  }
}
