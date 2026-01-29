import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart' as matrial;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../configuration/managers/value_manager.dart';
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/country_code_picker.dart';
import '../../../../../core/components/custom_date_picker.dart';
import '../../../../../core/components/svg_image_component.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';
import '../../../../home_module/home_imports.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../data/models/vehicle_deal_request.dart';
import '../controller/global_rental_options_controller.dart';
import 'rental_contract_screen.dart';

import 'package:easy_localization/easy_localization.dart';

enum DocumentType { identity, passport, residence }

class RentVehicleDataScreenEnhanced extends StatefulWidget {
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
  final int? receptionZoneId;
  final int? deliveryZoneId;
  final double? totalPrice;
    final bool? initialSecondDriver; // État initial du secondDriver depuis RentalSummaryScreen

  const RentVehicleDataScreenEnhanced({
    super.key,
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
    this.receptionZoneId,
    this.deliveryZoneId,
    this.totalPrice,
    this.initialSecondDriver,
  });

  @override
  State<RentVehicleDataScreenEnhanced> createState() => _RentVehicleDataScreenEnhancedState();
}

class _RentVehicleDataScreenEnhancedState extends State<RentVehicleDataScreenEnhanced> {
  // Instance d'ImagePicker
  final ImagePicker _picker = ImagePicker();

  // Controllers pour le locataire principal
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();

  // Controllers pour le deuxième chauffeur
  final TextEditingController _secondFirstNameController = TextEditingController();
  final TextEditingController _secondLastNameController = TextEditingController();
  final TextEditingController _secondFamilyNameController = TextEditingController();
  final TextEditingController _secondPhoneController = TextEditingController();
  final TextEditingController _secondIdNumberController = TextEditingController();
  final TextEditingController _secondLicenseNumberController = TextEditingController();
  final TextEditingController _secondAgeController = TextEditingController();

  // Variables d'état
  DocumentType _selectedDocumentType = DocumentType.identity;
  DateTime? _birthDate;
  DateTime? _idExpirationDate;
  DateTime? _licenseIssueDate;
  bool _hasSecondDriver = false;
  DateTime? _secondBirthDate;
  DateTime? _secondIdExpirationDate;
  DateTime? _secondLicenseIssueDate;
  DocumentType _secondSelectedDocumentType = DocumentType.identity;

  // Images
  File? _idImage;
  File? _licenseImage;
  File? _secondIdImage;
  File? _secondLicenseImage;
  bool _isFormValid = false;

  @override
  void dispose() {
    // Supprimer les listeners avant de disposer
    _firstNameController.removeListener(_checkFormValidity);
    _lastNameController.removeListener(_checkFormValidity);
    _familyNameController.removeListener(_checkFormValidity);
    _phoneController.removeListener(_checkFormValidity);
    _idNumberController.removeListener(_checkFormValidity);
    _licenseNumberController.removeListener(_checkFormValidity);

    _secondFirstNameController.removeListener(_checkFormValidity);
    _secondLastNameController.removeListener(_checkFormValidity);
    _secondFamilyNameController.removeListener(_checkFormValidity);
    _secondPhoneController.removeListener(_checkFormValidity);
    _secondIdNumberController.removeListener(_checkFormValidity);
    _secondLicenseNumberController.removeListener(_checkFormValidity);
    _secondAgeController.removeListener(_checkFormValidity);

    // Disposer les contrôleurs
    _firstNameController.dispose();
    _lastNameController.dispose();
    _familyNameController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _licenseNumberController.dispose();
    _secondFirstNameController.dispose();
    _secondLastNameController.dispose();
    _secondFamilyNameController.dispose();
    _secondPhoneController.dispose();
    _secondIdNumberController.dispose();
    _secondLicenseNumberController.dispose();
    _secondAgeController.dispose();
    super.dispose();
  }

  // Méthode helper pour copier un fichier vers un répertoire permanent
  Future<File?> _copyImageToPermanentStorage(File sourceFile, String prefix) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/vehicle_deal_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Obtenir l'extension du fichier
      final sourcePath = sourceFile.path;
      final extension = sourcePath.substring(sourcePath.lastIndexOf('.'));
      final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}$extension';
      final permanentPath = '${imagesDir.path}/$fileName';
      
      final permanentFile = await sourceFile.copy(permanentPath);
      print('✅ Image copiée vers: $permanentPath');
      return permanentFile;
    } catch (e) {
      print('❌ Erreur lors de la copie de l\'image: $e');
      // Si la copie échoue, retourner le fichier original
      return sourceFile;
    }
  }

  // Méthodes pour sélectionner les images
  Future<void> _pickIdImage() async {
    await _showImageSourceDialog((source) async {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final tempFile = File(image.path);
        // Copier vers un répertoire permanent
        final permanentFile = await _copyImageToPermanentStorage(tempFile, 'id_card');
        setState(() {
          _idImage = permanentFile;
        });
        _checkFormValidity();
        // Notification de succès
        // Get.snackbar(
        //   tr(LocaleKeys.imageAdded),
        //   tr(LocaleKeys.idDocumentUploaded),
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   duration: const Duration(seconds: 2),
        //   snackPosition: SnackPosition.BOTTOM,
        //   margin: const EdgeInsets.all(10),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${tr(LocaleKeys.imageAdded)}\n${tr(LocaleKeys.idDocumentUploaded)}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
          ),
        );

      }
    });
  }

  Future<void> _pickLicenseImage() async {
    await _showImageSourceDialog((source) async {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final tempFile = File(image.path);
        // Copier vers un répertoire permanent
        final permanentFile = await _copyImageToPermanentStorage(tempFile, 'driving_license');
        setState(() {
          _licenseImage = permanentFile;
        });
        // Notification de succès
        // Get.snackbar(
        //   tr(LocaleKeys.imageAdded),
        //   tr(LocaleKeys.licenseUploaded),
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   duration: const Duration(seconds: 2),
        //   snackPosition: SnackPosition.BOTTOM,
        //   margin: const EdgeInsets.all(10),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${tr(LocaleKeys.imageAdded)}\n${tr(LocaleKeys.licenseUploaded)}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating, // pour un style flottant
            margin: const EdgeInsets.all(10),    // marge autour du snackbar
          ),
        );



      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Ajouter des listeners pour tous les contrôleurs
    _firstNameController.addListener(_checkFormValidity);
    _lastNameController.addListener(_checkFormValidity);
    _familyNameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _idNumberController.addListener(_checkFormValidity);
    _licenseNumberController.addListener(_checkFormValidity);

    _secondFirstNameController.addListener(_checkFormValidity);
    _secondLastNameController.addListener(_checkFormValidity);
    _secondFamilyNameController.addListener(_checkFormValidity);
    _secondPhoneController.addListener(_checkFormValidity);
    _secondIdNumberController.addListener(_checkFormValidity);
    _secondLicenseNumberController.addListener(_checkFormValidity);
    _secondAgeController.addListener(_checkFormValidity);
  }

  Future<void> _pickSecondIdImage() async {
    await _showImageSourceDialog((source) async {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final tempFile = File(image.path);
        // Copier vers un répertoire permanent
        final permanentFile = await _copyImageToPermanentStorage(tempFile, 'second_id_card');
        setState(() {
          _secondIdImage = permanentFile;
        });
      }
    });
  }

  Future<void> _pickSecondLicenseImage() async {
    await _showImageSourceDialog((source) async {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final tempFile = File(image.path);
        // Copier vers un répertoire permanent
        final permanentFile = await _copyImageToPermanentStorage(tempFile, 'second_driving_license');
        setState(() {
          _secondLicenseImage = permanentFile;
        });
      }
    });
  }

  void _checkFormValidity() {
    bool isValid = _validateMainDriverForm();

    // Si le deuxième chauffeur est activé, vérifier aussi ses champs
    if (_hasSecondDriver) {
      isValid = isValid && _validateSecondDriverForm();
    }

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  // Méthode pour récupérer le montant dynamique du deuxième chauffeur
  double _getSecondDriverAmount() {
    try {
      if (Get.isRegistered<GlobalRentalOptionsController>()) {
        final optionsController = Get.find<GlobalRentalOptionsController>();
        return optionsController.secondDriverAmount;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du montant du deuxième chauffeur: $e');
    }
    // Valeur par défaut en cas d'erreur
    return 100.0;
  }

  bool _validateMainDriverForm() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _familyNameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _idNumberController.text.trim().isNotEmpty &&
        _licenseNumberController.text.trim().isNotEmpty &&
        _birthDate != null &&
        _idExpirationDate != null &&
        _licenseIssueDate != null &&
        _idImage != null &&
        _licenseImage != null;
  }

  bool _validateSecondDriverForm() {
    if (!_hasSecondDriver) return true;

    return _secondFirstNameController.text.trim().isNotEmpty &&
        _secondLastNameController.text.trim().isNotEmpty &&
        _secondFamilyNameController.text.trim().isNotEmpty &&
        _secondPhoneController.text.trim().isNotEmpty &&
        _secondIdNumberController.text.trim().isNotEmpty &&
        _secondLicenseNumberController.text.trim().isNotEmpty &&
        _secondAgeController.text.trim().isNotEmpty &&
        _validateAge(_secondAgeController.text) == null &&
        _secondBirthDate != null &&
        _secondIdExpirationDate != null &&
        _secondLicenseIssueDate != null &&
        _secondIdImage != null &&
        _secondLicenseImage != null;
  }

  Future<void> _showImageSourceDialog(Function(ImageSource) onSourceSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr(LocaleKeys.chooseSource)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(tr(LocaleKeys.camera)),
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.camera);
                  _checkFormValidity();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(tr(LocaleKeys.gallery)),
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.gallery);
                  _checkFormValidity();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Méthodes pour supprimer les images
  void _removeIdImage() {
    setState(() {
      _idImage = null;
    });
  }

  void _removeLicenseImage() {
    setState(() {
      _licenseImage = null;
    });
  }

  void _removeSecondIdImage() {
    setState(() {
      _secondIdImage = null;
    });
  }

  void _removeSecondLicenseImage() {
    setState(() {
      _secondLicenseImage = null;
    });
  }

  // Validation de l'âge
  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.ageRequired);
    }

    final age = int.tryParse(value);
    if (age == null) {
      return tr(LocaleKeys.validAgeRequired);
    }

    if (age < 18) {
      return tr(LocaleKeys.minAge18);
    }

    if (age > 80) {
      return tr(LocaleKeys.maxAge80);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      appBar: AppBar(
        title: Text(tr(LocaleKeys.tenantInfo)),
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NumberedTextHeaderComponent(
                    number: '1',
                    text: tr(LocaleKeys.mainTenant),
                  ),
                  SizedBox(height: context.scale(20)),

                  // Section Type de Document
                  _buildDocumentTypeSection(),
                  SizedBox(height: context.scale(16)),

                  // Section Image du Document
                  _buildDocumentImageSection(),
                  SizedBox(height: context.scale(16)),
                  // Section Informations Personnelles
                  _buildPersonalInfoSection(),
                  SizedBox(height: context.scale(16)),

                  // Section Permis de Conduire
                  _buildLicenseSection(),
                  SizedBox(height: context.scale(16)),

                  // Section Permis de Conduire - Détails
                  _buildLicenseDetailsSection(),
                  SizedBox(height: context.scale(24)),

                  // Section Deuxième Chauffeur
                  _buildSecondDriverSection(),

                  if (_hasSecondDriver) ...[
                    SizedBox(height: context.scale(20)),
                    _buildSecondDriverDetails(),
                  ],
                ],
              ),
            ),
          ),

          // Footer avec coût et bouton
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeSection() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.idDocumentType),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(12)),
          Row(
            children: [
              Expanded(
                child: _buildDocumentTypeOption(
                  DocumentType.identity,
                  tr(LocaleKeys.idCard),
                  Icons.credit_card,
                ),
              ),
              SizedBox(width: context.scale(8)),
              Expanded(
                child: _buildDocumentTypeOption(
                  DocumentType.passport,
                  tr(LocaleKeys.passport),
                  Icons.menu_book,
                ),
              ),
              SizedBox(width: context.scale(8)),
              Expanded(
                child: _buildDocumentTypeOption(
                  DocumentType.residence,
                  tr(LocaleKeys.residencePermit),
                  Icons.description,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeOption(DocumentType type, String title, IconData icon) {
    final isSelected = _selectedDocumentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDocumentType = type;
        });
        _checkFormValidity();
      },
      child: Container(
        padding: EdgeInsets.all(context.scale(12)),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primaryColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorManager.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? ColorManager.primaryColor : Colors.grey[600],
              size: 24,
            ),
            SizedBox(height: context.scale(4)),
            Text(
              title,
              style: getRegularStyle(
                color: isSelected ? ColorManager.primaryColor : Colors.grey[600]!,
                fontSize: FontSize.s10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentImageSection() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            _getDocumentImageTitle(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(8)),
          _buildImagePicker(
            onTap: _pickIdImage,
            image: _idImage,
            hintText: tr(LocaleKeys.uploadClearDocument),
            onRemove: _removeIdImage,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.personalInfo),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(16)),

          // Prénom
          _buildTextField(
            tr(LocaleKeys.firstName),
            tr(LocaleKeys.enterFirstName),
            _firstNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: context.scale(16)),

          // Nom
          _buildTextField(
            tr(LocaleKeys.lastName),
            tr(LocaleKeys.enterLastName),
            _lastNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: context.scale(16)),

          // Nom de famille
          _buildTextField(
            tr(LocaleKeys.familyName),
            tr(LocaleKeys.enterFamilyName),
            _familyNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: context.scale(16)),

          // Numéro de téléphone
          Text(
            tr(LocaleKeys.phoneNumber),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  textDirection: matrial.TextDirection.ltr,
                  hintText: tr(LocaleKeys.phoneNumberHint),
                  keyboardType: TextInputType.phone,
                  borderRadius: 20,
                  backgroundColor: ColorManager.whiteColor,
                  padding: EdgeInsets.zero,
                  controller: _phoneController,
                ),
              ),
              SizedBox(width: context.scale(8)),
              Container(
                width: context.scale(88),
                height: context.scale(44),
                decoration: BoxDecoration(
                  color: ColorManager.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomCountryCodePicker(
                  onChanged: (CountryCode countryCode) {
                    // Gérer le changement de code pays
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.scale(16)),

          // Numéro d'identité
          _buildTextField(
            tr(LocaleKeys.idNumber),
            tr(LocaleKeys.idNumberHint),
            _idNumberController,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: context.scale(16)),

          // Dates
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  tr(LocaleKeys.birthDate),
                  _birthDate,
                      (date) => setState(() => _birthDate = date),
                ),
              ),
              SizedBox(width: context.scale(16)),
              Expanded(
                child: _buildDateField(
                  tr(LocaleKeys.expiryDate),
                  _idExpirationDate,
                      (date) => setState(() => _idExpirationDate = date),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseSection() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.drivingLicense),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(8)),
          _buildImagePicker(
            onTap: _pickLicenseImage,
            image: _licenseImage,
            hintText: tr(LocaleKeys.uploadClearLicense),
            onRemove: _removeLicenseImage,
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseDetailsSection() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.licenseDetails),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(16)),

          // Numéro de permis
          _buildTextField(
            tr(LocaleKeys.licenseNumber),
            tr(LocaleKeys.licenseNumberHint),
            _licenseNumberController,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: context.scale(16)),

          // Date de sortie du permis
          _buildDateField(
            tr(LocaleKeys.licenseIssueDate),
            _licenseIssueDate,
                (date) => setState(() => _licenseIssueDate = date),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondDriverSection() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LocaleKeys.secondDriver),
                      style: getBoldStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    SizedBox(height: context.scale(4)),
                    Text(
                      '${tr(LocaleKeys.extraFees)}: +${_getSecondDriverAmount()}MRU',
                      style: getRegularStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _hasSecondDriver,
                onChanged: (value) {
                  setState(() {
                    _hasSecondDriver = value;
                  });
                  _checkFormValidity();
                },
                activeColor: ColorManager.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondDriverDetails() {
    return Column(
      children: [
        NumberedTextHeaderComponent(
          number: '2',
          text: tr(LocaleKeys.secondDriver),
        ),
        SizedBox(height: context.scale(20)),

        // Type de document pour le deuxième chauffeur
        _buildSecondDriverDocumentType(),
        SizedBox(height: context.scale(16)),

        // Images pour le deuxième chauffeur
        _buildSecondDriverImages(),
        SizedBox(height: context.scale(16)),

        // Informations personnelles du deuxième chauffeur
        _buildSecondDriverPersonalInfo(),
        SizedBox(height: context.scale(16)),
        _buildLicenseSectionSecondDriver(),
        SizedBox(height: context.scale(16)),
        // Détails du permis du deuxième chauffeur
        _buildSecondDriverLicenseDetails(),
      ],
    );
  }

  Widget _buildSecondDriverDocumentType() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.idDocumentType),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(12)),
          Row(
            children: [
              Expanded(
                child: _buildSecondDocumentTypeOption(
                  DocumentType.identity,
                  tr(LocaleKeys.idCard),
                  Icons.credit_card,
                ),
              ),
              SizedBox(width: context.scale(8)),
              Expanded(
                child: _buildSecondDocumentTypeOption(
                  DocumentType.passport,
                  tr(LocaleKeys.passport),
                  Icons.menu_book,
                ),
              ),
              SizedBox(width: context.scale(8)),
              Expanded(
                child: _buildSecondDocumentTypeOption(
                  DocumentType.residence,
                  tr(LocaleKeys.residencePermit),
                  Icons.description,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondDocumentTypeOption(DocumentType type, String title, IconData icon) {
    final isSelected = _secondSelectedDocumentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _secondSelectedDocumentType = type;
        });
        _checkFormValidity();
      },
      child: Container(
        padding: EdgeInsets.all(context.scale(12)),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primaryColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorManager.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? ColorManager.primaryColor : Colors.grey[600],
              size: 24,
            ),
            SizedBox(height: context.scale(4)),
            Text(
              title,
              style: getRegularStyle(
                color: isSelected ? ColorManager.primaryColor : Colors.grey[600]!,
                fontSize: FontSize.s10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondDriverImages() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.documents),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(16)),

          // Document d'identité
          Text(
            _getSecondDocumentImageTitle(),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: context.scale(8)),
          _buildImagePicker(
            onTap: _pickSecondIdImage,
            image: _secondIdImage,
            hintText: tr(LocaleKeys.idDocumentPhoto),
            onRemove: _removeSecondIdImage,
          ),
          SizedBox(height: context.scale(16)),

          // Permis de conduire
          // Text(
          //   tr(LocaleKeys.drivingLicense),
          //   style: getBoldStyle(
          //     color: ColorManager.blackColor,
          //     fontSize: FontSize.s14,
          //   ),
          // ),

        ],
      ),
    );
  }
  Widget _buildLicenseSectionSecondDriver() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.drivingLicense),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          // SizedBox(height: context.scale(8)),
          // _buildImagePicker(
          //   onTap: _pickLicenseImage,
          //   image: _licenseImage,
          //   hintText: tr(LocaleKeys.uploadClearLicense),
          //   onRemove: _removeLicenseImage,
          // ),
          SizedBox(height: context.scale(8)),
          _buildImagePicker(
            onTap: _pickSecondLicenseImage,
            image: _secondLicenseImage,
            hintText: tr(LocaleKeys.licensePhoto),
            onRemove: _removeSecondLicenseImage,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondDriverPersonalInfo() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.personalInfo),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(16)),

          // Prénom
          _buildTextField(
            tr(LocaleKeys.firstName),
            tr(LocaleKeys.secondDriverFirstNameHint),
            _secondFirstNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: context.scale(16)),

          // Nom
          _buildTextField(
            tr(LocaleKeys.lastName),
            tr(LocaleKeys.secondDriverLastNameHint),
            _secondLastNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: context.scale(16)),

          // Nom de famille
          _buildTextField(
            tr(LocaleKeys.familyName),
            tr(LocaleKeys.secondDriverFamilyNameHint),
            _secondFamilyNameController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: context.scale(16)),

          // Âge
          _buildValidatedTextField(
            tr(LocaleKeys.age),
            tr(LocaleKeys.ageHint),
            _secondAgeController,
            keyboardType: TextInputType.number,
            validator: _validateAge,
            maxLength: 2,
          ),
          SizedBox(height: context.scale(16)),

          // Téléphone
          Text(
            tr(LocaleKeys.phoneNumber),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: context.scale(8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  textDirection: matrial.TextDirection.ltr,
                  hintText: tr(LocaleKeys.phoneNumberHint),
                  keyboardType: TextInputType.phone,
                  borderRadius: 20,
                  backgroundColor: ColorManager.whiteColor,
                  padding: EdgeInsets.zero,
                  controller: _secondPhoneController,
                ),
              ),
              SizedBox(width: context.scale(8)),
              Container(
                width: context.scale(88),
                height: context.scale(44),
                decoration: BoxDecoration(
                  color: ColorManager.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomCountryCodePicker(
                  onChanged: (CountryCode countryCode) {
                    // Gérer le changement de code pays
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.scale(16)),

          // Numéro d'identité
          _buildTextField(
            tr(LocaleKeys.idNumber),
            tr(LocaleKeys.idNumberHint),
            _secondIdNumberController,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: context.scale(16)),

          // Dates
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  tr(LocaleKeys.birthDate),
                  _secondBirthDate,
                      (date) => setState(() => _secondBirthDate = date),
                ),
              ),
              SizedBox(width: context.scale(16)),
              Expanded(
                child: _buildDateField(
                  tr(LocaleKeys.expiryDate),
                  _secondIdExpirationDate,
                      (date) => setState(() => _secondIdExpirationDate = date),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondDriverLicenseDetails() {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
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
            tr(LocaleKeys.licenseDetails),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(16)),

          // Numéro de permis
          _buildTextField(
            tr(LocaleKeys.licenseNumber),
            tr(LocaleKeys.licenseNumberHint),
            _secondLicenseNumberController,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: context.scale(16)),

          // Date de délivrance
          _buildDateField(
            tr(LocaleKeys.licenseIssueDate),
            _secondLicenseIssueDate,
                (date) => setState(() => _secondLicenseIssueDate = date),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(8)),
        AppTextField(
          hintText: hint,
          keyboardType: keyboardType,
          borderRadius: 20,
          backgroundColor: ColorManager.whiteColor,
          padding: EdgeInsets.zero,
          controller: controller,
        ),
      ],
    );
  }

  Widget _buildValidatedTextField(
      String label,
      String hint,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(8)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getRegularStyle(
              color: Colors.grey[500]!,
              fontSize: FontSize.s14,
            ),
            filled: true,
            fillColor: ColorManager.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: ColorManager.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scale(16),
              vertical: context.scale(12),
            ),
            counterText: maxLength != null ? '' : null,
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: getRegularStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s14,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(8)),
        InkWell(
          onTap: () async {
            final DateTime? pickedDate = await showDialog<DateTime>(
              context: context,
              builder: (BuildContext dialogContext) {
                DateTime? tempSelectedDate = selectedDate;

                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.scale(12)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(context.scale(16)),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(context.scale(12)),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.blackColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          tr(LocaleKeys.selectDate),
                          style: getBoldStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        SizedBox(height: context.scale(16)),

                        Expanded(
                          child: CustomDatePicker(
                            showPreviousDates: true,
                            selectedDate: tempSelectedDate,
                            onSelectionChanged: (calendarSelectionDetails) {
                              if (calendarSelectionDetails.date != null) {
                                Navigator.of(dialogContext).pop(calendarSelectionDetails.date);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            if (pickedDate != null) {
              onDateSelected(pickedDate);
              _checkFormValidity();
            }
          },
          child: Container(
            height: context.scale(44),
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(context.scale(20)),
              border: Border.all(
                color: ColorManager.greyShade,
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
              child: Row(
                children: [
                  SvgImageComponent(
                    iconPath: AppAssets.calendarIcon,
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(width: context.scale(8)),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                          : tr(LocaleKeys.chooseDate),
                      style: selectedDate == null
                          ? getRegularStyle(
                        color: ColorManager.grey2,
                        fontSize: FontSize.s12,
                      )
                          : getSemiBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: ColorManager.grey2,
                    size: context.scale(24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker({
    required VoidCallback onTap,
    required File? image,
    required String hintText,
    VoidCallback? onRemove,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: image != null ? ColorManager.primaryColor : Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: image != null
            ? Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Bouton de suppression
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Indicateur de succès
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: Colors.grey[600],
            ),
            SizedBox(height: context.scale(8)),
            Text(
              hintText,
              style: getRegularStyle(
                color: Colors.grey[600]!,
                fontSize: FontSize.s12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.scale(4)),
            Text(
              '${tr(LocaleKeys.camera)} ${tr(LocaleKeys.or)} ${tr(LocaleKeys.gallery)}',
              style: getRegularStyle(
                color: ColorManager.primaryColor,
                fontSize: FontSize.s10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    double extraCost = 0;
    if (_hasSecondDriver) extraCost += _getSecondDriverAmount(); // Frais deuxième chauffeur dynamique

    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (extraCost > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tr(LocaleKeys.extraFees)}MRU',
                  style: getRegularStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
                Text(
                  '+${extraCost} ${tr(LocaleKeys.currency)}',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid ? _submitForm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? ColorManager.primaryColor
                    : Colors.grey[300],
                foregroundColor: _isFormValid
                    ? Colors.white
                    : Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _isFormValid ? 2 : 0,
              ),
              child: Text(
                tr(LocaleKeys.next),
                style: getBoldStyle(
                  color: _isFormValid ? Colors.white : Colors.grey[600]!,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDocumentImageTitle() {
    switch (_selectedDocumentType) {
      case DocumentType.identity:
        return tr(LocaleKeys.idCardPhoto);
      case DocumentType.passport:
        return tr(LocaleKeys.passportPhoto);
      case DocumentType.residence:
        return tr(LocaleKeys.residencePermitPhoto);
    }
  }

  String _getSecondDocumentImageTitle() {
    switch (_secondSelectedDocumentType) {
      case DocumentType.identity:
        return tr(LocaleKeys.idCard);
      case DocumentType.passport:
        return tr(LocaleKeys.passport);
      case DocumentType.residence:
        return tr(LocaleKeys.residencePermit);
    }
  }

  void _submitForm() {
    // Validation et soumission du formulaire
    if (_validateForm()) {
      // IMPORTANT: le total est déjà calculé dans `RentalSummaryScreen` (jours+heures + options)
      // On le réutilise ici pour garantir la cohérence (contrat + paiement)
      double totalPrice = widget.totalPrice ?? 0.0;
      
      // Ajuster le total en fonction de l'état actuel du deuxième chauffeur
      final secondDriverAmount = _getSecondDriverAmount();
      final wasSecondDriverIncluded = widget.initialSecondDriver ?? false;
      
      // Si le secondDriver était inclus dans le total initial mais n'est plus sélectionné, le soustraire
      if (wasSecondDriverIncluded && !_hasSecondDriver) {
        totalPrice -= secondDriverAmount;
      }
      // Si le secondDriver n'était pas inclus dans le total initial mais est maintenant sélectionné, l'ajouter
      else if (!wasSecondDriverIncluded && _hasSecondDriver) {
        totalPrice += secondDriverAmount;
      }
      // Si _hasSecondDriver == wasSecondDriverIncluded, le total est déjà correct

      // Créer les données du conducteur principal
      final mainDriver = MainDriverData(
        documentType: _selectedDocumentType.name,
        idCardImage: _idImage,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        familyName: _familyNameController.text,
        phoneNumber: _phoneController.text,
        idNumber: _idNumberController.text,
        birthDate: _birthDate!,
        idExpiryDate: _idExpirationDate!,
        drivingLicenseImage: _licenseImage,
        drivingLicenseNumber: _licenseNumberController.text,
        drivingLicenseIssueDate: _licenseIssueDate!,
        vehicleReceptionPlace: widget.receptionLocation,
        vehicleReceptionLat: "18.0731", // TODO: Récupérer les coordonnées réelles
        vehicleReceptionLng: "-15.9582",
        vehicleReturnPlace: widget.deliveryLocation,
        vehicleReturnLat: "18.0731", // TODO: Récupérer les coordonnées réelles
        vehicleReturnLng: "-15.9582",
      );

      // Créer les données du deuxième conducteur si activé
      SecondDriverData? secondDriver;
      if (_hasSecondDriver) {
        secondDriver = SecondDriverData(
          documentType: _secondSelectedDocumentType.name,
          idCardImage: _secondIdImage,
          firstName: _secondFirstNameController.text,
          lastName: _secondLastNameController.text,
          familyName: _secondFamilyNameController.text,
          phoneNumber: _secondPhoneController.text,
          idNumber: _secondIdNumberController.text,
          birthDate: _secondBirthDate!,
          idExpiryDate: _secondIdExpirationDate!,
          drivingLicenseImage: _secondLicenseImage,
          drivingLicenseNumber: _secondLicenseNumberController.text,
          drivingLicenseIssueDate: _secondLicenseIssueDate!,
        );
      }

      // Navigation vers l'écran de contrat
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RentalContractScreen(
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
            totalPrice: totalPrice,
            mainDriver: mainDriver,
            secondDriverEnabled: _hasSecondDriver,
            secondDriver: secondDriver,
            pickupAreaId: _getPickupAreaId(), // ID de la zone de récupération
            returnAreaId: _getReturnAreaId(), // ID de la zone de retour
          ),
        ),
      );
    } else {
      _showErrorMessage();
    }
  }

  bool _validateForm() {
    // Validation des champs obligatoires
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _familyNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _idNumberController.text.isNotEmpty &&
        _licenseNumberController.text.isNotEmpty &&
        _birthDate != null &&
        _licenseIssueDate != null;
  }

  void _showErrorMessage() {
    // Get.snackbar(
    //   tr(LocaleKeys.error),
    //   tr(LocaleKeys.fillAllFields),
    //   backgroundColor: Colors.red,
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.BOTTOM,
    //   margin: const EdgeInsets.all(16),
    //   borderRadius: 12,
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${tr(LocaleKeys.error)}: ${tr(LocaleKeys.fillAllFields)}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Récupère l'ID de la zone de récupération
  int _getPickupAreaId() {
    // Utiliser l'ID de la zone sélectionnée par l'utilisateur
    final areaId = widget.receptionZoneId ?? 1; // Fallback vers ID par défaut
    print('📍 Récupération de l\'ID de la zone de récupération: $areaId (depuis le formulaire de recherche)');
    return areaId;
  }

  /// Récupère l'ID de la zone de retour
  int _getReturnAreaId() {
    // Utiliser l'ID de la zone sélectionnée par l'utilisateur
    final areaId = widget.deliveryZoneId ?? 1; // Fallback vers ID par défaut
    print('📍 Récupération de l\'ID de la zone de retour: $areaId (depuis le formulaire de recherche)');
    return areaId;
  }
}