import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/geo_models.dart';
import '../models/vehicle_category_model.dart';

class GeoService {
  // Récupérer tous les pays
  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.countries),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Countries API Response: $data'); // Debug
        
        // Gérer le format paginé avec 'results'
        if (data is Map && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((json) => Country.fromJson(json)).toList();
        }
        // Gérer le format paginé avec 'items'
        else if (data is Map && data.containsKey('items')) {
          final List<dynamic> items = data['items'];
          return items.map((json) => Country.fromJson(json)).toList();
        }
        // Gérer le format liste directe
        else if (data is List) {
          return data.map((json) => Country.fromJson(json)).toList();
        }
        
        return [];
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return [];
    }
  }

  // Récupérer les villes par pays
  Future<List<City>> getCitiesByCountry(int countryId) async {
    try {
      final url = '${ApiConstants.baseUrl}cities/by-country?countryId=$countryId';
      print('Cities API URL: $url'); // Debug
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Cities API Response: $data'); // Debug
        
        if (data is List) {
          return data.map((json) => City.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((json) => City.fromJson(json)).toList();
        }
        
        return [];
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }

  // Récupérer les zones/lieux par ville
  Future<List<Area>> getAreasByCity(int cityId) async {
    try {
      final url = '${ApiConstants.baseUrl}areas/city/$cityId';
      print('Areas API URL: $url'); // Debug
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Areas API Response: $data'); // Debug
        
        if (data is List) {
          return data.map((json) => Area.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((json) => Area.fromJson(json)).toList();
        }
        
        return [];
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load areas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching areas: $e');
      return [];
    }
  }

  // Récupérer les catégories de véhicules
  Future<List<VehicleCategory>> getVehicleCategories() async {
    try {
      final url = '${ApiConstants.baseUrl}vehicles/categories';
      print('Vehicle Categories API URL: $url'); // Debug
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Vehicle Categories API Response: $data'); // Debug
        
        if (data is Map && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((json) => VehicleCategory.fromJson(json)).toList();
        } else if (data is List) {
          return data.map((json) => VehicleCategory.fromJson(json)).toList();
        }
        
        return [];
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load vehicle categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching vehicle categories: $e');
      return [];
    }
  }
}

