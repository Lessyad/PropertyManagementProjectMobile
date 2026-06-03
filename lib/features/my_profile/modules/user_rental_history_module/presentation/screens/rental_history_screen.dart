import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/app_bar_component.dart';
import '../../../../../../core/screens/property_empty_screen.dart';
import '../../../../../../core/translation/locale_keys.dart';
import '../../../../../../core/utils/enums.dart';
import '../components/rental_history_card.dart';
import '../controller/rental_history_cubit.dart';

class RentalHistoryScreen extends StatefulWidget {
  const RentalHistoryScreen({super.key});

  @override
  State<RentalHistoryScreen> createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends State<RentalHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.extentAfter < 300) {
      context.read<RentalHistoryCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: _rentalHistoryTitle(context),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          Expanded(
            child: BlocBuilder<RentalHistoryCubit, RentalHistoryState>(
              builder: (context, state) {
                if (state.requestState == RequestState.loading &&
                    state.rentals.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.requestState == RequestState.error &&
                    state.rentals.isEmpty) {
                  return _RentalHistoryError(
                    message: state.errorMessage,
                    onRetry: () {
                      context
                          .read<RentalHistoryCubit>()
                          .getRentalHistory(refresh: true);
                    },
                  );
                }

                if (state.rentals.isEmpty) {
                  return EmptyScreen(
                    alertText1: _noRentalHistoryTitle(context),
                    alertText2: _rentalHistoryAppearance(context),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context
                        .read<RentalHistoryCubit>()
                        .getRentalHistory(refresh: true);
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.rentals.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == state.rentals.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return RentalHistoryCard(rental: state.rentals[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _rentalHistoryTitle(BuildContext context) {
  switch (context.locale.languageCode) {
    case 'fr':
      return 'Historique de location';
    case 'ar':
      return 'سجل الإيجار';
    default:
      return 'Rental history';
  }
}

String _noRentalHistoryTitle(BuildContext context) {
  switch (context.locale.languageCode) {
    case 'fr':
      return 'Aucune location';
    case 'ar':
      return 'لا توجد إيجارات';
    default:
      return 'No rentals yet';
  }
}

String _rentalHistoryAppearance(BuildContext context) {
  switch (context.locale.languageCode) {
    case 'fr':
      return 'Vos locations apparaitront ici';
    case 'ar':
      return 'ستظهر إيجاراتك هنا';
    default:
      return 'Your rentals will appear here';
  }
}

class _RentalHistoryError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RentalHistoryError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: ColorManager.redColor,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.somethingWentWrong.tr(),
              textAlign: TextAlign.center,
              style: getBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.isEmpty ? LocaleKeys.errorScreenMessage.tr() : message,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s13,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(LocaleKeys.tryAgain.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
