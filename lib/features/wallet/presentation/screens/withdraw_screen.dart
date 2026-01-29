import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:enmaa/core/services/select_location_service/select_location_DI.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/core/utils/form_validator.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/features/wallet/data/models/withdraw_request_model.dart';
import 'package:enmaa/features/wallet/presentation/controller/wallet_cubit.dart';
import 'package:enmaa/features/wallet/domain/entities/bank_entity.dart';
import 'package:enmaa/features/wallet/domain/use_cases/withdraw_request_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_wallet_data_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_transaction_history_data_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_banks_use_case.dart';
import 'package:enmaa/features/wallet/domain/use_cases/get_user_balance_use_case.dart';
import 'package:enmaa/features/wallet/wallet_DI.dart';
import 'package:enmaa/core/services/currency_service.dart';
import 'package:enmaa/core/components/currency_display_widget.dart';
import '../../../../configuration/managers/drop_down_style_manager.dart';
import '../../../../core/components/custom_app_drop_down.dart';
import '../../../add_new_real_estate/presentation/components/country_selector_component.dart';
import '../../../home_module/home_imports.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  
  int? _selectedBankId;
  String? _selectedBankName;
  final CurrencyService _currencyService = CurrencyService();


  @override
  void dispose() {
    _ibanController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.amountRequired.tr();
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return LocaleKeys.invalidAmount.tr();
    }
    
    if (amount <= 0) {
      return LocaleKeys.amountMustBePositive.tr();
    }
    
    // Vérifier si le montant ne dépasse pas le solde disponible
    // Note: Cette validation sera faite côté serveur, mais on peut faire une validation basique ici
    // Le solde réel sera vérifié lors de la soumission
    
    return null;
  }

  String? _validateIban(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.ibanRequired.tr();
    }
    
    // Validation basique de l'IBAN (2 lettres + 2 chiffres + jusqu'à 30 caractères)
    final ibanRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{4,30}$');
    if (!ibanRegex.hasMatch(value.toUpperCase())) {
      return LocaleKeys.invalidIbanFormat.tr();
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            WalletDi().setup();
            return WalletCubit(
              ServiceLocator.getIt<WithdrawRequestUseCase>(),
              ServiceLocator.getIt<GetWalletDataUseCase>(),
              ServiceLocator.getIt<GetTransactionHistoryDataUseCase>(),
              ServiceLocator.getIt<GetBanksUseCase>(),
              ServiceLocator.getIt<GetUserBalanceUseCase>(),
            )..getBanks()..getWalletData();
          },
        ),
        BlocProvider(
          create: (context) {
            return SelectLocationServiceCubit.getOrCreate()
              ..removeSelectedData()
              ..getCountries();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.greyShade,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarComponent(
              appBarTextMessage: LocaleKeys.withdrawTitle.tr(),
              showNotificationIcon: false,
              showLocationIcon: false,
              centerText: true,
              showBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Affichage du solde disponible
                        BlocConsumer<WalletCubit, WalletState>(
                          buildWhen: (previous, current) =>
                              previous.getUserBalanceState != current.getUserBalanceState ||
                              previous.getWalletDataState != current.getWalletDataState,
                          builder: (context, state) {
                            // Utiliser le solde du wallet comme fallback si l'endpoint balance n'est pas disponible
                            double balance = 0.0;
                            bool isLoading = false;
                            
                            if (state.getUserBalanceState == RequestState.loaded) {
                              balance = state.userBalance;
                            } else if (state.getWalletDataState == RequestState.loaded && 
                                       state.walletDataEntity != null) {
                              balance = double.tryParse(state.walletDataEntity!.currentBalance) ?? 0.0;
                            } else if (state.getUserBalanceState == RequestState.loading || 
                                     state.getWalletDataState == RequestState.loading) {
                              isLoading = true;
                            }
                            
                            if (isLoading) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocaleKeys.availableBalance.tr(),
                                      style: getBoldStyle(
                                        color: ColorManager.blackColor,
                                        fontSize: FontSize.s12,
                                      ),
                                    ),
                                    const CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            } else if (balance > 0) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        LocaleKeys.availableBalance.tr(),
                                        style: getBoldStyle(
                                          color: ColorManager.blackColor,
                                          fontSize: FontSize.s12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    BoldCurrencyDisplayWidget(
                                      amount: balance,
                                      textColor: ColorManager.primaryColor,
                                      fontSize: FontSize.s14,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          listener: (context, state) {
                            // Pas de listener nécessaire pour l'instant
                          },
                        ),
                        SizedBox(height: context.scale(16)),

                        Text(
                          LocaleKeys.withdrawAmountLabel.tr(),
                          style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s16),
                        ),
                        SizedBox(height: context.scale(8)),
                        AppTextField(
                          controller: _amountController,
                          hintText: LocaleKeys.withdrawAmountHint.tr(),
                          keyboardType: TextInputType.number,
                          borderRadius: 20,
                          padding: EdgeInsets.zero,
                          validator: (value) => _validateAmount(value),
                        ),
                        SizedBox(height: context.scale(16)),

                        Text(
                          LocaleKeys.withdrawBankLabel.tr(),
                          style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s16),
                        ),
                        SizedBox(height: context.scale(8)),
                        BlocBuilder<WalletCubit, WalletState>(
                          buildWhen: (previous, current) =>
                              previous.getBanksState != current.getBanksState,
                          builder: (context, state) {
                            if (state.getBanksState == RequestState.loading) {
                              return Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorManager.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state.getBanksState == RequestState.error) {
                              return Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    LocaleKeys.bankLoadingError.tr(),
                                    style: getRegularStyle(
                                      color: Colors.red,
                                      fontSize: FontSize.s12,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state.getBanksState == RequestState.loaded) {
                              return CustomDropdown<BankEntity>(
                                items: state.banks,
                                value: _selectedBankId != null 
                                    ? state.banks.firstWhere((bank) => bank.id == _selectedBankId)
                                    : null,
                                onChanged: (BankEntity? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedBankId = value.id;
                                      _selectedBankName = value.name;
                                    });
                                  }
                                },
                                itemToString: (BankEntity item) => item.name,
                                hint: Text(LocaleKeys.selectBank.tr(),
                                    style: TextStyle(fontSize: FontSize.s12)),
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: ColorManager.greyShade),
                                decoration: DropdownStyles.getDropdownDecoration(),
                                dropdownColor: ColorManager.whiteColor,
                                menuMaxHeight: 200,
                                style: getMediumStyle(
                                  color: ColorManager.blackColor,
                                  fontSize: FontSize.s14,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: context.scale(16)),

                        Text(
                          LocaleKeys.withdrawIbanLabel.tr(),
                          style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s16),
                        ),
                        SizedBox(height: context.scale(8)),
                        AppTextField(
                          controller: _ibanController,
                          hintText: LocaleKeys.withdrawIbanHint.tr(),
                          keyboardType: TextInputType.text,
                          borderRadius: 20,
                          padding: EdgeInsets.zero,
                          validator: (value) => _validateIban(value),
                        ),
                        SizedBox(height: context.scale(16)),

                        InkWell(
                          onTap: (){

                          },
                          child: Row(
                            children: [
                              SvgImageComponent(
                                  iconPath:AppAssets.privacyAndPolicyIcon,
                              ),
                              SizedBox(width: context.scale(8)),

                              Text(
                                LocaleKeys.termsAndConditions.tr(),
                                style: getUnderlineRegularStyle(
                                  color: ColorManager.grey,
                                  fontSize: FontSize.s12,
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: context.scale(88),
              padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.scale(24)),
                  topRight: Radius.circular(context.scale(24)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonAppComponent(
                    width: 171,
                    height: 46,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.grey3,
                      borderRadius: BorderRadius.circular(context.scale(24)),
                    ),
                    buttonContent: Center(
                      child: Text(
                        LocaleKeys.cancelButton.tr(),
                        style: getMediumStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  BlocConsumer<WalletCubit, WalletState>(
                    listenWhen: (previous, current) =>
                        previous.withdrawRequestState !=
                        current.withdrawRequestState,
                    listener: (context, state) {
                      if (state.withdrawRequestState == RequestState.loaded) {
                        CustomSnackBar.show(
                          context: context,
                          message: LocaleKeys.withdrawSuccess.tr(),
                          type: SnackBarType.success,
                        );
                        Navigator.pop(context);
                      } else if (state.withdrawRequestState ==
                          RequestState.error) {
                        CustomSnackBar.show(
                          context: context,
                          message: state.withdrawRequestErrorMessage,
                          type: SnackBarType.error,
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.withdrawRequestState !=
                        current.withdrawRequestState,
                    builder: (context, state) {
                      return ButtonAppComponent(
                        width: 171,
                        height: 46,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius:
                              BorderRadius.circular(context.scale(24)),
                        ),
                        buttonContent: Center(
                          child: state.withdrawRequestState ==
                                  RequestState.loading
                              ? CupertinoActivityIndicator(
                                  color: ColorManager.whiteColor)
                              : Text(
                                  LocaleKeys.withdrawButton.tr(),
                                  style: getBoldStyle(
                                    color: ColorManager.whiteColor,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                        ),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedBankId == null) {
                              CustomSnackBar.show(
                                context: context,
                                message: LocaleKeys.selectBankRequired.tr(),
                                type: SnackBarType.error,
                              );
                              return;
                            }
                            
                            final amount = double.tryParse(_amountController.text.trim());
                            if (amount == null || amount <= 0) {
                              CustomSnackBar.show(
                                context: context,
                                message: LocaleKeys.invalidAmount.tr(),
                                type: SnackBarType.error,
                              );
                              return;
                            }
                            
                            final withdrawModel = WithDrawRequestModel(
                              amount: amount,
                              bankId: _selectedBankId!,
                              ibanNumber: _ibanController.text.trim(),
                            );
                            
                            context
                                .read<WalletCubit>()
                                .withdrawRequest(withdrawModel);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
