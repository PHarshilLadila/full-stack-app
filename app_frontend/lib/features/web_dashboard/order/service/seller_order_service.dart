import 'dart:convert';
import 'package:app_frontend/core/network/api_client.dart';
import '../model/seller_order_model.dart';

class SellerOrderService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getSellerOrders({
    required String token,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }

      final response = await _apiClient.get(
        '/order/seller_orders',
        queryParams: queryParams,
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> ordersJson = data['data'] ?? [];
          final List<SellerOrderModel> orders = ordersJson
              .map((order) => SellerOrderModel.fromJson(order))
              .toList();

          final PaginationInfo pagination = PaginationInfo.fromJson(
            data['pagination'] ?? {},
          );

          return {
            'orders': orders,
            'pagination': pagination,
          };
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

  Future<Map<String, dynamic>> updateOrderStatus({
    required String token,
    required String orderId,
    required String orderStatus,
    String? trackingId,
  }) async {
    try {
      final request = OrderStatusUpdateRequest(
        orderId: orderId,
        orderStatus: orderStatus,
        trackingId: trackingId,
      );

      final response = await _apiClient.put(
        '/order/update_status',
        request.toJson(),
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to update order status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }
}