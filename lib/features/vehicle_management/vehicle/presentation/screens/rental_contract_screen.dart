import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/shared_preferences_service.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../data/models/vehicle_deal_request.dart';
import '../../domain/entities/vehicle_entity.dart';
import 'payment_screen.dart';
import 'pdf_contract_viewer_screen.dart';
import '../components/vehicle_booking_stepper.dart';

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

  final MainDriverData mainDriver;
  final bool secondDriverEnabled;
  final SecondDriverData? secondDriver;

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
  bool _hasViewedContract = false;

  // Pré-chargement du PDF dès l'affichage de cet écran
  Future<Uint8List>? _pdfPrefetchFuture;

  @override
  void initState() {
    super.initState();
    _startPrefetch();
  }

  void _startPrefetch() {
    final startDT = DateTime(
      widget.receptionDate.year, widget.receptionDate.month, widget.receptionDate.day,
      widget.receptionTime.hour, widget.receptionTime.minute,
    );
    final endDT = DateTime(
      widget.deliveryDate.year, widget.deliveryDate.month, widget.deliveryDate.day,
      widget.deliveryTime.hour, widget.deliveryTime.minute,
    );
    if (!startDT.isBefore(endDT)) return;
    _pdfPrefetchFuture = _fetchContractBytes(startDT, endDT);
  }

  Future<Uint8List> _fetchContractBytes(DateTime startDT, DateTime endDT) async {
    final token = SharedPreferencesService().accessToken;
    final language = SharedPreferencesService().language;
    final body = _buildContractBody(startDT, endDT);

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ));
    final response = await dio.post(
      ApiConstants.vehicleContractPreview,
      data: body,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Accept': 'application/pdf',
          'content-type': 'application/json',
          'Accept-Language': language,
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Uint8List.fromList(response.data as List<int>);
    }
    throw Exception('HTTP ${response.statusCode}');
  }

  Map<String, dynamic> _buildContractBody(DateTime startDT, DateTime endDT) {
    return {
      'vehicleId': widget.vehicle.id,
      'startDate': startDT.toIso8601String(),
      'endDate': endDT.toIso8601String(),
      'documentType': widget.mainDriver.documentType,
      'firstName': widget.mainDriver.firstName,
      'lastName': widget.mainDriver.lastName,
      'familyName': widget.mainDriver.familyName,
      'name': '${widget.mainDriver.firstName} ${widget.mainDriver.lastName}',
      'phoneNumber': widget.mainDriver.phoneNumber,
      'idNumber': widget.mainDriver.idNumber,
      'dateOfBirth': widget.mainDriver.birthDate.toIso8601String(),
      'idExpiryDate': widget.mainDriver.idExpiryDate.toIso8601String(),
      'drivingLicenseNumber': widget.mainDriver.drivingLicenseNumber,
      'drivingLicenseIssueDate': widget.mainDriver.drivingLicenseIssueDate.toIso8601String(),
      'secondDriverEnabled': widget.secondDriverEnabled,
      'kilometerIllimitedPerDay': widget.extraKilometers,
      'allRiskCarInsurance': widget.fullInsurance,
      'addChildsChair': widget.childSeat,
      'pickupAreaId': widget.pickupAreaId,
      'returnAreaId': widget.returnAreaId,
      if (widget.secondDriverEnabled && widget.secondDriver != null) ...{
        'secondDriverDocumentType': widget.secondDriver!.documentType,
        'secondDriverFirstName': widget.secondDriver!.firstName,
        'secondDriverLastName': widget.secondDriver!.lastName,
        'secondDriverFamilyName': widget.secondDriver!.familyName,
        'secondDriverName': '${widget.secondDriver!.firstName} ${widget.secondDriver!.lastName}',
        'secondDriverPhoneNumber': widget.secondDriver!.phoneNumber,
        'secondDriverIdNumber': widget.secondDriver!.idNumber,
        'secondDriverBirthDate': widget.secondDriver!.birthDate.toIso8601String(),
        'secondDriverIdExpiryDate': widget.secondDriver!.idExpiryDate.toIso8601String(),
        'secondDriverLicenseNumber': widget.secondDriver!.drivingLicenseNumber,
        'secondDriverLicenseIssueDate': widget.secondDriver!.drivingLicenseIssueDate.toIso8601String(),
      },
    };
  }

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
          const VehicleBookingStepper(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildContractHeader(),
                  const SizedBox(height: 16),
                  _buildContractSummary(),
                  const SizedBox(height: 16),
                  _buildViewContractButton(),
                  const SizedBox(height: 16),
                  _buildAcceptanceCheckbox(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // ── En-tête ────────────────────────────────────────────────────────────────

  Widget _buildContractHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.description_rounded,
                size: 32, color: ColorManager.primaryColor),
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.rentalContractTitle.tr(),
            textAlign: TextAlign.center,
            style:
                getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s18),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.readTermsCarefully.tr(),
            textAlign: TextAlign.center,
            style:
                getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s13),
          ),
        ],
      ),
    );
  }

  // ── Résumé du contrat ──────────────────────────────────────────────────────

  Widget _buildContractSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(LocaleKeys.termsAndConditions.tr()),
          const SizedBox(height: 16),
          _buildInfoRow(
              Icons.directions_car_rounded, LocaleKeys.rentedVehicle.tr(),
              '${widget.vehicle.makeName} ${widget.vehicle.modelName} — ${widget.vehicle.color}'),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _buildInfoRow(
              Icons.calendar_today_rounded, LocaleKeys.rentalPeriod.tr(),
              '${_formatDate(widget.receptionDate)} → ${_formatDate(widget.deliveryDate)}'),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _buildInfoRow(
              Icons.location_on_rounded, LocaleKeys.pickupLocation.tr(),
              widget.receptionLocation),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _buildInfoRow(
              Icons.flag_rounded, LocaleKeys.returnLocation.tr(),
              widget.deliveryLocation),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _buildInfoRow(
              Icons.payments_rounded, LocaleKeys.totalToPay.tr(),
              '${widget.totalPrice.toStringAsFixed(0)} MRU',
              valueColor: ColorManager.primaryColor,
              bold: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor, bool bold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: ColorManager.primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: getRegularStyle(
                      color: ColorManager.grey, fontSize: FontSize.s11)),
              const SizedBox(height: 2),
              Text(value,
                  style: bold
                      ? getBoldStyle(
                          color: valueColor ?? ColorManager.blackColor,
                          fontSize: FontSize.s13)
                      : getRegularStyle(
                          color: valueColor ?? ColorManager.blackColor,
                          fontSize: FontSize.s13)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Bouton "Consulter le contrat" ──────────────────────────────────────────

  Widget _buildViewContractButton() {
    return GestureDetector(
      onTap: _openContractSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: _hasViewedContract
              ? const Color(0xFFE8F5E9)
              : ColorManager.primaryColor.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hasViewedContract
                ? Colors.green.shade400
                : ColorManager.primaryColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _hasViewedContract
                    ? Colors.green.shade50
                    : ColorManager.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _hasViewedContract
                    ? Icons.check_circle_rounded
                    : Icons.visibility_rounded,
                color: _hasViewedContract
                    ? Colors.green.shade600
                    : ColorManager.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.viewContract.tr(),
                    style: getBoldStyle(
                      color: _hasViewedContract
                          ? Colors.green.shade700
                          : ColorManager.primaryColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _hasViewedContract
                        ? LocaleKeys.iHaveReadContract.tr()
                        : LocaleKeys.contractReadRequired.tr(),
                    style: getRegularStyle(
                      color: _hasViewedContract
                          ? Colors.green.shade600
                          : ColorManager.grey,
                      fontSize: FontSize.s11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: _hasViewedContract
                  ? Colors.green.shade400
                  : ColorManager.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ── Checkbox acceptation ───────────────────────────────────────────────────

  Widget _buildAcceptanceCheckbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: !_hasViewedContract
            ? Border.all(color: const Color(0xFFEEEEEE), width: 1)
            : null,
      ),
      child: Opacity(
        opacity: _hasViewedContract ? 1.0 : 0.45,
        child: Row(
          children: [
            Checkbox(
              value: _isContractAccepted,
              onChanged: _hasViewedContract
                  ? (value) {
                      setState(() => _isContractAccepted = value ?? false);
                    }
                  : null,
              activeColor: ColorManager.primaryColor,
            ),
            Expanded(
              child: GestureDetector(
                onTap: _hasViewedContract
                    ? () => setState(
                        () => _isContractAccepted = !_isContractAccepted)
                    : null,
                child: Text(
                  LocaleKeys.acceptTerms.tr(),
                  style: getRegularStyle(
                      color: ColorManager.blackColor, fontSize: FontSize.s14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.greyShade,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: Text(
                LocaleKeys.backButton.tr(),
                style: getBoldStyle(
                    color: ColorManager.primaryColor, fontSize: FontSize.s16),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _isContractAccepted ? _proceedToPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isContractAccepted
                    ? ColorManager.primaryColor
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: _isContractAccepted ? 2 : 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: Text(
                LocaleKeys.proceedToPayment.tr(),
                style: getBoldStyle(
                    color: _isContractAccepted
                        ? Colors.white
                        : Colors.grey[500]!,
                    fontSize: FontSize.s16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom sheet contrat complet ───────────────────────────────────────────

  void _openContractSheet() {
    // Vérifier que les dates sont valides avant d'ouvrir le contrat
    final startDT = DateTime(
      widget.receptionDate.year, widget.receptionDate.month, widget.receptionDate.day,
      widget.receptionTime.hour, widget.receptionTime.minute,
    );
    final endDT = DateTime(
      widget.deliveryDate.year, widget.deliveryDate.month, widget.deliveryDate.day,
      widget.deliveryTime.hour, widget.deliveryTime.minute,
    );

    if (!startDT.isBefore(endDT)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.returnDateMustBeAfterPickup.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfContractViewerScreen(
          vehicle: widget.vehicle,
          startDate: widget.receptionDate,
          startTime: widget.receptionTime,
          endDate: widget.deliveryDate,
          endTime: widget.deliveryTime,
          mainDriver: widget.mainDriver,
          secondDriverEnabled: widget.secondDriverEnabled,
          secondDriver: widget.secondDriver,
          extraKilometers: widget.extraKilometers,
          fullInsurance: widget.fullInsurance,
          childSeat: widget.childSeat,
          pickupAreaId: widget.pickupAreaId,
          returnAreaId: widget.returnAreaId,
          prefetchedBytes: _pdfPrefetchFuture,
          onContractRead: () {
            setState(() => _hasViewedContract = true);
          },
        ),
      ),
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

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
          secondDriverAmount: widget.secondDriverAmount,
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(
        title,
        style: getBoldStyle(
            color: ColorManager.blackColor, fontSize: FontSize.s15),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
