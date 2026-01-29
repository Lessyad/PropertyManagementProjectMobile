// import 'package:flutter/material.dart';
// // import '../../data/services/vehicle_deal_service.dart';
//
// class TestApiScreen extends StatefulWidget {
//   const TestApiScreen({super.key});
//
//   @override
//   State<TestApiScreen> createState() => _TestApiScreenState();
// }
//
// class _TestApiScreenState extends State<TestApiScreen> {
//   bool _isLoading = false;
//   String _result = '';
//
//   Future<void> _testApi() async {
//     setState(() {
//       _isLoading = true;
//       _result = 'Test en cours...';
//     });
//
//     try {
//       // Créer un DTO de test
//       final dto = CreateVehicleDealDto(
//         vehicleId: 'test-vehicle-123',
//         isUser: true,
//         name: 'Test User',
//         phoneNumber: '+1234567890',
//         nni: '123456789',
//         birthDate: '1990-01-01',
//         idCardExpiryDate: '2030-01-01',
//         paymentMethod: 'bankily',
//         passCode: '1234',
//         idCardImage: '/path/to/test/image.jpg', // Chemin fictif pour le test
//         numberOfRentalDays: 3,
//         drivingLicenseNumber: 'DL123456',
//         drivingLicenseExpiry: '2030-01-01',
//         vehicleReceptionPlace: 'Test Location',
//         vehicleReturnPlace: 'Test Return',
//         totalAmount: 150.0,
//       );
//
//       final service = VehicleDealService();
//       final result = await service.createVehicleDeal(dto);
//
//       setState(() {
//         _result = '✅ Succès!\nRésultat: $result';
//       });
//     } catch (e) {
//       setState(() {
//         _result = '❌ Erreur: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Test API VehicleDeals'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _isLoading ? null : _testApi,
//               child: _isLoading
//                   ? const CircularProgressIndicator()
//                   : const Text('🧪 Tester l\'API'),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 _result.isEmpty ? 'Cliquez sur le bouton pour tester l\'API' : _result,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

