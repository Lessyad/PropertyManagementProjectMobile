import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/utils/number_parser.dart';
import 'package:enmaa/features/book_property/presentation/controller/book_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../core/components/payment_bottom_sheet_component.dart';
import '../../../home_module/home_imports.dart';

// BookPropertyButtons widget
class BookPropertyButtons extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final Duration animationTime;
  final String propertyID;

  const BookPropertyButtons({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.animationTime,
    required this.propertyID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookPropertyCubit, BookPropertyState>(
      listener: (context, state) {
        if (state.bookPropertyState.isLoaded) {
          context.read<RealEstateCubit>().fetchPropertyDetails(propertyID);
        }
        if (state.bookPropertyState.isLoaded &&
            state.bookPropertyResponse != null) {
          Navigator.pop(context);
          if (state.bookPropertyResponse!.paymentMethod == LocaleKeys.wallet.tr()) {
            CustomSnackBar.show(
              message: LocaleKeys.propertyBookedSuccessfully.tr(),
              type: SnackBarType.success,
            );
          } else if (state.bookPropertyResponse!.gatewayUrl.isNotEmpty) {
            _launchPaymentUrl(state.bookPropertyResponse!.gatewayUrl);
          } else {
            // Paiement traité mais pas de gateway URL (paiement direct)
            CustomSnackBar.show(
              message: LocaleKeys.propertyBookedSuccessfully.tr(),
              type: SnackBarType.success,
            );
          }
        }
      },
      builder: (context, state) {
        bool isLoading = state.bookPropertyState.isLoading;
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 32.0,
            top: 16.0,
          ),
          child: AnimatedSwitcher(
            duration: animationTime,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  child: child,
                ),
              );
            },
            child: currentPage == 0
                ? BlocBuilder<BookPropertyCubit, BookPropertyState>(
              builder: (context, state) {
                // Étape 1: Vérifier que les données de vente sont chargées
                bool isStep1Valid = _isStep1Valid(state);
                
                return SizedBox(
                  key: const ValueKey<int>(0),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentPage == 0 && isStep1Valid) {
                        pageController.nextPage(
                          duration: animationTime,
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStep1Valid
                          ? ColorManager.primaryColor
                          : ColorManager.grey2,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(LocaleKeys.next.tr()),
                  ),
                );
              },
            )
                : Row(
              key: const ValueKey<int>(1),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 175,
                    height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentPage > 0) {
                        pageController.previousPage(
                          duration: Duration(milliseconds: 1),
                          curve: Curves.easeInOutSine,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD6D8DB),
                      foregroundColor: Color(0xFFD6D8DB),
                    ),
                    child: Text(
                      LocaleKeys.previous.tr(),
                      style: TextStyle(color: ColorManager.blackColor),
                    ),
                  ),
                  ),
                ),
                Flexible(
                  child: AnimatedSize(
                    duration: animationTime,
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      width: 175,
                      height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentPage == 1) {
                          // Étape 2: Vérifier si tous les champs sont remplis
                          if (_isStep2Valid(state)) {
                            pageController.nextPage(
                              duration: animationTime,
                              curve: Curves.easeIn,
                            );
                          }
                        } else if (currentPage == 2) {
                          // Étape 3: Vérifier si la méthode de paiement est valide
                          if (_isStep3Valid(state)) {
                            if (state.currentPaymentMethod == LocaleKeys.wallet.tr()) {
                              double amountToPay = NumberParser.parseDecimalString(state.propertySaleDetailsEntity!.bookingDeposit);
                              double userBalance = NumberParser.parseDecimalString(state.propertySaleDetailsEntity!.userBalance);
                              
                              PaymentBottomSheet.show(
                                context: context,
                                amountToPay: amountToPay,
                                userBalance: userBalance,
                                confirmPayment: () {
                                  Navigator.pop(context);
                                  context
                                      .read<BookPropertyCubit>()
                                      .bookProperty(propertyID);
                                },
                                changePaymentMethod: () {
                                  context
                                      .read<BookPropertyCubit>()
                                      .changePaymentMethod(
                                      LocaleKeys.creditCard.tr());
                                  Navigator.pop(context);
                                },
                              );
                            } else if (state.currentPaymentMethod == LocaleKeys.bankily.tr()) {
                              final passCode = context.read<BookPropertyCubit>().bankilyPassCodeController.text.trim();
                              if (passCode.isEmpty) {
                                CustomSnackBar.show(message: LocaleKeys.thisFieldIsRequired.tr(), type: SnackBarType.error);
                                return;
                              }
                              context.read<BookPropertyCubit>().setBankilyPassCode(passCode);
                              context
                                  .read<BookPropertyCubit>()
                                  .bookProperty(propertyID);
                            } else {
                              context
                                  .read<BookPropertyCubit>()
                                  .bookProperty(propertyID);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColorForCurrentStep(state, isLoading)
                            ? ColorManager.primaryColor
                            : ColorManager.grey2,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(currentPage == 2
                          ? LocaleKeys.submit.tr()
                          : LocaleKeys.next.tr()),
                    ),
                  ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchPaymentUrl(String url) async {
    if (url.isEmpty) return;

    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching payment URL: $e');
    }
  }

  /// Vérifie si l'étape 1 est valide (SaleDetailsScreen)
  bool _isStep1Valid(BookPropertyState state) {
    return state.getPropertySaleDetailsState.isLoaded;
  }

  /// Vérifie si l'étape 2 est valide (BuyerDataScreen)
  bool _isStep2Valid(BookPropertyState state) {
    return state.userName.isNotEmpty &&
        state.phoneNumber.isNotEmpty &&
        state.userID.isNotEmpty &&
        state.birthDate != null &&
        state.idExpirationDate != null &&
        state.selectedImages.isNotEmpty;
  }

  /// Vérifie si l'étape 3 est valide (CompleteThePurchaseScreen)
  bool _isStep3Valid(BookPropertyState state) {
    if (state.currentPaymentMethod.isEmpty) return false;
    
    // Si Bankily est sélectionné, vérifier que le passcode est saisi
    if (state.currentPaymentMethod == LocaleKeys.bankily.tr()) {
      return state.bankilyPassCode.isNotEmpty;
    }
    
    // Pour les autres méthodes de paiement, le bouton est activé
    return true;
  }

  /// Détermine la couleur du bouton selon l'étape actuelle
  bool _getButtonColorForCurrentStep(BookPropertyState state, bool isLoading) {
    if (isLoading) return false;
    
    if (currentPage == 1) {
      return _isStep2Valid(state);
    } else if (currentPage == 2) {
      return _isStep3Valid(state);
    }
    
    return false;
  }
}
