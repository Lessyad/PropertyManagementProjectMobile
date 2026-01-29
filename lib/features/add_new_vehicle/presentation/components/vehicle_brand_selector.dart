// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class VehicleBrandSelector extends StatelessWidget {
//   final ValueChanged<VehicleBrandEntity?> onBrandSelected;
//
//   const VehicleBrandSelector({required this.onBrandSelected});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VehiclesCubit, VehiclesState>(
//       builder: (context, state) {
//         return DropdownButton<VehicleBrandEntity>(
//           value: state.selectedBrand,
//           onChanged: (brand) {
//             onBrandSelected(brand);
//             context.read<VehiclesCubit>().selectBrand(brand);
//           },
//           items: state.brands.map((brand) {
//             return DropdownMenuItem<VehicleBrandEntity>(
//               value: brand,
//               child: Text(brand.name),
//             );
//           }).toList(),
//           hint: const Text('Sélectionnez une marque'),
//         );
//       },
//     );
//   }
// }