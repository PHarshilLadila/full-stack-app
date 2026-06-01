// lib/features/customer/order/service/order_service.dart

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
      print("========== GET CUSTOMER ORDERS ==========");
      print("Page: $page, Limit: $limit");

      final response = await http.get(
        Uri.parse("$baseUrl/order/customer_orders").replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("Decoded Data: $data");

        if (data['success'] == true) {
          final List<dynamic> ordersJson = data['data'];
          print("Orders Count: ${ordersJson.length}");

          final List<OrderModel> orders = [];
          for (var orderJson in ordersJson) {
            print("Processing Order: ${orderJson['orderId']}");
            final order = OrderModel.fromJson(orderJson);
            print("Order Items Count: ${order.items.length}");
            for (var item in order.items) {
              print(
                "  - Item: ${item.productName}, Image: ${item.productImage}",
              );
            }
            orders.add(order);
          }

          final PaginationInfo pagination = PaginationInfo.fromJson(
            data['pagination'] ?? {},
          );

          return {'orders': orders, 'pagination': pagination};
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch orders');
        }
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching orders: $e");
      throw Exception('Error fetching orders: $e');
    }
  }
}
