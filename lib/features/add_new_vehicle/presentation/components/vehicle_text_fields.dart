import 'package:flutter/material.dart';

class VehicleTextFields extends StatelessWidget {
  final TextEditingController licensePlateController;
  final TextEditingController colorController;
  final TextEditingController dailyPriceController;
  final TextEditingController weeklyPriceController;
  final TextEditingController mileageController;
  final TextEditingController VIN;

  const VehicleTextFields({
    required this.licensePlateController,
    required this.colorController,
    required this.dailyPriceController,
    required this.weeklyPriceController,
    required this.mileageController,
    required this.VIN,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: licensePlateController,
          decoration: const InputDecoration(
            labelText: 'Plaque d\'immatriculation',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: VIN,
          decoration: const InputDecoration(
            labelText: 'VIN',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: colorController,
          decoration: const InputDecoration(
            labelText: 'Couleur',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: dailyPriceController,
          decoration: const InputDecoration(
            labelText: 'Prix journalier (€)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Requis';
            if (double.tryParse(v) == null) return 'Nombre valide requis';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: weeklyPriceController,
          decoration: const InputDecoration(
            labelText: 'Prix hebdomadaire (€)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Requis';
            if (double.tryParse(v) == null) return 'Nombre valide requis';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: mileageController,
          decoration: const InputDecoration(
            labelText: 'Kilométrage',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Requis';
            if (int.tryParse(v) == null) return 'Nombre valide requis';
            return null;
          },
        ),
      ],
    );
  }
}















