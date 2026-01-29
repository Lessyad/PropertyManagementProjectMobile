import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/services/dio_service.dart';
import '../../../../services/vehicle_make_service.dart';
import '../../data/models/vehicle_request_models.dart';
import '../controller/add_new_vehicle_cubit.dart';
import '../components/vehicle_text_fields.dart';
import '../components/vehicle_selectors.dart';
// import '../components/section_header.dart';

import '../components/make_model_selector.dart';
import '../controller/image_picker_widget.dart';


class AddVehicleFormScreen extends StatefulWidget {
  const AddVehicleFormScreen({Key? key}) : super(key: key);

  @override
  State<AddVehicleFormScreen> createState() => _AddVehicleFormScreenState();
}

class _AddVehicleFormScreenState extends State<AddVehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licensePlate = TextEditingController();
  final _VIN = TextEditingController();
  final _color = TextEditingController();
  final _dailyPrice = TextEditingController();
  final _weeklyPrice = TextEditingController();
  final _mileage = TextEditingController();

  String _fuelType = 'ESSENCE';
  String _transmission = 'MANUEL';
  bool _ac = false;
  List<File> _images = []; // Modifié: supprimé 'final'

  int? _selectedMakeId;
  int? _selectedModelId;

  final VehicleMakeService _makeService = VehicleMakeService(
    dioService: ServiceLocator.getIt<DioService>(),
  );

  @override
  void dispose() {
    _licensePlate.dispose();
    _VIN.dispose();
    _color.dispose();
    _dailyPrice.dispose();
    _weeklyPrice.dispose();
    _mileage.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMakeId == null || _selectedModelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une marque et un modèle')),
      );
      return;
    }

    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter au moins une image')),
      );
      return;
    }

    final body = CreateVehicleRequestModel(
      vehiclemakId: _selectedMakeId!,
      vehicleModelId: _selectedModelId!,
      licensePlate: _licensePlate.text.trim(),
      vin: _VIN.text.trim(),
      color: _color.text.trim(),
      dailyPrice: double.tryParse(_dailyPrice.text) ?? 0,
      weeklyPrice: double.tryParse(_weeklyPrice.text) ?? 0,
      mileage: int.tryParse(_mileage.text) ?? 0,
      fuelType: _fuelType,
      transmission: _transmission,
      hasAirConditioning: _ac,
      images: _images,
    );

    context.read<AddNewVehicleCubit>().submitCreate(body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un véhicule'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AddNewVehicleCubit, AddNewVehicleState>(
        listener: (context, state) {
          if (state.success) {
            Navigator.pop(context, true);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state.isSubmitting,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Section Marque et Modèle
                    // const SectionHeader('Marque et Modèle'),
                    const SizedBox(height: 8),
                    MakeModelSelector(
                      makeService: _makeService,
                      onMakeSelected: (makeId) => setState(() => _selectedMakeId = makeId),
                      onModelSelected: (modelId) => setState(() => _selectedModelId = modelId),
                    ),

                    const SizedBox(height: 24),

                    // Section Informations générales
                    // const SectionHeader('Informations générales'),
                    const SizedBox(height: 8),
                    VehicleTextFields(
                      licensePlateController: _licensePlate,
                      VIN:_VIN,
                      colorController: _color,
                      dailyPriceController: _dailyPrice,
                      weeklyPriceController: _weeklyPrice,
                      mileageController: _mileage,

                    ),

                    const SizedBox(height: 24),

                    // Section Caractéristiques
                    // const SectionHeader('Caractéristiques'),
                    const SizedBox(height: 8),
                    VehicleSelectors(
                      fuelType: _fuelType,
                      transmission: _transmission,
                      onFuelChanged: (v) => setState(() => _fuelType = v ?? _fuelType),
                      onTransmissionChanged: (v) => setState(() => _transmission = v ?? _transmission),
                      hasAc: _ac,
                      onAcChanged: (v) => setState(() => _ac = v),
                    ),

                    const SizedBox(height: 24),

                    // Section Images
                    // const SectionHeader('Images'),
                    const SizedBox(height: 8),
                    ImagePickerWidget(
                      images: _images,
                      onImagesChanged: (images) => setState(() => _images = images),
                    ),

                    const SizedBox(height: 32),

                    // Bouton de soumission
                    ElevatedButton(
                      onPressed: state.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Envoi en cours...'),
                        ],
                      )
                          : const Text(
                        'Ajouter le véhicule',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bouton annuler
                    OutlinedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}