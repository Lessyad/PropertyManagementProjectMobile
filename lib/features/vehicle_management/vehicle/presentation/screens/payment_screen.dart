import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../core/services/currency_service.dart';
import '../../../../../core/services/error_handler_service.dart';
import '../../../../../core/components/bankily_merchant_code_box.dart';
import '../../../../../core/components/currency_display_widget.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../controller/vehicle_deal_multipart_controller.dart';
import '../controller/vehicle_deal_dependency_injection.dart';
import '../controller/vehicle_deal_test.dart';
import '../controller/vehicle_deal_simple_test.dart';
import '../controller/vehicle_deal_debug.dart';
import '../controller/auth_helper.dart';
import '../controller/area_service.dart';
import '../../data/models/vehicle_deal_request.dart';
import '../../data/datasources/vehicle_deal_multipart_corrected.dart';
import '../../data/datasources/paypal_service.dart';
import '../../data/datasources/backend_test_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../components/vehicle_booking_stepper.dart';

class PaymentScreen extends StatefulWidget {
  final VehicleEntity vehicle;
  final DateTime receptionDate;
  final TimeOfDay receptionTime;
  final String receptionLocation;
  final DateTime deliveryDate;
  final TimeOfDay deliveryTime;
  final String deliveryLocation;
  final bool extraKilometers;
  final String? kilometerDetails;
  final bool fullInsurance;
  final bool childSeat;
  final double totalPrice;
  final bool secondDriverAmount;

  // Données du locataire principal
  final MainDriverData mainDriver;
  final bool secondDriverEnabled;
  final SecondDriverData? secondDriver;

  // Données de localisation
  final int pickupAreaId;
  final int returnAreaId;

  const PaymentScreen({
    Key? key,
    required this.vehicle,
    required this.receptionDate,
    required this.receptionTime,
    required this.receptionLocation,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryLocation,
    this.extraKilometers = false,
    this.kilometerDetails,
    this.fullInsurance = false,
    this.childSeat = false,
    required this.totalPrice,
    required this.mainDriver,
    this.secondDriverEnabled = false,
    this.secondDriver,
    required this.pickupAreaId,
    required this.returnAreaId,
    required this.secondDriverAmount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'paypal';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _bankilyPhoneController = TextEditingController();
  bool _isProcessing = false;

  // Contrôleur pour l'envoi des données
  late VehicleDealMultipartController _multipartController;

  @override
  void initState() {
    super.initState();

    // Vérifier l'authentification de l'utilisateur
    if (!AuthHelper.isUserAuthenticated()) {
      print('❌ Utilisateur non authentifié');
      // Optionnel: rediriger vers l'écran de connexion
      // Navigator.of(context).pushReplacementNamed('/login');
    } else {
      print('✅ Utilisateur authentifié: ${AuthHelper.getCurrentUserId()}');

      // Vérifier le token d'authentification
      if (!AuthHelper.hasValidToken()) {
        print('❌ Token d\'authentification invalide');
      } else {
        print('✅ Token d\'authentification valide');
      }
    }

    // Initialiser les dépendances de manière optimisée
    _initializeDependencies();
  }

  void _initializeDependencies() async {
    try {
      // Initialiser les dépendances
      VehicleDealDependencyInjection.init();

      // Initialiser le contrôleur multipart corrigé
      _multipartController = Get.put(VehicleDealMultipartController(
        multipartDataSource: VehicleDealMultipartCorrected(client: http.Client()),
      ));

      // Initialiser le service des zones
      Get.put(AreaService());

      // Tests de connexion en arrière-plan pour ne pas bloquer l'UI
      _runBackgroundTests();
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation des dépendances: $e');
    }
  }

  void _runBackgroundTests() async {
    // Exécuter les tests en arrière-plan
    Future.microtask(() async {
      try {
        await VehicleDealTest.testApiConnection();
        await VehicleDealSimpleTest.testSimpleRequest();
      } catch (e) {
        print('⚠️ Tests de connexion échoués: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      appBar: AppBar(
        title: Text(tr(LocaleKeys.paymentTitle)),
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const VehicleBookingStepper(currentStep: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Résumé de la commande
                  _buildOrderSummary(),
                  const SizedBox(height: 20),

                  // Méthodes de paiement
                  _buildPaymentMethods(),
                  const SizedBox(height: 20),

                  // Formulaire de paiement
                  if (_selectedPaymentMethod == 'paypal') _buildPayPalPaymentForm(),
                  if (_selectedPaymentMethod == 'bankily') _buildBankilyPaymentForm(),
                  if (_selectedPaymentMethod == 'wallet') _buildWalletPaymentInfo(),
                ],
              ),
            ),
          ),

          // Footer avec bouton de paiement
          _buildPaymentFooter(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.orderSummary),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 60,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: widget.vehicle.imageUrls.isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(widget.vehicle.imageUrls.first),
                    fit: BoxFit.cover,
                  )
                      : null,
                  color: widget.vehicle.imageUrls.isEmpty ? Colors.grey[300] : null,
                ),
                child: widget.vehicle.imageUrls.isEmpty
                    ? const Icon(Icons.car_rental, color: Colors.grey, size: 20)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.vehicle.makeName} ${widget.vehicle.modelName}',
                      style: getBoldStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    Text(
                      '${_formatDateTime(widget.receptionDate)} - ${_formatDateTime(widget.deliveryDate)}',
                      style: getRegularStyle(
                        color: ColorManager.grey,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
              BoldCurrencyDisplayWidget(
                amount: widget.totalPrice,
                textColor: ColorManager.primaryColor,
                fontSize: FontSize.s16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.paymentMethod),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),

          // PayPal
          _buildPaymentOption(
            'paypal',
            'PayPal',
            Icons.payment,
            'Payer avec PayPal de manière sécurisée',
            imageAsset: 'assets/images/PayPalImage.png',
          ),

          // Bankily
          _buildPaymentOption(
            'bankily',
            'Bankily',
            Icons.phone_android,
            'Payer avec Bankily',
            imageAsset: 'assets/images/BankilyImage.png',
          ),

          // Paiement par wallet
          _buildPaymentOption(
            'wallet',
            tr(LocaleKeys.walletPayment),
            Icons.account_balance_wallet,
            tr(LocaleKeys.walletPaymentDesc),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon, String subtitle, {String? imageAsset}) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorManager.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          color: isSelected ? ColorManager.primaryColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            if (imageAsset != null)
              SizedBox(
                width: 36,
                height: 36,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Icon(icon, color: isSelected ? ColorManager.primaryColor : Colors.grey, size: 24),
                ),
              )
            else
              Icon(icon, color: isSelected ? ColorManager.primaryColor : Colors.grey, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s14)),
                  Text(subtitle, style: getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s12)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() { _selectedPaymentMethod = newValue!; });
              },
              activeColor: ColorManager.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPalPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PayPal',
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.payment,
                  size: 48,
                  color: ColorManager.primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  'Paiement sécurisé avec PayPal',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous serez redirigé vers PayPal pour finaliser votre paiement de manière sécurisée.',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Montant: ',
                      style: getBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    BoldCurrencyDisplayWidget(
                      amount: widget.totalPrice,
                      textColor: ColorManager.primaryColor,
                      fontSize: FontSize.s16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankilyPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bankily',
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),

          // Champ Passcode unique
          // Champ Numéro de téléphone Bankily
          _buildTextField(
            controller: _bankilyPhoneController,
            label: 'Numéro de téléphone Bankily',
            hint: 'Entrez votre numéro Bankily ',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            onChanged: (_) => _updatePaymentButtonState(),
          ),

          const SizedBox(height: 16),

          // Champ Passcode Bankily
          _buildTextField(
            controller: _passcodeController,
            label: 'Passcode',
            hint: 'Entrez votre passcode Bankily',
            icon: Icons.lock,
            keyboardType: TextInputType.number,
            obscureText: true,
            onChanged: (_) => _updatePaymentButtonState(),
          ),

          const SizedBox(height: 16),

          const BankilyMerchantCodeBox(),
        ],
      ),
    );
  }

  Widget _buildWalletPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(23),
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tr(LocaleKeys.walletPayment),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 48,
                  color: ColorManager.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  tr(LocaleKeys.walletPaymentDesc),
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${tr(LocaleKeys.amountToDebit)}: ',
                      style: getBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    BoldCurrencyDisplayWidget(
                      amount: widget.totalPrice,
                      textColor: ColorManager.primaryColor,
                      fontSize: FontSize.s16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: ColorManager.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorManager.primaryColor),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFooter() {
    bool isButtonDisabled = _isProcessing ||
        _selectedPaymentMethod.isEmpty ||
        (_selectedPaymentMethod == 'bankily' && _passcodeController.text.trim().isEmpty);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr(LocaleKeys.totalToPay),
                style: getBoldStyle(
                  color: ColorManager.blackColor,
                  fontSize: FontSize.s16,
                ),
              ),
              BoldCurrencyDisplayWidget(
                amount: widget.totalPrice,
                textColor: ColorManager.primaryColor,
                fontSize: FontSize.s18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.greyShade,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    tr(LocaleKeys.backButton),
                    style: getBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: FontSize.s16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: isButtonDisabled ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonDisabled
                        ? Colors.grey[300]
                        : ColorManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          tr(LocaleKeys.payNow),
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updatePaymentButtonState() {
    setState(() {
      // Cette fonction est appelée lorsque le champ Passcode change
      // Le state est automatiquement mis à jour grâce au setState
      // Cela va déclencher la reconstruction du widget avec la nouvelle validation
    });
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Traitement spécial pour PayPal
      if (_selectedPaymentMethod == 'paypal') {
        await _processPayPalPayment();
        return;
      }

      // Déterminer la méthode de paiement
      String paymentMethod = _selectedPaymentMethod;
      String? passcode;
      String? bankilyPhoneNumber;

      if (_selectedPaymentMethod == 'bankily') {
        paymentMethod = 'bankily';
        // passcode = _passcodeController.text;
        passcode = _passcodeController.text.trim();
        bankilyPhoneNumber = _bankilyPhoneController.text.trim();

        // Validation des champs Bankily
        if (bankilyPhoneNumber.isEmpty) {
          throw Exception('Veuillez entrer votre numéro de téléphone Bankily');
        }

        // Validation du champ Passcode
        if (passcode.isEmpty) {
          throw Exception('Veuillez entrer votre passcode Bankily');
        }
      } else if (_selectedPaymentMethod == 'wallet') {
        paymentMethod = 'wallet';
      }

      // Récupérer l'ID utilisateur depuis l'authentification
      final userId = AuthHelper.getAuthenticatedUserId();
      print('👤 ID utilisateur récupéré depuis l\'authentification: $userId');

      // Créer la requête pour le debug
      final request = VehicleDealRequest(
        vehicleId: widget.vehicle.id,
        startDate: widget.receptionDate,
        endDate: widget.deliveryDate,
        mainDriver: widget.mainDriver,
        secondDriverEnabled: widget.secondDriverEnabled,
        secondDriver: widget.secondDriver,
        paymentMethod: paymentMethod,
        passcode: passcode,
        bankilyPhoneNumber: bankilyPhoneNumber,
        kilometerIllimitedPerDay: widget.extraKilometers,
        allRiskCarInsurance: widget.fullInsurance,
        addChildsChair: widget.childSeat,
        pickupAreaId: widget.pickupAreaId,
        returnAreaId: widget.returnAreaId,
        secondDriverAmount : widget.secondDriverAmount,
      );

      // Debug de la requête
      await VehicleDealDebug.debugRequest(
        request: request,
        userId: userId,
        isClientUser: true,
      );

      // Envoyer les données vers l'endpoint deal/ avec multipart corrigé
      await _multipartController.createVehicleDealMultipart(
        vehicle: widget.vehicle,
        startDate: widget.receptionDate,
        endDate: widget.deliveryDate,
        mainDriver: widget.mainDriver,
        secondDriverEnabled: widget.secondDriverEnabled,
        secondDriver: widget.secondDriver,
        paymentMethod: paymentMethod,
        passcode: passcode,
        bankilyPhoneNumber: bankilyPhoneNumber,
        kilometerIllimitedPerDay: widget.extraKilometers,
        allRiskCarInsurance: widget.fullInsurance,
        addChildsChair: widget.childSeat,
        pickupAreaId: widget.pickupAreaId,
        returnAreaId: widget.returnAreaId,
        userId: userId, // ID utilisateur récupéré depuis l'authentification
        isClientUser: true,
      );

      if (_multipartController.hasError.value) {
        print('❌ PaymentScreen Multipart Error: ${_multipartController.errorMessage.value}');
        throw Exception(_multipartController.errorMessage.value);
      }

      setState(() {
        _isProcessing = false;
      });

      // Afficher un message de succès
      ErrorHandlerService.showSuccess(
        context: context,
        message: tr(LocaleKeys.successPaymentCompleted),
      );

      // Retourner à l'écran principal ou afficher un écran de confirmation
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      // Afficher un message d'erreur
      ErrorHandlerService.showError(
        context: context,
        errorResponse: e,
      );
    }
  }

  // Flux PayPal transactionnel : aucun deal n'est créé tant que le paiement n'est pas confirmé.
  // 1. Appel à /api/Vehicles/deal/paypal/initiate → backend valide, stocke la réservation, crée le paiement PayPal
  // 2. Ouverture du navigateur avec l'URL d'approbation PayPal
  // 3. Sur succès PayPal → backend crée le deal (Active) et la transaction (Completed)
  // 4. Sur annulation PayPal → backend supprime la réservation pendante (aucun deal créé)
  Future<void> _processPayPalPayment() async {
    try {
      final authToken = AuthHelper.getAuthToken();
      if (authToken.isEmpty) throw Exception('Token d\'authentification manquant');

      const baseUrl = 'https://inmaa-api-gjhfcrfcg3hednhb.spaincentral-01.azurewebsites.net/api';
      final uri = Uri.parse('$baseUrl/Vehicles/deal/paypal/initiate');
      final userId = AuthHelper.getAuthenticatedUserId();

      // Construire la requête multipart (même structure que la création normale)
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $authToken'
        ..fields['userId'] = userId.toString()
        ..fields['isClientUser'] = 'true'
        ..fields['VehicleId'] = widget.vehicle.id.toString()
        ..fields['StartDate'] = widget.receptionDate.toIso8601String()
        ..fields['EndDate'] = widget.deliveryDate.toIso8601String()
        ..fields['PaymentMethod'] = 'paypal'
        ..fields['KilometerIllimitedPerDay'] = widget.extraKilometers.toString()
        ..fields['AllRiskCarInsurance'] = widget.fullInsurance.toString()
        ..fields['AddChildsChair'] = widget.childSeat.toString()
        ..fields['PickupAreaId'] = widget.pickupAreaId.toString()
        ..fields['ReturnAreaId'] = widget.returnAreaId.toString()
        ..fields['MainDriver.DocumentType'] = widget.mainDriver.documentType
        ..fields['MainDriver.FirstName'] = widget.mainDriver.firstName
        ..fields['MainDriver.LastName'] = widget.mainDriver.lastName
        ..fields['MainDriver.FamilyName'] = widget.mainDriver.familyName
        ..fields['MainDriver.PhoneNumber'] = widget.mainDriver.phoneNumber
        ..fields['MainDriver.IdNumber'] = widget.mainDriver.idNumber
        ..fields['MainDriver.BirthDate'] = widget.mainDriver.birthDate.toIso8601String()
        ..fields['MainDriver.IdExpiryDate'] = widget.mainDriver.idExpiryDate.toIso8601String()
        ..fields['MainDriver.DrivingLicenseNumber'] = widget.mainDriver.drivingLicenseNumber
        ..fields['MainDriver.DrivingLicenseIssueDate'] = widget.mainDriver.drivingLicenseIssueDate.toIso8601String()
        ..fields['SecondDriverEnabled'] = widget.secondDriverEnabled.toString();

      // Images du conducteur principal
      if (widget.mainDriver.idCardImage != null) {
        final bytes = await widget.mainDriver.idCardImage!.readAsBytes();
        req.files.add(http.MultipartFile.fromBytes('MainDriver.IdCardImage', bytes,
            filename: 'id_card_${DateTime.now().millisecondsSinceEpoch}.jpg'));
      }
      if (widget.mainDriver.drivingLicenseImage != null) {
        final bytes = await widget.mainDriver.drivingLicenseImage!.readAsBytes();
        req.files.add(http.MultipartFile.fromBytes('MainDriver.DrivingLicenseImage', bytes,
            filename: 'license_${DateTime.now().millisecondsSinceEpoch}.jpg'));
      }

      // Deuxième conducteur
      if (widget.secondDriverEnabled && widget.secondDriver != null) {
        final d = widget.secondDriver!;
        req.fields['SecondDriver.DocumentType'] = d.documentType;
        req.fields['SecondDriver.FirstName'] = d.firstName;
        req.fields['SecondDriver.LastName'] = d.lastName;
        req.fields['SecondDriver.FamilyName'] = d.familyName;
        req.fields['SecondDriver.PhoneNumber'] = d.phoneNumber;
        req.fields['SecondDriver.IdNumber'] = d.idNumber;
        req.fields['SecondDriver.BirthDate'] = d.birthDate.toIso8601String();
        req.fields['SecondDriver.IdExpiryDate'] = d.idExpiryDate.toIso8601String();
        req.fields['SecondDriver.DrivingLicenseNumber'] = d.drivingLicenseNumber;
        req.fields['SecondDriver.DrivingLicenseIssueDate'] = d.drivingLicenseIssueDate.toIso8601String();
        if (d.idCardImage != null) {
          final bytes = await d.idCardImage!.readAsBytes();
          req.files.add(http.MultipartFile.fromBytes('SecondDriver.IdCardImage', bytes,
              filename: 'id2_${DateTime.now().millisecondsSinceEpoch}.jpg'));
        }
        if (d.drivingLicenseImage != null) {
          final bytes = await d.drivingLicenseImage!.readAsBytes();
          req.files.add(http.MultipartFile.fromBytes('SecondDriver.DrivingLicenseImage', bytes,
              filename: 'license2_${DateTime.now().millisecondsSinceEpoch}.jpg'));
        }
      }

      final streamed = await req.send();
      final responseBody = await streamed.stream.bytesToString();
      print('📡 Initiate Response ${streamed.statusCode}: $responseBody');

      if (streamed.statusCode != 200) {
        throw Exception('Erreur serveur (${streamed.statusCode}): $responseBody');
      }

      final data = json.decode(responseBody) as Map<String, dynamic>;
      final approvalUrl = data['approvalUrl'] as String?;
      if (approvalUrl == null || approvalUrl.isEmpty) {
        throw Exception('URL PayPal manquante dans la réponse du serveur');
      }

      final paypalUri = Uri.parse(approvalUrl);
      if (!await canLaunchUrl(paypalUri)) throw Exception('Impossible d\'ouvrir PayPal');

      await launchUrl(paypalUri, mode: LaunchMode.externalApplication);

      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Complétez le paiement sur PayPal. Votre réservation sera confirmée automatiquement.',
              style: getRegularStyle(color: Colors.white, fontSize: FontSize.s14),
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 6),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      ErrorHandlerService.showError(context: context, errorResponse: e);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _passcodeController.dispose();
    _bankilyPhoneController.dispose();
    super.dispose();
  }
}