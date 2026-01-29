import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/presentation/controller/user_appointments_cubit.dart';
import 'package:enmaa/features/preview_property/presentation/controller/preview_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart' as material;
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../data/models/add_new_preview_time_request_model.dart';

class BottomButtons extends material.StatelessWidget {
  const BottomButtons({
    super.key,
    required this.currentPage,
    required this.pageController,
    required this.propertyId,
    this.updateAppointment = false,
  });

  final int currentPage;
  final material.PageController pageController;
  final String propertyId;
  final bool updateAppointment;

  @override
  material.Widget build(material.BuildContext context) {
    return material.Positioned(
      bottom: context.scale(25),
      left: context.scale(16),
      right: context.scale(16),
      child: material.Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? material.TextDirection.rtl
            : material.TextDirection.ltr,
        child: material.Row(
          mainAxisAlignment: material.MainAxisAlignment.spaceBetween,
          children: [
            ButtonAppComponent(
              width: 171,
              height: 46,
              padding: material.EdgeInsets.zero,
              decoration: material.BoxDecoration(
                color: ColorManager.grey3,
                borderRadius: material.BorderRadius.circular(context.scale(24)),
              ),
              buttonContent: material.Center(
                child: material.Text(
                  updateAppointment || currentPage == 0
                      ? LocaleKeys.cancel.tr()
                      : LocaleKeys.previous.tr(),
                  style: getMediumStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
              onTap: () {
                if (updateAppointment || currentPage == 0) {
                  material.Navigator.of(context).pop();
                } else {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: material.Curves.easeInOut,
                  );
                }
              },
            ),
            BlocConsumer<PreviewPropertyCubit, PreviewPropertyState>(
              listener: (context, state) {
                if (state.addNewPreviewTimeState.isLoaded) {
                  CustomSnackBar.show(
                    context: context,
                    message: LocaleKeys.appointmentConfirmedMessage.tr(),
                    type: SnackBarType.success,
                  );
                  material.Navigator.pop(context);
                }
              },
              builder: (context, state) {
                final bool canConfirm =
                    state.selectedDate != null && state.selectedTime != null;
                final bool canSendRequest = state.getInspectionAmountState.isLoaded;
                
                // Vérifier si une méthode de paiement est sélectionnée
                final bool isPaymentMethodSelected = state.currentPaymentMethod.isNotEmpty;
                
                // Vérifier si Bankily est sélectionné et si le passcode est saisi
                final bool isBankilySelected = state.currentPaymentMethod == LocaleKeys.bankily.tr();
                final bool hasBankilyPasscode = state.bankilyPassCode.isNotEmpty;
                final bool isBankilyValid = !isBankilySelected || hasBankilyPasscode;
                
                // Le bouton est activé seulement si une méthode est sélectionnée ET que Bankily est valide
                final bool isButtonEnabled = isPaymentMethodSelected && isBankilyValid;

                return ButtonAppComponent(
                  width: 171,
                  height: 46,
                  padding: material.EdgeInsets.zero,
                  decoration: material.BoxDecoration(
                    color: (canConfirm && isButtonEnabled)
                        ? ColorManager.primaryColor
                        : (canSendRequest && isButtonEnabled)
                        ? ColorManager.primaryColor
                        : ColorManager.primaryColor.withOpacity(0.5),
                    borderRadius: material.BorderRadius.circular(context.scale(24)),
                  ),
                  buttonContent: material.Center(
                    child: material.Text(
                      updateAppointment
                          ? LocaleKeys.confirm.tr()
                          : currentPage == 0
                          ? LocaleKeys.next.tr()
                          : LocaleKeys.confirmAppointment.tr(),
                      style: getBoldStyle(
                        color: ColorManager.whiteColor,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Vérifier si le bouton est désactivé
                    if (!isButtonEnabled) {
                      return; // Ne rien faire si aucune méthode n'est sélectionnée ou si Bankily est invalide
                    }
                    
                    if (updateAppointment && canConfirm) {
                      context.read<UserAppointmentsCubit>().updateAppointment(
                        newDate: DateFormat('yyyy-MM-dd', 'en')
                            .format(state.selectedDate!),
                        newTime: state.selectedTime!,
                      );
                      material.Navigator.pop(context);
                    } else if (currentPage == 0 && canConfirm) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: material.Curves.easeInOut,
                      );
                    } else {
                      if (canSendRequest) {
                        // Si PayPal est sélectionné, utiliser le processus PayPal
                        if (state.currentPaymentMethod == LocaleKeys.paypal.tr()) {
                          // Obtenir le token d'authentification depuis SharedPreferences
                          final authToken = SharedPreferencesService().accessToken;
                          if (authToken.isEmpty) {
                            CustomSnackBar.show(
                              context: context,
                              message: 'Token d\'authentification manquant',
                              type: SnackBarType.error,
                            );
                            return;
                          }
                          context
                              .read<PreviewPropertyCubit>()
                              .processPayPalPayment(
                                propertyId: propertyId,
                                authToken: authToken,
                              );
                        } else {
                          // Pour les autres méthodes de paiement (wallet, bankily)
                          String paymentMethod;
                          if (state.currentPaymentMethod == LocaleKeys.wallet.tr()) {
                            paymentMethod = 'wallet';
                          } else if (state.currentPaymentMethod == LocaleKeys.bankily.tr()) {
                            paymentMethod = 'bankily';
                          } else {
                            paymentMethod = 'wallet'; // default
                          }
                          
                          AddNewPreviewRequestModel request =
                          AddNewPreviewRequestModel(
                            propertyId: propertyId,
                            previewTime: state.selectedTime,
                            previewDate: DateFormat('yyyy-MM-dd', 'en')
                                .format(state.selectedDate!),
                            paymentMethod: paymentMethod,
                          );
                          context
                              .read<PreviewPropertyCubit>()
                              .addPreviewTimeForSpecificProperty(request);
                        }
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}