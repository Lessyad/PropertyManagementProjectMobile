import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../core/components/need_to_login_component.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../core/services/geo_service.dart';
import '../../../../../core/models/geo_models.dart';
import '../../../../../core/models/vehicle_category_model.dart';
import '../../../../../main.dart';
import '../controller/vehicle_controller.dart';
import 'vehicle_search_results_screen.dart';

class VehicleSearchScreen extends StatefulWidget {
  const VehicleSearchScreen({super.key});

  @override
  _VehicleSearchScreenState createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends State<VehicleSearchScreen> {
  final VehicleController _vehicleController = Get.find<VehicleController>();
  final GeoService _geoService = GeoService();

  // États pour les filtres avancés
  final Map<String, bool> _activeFilters = {
    'gasoline': false,
    'diesel': false,
    'automatic': false,
    'manual': false,
  };

  // Controllers pour les nouveaux champs de filtrage
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _deliveryCityController = TextEditingController();
  final TextEditingController _receptionLocationController = TextEditingController();
  final TextEditingController _deliveryLocationController = TextEditingController();
  final TextEditingController _driverAgeController = TextEditingController();

  // Focus nodes pour gérer les états actifs
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _deliveryCityFocusNode = FocusNode();
  final FocusNode _receptionLocationFocusNode = FocusNode();
  final FocusNode _deliveryLocationFocusNode = FocusNode();
  final FocusNode _driverAgeFocusNode = FocusNode();

  // Variables pour les dates et heures
  DateTime? _receptionDate;
  TimeOfDay? _receptionTime;
  DateTime? _deliveryDate;
  TimeOfDay? _deliveryTime;

  // Variables pour les dropdowns
  Country? _selectedCountry;
  City? _selectedReceptionCity;
  City? _selectedDeliveryCity;
  Area? _selectedReceptionArea;
  Area? _selectedDeliveryArea;
  VehicleCategory? _selectedVehicleCategory;
  bool _isDriverAgeValid = false;
  bool _showAgeValidation = false;

  // Listes pour les dropdowns (chargées depuis le backend)
  List<Country> _countries = [];
  List<City> _receptionCities = [];
  List<City> _deliveryCities = [];
  List<Area> _receptionAreas = [];
  List<Area> _deliveryAreas = [];
  List<VehicleCategory> _vehicleCategories = [];
  
  bool _isLoadingCountries = true;
  bool _isLoadingReceptionCities = false;
  bool _isLoadingDeliveryCities = false;
  bool _isLoadingReceptionAreas = false;
  bool _isLoadingDeliveryAreas = false;
  bool _isLoadingVehicleCategories = true;

  @override
  void initState() {
    super.initState();
    _driverAgeController.addListener(_validateDriverAge);
    _loadCountries();
    _loadVehicleCategories();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoadingCountries = true;
    });
    
    try {
      print('Loading countries...');
      final countries = await _geoService.getCountries();
      print('Loaded ${countries.length} countries');
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });
    } catch (e) {
      print('Error loading countries: $e');
      setState(() {
        _isLoadingCountries = false;
      });
      
      // Afficher un message d'erreur à l'utilisateur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des pays: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadVehicleCategories() async {
    setState(() {
      _isLoadingVehicleCategories = true;
    });
    
    try {
      print('Loading vehicle categories...');
      final categories = await _geoService.getVehicleCategories();
      print('Loaded ${categories.length} vehicle categories');
      setState(() {
        _vehicleCategories = categories;
        _isLoadingVehicleCategories = false;
      });
    } catch (e) {
      print('Error loading vehicle categories: $e');
      setState(() {
        _isLoadingVehicleCategories = false;
      });
      
      // Afficher un message d'erreur à l'utilisateur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des catégories: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadReceptionCities(int countryId) async {
    setState(() {
      _isLoadingReceptionCities = true;
      _selectedReceptionCity = null;
      _receptionCities = [];
      _receptionAreas = [];
      _selectedReceptionArea = null;
    });
    
    try {
      final cities = await _geoService.getCitiesByCountry(countryId);
      setState(() {
        _receptionCities = cities;
        _isLoadingReceptionCities = false;
      });
    } catch (e) {
      print('Error loading reception cities: $e');
      setState(() {
        _isLoadingReceptionCities = false;
      });
    }
  }

  Future<void> _loadDeliveryCities(int countryId) async {
    setState(() {
      _isLoadingDeliveryCities = true;
      _selectedDeliveryCity = null;
      _deliveryCities = [];
      _deliveryAreas = [];
      _selectedDeliveryArea = null;
    });
    
    try {
      final cities = await _geoService.getCitiesByCountry(countryId);
      setState(() {
        _deliveryCities = cities;
        _isLoadingDeliveryCities = false;
      });
    } catch (e) {
      print('Error loading delivery cities: $e');
      setState(() {
        _isLoadingDeliveryCities = false;
      });
    }
  }

  Future<void> _loadReceptionAreas(int cityId) async {
    setState(() {
      _isLoadingReceptionAreas = true;
      _selectedReceptionArea = null;
      _receptionAreas = [];
    });
    
    try {
      final areas = await _geoService.getAreasByCity(cityId);
      setState(() {
        _receptionAreas = areas;
        _isLoadingReceptionAreas = false;
      });
    } catch (e) {
      print('Error loading reception areas: $e');
      setState(() {
        _isLoadingReceptionAreas = false;
      });
    }
  }

  Future<void> _loadDeliveryAreas(int cityId) async {
    setState(() {
      _isLoadingDeliveryAreas = true;
      _selectedDeliveryArea = null;
      _deliveryAreas = [];
    });
    
    try {
      final areas = await _geoService.getAreasByCity(cityId);
      setState(() {
        _deliveryAreas = areas;
        _isLoadingDeliveryAreas = false;
      });
    } catch (e) {
      print('Error loading delivery areas: $e');
      setState(() {
        _isLoadingDeliveryAreas = false;
      });
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    _deliveryCityController.dispose();
    _receptionLocationController.dispose();
    _deliveryLocationController.dispose();
    _driverAgeController.dispose();
    _cityFocusNode.dispose();
    _deliveryCityFocusNode.dispose();
    _receptionLocationFocusNode.dispose();
    _deliveryLocationFocusNode.dispose();
    _driverAgeFocusNode.dispose();
    super.dispose();
  }

  void _validateDriverAge() {
    final ageText = _driverAgeController.text.trim();
    if (ageText.isNotEmpty) {
      final age = int.tryParse(ageText);
      // Utiliser l'âge minimum de la catégorie sélectionnée, sinon 18 par défaut
      final minimumAge = _selectedVehicleCategory?.age ?? 18;
      setState(() {
        _showAgeValidation = true;
        _isDriverAgeValid = age != null && age >= minimumAge;
      });
    } else {
      setState(() {
        _showAgeValidation = false;
        _isDriverAgeValid = false;
      });
    }
  }

  void _resetAllFilters() {
    setState(() {
      _activeFilters.forEach((key, value) {
        _activeFilters[key] = false;
      });
      // Réinitialiser tous les nouveaux filtres
      _countryController.clear();
      _cityController.clear();
      _deliveryCityController.clear();
      _receptionLocationController.clear();
      _deliveryLocationController.clear();
      _driverAgeController.clear();
      _selectedCountry = null;
      _selectedReceptionCity = null;
      _selectedDeliveryCity = null;
      _selectedReceptionArea = null;
      _selectedDeliveryArea = null;
      _selectedVehicleCategory = null;
      _receptionCities = [];
      _deliveryCities = [];
      _receptionAreas = [];
      _deliveryAreas = [];
      _vehicleCategories = [];
      _receptionDate = null;
      _receptionTime = null;
      _deliveryDate = null;
      _deliveryTime = null;
      _isDriverAgeValid = false;
      _showAgeValidation = false;
    });
    _vehicleController.resetFilters();
  }

  Future<void> _selectDate(BuildContext context, {required bool isReception}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManager.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorManager.blackColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.height * 0.3,
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              child: child,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isReception) {
          _receptionDate = picked;
        } else {
          _deliveryDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isReception}) async {
    final TimeOfDay? picked = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        TimeOfDay selectedTime = TimeOfDay.now();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr(LocaleKeys.selectTime),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.blackColor,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: Brightness.light,
                      primaryColor: ColorManager.primaryColor,
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime dateTime) {
                        selectedTime = TimeOfDay.fromDateTime(dateTime);
                      },
                      use24hFormat: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        tr(LocaleKeys.cancelButton),
                        style: TextStyle(
                          color: ColorManager.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(selectedTime),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        tr(LocaleKeys.confirmButton),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isReception) {
          _receptionTime = picked;
        } else {
          _deliveryTime = picked;
        }
      });
    }
  }

  void _toggleFilter(String filterType, String filterValue) {
    setState(() {
      _activeFilters[filterType] = !_activeFilters[filterType]!;
    });

    // Appliquer le filtre
    if (filterType == 'gasoline' || filterType == 'diesel') {
      final fuelType = _activeFilters[filterType]! ? filterValue.toUpperCase() : null;
      _vehicleController.applyFilters(fuelType: fuelType);
    } else if (filterType == 'automatic' || filterType == 'manual') {
      final transmission = _activeFilters[filterType]! ? filterValue.toUpperCase() : null;
      _vehicleController.applyFilters(transmission: transmission);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: Column(
        children: [
          // Header simple
          _buildFormHeader(context),

          // Formulaire de filtres (toujours affiché)
          Expanded(
            child: _buildUnifiedFiltersForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Center(
        child: Text(
            tr(LocaleKeys.startRental),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorManager.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedFiltersForm() {
    return Container(
      color: ColorManager.whiteColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(tr(LocaleKeys.locationSection)),
            const SizedBox(height: 12),
            _buildCountryDropdown(),
            const SizedBox(height: 16),

            _buildSectionTitle(tr(LocaleKeys.receptionInfoSection)),
            const SizedBox(height: 12),
            _buildCityDropdown(
              label: tr(LocaleKeys.receptionCity),
              cities: _receptionCities,
              selectedCity: _selectedReceptionCity,
              isLoading: _isLoadingReceptionCities,
              onChanged: (City? city) {
                setState(() {
                  _selectedReceptionCity = city;
                  if (city != null) {
                    _loadReceptionAreas(city.id);
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDateTimeRow(
              tr(LocaleKeys.receptionDate),
              tr(LocaleKeys.receptionTime),
              _receptionDate,
              _receptionTime,
                  () => _selectDate(context, isReception: true),
                  () => _selectTime(context, isReception: true),
            ),
            const SizedBox(height: 12),
            _buildAreaDropdown(
              label: tr(LocaleKeys.receptionPlace),
              areas: _receptionAreas,
              selectedArea: _selectedReceptionArea,
              isLoading: _isLoadingReceptionAreas,
              onChanged: (Area? area) {
                setState(() {
                  _selectedReceptionArea = area;
                });
              },
            ),
            const SizedBox(height: 16),

            _buildSectionTitle(tr(LocaleKeys.deliveryInfoSection)),
            const SizedBox(height: 12),
            _buildCityDropdown(
              label: tr(LocaleKeys.deliveryCity),
              cities: _deliveryCities,
              selectedCity: _selectedDeliveryCity,
              isLoading: _isLoadingDeliveryCities,
              onChanged: (City? city) {
                setState(() {
                  _selectedDeliveryCity = city;
                  if (city != null) {
                    _loadDeliveryAreas(city.id);
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDateTimeRow(
              tr( LocaleKeys.deliveryDate),
              tr(LocaleKeys.deliveryTime),
              _deliveryDate,
              _deliveryTime,
                  () => _selectDate(context, isReception: false),
                  () => _selectTime(context, isReception: false),
            ),
            const SizedBox(height: 12),
            _buildAreaDropdown(
              label: tr(LocaleKeys.deliveryPlace),
              areas: _deliveryAreas,
              selectedArea: _selectedDeliveryArea,
              isLoading: _isLoadingDeliveryAreas,
              onChanged: (Area? area) {
                setState(() {
                  _selectedDeliveryArea = area;
                });
              },
            ),
            const SizedBox(height: 16),

            _buildSectionTitle(tr(LocaleKeys.vehicleDetailsSection)),
            const SizedBox(height: 12),
            _buildVehicleCategoryDropdown(),
            const SizedBox(height: 16),

            _buildSectionTitle(tr(LocaleKeys.driverInfoSection)),
            const SizedBox(height: 12),
            _buildDriverAgeField(),
            const SizedBox(height: 8),
            _buildAgeValidationMessage(),
            const SizedBox(height: 16),

            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCheckbox({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ColorManager.primaryColor : ColorManager.greyShade,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? ColorManager.primaryColor : ColorManager.grey3,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.circle_outlined,
              color: isActive ? Colors.white : ColorManager.grey,
              size: 15,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : ColorManager.blackColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    final bool isCountryValid = _selectedCountry != null;
    final bool isReceptionCityValid = _selectedReceptionCity != null;
    final bool isDeliveryCityValid = _selectedDeliveryCity != null;
    final bool isReceptionDateValid = _receptionDate != null;
    final bool isReceptionTimeValid = _receptionTime != null;
    final bool isReceptionAreaValid = _selectedReceptionArea != null;
    final bool isDeliveryDateValid = _deliveryDate != null;
    final bool isDeliveryTimeValid = _deliveryTime != null;
    final bool isDeliveryAreaValid = _selectedDeliveryArea != null;
    final bool isDriverAgeValid = _isDriverAgeValid;
    final bool idCatagoryValid = _selectedVehicleCategory != null;

    return isCountryValid &&
        isReceptionCityValid &&
        isDeliveryCityValid &&
        isReceptionDateValid &&
        isReceptionTimeValid &&
        isReceptionAreaValid &&
        isDeliveryDateValid &&
        isDeliveryTimeValid &&
        isDeliveryAreaValid &&
        idCatagoryValid &&
        isDriverAgeValid;
  }





  Widget _buildActionButtons() {
    final bool isFormValid = _isFormValid();
    DateTime? completeReceptionDateTime;
    if (_receptionDate != null && _receptionTime != null) {
      completeReceptionDateTime = DateTime(
        _receptionDate!.year,
        _receptionDate!.month,
        _receptionDate!.day,
        _receptionTime!.hour,
        _receptionTime!.minute,
      );
    }

    DateTime? completeDeliveryDateTime;
    if (_deliveryDate != null && _deliveryTime != null) {
      completeDeliveryDateTime = DateTime(
        _deliveryDate!.year,
        _deliveryDate!.month,
        _deliveryDate!.day,
        _deliveryTime!.hour,
        _deliveryTime!.minute,
      );
    }
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorManager.primaryColor,
                side: BorderSide(color: ColorManager.primaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                tr(LocaleKeys.previousButton),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          // onTap: () {
          //   if (isAuth) {
          //     Navigator.of(context, rootNavigator: true)
          //         .pushNamed(RoutersNames.addNewRealEstateScreen);
          //   } else {
          //     LoginBottomSheet.show();
          //   }
          // },
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: isFormValid ? () {
    if (isAuth) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehicleSearchResultsScreen(
                      // receptionDate: _receptionDate,
                      receptionDate: completeReceptionDateTime!,
                      receptionTime: _receptionTime, // Passer receptionTime séparément
                      receptionCity: _selectedReceptionCity?.name,
                      receptionLocation: _selectedReceptionArea?.name,
                      // deliveryDate: _deliveryDate,
                      deliveryDate: completeDeliveryDateTime!,
                      deliveryTime: _deliveryTime,
                      deliveryCity: _selectedDeliveryCity?.name,
                      deliveryLocation: _selectedDeliveryArea?.name,
                      receptionZoneId: _selectedReceptionArea?.id,
                      deliveryZoneId: _selectedDeliveryArea?.id,
                      vehicleCategoryId: _selectedVehicleCategory?.id,
                      userAge: int.tryParse(_driverAgeController.text),
                      userCountryId: _selectedCountry?.id, // Passer l'ID du pays sélectionné
                    ),
                  ),
                );
    } else {
      LoginBottomSheet.show();
    }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              child: Text(
                tr(LocaleKeys.nextButton),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: ColorManager.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorManager.primaryColor,
          ),
        ),
      ],
    );
  }

  Color _getBorderColor(bool hasFocus, bool hasValue) {
    if (hasFocus || hasValue) {
      return ColorManager.primaryColor;
    }
    return ColorManager.grey3;
  }

  Widget _buildCountryDropdown() {
    bool hasValue = _selectedCountry != null;

    if (_isLoadingCountries) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: ColorManager.greyShade,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.grey3,
            width: 1.5,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorManager.greyShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(false, hasValue),
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<Country>(
        value: _selectedCountry,
        decoration: InputDecoration(
          labelText: _selectedCountry == null ? tr(LocaleKeys.country) : null,
          labelStyle: TextStyle(color: hasValue ? ColorManager.primaryColor : ColorManager.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        dropdownColor: ColorManager.whiteColor,
        items: _countries.map((Country country) {
          return DropdownMenuItem<Country>(
            value: country,
            child: Text(
              country.name,
              style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (Country? newValue) {
          setState(() {
            _selectedCountry = newValue;
            if (newValue != null) {
              _loadReceptionCities(newValue.id);
              _loadDeliveryCities(newValue.id);
            }
          });
        },
      ),
    );
  }

  Widget _buildCityDropdown({
    required String label,
    required List<City> cities,
    required City? selectedCity,
    required bool isLoading,
    required Function(City?) onChanged,
  }) {
    bool hasValue = selectedCity != null;

    if (isLoading) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: ColorManager.greyShade,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.grey3,
            width: 1.5,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorManager.greyShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(false, hasValue),
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<City>(
        value: selectedCity,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: hasValue ? ColorManager.primaryColor : ColorManager.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          prefixIcon: Icon(
            Icons.location_city,
            color: hasValue ? ColorManager.primaryColor : ColorManager.grey,
            size: 20,
          ),
        ),
        dropdownColor: ColorManager.whiteColor,
        items: cities.isEmpty
            ? null
            : cities.map((City city) {
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(
                    city.name,
                    style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
                  ),
                );
              }).toList(),
        onChanged: cities.isEmpty ? null : onChanged,
      ),
    );
  }

  Widget _buildAreaDropdown({
    required String label,
    required List<Area> areas,
    required Area? selectedArea,
    required bool isLoading,
    required Function(Area?) onChanged,
  }) {
    bool hasValue = selectedArea != null;

    if (isLoading) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: ColorManager.greyShade,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.grey3,
            width: 1.5,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorManager.greyShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(false, hasValue),
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<Area>(
        value: selectedArea,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: hasValue ? ColorManager.primaryColor : ColorManager.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          prefixIcon: Icon(
            Icons.place,
            color: hasValue ? ColorManager.primaryColor : ColorManager.grey,
            size: 20,
          ),
        ),
        dropdownColor: ColorManager.whiteColor,
        items: areas.isEmpty
            ? null
            : areas.map((Area area) {
                return DropdownMenuItem<Area>(
                  value: area,
                  child: Text(
                    area.name,
                    style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
                  ),
                );
              }).toList(),
        onChanged: areas.isEmpty ? null : onChanged,
      ),
    );
  }

  Widget _buildCityField({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
  }) {
    final cityController = controller ?? _cityController;
    final cityFocusNode = focusNode ?? _cityFocusNode;
    final cityLabel = label ?? tr(LocaleKeys.city);

    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          final hasValue = cityController.text.isNotEmpty;

          return Container(
            height: 40,
            decoration: BoxDecoration(
              color: ColorManager.greyShade,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBorderColor(hasFocus, hasValue),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: cityController,
              focusNode: cityFocusNode,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: cityLabel,
                hintStyle: TextStyle(
                  color: hasFocus || hasValue ? ColorManager.primaryColor : ColorManager.grey,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: Icon(
                  Icons.location_city,
                  color: hasFocus || hasValue ? ColorManager.primaryColor : ColorManager.grey,
                  size: 20,
                ),
              ),
              style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeRow(
      String dateLabel,
      String timeLabel,
      DateTime? selectedDate,
      TimeOfDay? selectedTime,
      VoidCallback onDateTap,
      VoidCallback onTimeTap,
      ) {
    bool hasDateValue = selectedDate != null;
    bool hasTimeValue = selectedTime != null;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onDateTap,
            child: Container(
              height: 47,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.greyShade,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(false, hasDateValue),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: hasDateValue ? ColorManager.primaryColor : ColorManager.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 10,
                            color: hasDateValue ? ColorManager.primaryColor : ColorManager.grey,
                          ),
                        ),
                        Text(
                          selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(selectedDate)
                              : tr(LocaleKeys.select),
                          style: TextStyle(
                            fontSize: 10,
                            color: selectedDate != null
                                ? ColorManager.blackColor
                                : ColorManager.grey,
                            fontWeight: selectedDate != null
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onTimeTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.greyShade,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(false, hasTimeValue),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: hasTimeValue ? ColorManager.primaryColor : ColorManager.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            color: hasTimeValue ? ColorManager.primaryColor : ColorManager.grey,
                          ),
                        ),
                        Text(
                          selectedTime != null
                              ? selectedTime.format(context)
                              : tr(LocaleKeys.select),
                          style: TextStyle(
                            fontSize: 12,
                            color: selectedTime != null
                                ? ColorManager.blackColor
                                : ColorManager.grey,
                            fontWeight: selectedTime != null
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(TextEditingController controller, String label, FocusNode focusNode) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          final hasValue = controller.text.isNotEmpty;

          return Container(
            height: 40,
            decoration: BoxDecoration(
              color: ColorManager.greyShade,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBorderColor(hasFocus, hasValue),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: hasFocus || hasValue ? ColorManager.primaryColor : ColorManager.grey,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: Icon(
                  Icons.place,
                  color: hasFocus || hasValue ? ColorManager.primaryColor : ColorManager.grey,
                  size: 20,
                ),
              ),
              style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleCategoryDropdown() {
    bool hasValue = _selectedVehicleCategory != null;

    if (_isLoadingVehicleCategories) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: ColorManager.greyShade,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.grey3,
            width: 1.5,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorManager.greyShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(false, hasValue),
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<VehicleCategory>(
        value: _selectedVehicleCategory,
        decoration: InputDecoration(
          labelText: _selectedVehicleCategory == null ? tr(LocaleKeys.vehicleCategory) : null,
          labelStyle: TextStyle(
            color: hasValue ? ColorManager.primaryColor : ColorManager.grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          prefixIcon: Icon(
            Icons.directions_car,
            color: hasValue ? ColorManager.primaryColor : ColorManager.grey,
            size: 20,
          ),
        ),
        dropdownColor: ColorManager.whiteColor,
        items: _vehicleCategories.isEmpty
            ? null
            : _vehicleCategories.map((VehicleCategory category) {
                return DropdownMenuItem<VehicleCategory>(
                  value: category,
                  child: Text(
                    category.name,
                    style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
                  ),
                );
              }).toList(),
        onChanged: _vehicleCategories.isEmpty ? null : (VehicleCategory? newValue) {
          setState(() {
            _selectedVehicleCategory = newValue;
            // Re-valider l'âge si une catégorie est sélectionnée et qu'un âge est déjà saisi
            if (_driverAgeController.text.isNotEmpty) {
              _validateDriverAge();
            }
          });
        },
      ),
    );
  }

  Widget _buildDriverAgeField() {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          final hasValue = _driverAgeController.text.isNotEmpty;

          Color borderColor;
          if (_showAgeValidation) {
            borderColor = _isDriverAgeValid ? ColorManager.primaryColor : ColorManager.redColor;
          } else {
            borderColor = _getBorderColor(hasFocus, hasValue);
          }

          return Container(
            height: 40,
            decoration: BoxDecoration(
              color: ColorManager.greyShade,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _driverAgeController,
              focusNode: _driverAgeFocusNode,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: tr(LocaleKeys.driverAge),
                hintStyle: TextStyle(
                  color: hasFocus || hasValue ? ColorManager.primaryColor : ColorManager.grey,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: Icon(
                  Icons.person,
                  color: hasFocus || hasValue ? ColorManager.primaryColor : ColorManager.grey,
                  size: 20,
                ),
                suffixIcon: _showAgeValidation
                    ? Icon(
                  _isDriverAgeValid ? Icons.check_circle : Icons.error,
                  color: _isDriverAgeValid ? ColorManager.primaryColor : ColorManager.redColor,
                  size: 20,
                )
                    : null,
              ),
              style: TextStyle(color: ColorManager.blackColor, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAgeValidationMessage() {
    if (!_showAgeValidation) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _isDriverAgeValid
            ? ColorManager.primaryColor.withOpacity(0.1)
            : ColorManager.redColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isDriverAgeValid ? ColorManager.primaryColor : ColorManager.redColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isDriverAgeValid ? Icons.check_circle : Icons.error,
            color: _isDriverAgeValid ? ColorManager.primaryColor : ColorManager.redColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _isDriverAgeValid
                  ? tr(LocaleKeys.ageValidationSuccess)
                  : tr(LocaleKeys.ageValidationError),
              style: TextStyle(
                color: _isDriverAgeValid ? ColorManager.primaryColor : ColorManager.redColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}