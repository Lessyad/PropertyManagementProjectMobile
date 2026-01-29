import 'package:flutter/material.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../data/models/vehicle_deal_request.dart';
import 'payment_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class RentalContractScreen extends StatefulWidget {
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

  const RentalContractScreen({
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
    this.secondDriverAmount = false,
  }) : super(key: key);

  @override
  State<RentalContractScreen> createState() => _RentalContractScreenState();
}

class _RentalContractScreenState extends State<RentalContractScreen> {
  bool _isContractAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      appBar: AppBar(
        title: Text(LocaleKeys.rentalContract.tr()),
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // En-tête du contrat
                  _buildContractHeader(),
                  const SizedBox(height: 20),

                  // Contenu du contrat PDF
                  _buildContractContent(),
                  const SizedBox(height: 20),

                  // Case à cocher pour accepter
                  _buildAcceptanceCheckbox(),
                ],
              ),
            ),
          ),

          // Footer avec bouton de navigation vers paiement
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildContractHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: [
          Icon(
            Icons.description,
            size: 48,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.rentalContractTitle.tr(),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.readTermsCarefully.tr(),
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: ColorManager.grey,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            LocaleKeys.termsAndConditions.tr(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 16),

          // Informations du véhicule
          _buildContractSection(
            LocaleKeys.rentedVehicle.tr(),
            '${LocaleKeys.brandModel.tr()}: ${widget.vehicle.makeName} ${widget.vehicle.modelName}\n'
                '${LocaleKeys.category.tr()}: ${widget.vehicle.categoryName}\n'
                '${LocaleKeys.color.tr()}: ${widget.vehicle.color}\n'
                '${LocaleKeys.dailyPrice.tr()}: ${widget.vehicle.dailyPrice.toStringAsFixed(0)} ',
          ),

          const SizedBox(height: 16),

          // Période de location
          _buildContractSection(
            LocaleKeys.rentalPeriod.tr(),
            '${LocaleKeys.startDate.tr()}: ${_formatDate(widget.receptionDate)} ${LocaleKeys.at.tr()} ${_formatTime(widget.receptionTime)}\n'
                '${LocaleKeys.endDate.tr()}: ${_formatDate(widget.deliveryDate)} ${LocaleKeys.at.tr()} ${_formatTime(widget.deliveryTime)}\n'
                '${LocaleKeys.pickupLocation.tr()}: ${widget.receptionLocation}\n'
                '${LocaleKeys.returnLocation.tr()}: ${widget.deliveryLocation}',
          ),

          const SizedBox(height: 16),

          // Options supplémentaires
          if (widget.extraKilometers || widget.fullInsurance || widget.childSeat)
            _buildContractSection(
              LocaleKeys.additionalOptions.tr(),
              '${widget.extraKilometers ? "${LocaleKeys.extraKilometers.tr()}: ${widget.kilometerDetails ?? LocaleKeys.included.tr()}\n" : ""}'
                  '${widget.fullInsurance ? "${LocaleKeys.fullInsurance.tr()}: ${LocaleKeys.included.tr()}\n" : ""}'
                  '${widget.childSeat ? "${LocaleKeys.childSeatOption.tr()}: ${LocaleKeys.included.tr()}\n" : ""}',
            ),

          const SizedBox(height: 16),

          // Montant total
          _buildContractSection(
            LocaleKeys.totalAmount.tr(),
            '${LocaleKeys.totalToPay.tr()}: ${widget.totalPrice} MRU',
          ),

          const SizedBox(height: 16),

          // Conditions générales
          // _buildContractSection(
          //   LocaleKeys.generalConditions.tr(),
          //   '${LocaleKeys.condition1.tr()}\n'
          //       '${LocaleKeys.condition2.tr()}\n'
          //       '${LocaleKeys.condition3.tr()}\n'
          //       '${LocaleKeys.condition4.tr()}\n'
          //       '${LocaleKeys.condition5.tr()}\n'
          //       '${LocaleKeys.condition6.tr()}\n'
          //       '${LocaleKeys.condition7.tr()}',
          // ),

          const SizedBox(height: 16),

          // Clause d'acceptation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorManager.primaryColor,
                width: 1,
              ),
            ),
            child: Text(
              LocaleKeys.acceptanceClause.tr(),
              style: getRegularStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractSection(String title, String content) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: getRegularStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptanceCheckbox() {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          Checkbox(
            value: _isContractAccepted,
            onChanged: (value) {
              setState(() {
                _isContractAccepted = value ?? false;
              });
            },
            activeColor: ColorManager.primaryColor,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isContractAccepted = !_isContractAccepted;
                });
              },
              child: Text(
                LocaleKeys.acceptTerms.tr(),
                style: getRegularStyle(
                  color: ColorManager.blackColor,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                LocaleKeys.backButton.tr(),
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isContractAccepted ? _proceedToPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isContractAccepted
                    ? ColorManager.primaryColor
                    : Colors.grey[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                LocaleKeys.proceedToPayment.tr(),
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          vehicle: widget.vehicle,
          receptionDate: widget.receptionDate,
          receptionTime: widget.receptionTime,
          receptionLocation: widget.receptionLocation,
          deliveryDate: widget.deliveryDate,
          deliveryTime: widget.deliveryTime,
          deliveryLocation: widget.deliveryLocation,
          extraKilometers: widget.extraKilometers,
          kilometerDetails: widget.kilometerDetails,
          fullInsurance: widget.fullInsurance,
          childSeat: widget.childSeat,
          totalPrice: widget.totalPrice,
          mainDriver: widget.mainDriver,
          secondDriverEnabled: widget.secondDriverEnabled,
          secondDriver: widget.secondDriver,
          pickupAreaId: widget.pickupAreaId,
          returnAreaId: widget.returnAreaId,
          secondDriverAmount : widget.secondDriverAmount
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}