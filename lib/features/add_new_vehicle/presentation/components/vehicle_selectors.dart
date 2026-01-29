import 'package:flutter/material.dart';

class VehicleSelectors extends StatelessWidget {
  final String fuelType;
  final String transmission;
  final ValueChanged<String?> onFuelChanged;
  final ValueChanged<String?> onTransmissionChanged;
  final bool hasAc;
  final ValueChanged<bool> onAcChanged;

  const VehicleSelectors({
    required this.fuelType,
    required this.transmission,
    required this.onFuelChanged,
    required this.onTransmissionChanged,
    required this.hasAc,
    required this.onAcChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: fuelType,
          items: const [
            DropdownMenuItem(value: 'ESSENCE', child: Text('Essence')),
            DropdownMenuItem(value: 'DIESEL', child: Text('Diesel')),
            DropdownMenuItem(value: 'ELECTRONIQUE', child: Text('Electrique')),
            DropdownMenuItem(value: 'HYBRIDE', child: Text('Hybride')),
          ],
          onChanged: onFuelChanged,
          decoration: const InputDecoration(labelText: 'Carburant'),
        ),
        DropdownButtonFormField<String>(
          value: transmission,
          items: const [
            DropdownMenuItem(value: 'MANUEL', child: Text('Manuel')),
            DropdownMenuItem(value: 'AUTOMATIQUE', child: Text('Automatique')),
          ],
          onChanged: onTransmissionChanged,
          decoration: const InputDecoration(labelText: 'Transmission'),
        ),
        SwitchListTile(
          title: const Text('Climatisation'),
          value: hasAc,
          onChanged: onAcChanged,
        ),
      ],
    );
  }
}



