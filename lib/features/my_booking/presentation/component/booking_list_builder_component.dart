import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/routers/app_routers.dart';
import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/components/card_listing_shimmer.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/extensions/status_extension.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/screens/property_empty_screen.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/home_module/presentation/components/real_state_card_component.dart';

import '../../../../core/translation/locale_keys.dart';
import '../controller/my_booking_cubit.dart';

class BookingListBuilderComponent extends StatelessWidget {
  final RequestStatus status;
  final ScrollController scrollController;

  const BookingListBuilderComponent({
    super.key,
    required this.status,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MyBookingCubit>().getMyBookings(
          status: status.toJson(),
          isRefresh: true,
        );
      },
      child: BlocBuilder<MyBookingCubit, MyBookingState>(
        buildWhen: (previous, current) =>
        previous.loadedStates[status.toJson()] != current.loadedStates[status.toJson()] ||
            previous.bookings[status.toJson()] != current.bookings[status.toJson()] ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.hasMore[status.toJson()] != current.hasMore[status.toJson()],
        builder: (context, state) {
          final bookings = state.getBookingsByStatus(status.toJson());
          final requestState = state.getStateByStatus(status.toJson());

          if (requestState.isError && bookings.isEmpty) {
            return ErrorAppScreen(
              showActionButton: false,
              showBackButton: false,
              backgroundColor: Colors.grey.shade100,
            );
          }

          if (requestState.isLoaded && bookings.isEmpty && !state.isLoadingMore) {
            return EmptyScreen(
              alertText1: LocaleKeys.emptyScreenNoBookings.tr(),
              alertText2: LocaleKeys.emptyScreenBrowseOffers.tr(),
              buttonText: LocaleKeys.emptyScreenExploreOffers.tr(),
              showActionButtonIcon: false,
              onTap: () {
                Navigator.pushNamed(context, RoutersNames.layoutScreen, arguments: 0);
              },
            );
          }

          /// First loading
          if (requestState.isLoading && bookings.isEmpty) {
            return CardShimmerList(
              scrollDirection: Axis.vertical,
              cardWidth: MediaQuery.of(context).size.width,
              cardHeight: context.scale(290),
            );
          }

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: bookings.length + (state.hasMoreBookings(status.toJson()) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= bookings.length) {
                return CardListingShimmer(
                  width: MediaQuery.of(context).size.width,
                  height: context.scale(290),
                );
              }

              final bookingItem = bookings[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RealStateCardComponent(
                  width: MediaQuery.of(context).size.width,
                  height: context.scale(290),
                  currentProperty: bookingItem,
                ),
              );
            },
          );
        },
      ),
    );
  }
}