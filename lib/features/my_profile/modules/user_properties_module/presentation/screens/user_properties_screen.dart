import 'package:enmaa/core/components/need_to_login_component.dart';
import 'package:enmaa/core/extensions/booking_status_extension.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/presentation/controller/user_properties_cubit.dart';
import 'package:enmaa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../configuration/routers/route_names.dart';
import '../../../../../../core/components/button_app_component.dart';
import '../../../../../../core/components/svg_image_component.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../components/property_list_builder_component.dart';
import '../components/user_properties_tab_bar.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<BookingStatus> _tabStatuses = [
    BookingStatus.available,
    BookingStatus.reserved
  ];
  final List<ScrollController> _scrollControllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabStatuses.length, vsync: this);
    _tabController.addListener(_handleTabChange);

    for (int i = 0; i < _tabStatuses.length; i++) {
      final controller = ScrollController();
      controller.addListener(() => _handleScroll(controller, _tabStatuses[i]));
      _scrollControllers.add(controller);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserPropertiesCubit>().getMyProperties(
            status: _tabStatuses[_tabController.index].toJson(),
            isRefresh: true,
          );
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final status = _tabStatuses[_tabController.index].toJson();
    if (!context
        .read<UserPropertiesCubit>()
        .state
        .loadedStates
        .containsKey(status)) {
      context.read<UserPropertiesCubit>().getMyProperties(
            status: status,
            isRefresh: true,
          );
    }
    setState(() {});
  }

  void _handleScroll(ScrollController controller, BookingStatus status) {
    if (controller.position.extentAfter < 300 &&
        !context.read<UserPropertiesCubit>().state.isLoadingMore &&
        context
            .read<UserPropertiesCubit>()
            .state
            .hasMoreProperties(status.toJson())) {
      context.read<UserPropertiesCubit>().getMyProperties(
            status: status.toJson(),
            isRefresh: false,
          );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.myRealEstate.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UserPropertiesTabBar(
                  tabController: _tabController,
                  tabStatuses: _tabStatuses,
                  onTabChanged: (index) {
                    _tabController.animateTo(index);
                  },
                ),
              ),
              SizedBox(width: 8),
              ButtonAppComponent(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                width: context.scale(117),
                onTap: () {
                  if (isAuth) {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(RoutersNames.addNewRealEstateScreen);
                  } else {
                    LoginBottomSheet.show();
                  }
                },
                buttonContent: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabStatuses.length, (index) {
                return UserPropertiesListBuilderComponent(
                  status: _tabStatuses[index],
                  scrollController: _scrollControllers[index],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
