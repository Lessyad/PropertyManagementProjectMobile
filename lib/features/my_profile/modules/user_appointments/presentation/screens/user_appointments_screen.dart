import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/extensions/appointment_status_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/components/app_bar_component.dart';
import '../components/user_appointments_list_builder_component.dart';
import '../components/user_appointments_tab_bar.dart';
import '../controller/user_appointments_cubit.dart';

class UserAppointmentsScreen extends StatefulWidget {
  const UserAppointmentsScreen({super.key});

  @override
  State<UserAppointmentsScreen> createState() => _UserAppointmentsScreenState();
}

class _UserAppointmentsScreenState extends State<UserAppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<AppointmentStatus> _tabStatuses = [
    AppointmentStatus.coming,
    AppointmentStatus.completed,
    AppointmentStatus.cancelled
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
      context.read<UserAppointmentsCubit>().getUserAppointments(
            status: _tabStatuses[_tabController.index].toJson(),
            isRefresh: true,
          );
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final status = _tabStatuses[_tabController.index].toJson();
    final currentState = context.read<UserAppointmentsCubit>().state;
    
    // Toujours faire un appel API si le statut n'a jamais été chargé
    // ou si on veut forcer le rechargement
    if (!currentState.loadedStates.containsKey(status) || 
        currentState.getAppointmentsByStatus(status).isEmpty) {
      context.read<UserAppointmentsCubit>().getUserAppointments(
            status: status,
            isRefresh: true,
          );
    }
    setState(() {});
  }

  void _handleScroll(ScrollController controller, AppointmentStatus status) {
    if (controller.position.extentAfter < 300 &&
        !context.read<UserAppointmentsCubit>().state.isLoadingMore &&
        context
            .read<UserAppointmentsCubit>()
            .state
            .hasMoreAppointments(status.toJson())) {
      context.read<UserAppointmentsCubit>().getUserAppointments(
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
            appBarTextMessage: LocaleKeys.myAppointments.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          UserAppointmentsTabBar(
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
                return UserAppointmentsListBuilderComponent(
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
