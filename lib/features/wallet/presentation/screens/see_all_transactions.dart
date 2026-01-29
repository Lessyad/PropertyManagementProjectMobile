import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';

import '../../../../core/components/app_bar_component.dart';
import '../../../../core/components/card_listing_shimmer.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../home_module/home_imports.dart';
import '../components/transaction_history_card.dart';
import '../controller/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeeAllTransactionsScreen extends StatefulWidget {
  const SeeAllTransactionsScreen({super.key, required this.walletCubit});
  final WalletCubit walletCubit;

  @override
  State<SeeAllTransactionsScreen> createState() => _SeeAllTransactionsScreenState();
}

class _SeeAllTransactionsScreenState extends State<SeeAllTransactionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.walletCubit.state.allTransactions.isEmpty) {
        widget.walletCubit.resetAndFetchTransactions();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.walletCubit.loadMoreTransactions();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
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
            appBarTextMessage: LocaleKeys.transactionHistoryTitle.tr() ,
            centerText: true,
            showLocationIcon: false,
            showBackIcon: true,
            showNotificationIcon: false,
          ),
          Expanded(
            child: BlocBuilder<WalletCubit, WalletState>(
              bloc: widget.walletCubit,
              builder: (context, state) {
                return _buildContent(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WalletState state) {
    // Initial loading state
    if (state.getTransactionHistoryDataState.isLoading &&
        state.allTransactions.isEmpty) {
      return CardShimmerList(
        scrollDirection: Axis.vertical,
        cardHeight: context.scale(120),
        cardWidth: context.screenWidth,
        numberOfCards: 5,
      );
    }

    if (state.getTransactionHistoryDataState.isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.getTransactionHistoryDataErrorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => widget.walletCubit.resetAndFetchTransactions(),
              child: Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (state.allTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لا توجد معاملات حتى الآن',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'سيتم عرض المعاملات الخاصة بك هنا',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.walletCubit.resetAndFetchTransactions();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(context.scale(8)),
        itemCount: state.allTransactions.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == state.allTransactions.length) {
            return CardListingShimmer(
              width: context.screenWidth,
              height: context.scale(120),
            );
          }

          final transaction = state.allTransactions[index];
          return Padding(
            padding: EdgeInsets.only(bottom: context.scale(8)),
            child: TransactionHistoryCard(
              transactionHistoryEntity: transaction,
            ),
          );
        },
      ),
    );
  }
}