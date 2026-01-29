import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../core/components/app_bar_component.dart';
import '../../../../../core/components/button_app_component.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../controller/rent_vehicle_cubit.dart';
import 'rent_vehicle_data_screen.dart';
import 'rent_vehicle_payment_screen.dart';
import '../../data/services/vehicle_rental_service.dart';
import '../../../../../core/services/dio_service.dart';

class RentVehicleMainScreen extends StatefulWidget {
  const RentVehicleMainScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  _RentVehicleMainScreenState createState() => _RentVehicleMainScreenState();
}

class _RentVehicleMainScreenState extends State<RentVehicleMainScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Service pour récupérer les données du véhicule
  late VehicleRentalService _vehicleRentalService;
  VehicleRentalData? _vehicleData;
  bool _isLoadingVehicleData = true;
  String? _vehicleDataError;

  @override
  void initState() {
    super.initState();
    _initializeVehicleData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeVehicleData() async {
    try {
      _vehicleRentalService = VehicleRentalService(
        dioService: DioService(dio: Dio()),
      );

      final vehicleId = int.tryParse(widget.vehicleId);
      if (vehicleId != null) {
        _vehicleData = await _vehicleRentalService.getVehicleDetails(vehicleId);
      } else {
        _vehicleDataError = LocaleKeys.invalidVehicleId.tr();
      }
    } catch (e) {
      _vehicleDataError = '${LocaleKeys.vehicleDataLoadError.tr()}: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingVehicleData = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RentVehicleCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: ColorManager.greyShade,
            body: BlocBuilder<RentVehicleCubit, RentVehicleState>(
              builder: (context, state) {
                return Column(
                  children: [
                    AppBarComponent(
                      appBarTextMessage: LocaleKeys.vehicleRental.tr(),
                      showNotificationIcon: false,
                      showLocationIcon: false,
                      showBackIcon: true,
                      centerText: true,
                    ),
                    _buildPageIndicator(),
                    Expanded(
                      child: _isLoadingVehicleData
                          ? Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
                      )
                          : _vehicleDataError != null
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _vehicleDataError!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _initializeVehicleData,
                              child: Text(LocaleKeys.retryButton.tr()),
                            ),
                          ],
                        ),
                      )
                          : PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          RentVehicleDataScreen(),
                          RentVehiclePaymentScreen(
                            vehicleId: widget.vehicleId,
                            vehicleName: _vehicleData?.fullVehicleName ?? LocaleKeys.vehicle.tr(),
                            vehicleImage: _vehicleData?.firstImage ?? '',
                            dailyPrice: _vehicleData?.dailyPrice ?? 0.0,
                            numberOfDays: _calculateNumberOfDays(state),
                            totalPrice: _calculateTotalPrice(state),
                          ),
                        ],
                      ),
                    ),
                    _buildNavigationButtons(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStepIndicator(1, LocaleKeys.informationStep.tr(), _currentPage >= 0),
          _buildStepLine(_currentPage > 0),
          _buildStepIndicator(2, LocaleKeys.paymentStep.tr(), _currentPage >= 1),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepNumber, String stepTitle, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? ColorManager.primaryColor : ColorManager.grey2,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: getBoldStyle(
                  color: isActive ? ColorManager.whiteColor : ColorManager.blackColor,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            stepTitle,
            style: getMediumStyle(
              color: isActive ? ColorManager.primaryColor : ColorManager.grey2,
              fontSize: FontSize.s10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? ColorManager.primaryColor : ColorManager.grey2,
    );
  }

  Widget _buildNavigationButtons() {
    return BlocBuilder<RentVehicleCubit, RentVehicleState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: ButtonAppComponent(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: ColorManager.primaryColor,
                        width: 1,
                      ),
                    ),
                    buttonContent: Text(
                      LocaleKeys.previousButton.tr(),
                      style: getBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    onTap: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              if (_currentPage > 0) SizedBox(width: 16),
              Expanded(
                child: ButtonAppComponent(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  buttonContent: Text(
                    _currentPage == 0 ? LocaleKeys.nextButton.tr() : LocaleKeys.confirmButton.tr(),
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  onTap: () {
                    if (_currentPage == 0) {
                      // Valider les données avant de passer à l'étape suivante
                      if (_validateCurrentStep(context)) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    } else {
                      // Finaliser la location
                      _finalizeRental();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _validateCurrentStep(BuildContext context) {
    final cubit = context.read<RentVehicleCubit>();
    final state = cubit.state;

    // Validation des champs obligatoires
    if (state.userName.isEmpty) {
      _showErrorSnackBar(LocaleKeys.nameRequired.tr());
      return false;
    }

    if (state.phoneNumber.isEmpty) {
      _showErrorSnackBar(LocaleKeys.phoneNumberRequired.tr());
      return false;
    }

    if (state.userID.isEmpty) {
      _showErrorSnackBar(LocaleKeys.idNumberRequired.tr());
      return false;
    }

    if (state.age.isEmpty) {
      _showErrorSnackBar(LocaleKeys.ageRequired.tr());
      return false;
    }

    if (state.birthDate == null) {
      _showErrorSnackBar(LocaleKeys.birthDateRequired.tr());
      return false;
    }

    if (state.idExpirationDate == null) {
      _showErrorSnackBar(LocaleKeys.idExpirationDateRequired.tr());
      return false;
    }

    if (state.rentalDate == null) {
      _showErrorSnackBar(LocaleKeys.rentalStartDateRequired.tr());
      return false;
    }

    if (state.returnDate == null) {
      _showErrorSnackBar(LocaleKeys.rentalEndDateRequired.tr());
      return false;
    }

    if (!state.validateIDImage) {
      _showErrorSnackBar(LocaleKeys.idPhotoRequired.tr());
      return false;
    }

    if (!state.validateDriveLicenseImage) {
      _showErrorSnackBar(LocaleKeys.drivingLicenseRequired.tr());
      return false;
    }

    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _finalizeRental() {
    // TODO: Implémenter la logique de finalisation de la location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.rentalSuccessMessage.tr()),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Retourner à l'écran précédent
    Navigator.of(context).pop(true);
  }

  // Méthode pour calculer le nombre de jours de location
  int _calculateNumberOfDays(RentVehicleState state) {
    if (state.rentalDate != null && state.returnDate != null) {
      return _vehicleRentalService.calculateNumberOfDays(
        state.rentalDate!,
        state.returnDate!,
      );
    }
    return 1; // Valeur par défaut
  }

  // Méthode pour calculer le prix total
  double _calculateTotalPrice(RentVehicleState state) {
    if (_vehicleData == null) return 0.0;

    final numberOfDays = _calculateNumberOfDays(state);
    return _vehicleData!.calculateTotalPrice(numberOfDays);
  }
}