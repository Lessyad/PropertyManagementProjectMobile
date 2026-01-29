import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/wallet/presentation/controller/wallet_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/services/currency_service.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/components/currency_display_widget.dart';
import '../../../home_module/home_imports.dart';
import '../../domain/entities/wallet_data_entity.dart';

class ChargeScreenWalletDataContainer extends StatelessWidget {
  const ChargeScreenWalletDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        // Déclencher le chargement des données du wallet si pas encore chargé
        if (state.getWalletDataState.isInitial) {
          print('🚀 [ChargeScreenWalletDataContainer] Déclenchement du chargement des données du wallet');
          context.read<WalletCubit>().getWalletData();
        }
      },
      child: Container(
      width: double.infinity,
      height: context.scale(368),
      decoration: BoxDecoration(
        color: ColorManager.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          // Debug logs
          print('🔍 [ChargeScreenWalletDataContainer] State: ${state.getWalletDataState}');
          print('🔍 [ChargeScreenWalletDataContainer] WalletData: ${state.walletDataEntity}');
          
          if (state.getWalletDataState.isLoaded) {
            final WalletDataEntity walletData = state.walletDataEntity!;
            print('🔍 [ChargeScreenWalletDataContainer] CurrentBalance: "${walletData.currentBalance}"');
            print('🔍 [ChargeScreenWalletDataContainer] PendingBalance: "${walletData.pendingBalance}"');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: context.scale(102),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.chargeScreenCurrentBalance.tr(),
                      style: getBoldStyle(
                          color: ColorManager.whiteColor, fontSize: FontSize.s16),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        print('🔄 [ChargeScreenWalletDataContainer] Rafraîchissement manuel des données');
                        context.read<WalletCubit>().getWalletData();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: ColorManager.whiteColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                BoldCurrencyDisplayWidget(
                  amount: double.tryParse(walletData.currentBalance) ?? 0.0,
                  textColor: ColorManager.whiteColor,
                  fontSize: FontSize.s32,
                ),
                SizedBox(
                  height: context.scale(8),
                ),
                SemiBoldCurrencyDisplayWidget(
                  amount: double.tryParse(walletData.pendingBalance) ?? 0.0,
                  textColor: ColorManager.whiteColor,
                  fontSize: FontSize.s16,
                ),
                SizedBox(
                  height: context.scale(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // Vérifier si l'utilisateur est connecté
                            final prefsService = SharedPreferencesService();
                            final accessToken = prefsService.accessToken;
                            
                            if (accessToken.isEmpty) {
                              // Utilisateur non connecté - afficher un message
                              CustomSnackBar.show(
                                context: context,
                                message: LocaleKeys.loginRequired.tr(),
                                type: SnackBarType.error,
                              );
                            } else {
                              // Utilisateur connecté - autoriser l'accès
                              Navigator.pushNamed(context, RoutersNames.withdrawScreen);
                            }
                          },
                          child: CircularIconButton(
                            containerSize: context.scale(60),
                            iconPath: AppAssets.withdrawIcon,
                            iconSize: 30,
                            backgroundColor: ColorManager.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: context.scale(8),
                        ),
                        Text(
                          LocaleKeys.chargeScreenWithdraw.tr(),
                          style: getBoldStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else if (state.getWalletDataState.isLoading) {
            // Affichage pendant le chargement
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: context.scale(102),
                ),
                Text(
                  LocaleKeys.chargeScreenCurrentBalance.tr(),
                  style: getBoldStyle(
                      color: ColorManager.whiteColor, fontSize: FontSize.s16),
                ),
                SizedBox(
                  height: context.scale(20),
                ),
                Container(
                  width: context.scale(120),
                  height: context.scale(40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.scale(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CircularIconButton(
                            containerSize: context.scale(60),
                            iconPath: AppAssets.chargeWallerIcon,
                            iconSize: 30,
                            backgroundColor: ColorManager.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: context.scale(8),
                        ),
                        Text(
                          LocaleKeys.chargeScreenWithdraw.tr(),
                          style: getBoldStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Affichage par défaut quand les données ne sont pas chargées
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: context.scale(102),
                ),
                Text(
                  LocaleKeys.chargeScreenCurrentBalance.tr(),
                  style: getBoldStyle(
                      color: ColorManager.whiteColor, fontSize: FontSize.s16),
                ),
                BoldCurrencyDisplayWidget(
                  amount: 0.0,
                  textColor: ColorManager.whiteColor,
                  fontSize: FontSize.s32,
                ),
                SizedBox(
                  height: context.scale(8),
                ),
                SemiBoldCurrencyDisplayWidget(
                  amount: 0.0,
                  textColor: ColorManager.whiteColor,
                  fontSize: FontSize.s16,
                ),
                SizedBox(
                  height: context.scale(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CircularIconButton(
                            containerSize: context.scale(60),
                            iconPath: AppAssets.chargeWallerIcon,
                            iconSize: 30,
                            backgroundColor: ColorManager.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: context.scale(8),
                        ),
                        Text(
                          LocaleKeys.chargeScreenWithdraw.tr(),
                          style: getBoldStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    ),
    );
  }
}