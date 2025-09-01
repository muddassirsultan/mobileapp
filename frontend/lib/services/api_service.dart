import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Get all categories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get category by ID
  static Future<Map<String, dynamic>> getCategoryById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      throw Exception('Failed to load category');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Submit venue request
  static Future<Map<String, dynamic>> submitVenueRequest({
    required String eventType,
    required String country,
    required String state,
    required String city,
    List<String>? eventDates,
    int? numberOfAdults,
    String? cateringPreference,
    List<String>? cuisines,
    double? budget,
    String? currency,
    bool? is24HourResponse,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/venue-requests'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'eventType': eventType,
          'country': country,
          'state': state,
          'city': city,
          'eventDates': eventDates,
          'numberOfAdults': numberOfAdults,
          'cateringPreference': cateringPreference,
          'cuisines': cuisines,
          'budget': budget,
          'currency': currency,
          'is24HourResponse': is24HourResponse,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      throw Exception('Failed to submit venue request');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get all venue requests
  static Future<List<Map<String, dynamic>>> getVenueRequests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/venue-requests'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      throw Exception('Failed to load venue requests');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get venue request by ID
  static Future<Map<String, dynamic>> getVenueRequestById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/venue-requests/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      throw Exception('Failed to load venue request');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update venue request status
  static Future<Map<String, dynamic>> updateVenueRequestStatus({
    required String id,
    required String status,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/venue-requests/$id/status'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      throw Exception('Failed to update venue request status');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Submit travel request
  static Future<Map<String, dynamic>> submitTravelRequest({
    required String travelType,
    required String country,
    required String state,
    required String city,
    required String checkInDate,
    required String checkOutDate,
    int? numberOfTravelers,
    String? accommodationType,
    String? travelClass,
    double? budget,
    String? currency,
    bool? is24HourResponse,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/travel-requests'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'travelType': travelType,
          'country': country,
          'state': state,
          'city': city,
          'checkInDate': checkInDate,
          'checkOutDate': checkOutDate,
          'numberOfTravelers': numberOfTravelers,
          'accommodationType': accommodationType,
          'travelClass': travelClass,
          'budget': budget,
          'currency': currency,
          'is24HourResponse': is24HourResponse,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      throw Exception('Failed to submit travel request');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Submit retail request
  static Future<Map<String, dynamic>> submitRetailRequest({
    required String retailCategory,
    required String country,
    required String state,
    required String city,
    required String deliveryDate,
    int? quantity,
    String? brandPreference,
    String? qualityPreference,
    double? budget,
    String? currency,
    bool? is24HourResponse,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/retail-requests'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'retailCategory': retailCategory,
          'country': country,
          'state': state,
          'city': city,
          'deliveryDate': deliveryDate,
          'quantity': quantity,
          'brandPreference': brandPreference,
          'qualityPreference': qualityPreference,
          'budget': budget,
          'currency': currency,
          'is24HourResponse': is24HourResponse,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      throw Exception('Failed to submit retail request');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Health check
  static Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
