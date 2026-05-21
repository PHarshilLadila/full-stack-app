// lib/features/customer/address/services/address_service.dart
import 'dart:convert';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/address/model/address_model.dart';
import 'package:http/http.dart' as http; 

class AddressService {
  final ApiClient _apiClient = ApiClient();
  
  Future<http.Response> getAuthenticatedRequest(String token) async {
    // This is just a helper, actual implementation uses ApiClient methods
    throw UnimplementedError('Use ApiClient methods directly');
  }

  Future<Map<String, dynamic>> addAddress(
    String token,
    AddressModel address,
  ) async {
    try {
      final response = await _apiClient.postWithParam(
        '/address/add',
        address.toJson(),
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to add address: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  Future<List<AddressModel>> getAddresses(String token) async {
    try {
      final response = await _apiClient.get(
        '/address/list',
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> addressesJson = data['data'];
          return addressesJson
              .map((json) => AddressModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch addresses: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  Future<Map<String, dynamic>> updateAddress(
    String token,
    AddressModel address,
  ) async {
    try {
      if (address.id == null) {
        throw Exception('Address ID is required for update');
      }

      final response = await _apiClient.put(
        '/address/update',
        address.toJson(),
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to update address: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAddress(
    String token,
    String addressId,
  ) async {
    try {
      final response = await _apiClient.delete(
        '/address/delete',
        body: {'addressId': addressId},
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to delete address: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }
}