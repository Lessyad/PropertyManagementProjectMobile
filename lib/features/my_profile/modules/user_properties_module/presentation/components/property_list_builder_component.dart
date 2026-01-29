import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:enmaa/core/extensions/booking_status_extension.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/presentation/controller/user_properties_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/components/card_listing_shimmer.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/screens/property_empty_screen.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/home_module/presentation/components/real_state_card_component.dart';


import '../../../../../../configuration/routers/route_names.dart';
import 'my_properties_card_actions.dart';

class UserPropertiesListBuilderComponent extends StatelessWidget {
  final BookingStatus status;
  final ScrollController scrollController;

  const UserPropertiesListBuilderComponent({
    super.key,
    required this.status,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<UserPropertiesCubit>().getMyProperties(
              status: status.toJson(),
              isRefresh: true,
            );
      },
      child: BlocBuilder<UserPropertiesCubit, UserPropertiesState>(
        buildWhen: (previous, current) =>
            previous.loadedStates[status.toJson()] !=
                current.loadedStates[status.toJson()] ||
            previous.properties[status.toJson()] !=
                current.properties[status.toJson()] ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.hasMore[status.toJson()] !=
                current.hasMore[status.toJson()],
        builder: (context, state) {
          final properties = state.getPropertiesByStatus(status.toJson());
          final requestState = state.getStateByStatus(status.toJson());

          if (requestState.isError && properties.isEmpty) {
            return ErrorAppScreen(
              showActionButton: false,
              showBackButton: false,
              backgroundColor: Colors.grey.shade100,
            );
          }

          if (requestState.isLoaded &&
              properties.isEmpty &&
              !state.isLoadingMore) {
            return EmptyScreen(
              alertText1: 'لا توجد عقارات ${status.name}',
              alertText2: 'يمكنك إضافة عقاراتك للبدء في عرضها للحجز',
              buttonText: 'إضافة عقار جديد',
              showActionButtonIcon: false,
              onTap: () {
                Navigator.pushNamed(context, RoutersNames.addNewRealEstateScreen);
              },
            );
          }

          /// First loading
          if (requestState.isLoading && properties.isEmpty) {
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
            itemCount: properties.length +
                (state.hasMoreProperties(status.toJson()) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= properties.length) {
                return CardListingShimmer(
                  width: MediaQuery.of(context).size.width,
                  height: context.scale(290),
                );
              }

              final propertyItem = properties[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RealStateCardComponent(
                  width: MediaQuery.of(context).size.width,
                  height: context.scale(290),
                  currentProperty: propertyItem,
                  showWishlistButton: false,
                  cardActions: MyPropertiesCardActions (
                    propertyItem: propertyItem,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
