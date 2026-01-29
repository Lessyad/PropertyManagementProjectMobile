import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../domain/entities/vehicle_details_entity.dart';

class VehicleDetailsCard extends StatelessWidget {
  final VehicleDetailsEntity vehicle;

  const VehicleDetailsCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.vehicleDetails.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, LocaleKeys.brandLabel.tr(), vehicle.makeName),
            _buildDetailRow(context, LocaleKeys.modelLabel.tr(), vehicle.modelName),
            _buildDetailRow(context, LocaleKeys.licensePlateLabel.tr(), vehicle.licensePlate),
            _buildDetailRow(context, LocaleKeys.colorLabel.tr(), vehicle.color),
            _buildDetailRow(context, LocaleKeys.yearLabel.tr(), vehicle.year.toString()),
            _buildDetailRow(context, LocaleKeys.mileageLabel.tr(), '${vehicle.mileage} ${LocaleKeys.kilometers.tr()}'),
            _buildDetailRow(context, LocaleKeys.fuelTypeLabel.tr(), _getFuelTypeTranslation(vehicle.fuelType)),
            _buildDetailRow(context, LocaleKeys.transmissionLabel.tr(), _getTransmissionTranslation(vehicle.transmission)),
            _buildDetailRow(context, LocaleKeys.airConditioningLabel.tr(), vehicle.hasAirConditioning ? LocaleKeys.yes.tr() : LocaleKeys.no.tr()),
            _buildDetailRow(context, LocaleKeys.seatsLabel.tr(), vehicle.seats.toString()),
            _buildDetailRow(context, LocaleKeys.dailyPrice.tr(), '${vehicle.dailyPrice} ${LocaleKeys.currency.tr()}'),
            _buildDetailRow(context, LocaleKeys.weeklyPrice.tr(), '${vehicle.weeklyPrice} ${LocaleKeys.currency.tr()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getFuelTypeTranslation(String fuelType) {
    switch (fuelType.toLowerCase()) {
      case 'gasoline':
      case 'essence':
        return LocaleKeys.fuelTypeGasoline.tr();
      case 'diesel':
        return LocaleKeys.fuelTypeDiesel.tr();
      case 'electric':
      case 'électrique':
        return LocaleKeys.fuelTypeElectric.tr();
      case 'hybrid':
      case 'hybride':
        return LocaleKeys.fuelTypeHybrid.tr();
      default:
        return fuelType;
    }
  }

  String _getTransmissionTranslation(String transmission) {
    switch (transmission.toLowerCase()) {
      case 'manual':
      case 'manuelle':
        return LocaleKeys.transmissionManual.tr();
      case 'automatic':
      case 'automatique':
        return LocaleKeys.transmissionAutomatic.tr();
      default:
        return transmission;
    }
  }
}