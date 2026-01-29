import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/wallet/presentation/components/transaction_history_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/shimmer_component.dart';
import '../../../../core/screens/error_app_screen.dart';
import '../../../../core/screens/property_empty_screen.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import '../../domain/entities/transaction_history_entity.dart';
import '../controller/wallet_cubit.dart';

class TransactionHistoryList extends StatelessWidget {
  const TransactionHistoryList({super.key, this.title = ''});

  final String title;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Taille du titre adaptative
    final double titleFontSize = width < 360 ? 16 : 18;
    final double seeAllFontSize = width < 360 ? 12 : 14;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER: Titre + See All
        Row(
          children: [
            Flexible(
              child: Text(
                title.isEmpty ? LocaleKeys.transactionHistoryTitle.tr() : title,
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: titleFontSize,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutersNames.seeAllTransactionsScreen,
                  arguments: context.read<WalletCubit>(),
                );
              },
              child: Text(
                LocaleKeys.servicesSeeAll.tr(),
                style: getUnderlineSemiBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: seeAllFontSize,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: context.scale(12)),

        /// BLOC == CONTENU
        BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if (state.getTransactionHistoryDataState.isLoading) {
              return _buildShimmerList(context);
            }

            if (state.getTransactionHistoryDataState.isLoaded) {
              final List<TransactionHistoryEntity> transactionHistory = state.transactions;

              if (transactionHistory.isEmpty) {
                // Pas de hauteur fixe → prend l’espace dispo
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: context.scale(40)),
                    child: EmptyScreen(
                      alertText1: LocaleKeys.transactionHistoryNoTransactions.tr(),
                      alertText2: LocaleKeys.transactionHistoryEmptyMessage.tr(),
                    ),
                  ),
                );
              }

              // Afficher max 3 éléments
              final int numberOfItems = transactionHistory.length > 3 ? 3 : transactionHistory.length;

              /// IMPORTANT : Utiliser ConstrainedBox et shrinkWrap pour éviter overflow
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: context.scale(350),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: numberOfItems,
                  physics: const NeverScrollableScrollPhysics(), // scroll géré par la page parente
                  itemBuilder: (context, index) {
                    return TransactionHistoryCard(
                      transactionHistoryEntity: transactionHistory[index],
                    );
                  },
                ),
              );
            }

            // ERREUR
            return Padding(
              padding: EdgeInsets.symmetric(vertical: context.scale(20)),
              child: ErrorAppScreen(
                showActionButton: false,
                showBackButton: false,
                backgroundColor: ColorManager.greyShade,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.scale(350),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShimmerComponent(
              height: context.scale(70),
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}
