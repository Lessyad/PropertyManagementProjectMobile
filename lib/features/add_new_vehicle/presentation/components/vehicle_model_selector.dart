// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class VehicleModelSelector extends StatelessWidget {
//   final ValueChanged<VehicleModelEntity?> onModelSelected;
//
//   const VehicleModelSelector({required this.onModelSelected});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VehiclesCubit, VehiclesState>(
//       builder: (context, state) {
//         return DropdownButton<VehicleModelEntity>(
//           value: state.selectedModel,
//           onChanged: (model) {
//             onModelSelected(model);
//             context.read<VehiclesCubit>().selectModel(model);
//           },
//           items: state.models.map((model) {
//             return DropdownMenuItem<VehicleModelEntity>(
//               value: model,
//               child: Text('${model.name} (${model.year})'),
//             );
//           }).toList(),
//           hint: const Text('Sélectionnez un modèle'),
//           disabledHint: state.selectedBrand == null
//               ? const Text('Sélectionnez d\'abord une marque')
//               : null,
//         );
//       },
//     );
//   }
// }