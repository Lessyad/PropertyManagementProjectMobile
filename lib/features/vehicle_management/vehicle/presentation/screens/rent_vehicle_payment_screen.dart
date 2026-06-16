import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../configuration/managers/value_manager.dart';
import '../../../../../core/components/app_bar_component.dart';
import '../../../../../core/components/button_app_component.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/request_states_extension.dart';
import '../../../../../core/utils/enums.dart';
import '../controller/rent_vehicle_cubit.dart';
import 'debug_state_screen.dart';
import '../../../../../core/services/paypal_payment_service.dart';
import '../../../../../core/services/shared_preferences_service.dart';

class RentVehiclePaymentScreen extends StatefulWidget {
  final String vehicleId;
  final String vehicleName;
  final String vehicleImage;
  final double dailyPrice;
  final int numberOfDays;
  final double totalPrice;

  const RentVehiclePaymentScreen({
    super.key,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImage,
    required this.dailyPrice,
    required this.numberOfDays,
    required this.totalPrice,
  });

  @override
  State<RentVehiclePaymentScreen> createState() => _RentVehiclePaymentScreenState();
}

class _RentVehiclePaymentScreenState extends State<RentVehiclePaymentScreen> {
  String selectedPaymentMethod = 'paypal';
  final TextEditingController _passCodeController = TextEditingController();

  @override
  void dispose() {
    _passCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.paymentFinalization.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            showBackIcon: true,
            centerText: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête numéroté
                  Row(
                    children: [
                      Container(
                        width: context.scale(32),
                        height: context.scale(32),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '3',
                            style: getBoldStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.scale(12)),
                      Text(
                        LocaleKeys.paymentFinalization.tr(),
                        style: getBoldStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.scale(24)),

                  // Informations du véhicule
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.vehicleInformation.tr(),
                          style: getBoldStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        SizedBox(height: context.scale(16)),

                        // Image et détails du véhicule
                        Row(
                          children: [
                            // Image du véhicule
                            Container(
                              width: context.scale(80),
                              height: context.scale(60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(widget.vehicleImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: context.scale(12)),

                            // Détails du véhicule
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.vehicleName,
                                    style: getBoldStyle(
                                      color: ColorManager.blackColor,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                  SizedBox(height: context.scale(4)),
                                  Text(
                                    '${widget.numberOfDays} ${LocaleKeys.days.tr()}',
                                    style: getRegularStyle(
                                      color: ColorManager.grey2,
                                      fontSize: FontSize.s12,
                                    ),
                                  ),
                                  SizedBox(height: context.scale(4)),
                                  Text(
                                    '${widget.dailyPrice.toStringAsFixed(0)} ${LocaleKeys.currencyPerDay.tr()}',
                                    style: getSemiBoldStyle(
                                      color: ColorManager.primaryColor,
                                      fontSize: FontSize.s12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.scale(16)),

                  // Détails du paiement
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.paymentDetails.tr(),
                          style: getBoldStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        SizedBox(height: context.scale(16)),

                        // Prix journalier
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.dailyPrice.tr(),
                              style: getRegularStyle(
                                color: ColorManager.grey2,
                                fontSize: FontSize.s14,
                              ),
                            ),
                            Text(
                              '${widget.dailyPrice.toStringAsFixed(0)} ${LocaleKeys.currency.tr()}',
                              style: getSemiBoldStyle(
                                color: ColorManager.blackColor,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: context.scale(8)),

                        // Nombre de jours
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.numberOfDays.tr(),
                              style: getRegularStyle(
                                color: ColorManager.grey2,
                                fontSize: FontSize.s14,
                              ),
                            ),
                            Text(
                              '${widget.numberOfDays} ${LocaleKeys.days.tr()}',
                              style: getSemiBoldStyle(
                                color: ColorManager.blackColor,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: context.scale(12)),

                        // Ligne de séparation
                        Divider(
                          color: ColorManager.greyShade,
                          thickness: 1,
                        ),

                        SizedBox(height: context.scale(12)),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.total.tr(),
                              style: getBoldStyle(
                                color: ColorManager.blackColor,
                                fontSize: FontSize.s16,
                              ),
                            ),
                            Text(
                              '${widget.totalPrice.toStringAsFixed(0)} ${LocaleKeys.currency.tr()}',
                              style: getBoldStyle(
                                color: ColorManager.primaryColor,
                                fontSize: FontSize.s18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.scale(16)),

                  // Méthode de paiement
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.paymentMethod.tr(),
                          style: getBoldStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        SizedBox(height: context.scale(16)),

                        // PayPal
                        _buildPaymentOption(
                          icon: Icons.payment,
                          title: 'PayPal',
                          subtitle: 'Payer avec PayPal de manière sécurisée',
                          value: 'paypal',
                          isSelected: selectedPaymentMethod == 'paypal',
                          imageAsset: 'assets/images/PayPalImage.png',
                        ),

                        SizedBox(height: context.scale(12)),

                        // Carte bancaire
                        _buildPaymentOption(
                          icon: Icons.credit_card,
                          title: LocaleKeys.creditCard.tr(),
                          subtitle: LocaleKeys.creditCardDescription.tr(),
                          value: 'Credit',
                          isSelected: selectedPaymentMethod == 'Credit',
                        ),

                        SizedBox(height: context.scale(12)),

                        // Portefeuille
                        _buildPaymentOption(
                          icon: Icons.account_balance_wallet,
                          title: LocaleKeys.wallet.tr(),
                          subtitle: LocaleKeys.walletDescription.tr(),
                          value: 'Wallet',
                          isSelected: selectedPaymentMethod == 'Wallet',
                        ),

                        SizedBox(height: context.scale(12)),

                        // Bankily
                        _buildPaymentOption(
                          icon: Icons.account_balance,
                          title: LocaleKeys.bankily.tr(),
                          subtitle: LocaleKeys.bankityDescription.tr(),
                          value: 'Bankily',
                          isSelected: selectedPaymentMethod == 'Bankily',
                          imageAsset: 'assets/images/BankilyImage.png',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.scale(24)),

                  // Champ PassCode pour Bankily
                  if (selectedPaymentMethod == 'bankily')
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppPadding.p16),
                      decoration: BoxDecoration(
                        color: ColorManager.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PassCode',
                            style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          SizedBox(height: context.scale(16)),
                          TextFormField(
                            controller: _passCodeController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Entrez votre PassCode',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: ColorManager.greyShade,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: ColorManager.greyShade,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: ColorManager.primaryColor,
                                ),
                              ),
                              filled: true,
                              fillColor: ColorManager.greyShade.withOpacity(0.3),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p16,
                                vertical: AppPadding.p12,
                              ),
                            ),
                            style: getRegularStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (selectedPaymentMethod == 'bankity')
                    SizedBox(height: context.scale(16)),

                  // Champs pour le permis de conduire
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations du permis de conduire',
                          style: getBoldStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        SizedBox(height: context.scale(16)),
                        
                        // Numéro de permis
                        TextFormField(
                          onChanged: (value) {
                            context.read<RentVehicleCubit>().setDrivingLicenseNumber(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Numéro de permis de conduire',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: ColorManager.greyShade,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: ColorManager.greyShade,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: ColorManager.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: ColorManager.greyShade.withOpacity(0.3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p16,
                              vertical: AppPadding.p12,
                            ),
                          ),
                          style: getRegularStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        
                        SizedBox(height: context.scale(12)),
                        
                        // Date d'expiration du permis
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(Duration(days: 365)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 3650)),
                            );
                            if (picked != null) {
                              context.read<RentVehicleCubit>().selectDrivingLicenseExpiry(picked);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.p16,
                              vertical: AppPadding.p12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorManager.greyShade),
                              borderRadius: BorderRadius.circular(8),
                              color: ColorManager.greyShade.withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<RentVehicleCubit, RentVehicleState>(
                                  builder: (context, state) {
                                    return Text(
                                      state.drivingLicenseExpiry != null
                                          ? 'Expire le: ${state.drivingLicenseExpiry!.day}/${state.drivingLicenseExpiry!.month}/${state.drivingLicenseExpiry!.year}'
                                          : 'Date d\'expiration du permis',
                                      style: getRegularStyle(
                                        color: state.drivingLicenseExpiry != null
                                            ? ColorManager.blackColor
                                            : ColorManager.grey2,
                                        fontSize: FontSize.s14,
                                      ),
                                    );
                                  },
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorManager.grey2,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.scale(16)),

                  // Bouton de confirmation
                  BlocBuilder<RentVehicleCubit, RentVehicleState>(
                    buildWhen: (previous, current) => true, // Toujours reconstruire pour le debug
                    builder: (context, state) {
                      return ButtonAppComponent(
                        width: double.infinity,
                        height: context.scale(50),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        buttonContent: state.paymentState.isLoading
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.whiteColor,
                            ),
                          ),
                        )
                            : Text(
                          LocaleKeys.confirmPaymentButton.tr(),
                          style: getBoldStyle(
                            color: ColorManager.whiteColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        onTap: () {
                          _confirmPayment();
                        },
                      );
                    },
                  ),

                  SizedBox(height: context.scale(16)),

                  // Conditions
                  Container(
                    padding: EdgeInsets.all(AppPadding.p12),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: ColorManager.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: context.scale(8)),
                        Expanded(
                          child: Text(
                            LocaleKeys.paymentTerms.tr(),
                            style: getRegularStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.scale(16)),

                  // Bouton de débogage
                  // Container(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const DebugStateScreen(),
                  //         ),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.orange,
                  //       padding: EdgeInsets.symmetric(vertical: 12),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.bug_report, color: Colors.white),
                  //         SizedBox(width: 8),
                  //         Text(
                  //           '🔍 Debug - Voir l\'état du Cubit',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: context.scale(16)),

                  // Bouton de test simple
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _confirmPayment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            '🧪 Test Direct - Forcer le Paiement',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
    String? imageAsset,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(AppPadding.p12),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorManager.primaryColor : ColorManager.greyShade,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (imageAsset != null)
              SizedBox(
                width: context.scale(40),
                height: context.scale(40),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: context.scale(40),
                    height: context.scale(40),
                    decoration: BoxDecoration(
                      color: isSelected ? ColorManager.primaryColor : ColorManager.greyShade,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(icon, color: isSelected ? ColorManager.whiteColor : ColorManager.grey2, size: 20),
                  ),
                ),
              )
            else
              Container(
                width: context.scale(40),
                height: context.scale(40),
                decoration: BoxDecoration(
                  color: isSelected ? ColorManager.primaryColor : ColorManager.greyShade,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: isSelected ? ColorManager.whiteColor : ColorManager.grey2, size: 20),
              ),
            SizedBox(width: context.scale(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      color: isSelected ? ColorManager.primaryColor : ColorManager.blackColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Text(subtitle, style: getRegularStyle(color: ColorManager.grey2, fontSize: FontSize.s12)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: ColorManager.primaryColor, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayPalPayment() async {
    try {
      final authToken = SharedPreferencesService().accessToken ?? '';
      if (authToken.isEmpty) {
        throw Exception('Token d\'authentification manquant. Veuillez vous reconnecter.');
      }

      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final paymentResponse = await PayPalPaymentService.createPayment(
        amount: widget.totalPrice,
        currency: 'USD',
        orderId: orderId,
        description: 'Location de véhicule - ${widget.vehicleName}',
        returnUrl: 'https://inmaa-api-gjhfcrfcg3hednhb.spaincentral-01.azurewebsites.net/api/payments/paypal/success',
        cancelUrl: 'https://inmaa-api-gjhfcrfcg3hednhb.spaincentral-01.azurewebsites.net/api/payments/paypal/cancel',
        authToken: authToken,
      );

      if (paymentResponse.success && paymentResponse.approvalUrl != null) {
        await PayPalPaymentService.openPayPalInBrowser(paymentResponse.approvalUrl!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Redirection vers PayPal...'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception(paymentResponse.errorMessage ?? 'Erreur lors de la création du paiement PayPal');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur PayPal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmPayment() async {
    // Traitement spécial pour PayPal
    if (selectedPaymentMethod == 'paypal') {
      await _processPayPalPayment();
      return;
    }

    final cubit = context.read<RentVehicleCubit>();

    // Vérifier que toutes les données sont remplies
    if (!_validatePaymentData()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.fillAllRequiredFields.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Lancer le processus de paiement
    cubit.confirmPayment(
      vehicleId: widget.vehicleId,
      paymentMethod: selectedPaymentMethod,
      totalAmount: widget.totalPrice,
      passCode: selectedPaymentMethod == 'bankily' ? _passCodeController.text.trim() : null,
    );
  }

  bool _validatePaymentData() {
    final state = context.read<RentVehicleCubit>().state;



    // Validation de base pour toutes les méthodes de paiement
    bool basicValidation = state.userName.isNotEmpty &&
        state.phoneNumber.isNotEmpty &&
        state.userID.isNotEmpty &&
        state.age.isNotEmpty &&
        state.vehicleReceptionPlace.isNotEmpty &&
        state.vehicleReturnPlace.isNotEmpty &&
        state.rentalDate != null &&
        state.returnDate != null &&
        state.idImage != null &&
        state.driveLicenseImage != null &&
        state.drivingLicenseNumber.isNotEmpty &&
        state.drivingLicenseExpiry != null;

    // Validation spécifique pour Bankily
    if (selectedPaymentMethod == 'bankily') {
      if (_passCodeController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le PassCode est requis pour Bankily'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }
    return basicValidation;
  }
}