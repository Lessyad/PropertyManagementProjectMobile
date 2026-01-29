import 'package:enmaa/core/extensions/appointment_status_extension.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/presentation/components/user_appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/components/card_listing_shimmer.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
 import 'package:enmaa/core/utils/enums.dart';

import '../../../../../../core/screens/property_empty_screen.dart';
import '../controller/user_appointments_cubit.dart';

class UserAppointmentsListBuilderComponent extends StatelessWidget {
  final AppointmentStatus status;
  final ScrollController scrollController;

  const UserAppointmentsListBuilderComponent({
    super.key,
    required this.status,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<UserAppointmentsCubit>().getUserAppointments(
          status: status.toJson(),
          isRefresh: true,
        );
      },
      child: BlocBuilder<UserAppointmentsCubit, UserAppointmentsState>(
        buildWhen: (previous, current) =>
        previous.loadedStates[status.toJson()] != current.loadedStates[status.toJson()] ||
            previous.appointments[status.toJson()] != current.appointments[status.toJson()] ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.hasMore[status.toJson()] != current.hasMore[status.toJson()],
        builder: (context, state) {
          final appointments = state.getAppointmentsByStatus(status.toJson());
          final requestState = state.getStateByStatus(status.toJson());

          if (requestState.isError && appointments.isEmpty) {
            return ErrorAppScreen(
              showActionButton: false,
              showBackButton: false,
              backgroundColor: Colors.grey.shade100,
            );
          }

          if (requestState.isLoaded && appointments.isEmpty && !state.isLoadingMore) {
            return EmptyScreen(
              alertText1: 'لا توجد مواعيد ${status.toName}',
              alertText2: 'يمكنك حجز مواعيد خاصه بالعقارات للبدء في عرضها',
            );
          }

          if (requestState.isLoading && appointments.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, ),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: appointments.length + (state.hasMoreAppointments(status.toJson()) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= appointments.length) {
                return Center(child: CircularProgressIndicator());

              }

              final appointment = appointments[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: UserAppointmentCard(
                  appointment: appointment,
                ),
              );
            },
          );
        },
      ),
    );
  }
}