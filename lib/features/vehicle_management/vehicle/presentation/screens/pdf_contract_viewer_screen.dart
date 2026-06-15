import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/shared_preferences_service.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../data/models/vehicle_deal_request.dart';
import '../../domain/entities/vehicle_entity.dart';

class PdfContractViewerScreen extends StatefulWidget {
  final VehicleEntity vehicle;
  final DateTime startDate;
  final TimeOfDay startTime;
  final DateTime endDate;
  final TimeOfDay endTime;
  final MainDriverData mainDriver;
  final bool secondDriverEnabled;
  final SecondDriverData? secondDriver;
  final bool extraKilometers;
  final bool fullInsurance;
  final bool childSeat;
  final int pickupAreaId;
  final int returnAreaId;
  final VoidCallback onContractRead;

  /// Bytes pré-chargés depuis RentalContractScreen (optionnel — accélère l'affichage).
  final Future<Uint8List>? prefetchedBytes;

  const PdfContractViewerScreen({
    Key? key,
    required this.vehicle,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.mainDriver,
    required this.secondDriverEnabled,
    this.secondDriver,
    required this.extraKilometers,
    required this.fullInsurance,
    required this.childSeat,
    required this.pickupAreaId,
    required this.returnAreaId,
    required this.onContractRead,
    this.prefetchedBytes,
  }) : super(key: key);

  @override
  State<PdfContractViewerScreen> createState() =>
      _PdfContractViewerScreenState();
}

class _PdfContractViewerScreenState extends State<PdfContractViewerScreen> {
  Uint8List? _pdfBytes;
  bool _isLoading = true;
  String? _error;
  bool _hasScrolledToEnd = false;
  bool _prefetchConsumed = false;

  final PdfViewerController _pdfController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _fetchPreview();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  // ── Appel API ──────────────────────────────────────────────────────────────

  Future<void> _fetchPreview() async {
    // Validation locale avant appel API
    final startDT = DateTime(
      widget.startDate.year, widget.startDate.month, widget.startDate.day,
      widget.startTime.hour, widget.startTime.minute,
    );
    final endDT = DateTime(
      widget.endDate.year, widget.endDate.month, widget.endDate.day,
      widget.endTime.hour, widget.endTime.minute,
    );

    if (!startDT.isBefore(endDT)) {
      setState(() {
        _isLoading = false;
        _error = LocaleKeys.returnDateMustBeAfterPickup.tr();
      });
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    try {
      Uint8List bytes;
      // Première ouverture : utiliser les bytes pré-chargés si disponibles
      if (!_prefetchConsumed && widget.prefetchedBytes != null) {
        _prefetchConsumed = true;
        try {
          bytes = await widget.prefetchedBytes!;
        } catch (_) {
          // Le pré-chargement a échoué → appel frais
          bytes = await _doFetch(startDT, endDT);
        }
      } else {
        bytes = await _doFetch(startDT, endDT);
      }
      setState(() { _pdfBytes = bytes; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  // Appel HTTP direct, sans PrettyDioLogger (plus rapide sur réponse binaire)
  Future<Uint8List> _doFetch(DateTime startDT, DateTime endDT) async {
    final token = SharedPreferencesService().accessToken;
    final language = SharedPreferencesService().language;

    final body = <String, dynamic>{
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

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          LocaleKeys.rentalContractTitle.tr(),
          style: getBoldStyle(color: Colors.white, fontSize: FontSize.s16),
        ),
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isLoading && _error == null)
            IconButton(
              onPressed: _fetchPreview,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Actualiser',
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_error != null) return _buildError();
    return _buildPdfViewer();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: ColorManager.primaryColor),
          const SizedBox(height: 16),
          Text(
            'Génération du contrat...',
            style: getRegularStyle(
                color: ColorManager.grey, fontSize: FontSize.s14),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Impossible de générer le contrat',
              textAlign: TextAlign.center,
              style: getBoldStyle(
                  color: ColorManager.blackColor, fontSize: FontSize.s15),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: getRegularStyle(
                  color: ColorManager.grey, fontSize: FontSize.s12),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchPreview,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(LocaleKeys.tryAgain.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (!_hasScrolledToEnd &&
            n is ScrollUpdateNotification &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 100) {
          setState(() => _hasScrolledToEnd = true);
        }
        return false;
      },
      child: SfPdfViewer.memory(
        _pdfBytes!,
        controller: _pdfController,
        onPageChanged: (details) {
          // Mark as read when reaching last page
          if (!_hasScrolledToEnd &&
              details.newPageNumber == _pdfController.pageCount) {
            setState(() => _hasScrolledToEnd = true);
          }
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    if (_isLoading || _error != null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_hasScrolledToEnd) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.swipe_down_rounded,
                    size: 16, color: Color(0xFFAAAAAA)),
                const SizedBox(width: 4),
                Text(
                  LocaleKeys.readTermsCarefully.tr(),
                  style: getRegularStyle(
                      color: const Color(0xFFAAAAAA), fontSize: FontSize.s11),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                widget.onContractRead();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle_rounded, size: 20),
              label: Text(
                LocaleKeys.iHaveReadContract.tr(),
                style:
                    getBoldStyle(color: Colors.white, fontSize: FontSize.s14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
