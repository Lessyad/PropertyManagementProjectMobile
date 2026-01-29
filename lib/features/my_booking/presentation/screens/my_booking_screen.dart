import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/status_extension.dart';
import 'package:enmaa/features/my_booking/presentation/component/booking_list_builder_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/utils/enums.dart';
import '../../../../core/translation/locale_keys.dart';
import '../component/tab_bar_component.dart';
import '../controller/my_booking_cubit.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<RequestStatus> _tabStatuses = [RequestStatus.active, RequestStatus.completed, RequestStatus.cancelled];
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
      context.read<MyBookingCubit>().getMyBookings(
        status: _tabStatuses[_tabController.index].toJson(),
        isRefresh: true,
      );
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final status = _tabStatuses[_tabController.index].toJson();
    if (!context.read<MyBookingCubit>().state.loadedStates.containsKey(status)) {
      context.read<MyBookingCubit>().getMyBookings(
        status: status,
        isRefresh: true,
      );
    }
    setState(() {});
  }

  void _handleScroll(ScrollController controller, RequestStatus status) {
    if (controller.position.extentAfter < 300 &&
        !context.read<MyBookingCubit>().state.isLoadingMore &&
        context.read<MyBookingCubit>().state.hasMoreBookings(status.toJson())) {
      context.read<MyBookingCubit>().getMyBookings(
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
            appBarTextMessage: LocaleKeys.myBookings.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
          ),
          CustomTabBar(
            tabController: _tabController,
            tabStatuses: _tabStatuses,
            onTabChanged: (index) {
              _tabController.animateTo(index);
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabStatuses.length, (index) {
                return BookingListBuilderComponent(
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