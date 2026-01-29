import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../../core/components/currency_display_widget.dart';
import '../../domain/entities/vehicle_entity.dart';
import 'rent_vehicle_data_screen_enhanced.dart';
import '../controller/global_rental_options_controller.dart';

class RentalSummaryScreen extends StatelessWidget {
  final VehicleEntity vehicle;
  final DateTime receptionDate;
  final TimeOfDay receptionTime;
  final String receptionCity;
  final String receptionLocation;
  final DateTime deliveryDate;
  final TimeOfDay deliveryTime;
  final String deliveryCity;
  final String deliveryLocation;
  final bool extraKilometers;
  final String? kilometerDetails;
  final bool fullInsurance;
  final bool childSeat;
  final int? receptionZoneId;
  final int? deliveryZoneId;
  final bool secondDriver;

  const RentalSummaryScreen({
    Key? key,
    required this.vehicle,
    required this.receptionDate,
    required this.receptionTime,
    required this.receptionCity,
    required this.receptionLocation,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryCity,
    required this.deliveryLocation,
    this.extraKilometers = false,
    this.kilometerDetails,
    this.fullInsurance = false,
    this.childSeat = false,
    this.receptionZoneId,
    this.deliveryZoneId,
    this.secondDriver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupérer ou créer le contrôleur des options globales
    GlobalRentalOptionsController optionsController;
    try {
      optionsController = Get.find<GlobalRentalOptionsController>();
    } catch (e) {
      // Si le contrôleur n'est pas trouvé, le créer
      optionsController = Get.put(GlobalRentalOptionsController());
    }

    // Vérifier si le cache des options est valide, sinon recharger
    if (!optionsController.isCacheValid) {
      optionsController.refreshFromAPI();
    }

    // Calculer le prix de base avec la nouvelle logique basée sur les heures
    final basePrice = _calculateRentalPrice(vehicle.dailyPrice);
    final extraCosts = _calculateExtraCosts(optionsController);
    final totalPrice = basePrice + extraCosts;

    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      appBar: AppBar(
        title: Text(tr(LocaleKeys.rentalSummary)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations du véhicule
                  _buildVehicleInfoCard(),
                  const SizedBox(height: 16),

                  // Détails de la location
                  _buildRentalDetailsCard(),
                  const SizedBox(height: 16),

                  // Options supplémentaires
                  _buildExtraOptionsCard(optionsController),
                  const SizedBox(height: 16),

                  // Résumé des coûts
                  _buildCostSummaryCard(basePrice, extraCosts, totalPrice, optionsController),
                ],
              ),
            ),
          ),

          // Footer avec bouton de confirmation
          _buildFooter(totalPrice),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard() {
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
            tr(LocaleKeys.selectedVehicle),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: vehicle.imageUrls.isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(vehicle.imageUrls.first),
                    fit: BoxFit.cover,
                  )
                      : null,
                  color: vehicle.imageUrls.isEmpty ? Colors.grey[300] : null,
                ),
                child: vehicle.imageUrls.isEmpty
                    ? const Icon(Icons.car_rental, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.makeName} ${vehicle.modelName}',
                      style: getBoldStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle.categoryName} • ${vehicle.color}',
                      style: getRegularStyle(
                        color: ColorManager.grey,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${vehicle.dailyPrice.toStringAsFixed(0)} ',
                          style: getBoldStyle(
                            color: ColorManager.primaryColor,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        BoldCurrencyPerDayWidget(
                          textColor: ColorManager.primaryColor,
                          fontSize: FontSize.s14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRentalDetailsCard() {
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
            tr(LocaleKeys.rentalDetails),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            tr(LocaleKeys.pickupDate),
            '${_formatDate(receptionDate)} ${tr(LocaleKeys.at)} ${_formatTime(receptionTime)}',
            Icons.calendar_today,
          ),
          _buildDetailRow(
            tr(LocaleKeys.pickupLocation),
            receptionLocation,
            Icons.location_on,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            tr(LocaleKeys.returnDate),
            '${_formatDate(deliveryDate)} ${tr(LocaleKeys.at)} ${_formatTime(deliveryTime)}',
            Icons.calendar_today,
          ),
          _buildDetailRow(
            tr(LocaleKeys.returnLocation),
            deliveryLocation,
            Icons.location_on,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            tr(LocaleKeys.rentalDuration),
              _formatRentalDuration(),
            Icons.schedule,
          ),
        ],
      ),
    );
  }

  // Widget _buildExtraOptionsCard(GlobalRentalOptionsController optionsController) {
  //   if (!extraKilometers && !fullInsurance && !childSeat && !secondDriver) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           tr(LocaleKeys.additionalOptions),
  //           style: getBoldStyle(
  //             color: ColorManager.blackColor,
  //             fontSize: FontSize.s16,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         if (extraKilometers) ...[
  //           _buildOptionRow(
  //             tr(LocaleKeys.extraKilometers),
  //             kilometerDetails ?? tr(LocaleKeys.yes),
  //             Icons.speed,
  //             '+ ${optionsController.kilometerIllimitedPerDayAmount.toStringAsFixed(1)} ${tr(LocaleKeys.currency)}',
  //           ),
  //         ],
  //         if (fullInsurance) ...[
  //           _buildOptionRow(
  //             tr(LocaleKeys.fullInsurance),
  //             tr(LocaleKeys.fullProtection),
  //             Icons.shield,
  //             '+ ${optionsController.allRiskCarInsuranceAmount.toStringAsFixed(1)} ${tr(LocaleKeys.currencyPerDay)}',
  //           ),
  //         ],
  //         if (childSeat) ...[
  //           _buildOptionRow(
  //             tr(LocaleKeys.childSeatOption),
  //             tr(LocaleKeys.childSafetySeat),
  //             Icons.child_care,
  //             '+ ${optionsController.addChildsChairAmount.toStringAsFixed(1)} ${tr(LocaleKeys.currencyPerDay)}',
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }
  Widget _buildExtraOptionsCard(GlobalRentalOptionsController optionsController) {
    if (!extraKilometers && !fullInsurance && !childSeat && !secondDriver) {
      return const SizedBox.shrink();
    }

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
            tr(LocaleKeys.additionalOptions),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 12),
          if (extraKilometers) ...[
            _buildOptionRow(
              tr(LocaleKeys.extraKilometers),
              tr(LocaleKeys.extraKilometers), // ou le texte approprié
              Icons.speed,
              '${optionsController.kilometerIllimitedPerDayAmount}MRU',
            ),
          ],
          if (fullInsurance) ...[
            _buildOptionRow(
              tr(LocaleKeys.fullInsurance),
              tr(LocaleKeys.fullProtection),
              Icons.shield,
              '${optionsController.allRiskCarInsuranceAmount}MRU',
            ),
          ],
          if (childSeat) ...[
            _buildOptionRow(
              tr(LocaleKeys.childSeatOption),
              tr(LocaleKeys.childSafetySeat),
              Icons.child_care,
              '${optionsController.addChildsChairAmount} MRU',
            ),
          ],
          if (secondDriver) ...[
            _buildOptionRow(
              tr(LocaleKeys.secondDriver),
              tr(LocaleKeys.secondDriver), // ou le texte approprié
              Icons.person_add,
              '${optionsController.secondDriverAmount}  MRU',
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildCostSummaryCard(double basePrice, double extraCosts, double totalPrice, GlobalRentalOptionsController optionsController) {
    final rentalDurationInfo = _getRentalDurationInfo();
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
            tr(LocaleKeys.costSummary),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          const SizedBox(height: 12),
          _buildCostRow(
            tr(LocaleKeys.baseRental),
            _formatBaseRentalDetails(rentalDurationInfo),
            '${basePrice.toStringAsFixed(0)} MRU',
          ),

          // Détail des options supplémentaires sélectionnées
          ..._buildExtraOptionsCostRows(rentalDurationInfo['fullDays'] as int, optionsController),
          const Divider(height: 24),
          _buildCostRow(
            tr(LocaleKeys.total),
            '',
            '${totalPrice.toStringAsFixed(0)} MRU',
            isTotal: true,
          ),
        ],
      ),
    );
  }



  Widget _buildFooter(double totalPrice) {
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
          Builder(
            builder: (context) => Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      tr(LocaleKeys.previous),
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
                    onPressed: () => _confirmRental(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      tr(LocaleKeys.confirmBooking),
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: getRegularStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
                Text(
                  value,
                  style: getRegularStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(String title, String subtitle, IconData icon, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: ColorManager.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String details, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: isTotal
                      ? getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s16,
                  )
                      : getRegularStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
                if (details.isNotEmpty)
                  Text(
                    details,
                    style: getRegularStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            amount,
            style: isTotal
                ? getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s16,
            )
                : getRegularStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExtraOptionsCostRows(int numberOfDays, GlobalRentalOptionsController optionsController) {
    List<Widget> costRows = [];

    // Kilomètres illimités (frais unique)
    if (extraKilometers) {
      final kilometerCost = optionsController.kilometerIllimitedPerDayAmount;
      costRows.add(
        _buildCostRow(
          tr(LocaleKeys.extraKilometers),
          tr(LocaleKeys.extraKilometers),
          '+ ${kilometerCost} MRU',
        ),
      );
    }

    // Assurance tous risques (par jour)
    if (fullInsurance) {
      final insuranceCostPerDay = optionsController.allRiskCarInsuranceAmount;
      final totalInsuranceCost = insuranceCostPerDay ;
      costRows.add(
        _buildCostRow(
          tr(LocaleKeys.fullInsurance),
            tr(LocaleKeys.childSeatOption),
          '+ ${totalInsuranceCost} MRU',
        ),
      );
    }

    // Siège enfant (par jour)
    if (childSeat) {
      final childSeatCostPerDay = optionsController.addChildsChairAmount;
      final totalChildSeatCost = childSeatCostPerDay ;
      costRows.add(
        _buildCostRow(
          tr(LocaleKeys.childSeatOption),
            tr(LocaleKeys.childSeatOption),
          '+ ${totalChildSeatCost} MRU',
        ),
      );
    }

    // Deuxième chauffeur (frais unique)
    if (secondDriver) {
      final secondDriverCost = optionsController.secondDriverAmount;
      costRows.add(
        _buildCostRow(
          tr(LocaleKeys.secondDriver),
          tr(LocaleKeys.secondDriver),
          '+ ${secondDriverCost} MRU',
        ),
      );
    }

    return costRows;
  }
  // Calculer le prix de location basé sur les heures
  double _calculateRentalPrice(double dailyPrice) {
    final receptionDateTime = DateTime(
      receptionDate.year,
      receptionDate.month,
      receptionDate.day,
      receptionTime.hour,
      receptionTime.minute,
    );
    final deliveryDateTime = DateTime(
      deliveryDate.year,
      deliveryDate.month,
      deliveryDate.day,
      deliveryTime.hour,
      deliveryTime.minute,
    );

    final duration = deliveryDateTime.difference(receptionDateTime);
    // Utiliser inMinutes pour une précision plus grande, puis convertir en heures
    final totalHoursDouble = duration.inMinutes / 60.0;

    if (totalHoursDouble <= 0) {
      return dailyPrice;
    }

    // Moins de 24h → 1 jour minimum
    if (totalHoursDouble < 24) {
      return dailyPrice;
    }

    final fullDays = (totalHoursDouble / 24).floor(); // nombre de jours complets
    final remainingHoursDouble = totalHoursDouble - (fullDays * 24);
    final remainingHours = remainingHoursDouble.ceil(); // Arrondir à l'heure supérieure pour les heures restantes

    double totalPrice = fullDays * dailyPrice;

    if (remainingHours > 0) {
      final hourlyRate = dailyPrice / 24;
      totalPrice += remainingHours * hourlyRate;
    }

    return totalPrice;
  }

  // Obtenir les informations de durée pour l'affichage
  Map<String, dynamic> _getRentalDurationInfo() {
    final receptionDateTime = DateTime(
      receptionDate.year,
      receptionDate.month,
      receptionDate.day,
      receptionTime.hour,
      receptionTime.minute,
    );
    final deliveryDateTime = DateTime(
      deliveryDate.year,
      deliveryDate.month,
      deliveryDate.day,
      deliveryTime.hour,
      deliveryTime.minute,
    );

    final duration = deliveryDateTime.difference(receptionDateTime);
    // Utiliser inMinutes pour une précision plus grande, puis convertir en heures
    final totalHoursDouble = duration.inMinutes / 60.0;

    if (totalHoursDouble <= 0) {
      return {'fullDays': 1, 'remainingHours': 0, 'totalHours': 0};
    }

    if (totalHoursDouble < 24) {
      final totalHours = totalHoursDouble.round();
      return {'fullDays': 1, 'remainingHours': 0, 'totalHours': totalHours};
    }

    final fullDays = (totalHoursDouble / 24).floor(); // nombre de jours complets
    final remainingHoursDouble = totalHoursDouble - (fullDays * 24);
    final remainingHours = remainingHoursDouble.ceil(); // Arrondir à l'heure supérieure pour l'affichage
    final totalHours = (fullDays * 24 + remainingHours).round();

    return {
      'fullDays': fullDays,
      'remainingHours': remainingHours,
      'totalHours': totalHours,
    };
  }

  // Formater la durée de location pour l'affichage
  String _formatRentalDuration() {
    final durationInfo = _getRentalDurationInfo();
    final fullDays = durationInfo['fullDays'] as int;
    final remainingHours = durationInfo['remainingHours'] as int;

    if (fullDays == 1 && remainingHours == 0) {
      return '1 ${tr(LocaleKeys.days)}';
    } else if (fullDays > 0 && remainingHours > 0) {
      return '$fullDays ${tr(LocaleKeys.days)} $remainingHours ${tr(LocaleKeys.hours)}';
    } else if (fullDays > 0) {
      return '$fullDays ${tr(LocaleKeys.days)}';
    } else {
      return '${durationInfo['totalHours']} ${tr(LocaleKeys.hours)}';
    }
  }

  // Formater les détails du prix de base pour le résumé des coûts
  String _formatBaseRentalDetails(Map<String, dynamic> durationInfo) {
    final fullDays = durationInfo['fullDays'] as int;
    final remainingHours = durationInfo['remainingHours'] as int;
    final dailyPrice = vehicle.dailyPrice;
    if (fullDays == 1 && remainingHours == 0) {
      return '${dailyPrice.toStringAsFixed(0)} × 1 ${tr(LocaleKeys.days)}';
    } else if (fullDays > 0 && remainingHours > 0) {
      final hourlyRate = dailyPrice / 24;
      return '${dailyPrice.toStringAsFixed(0)} × $fullDays ${tr(LocaleKeys.days)} + ${hourlyRate.toStringAsFixed(0)} × $remainingHours ${tr(LocaleKeys.hours)}';
    } else if (fullDays > 0) {
      return '${dailyPrice.toStringAsFixed(0)} × $fullDays ${tr(LocaleKeys.days)}';
    } else {
      final hourlyRate = dailyPrice / 24;
      return '${hourlyRate.toStringAsFixed(0)} × ${durationInfo['totalHours']} ${tr(LocaleKeys.hours)}';
    }
  }

  int _calculateRentalDays() {
    final duration = deliveryDate.difference(receptionDate);
    final totalHours = duration.inHours;

    if (totalHours <= 0) {
      return 1;
    } else if (totalHours < 24) {
      return 1;
    } else {
      return (totalHours / 24).ceil();
    }
  }

  // double _calculateExtraCosts(GlobalRentalOptionsController optionsController) {
  //   // final numberOfDays = deliveryDate.difference(receptionDate).inDays + 1;
  //   final duration = deliveryDate.difference(receptionDate);
  //   final totalHours = duration.inHours;
  //   int numbersOfDays;
  //
  //   if (totalHours <= 0) {
  //     numbersOfDays = 1;
  //   } else if (totalHours < 24) {
  //     numbersOfDays = 1;
  //   } else {
  //     numbersOfDays = (totalHours / 24).ceil();
  //   }
  //
  //   return optionsController.calculateExtraCosts(
  //     secondDriver: secondDriver,
  //     extraKilometers: extraKilometers,
  //     fullInsurance: fullInsurance,
  //     childSeat: childSeat,
  //     numberOfDays: numbersOfDays,
  //   );
  // }

  double _calculateExtraCosts(GlobalRentalOptionsController optionsController) {
    final numberOfDays = _calculateRentalDays();

    return optionsController.calculateExtraCosts(
      secondDriver: secondDriver,
      extraKilometers: extraKilometers,
      fullInsurance: fullInsurance,
      childSeat: childSeat,
      numberOfDays: numberOfDays,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _confirmRental(BuildContext context) {
    final optionsController = Get.find<GlobalRentalOptionsController>();
    final basePrice = _calculateRentalPrice(vehicle.dailyPrice);
    final extraCosts = _calculateExtraCosts(optionsController);
    final totalPrice = basePrice + extraCosts; // Recalcul explicite
    // Navigation vers l'écran de données du locataire
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RentVehicleDataScreenEnhanced(
          vehicle: vehicle,
          receptionDate: receptionDate,
          receptionTime: receptionTime,
          receptionLocation: receptionLocation,
          deliveryDate: deliveryDate,
          deliveryTime: deliveryTime,
          deliveryLocation: deliveryLocation,
          extraKilometers: extraKilometers,
          kilometerDetails: kilometerDetails,
          fullInsurance: fullInsurance,
          childSeat: childSeat,
          receptionZoneId: receptionZoneId,
          deliveryZoneId: deliveryZoneId,
          totalPrice: totalPrice,
          initialSecondDriver: secondDriver,
        ),
      ),
    );
  }
}