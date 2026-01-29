// // Dans make_model_selector.dart
// import 'package:enmaa/features/add_new_vehicle/data/models/vehicle_make_model.dart';
//
// import '../../../../services/vehicle_make_service.dart';
// import '../../../home_module/home_imports.dart';
// import '../../../vehicle_management/vehicle/data/models/vehicle_model.dart';
// // import '../../data/models/vehicle_make_model.dart';
//
// class MakeModelSelector extends StatefulWidget {
//   final VehicleMakeService makeService;
//   final ValueChanged<int> onMakeSelected;
//   final ValueChanged<int> onModelSelected;
//
//   const MakeModelSelector({
//     required this.makeService,
//     required this.onMakeSelected,
//     required this.onModelSelected,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _MakeModelSelectorState createState() => _MakeModelSelectorState();
// }
//
// class _MakeModelSelectorState extends State<MakeModelSelector> {
//   List<VehicleMake> makes = [];
//   List<VehicleModel> models = [];
//   VehicleMake? selectedMake;
//   VehicleModel? selectedModel;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMakesWithModels();
//   }
//
//   Future<void> _loadMakesWithModels() async {
//     setState(() => isLoading = true);
//     try {
//       makes = await widget.makeService.getMakesWithModels();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur: ${e.toString()}')),
//       );
//     }
//     setState(() => isLoading = false);
//   }
//
//   void _onMakeChanged(VehicleMake? make) {
//     setState(() {
//       selectedMake = make;
//       selectedModel = null;
//       models = make?.models?.cast<VehicleModelMake>()  ?? [];
//       // models = (make?.models as List<VehicleModel>?) ?? [];// Utilise les modèles directement de la marque
//     });
//
//     if (make != null) {
//       widget.onMakeSelected(make.id);
//     }
//   }
//
//   void _onModelChanged(VehicleModel? model) {
//     setState(() => selectedModel = model);
//     if (model != null) {
//       widget.onModelSelected(model.id);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Sélecteur de marque
//         DropdownButtonFormField<VehicleMake>(
//           value: selectedMake,
//           items: makes.map((make) {
//             return DropdownMenuItem<VehicleMake>(
//               value: make,
//               child: Row(
//                 children: [
//                   if (make.logoUrl != null && make.logoUrl!.isNotEmpty)
//                     Container(
//                       width: 24,
//                       height: 24,
//                       margin: const EdgeInsets.only(right: 8),
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(make.logoUrl!),
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   Text(make.name),
//                 ],
//               ),
//             );
//           }).toList(),
//           onChanged: _onMakeChanged,
//           decoration: const InputDecoration(
//             labelText: 'Marque',
//             border: OutlineInputBorder(),
//           ),
//           validator: (value) => value == null ? 'Sélectionnez une marque' : null,
//           isExpanded: true,
//         ),
//
//         const SizedBox(height: 16),
//
//         // Sélecteur de modèle (seulement si une marque est sélectionnée)
//         if (selectedMake != null)
//           DropdownButtonFormField<VehicleModel>(
//             value: selectedModel,
//             items: models.map((model) {
//               return DropdownMenuItem<VehicleModel>(
//                 value: model,
//                 child: Text(model.modelName),
//               );
//             }).toList(),
//             onChanged: _onModelChanged,
//             decoration: const InputDecoration(
//               labelText: 'Modèle',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) => value == null ? 'Sélectionnez un modèle' : null,
//             isExpanded: true,
//           ),
//
//         // Indicateur de chargement
//         if (isLoading)
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: CircularProgressIndicator(),
//           ),
//       ],
//     );
//   }
// }

// Dans make_model_selector.dart
import 'package:enmaa/features/add_new_vehicle/data/models/vehicle_make_model.dart';
import '../../../../services/vehicle_make_service.dart';
import '../../../home_module/home_imports.dart';
// Supprimez l'import inutile si VehicleModel n'est pas utilisé ailleurs
// import '../../../vehicle_management/vehicle/data/models/vehicle_model.dart';

class MakeModelSelector extends StatefulWidget {
  final VehicleMakeService makeService;
  final ValueChanged<int> onMakeSelected;
  final ValueChanged<int> onModelSelected;

  const MakeModelSelector({
    required this.makeService,
    required this.onMakeSelected,
    required this.onModelSelected,
    Key? key,
  }) : super(key: key);

  @override
  _MakeModelSelectorState createState() => _MakeModelSelectorState();
}

class _MakeModelSelectorState extends State<MakeModelSelector> {
  List<VehicleMake> makes = [];
  List<VehicleModelMake> models = []; // Changé: VehicleModelMake
  VehicleMake? selectedMake;
  VehicleModelMake? selectedModel; // Changé: VehicleModelMake
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMakesWithModels();
  }

  Future<void> _loadMakesWithModels() async {
    setState(() => isLoading = true);
    try {
      makes = await widget.makeService.getMakesWithModels();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
    setState(() => isLoading = false);
  }

  void _onMakeChanged(VehicleMake? make) {
    setState(() {
      selectedMake = make;
      selectedModel = null;
      models = make?.models ?? []; // Simplifié: plus besoin de cast
    });

    if (make != null) {
      widget.onMakeSelected(make.id);
    }
  }

  void _onModelChanged(VehicleModelMake? model) { // Changé: VehicleModelMake
    setState(() => selectedModel = model);
    if (model != null) {
      widget.onModelSelected(model.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sélecteur de marque
        DropdownButtonFormField<VehicleMake>(
          value: selectedMake,
          items: makes.map((make) {
            return DropdownMenuItem<VehicleMake>(
              value: make,
              child: Row(
                children: [
                  if (make.logoUrl != null && make.logoUrl!.isNotEmpty)
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(make.logoUrl!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  Text(make.name),
                ],
              ),
            );
          }).toList(),
          onChanged: _onMakeChanged,
          decoration: const InputDecoration(
            labelText: 'Marque',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null ? 'Sélectionnez une marque' : null,
          isExpanded: true,
        ),

        const SizedBox(height: 16),

        // Sélecteur de modèle (seulement si une marque est sélectionnée)
        if (selectedMake != null)
          DropdownButtonFormField<VehicleModelMake>( // Changé: VehicleModelMake
            value: selectedModel,
            items: models.map((model) {
              return DropdownMenuItem<VehicleModelMake>( // Changé: VehicleModelMake
                value: model,
                child: Text(model.name), // Changé: model.name au lieu de model.modelName
              );
            }).toList(),
            onChanged: _onModelChanged,
            decoration: const InputDecoration(
              labelText: 'Modèle',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null ? 'Sélectionnez un modèle' : null,
            isExpanded: true,
          ),

        // Indicateur de chargement
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}