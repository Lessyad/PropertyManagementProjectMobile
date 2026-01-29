// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../controller/rent_vehicle_cubit.dart';
//
// class DebugStateScreen extends StatelessWidget {
//   const DebugStateScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('🔍 Debug - État du Cubit'),
//         backgroundColor: Colors.orange,
//       ),
//       body: BlocBuilder<RentVehicleCubit, RentVehicleState>(
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'État actuel du Cubit RentVehicle',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 _buildStateCard('Informations utilisateur', {
//                   'userName': state.userName,
//                   'phoneNumber': state.phoneNumber,
//                   'userID': state.userID,
//                   'age': state.age,
//                 }),
//
//                 _buildStateCard('Dates', {
//                   'birthDate': state.birthDate?.toString() ?? 'null',
//                   'idExpirationDate': state.idExpirationDate?.toString() ?? 'null',
//                   'rentalDate': state.rentalDate?.toString() ?? 'null',
//                   'returnDate': state.returnDate?.toString() ?? 'null',
//                   'drivingLicenseExpiry': state.drivingLicenseExpiry?.toString() ?? 'null',
//                 }),
//
//                 _buildStateCard('Lieux', {
//                   'vehicleReceptionPlace': state.vehicleReceptionPlace,
//                   'vehicleReturnPlace': state.vehicleReturnPlace,
//                 }),
//
//                 _buildStateCard('Images', {
//                   'idImage': state.idImage?.path ?? 'null',
//                   'driveLicenseImage': state.driveLicenseImage?.path ?? 'null',
//                 }),
//
//                 _buildStateCard('Permis de conduire', {
//                   'drivingLicenseNumber': state.drivingLicenseNumber,
//                   'drivingLicenseExpiry': state.drivingLicenseExpiry?.toString() ?? 'null',
//                 }),
//
//                 _buildStateCard('États de validation', {
//                   'validateIDImage': state.validateIDImage.toString(),
//                   'validateDriveLicenseImage': state.validateDriveLicenseImage.toString(),
//                   'paymentState': state.paymentState.toString(),
//                 }),
//
//                 const SizedBox(height: 20),
//
//                 ElevatedButton(
//                   onPressed: () {
//                     // Test de validation
//                     final cubit = context.read<RentVehicleCubit>();
//                     print('🧪 Test de validation...');
//                     print('👤 userName: "${state.userName}"');
//                     print('📱 phoneNumber: "${state.phoneNumber}"');
//                     print('🆔 userID: "${state.userID}"');
//                     print('🎂 age: "${state.age}"');
//                     print('📍 vehicleReceptionPlace: "${state.vehicleReceptionPlace}"');
//                     print('📍 vehicleReturnPlace: "${state.vehicleReturnPlace}"');
//                     print('📅 rentalDate: ${state.rentalDate}');
//                     print('📅 returnDate: ${state.returnDate}');
//                     print('🖼️ idImage: ${state.idImage}');
//                     print('🖼️ driveLicenseImage: ${state.driveLicenseImage}');
//                     print('🚗 drivingLicenseNumber: "${state.drivingLicenseNumber}"');
//                     print('📅 drivingLicenseExpiry: ${state.drivingLicenseExpiry}');
//                   },
//                   child: const Text('🧪 Tester la validation'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildStateCard(String title, Map<String, String> fields) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ...fields.entries.map((entry) {
//               final isNotEmpty = entry.value != 'null' && entry.value.isNotEmpty;
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       isNotEmpty ? Icons.check_circle : Icons.cancel,
//                       color: isNotEmpty ? Colors.green : Colors.red,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         '${entry.key}: ${entry.value}',
//                         style: TextStyle(
//                           color: isNotEmpty ? Colors.black : Colors.red,
//                           fontWeight: isNotEmpty ? FontWeight.normal : FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
