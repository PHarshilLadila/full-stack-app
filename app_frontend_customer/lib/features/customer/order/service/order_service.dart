import 'dart:convert';
import 'package:app_frontend_customer/features/customer/order/model/order_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl = "https://full-stack-app-1-4iqk.onrender.com";
  final String token;

  OrderService({required this.token});

  Future<Map<String, dynamic>> getCustomerOrders({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/order/customer_orders").replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> ordersJson = data['data'];
          final List<OrderModel> orders =
              ordersJson.map((order) => OrderModel.fromJson(order)).toList();

          final PaginationInfo pagination = PaginationInfo.fromJson(
            data['pagination'],
          );

          return {'orders': orders, 'pagination': pagination};
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch orders');
        }
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
}
