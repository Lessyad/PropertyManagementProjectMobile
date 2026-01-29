import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/card_listing_shimmer.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/screens/property_empty_screen.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/services/get_file_permission.dart';
import '../../domain/entity/user_electronic_contract_entity.dart';
import '../controller/user_electronic_contracts_cubit.dart';
import '../components/electronic_contract_card_component.dart';

class UserElectronicContractsScreen extends StatefulWidget {
  const UserElectronicContractsScreen({super.key});

  @override
  State<UserElectronicContractsScreen> createState() =>
      _UserElectronicContractsScreenState();
}

class _UserElectronicContractsScreenState
    extends State<UserElectronicContractsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        context.read<UserElectronicContractsCubit>().loadMoreContracts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.myElectronicContracts.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          Expanded(
            child: BlocBuilder<UserElectronicContractsCubit,
                UserElectronicContractsState>(
              builder: (context, state) {
                return _buildContractsList(
                  state.getContractsRequestState,
                  state.electronicContracts,
                  state.getContractsRequestError,
                  state.hasMoreContracts,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractsList(
    RequestState state,
    List<UserElectronicContractEntity> contracts,
    String errorMessage,
    bool hasMore,
  ) {
    if (state == RequestState.loading && contracts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else if (state == RequestState.error && contracts.isEmpty) {
      return ErrorAppScreen(
        showBackButton: false,
        showActionButton: false,
        backgroundColor: ColorManager.greyShade,
      );
    } else if (contracts.isEmpty) {
      return EmptyScreen(
        alertText1: LocaleKeys.nomElectronicContracts.tr(),
        alertText2: LocaleKeys.myElectronicContractsAppearance.tr(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context
            .read<UserElectronicContractsCubit>()
            .getUserElectronicContracts(refresh: true);
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: contracts.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == contracts.length) {
            return CircularProgressIndicator();
          }

          final contract = contracts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElectronicContractCardComponent(
              contract: contract,
              width: context.screenWidth,
              height: context.scale(74),
            ),
          );
        },
      ),
    );
  }
}
