// // lib/services/api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static const String baseUrl = "http://192.168.100.76:5000/api/";
//
//   Future<List<dynamic>> getTasks() async {
//     final response = await http.get(Uri.parse('$baseUrl/tasks/'));
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load tasks');
//     }
//   }
//
//   Future<void> createTask(Map<String, dynamic> task) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/tasks/'),
//       headers: { 'accept': 'application/json',
//         'Content-Type': 'application/json',},
//       body: json.encode(task),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to create task');
//     }
//   }
// }