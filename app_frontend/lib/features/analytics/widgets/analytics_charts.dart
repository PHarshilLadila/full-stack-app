// lib/features/analytics/widgets/analytics_charts.dart

import 'package:app_frontend/features/analytics/model/analytics_models.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class RevenueLineChart extends StatelessWidget {
  final Map<String, double> data;
  final String title;

  const RevenueLineChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _getChartData();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
                axisLine: const AxisLine(width: 0),
                labelRotation: chartData.length > 7 ? 45 : 0,
              ),
              primaryYAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                majorGridLines: MajorGridLines(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                labelStyle: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
                axisLine: const AxisLine(width: 0),
                numberFormat: NumberFormat.compactCurrency(
                  symbol: '₹',
                  decimalDigits: 0,
                ),
              ),
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: const Color(0xFF7C3AED),
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Color(0xFF7C3AED),
                    borderColor: Colors.white,
                    borderWidth: 2,
                    height: 8,
                    width: 8,
                  ),
                  enableTooltip: true,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: false,
                  ),
                  animationDuration: 1000,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                format: 'point.x: ₹point.y',
                color: const Color(0xFF1E293B),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> _getChartData() {
    return data.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();
  }
}

class OrderStatusPieChart extends StatelessWidget {
  final OrderStatus orderStatus;

  const OrderStatusPieChart({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    final pieData = [
      PieData('Pending', orderStatus.pending.toDouble(), const Color(0xFFF59E0B)),
      PieData('Confirmed', orderStatus.confirmed.toDouble(), const Color(0xFF3B82F6)),
      PieData('Shipped', orderStatus.shipped.toDouble(), const Color(0xFF8B5CF6)),
      PieData('Out for Delivery', orderStatus.outForDelivery.toDouble(), const Color(0xFF06B6D4)),
      PieData('Delivered', orderStatus.delivered.toDouble(), const Color(0xFF10B981)),
      PieData('Cancelled', orderStatus.cancelled.toDouble(), const Color(0xFFEF4444)),
    ].where((data) => data.value > 0).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SfCircularChart(
              legend: const Legend(
                isVisible: false,
              ),
              series: <CircularSeries>[
                DoughnutSeries<PieData, String>(
                  dataSource: pieData,
                  xValueMapper: (PieData data, _) => data.label,
                  yValueMapper: (PieData data, _) => data.value,
                  pointColorMapper: (PieData data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  enableTooltip: true,
                  radius: '70%',
                  innerRadius: '40%',
                  animationDuration: 1000,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                format: 'point.x: point.y',
                color: const Color(0xFF1E293B),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: pieData.map((data) {
              return _buildLegend(data.label, data.value.toInt(), data.color);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $count',
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class ProductPerformanceTable extends StatelessWidget {
  final List<ProductPerformance> products;
  final String title;

  const ProductPerformanceTable({
    super.key,
    required this.products,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          if (products.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No products found'),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color(0xFFF8FAFC),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Product',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sold',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Revenue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Stock',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: products.take(10).map((product) {
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.productImage,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  product.productName,
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(Text('${product.totalSold}')),
                      DataCell(
                        Text('₹${product.totalRevenue.toStringAsFixed(0)}'),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: product.isLowStock
                                ? const Color(0xFFEF4444).withOpacity(0.1)
                                : product.stockAvailable > 50
                                    ? const Color(0xFF10B981).withOpacity(0.1)
                                    : const Color(0xFFF59E0B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${product?.stockAvailable}',
                            style: TextStyle(
                              fontSize: 12,
                              color: product.isLowStock
                                  ? const Color(0xFFEF4444)
                                  : product.stockAvailable > 50
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 4),
                            Text(product.rating.toStringAsFixed(1)),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// Data model classes for charts
class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class PieData {
  final String label;
  final double value;
  final Color color;

  PieData(this.label, this.value, this.color);
}

// Additional Bar Chart Widget for extra analytics
class SalesBarChart extends StatelessWidget {
  final Map<String, double> data;
  final String title;

  const SalesBarChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = data.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
                axisLine: const AxisLine(width: 0),
                labelRotation: chartData.length > 7 ? 45 : 0,
              ),
              primaryYAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                majorGridLines: MajorGridLines(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                labelStyle: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
                axisLine: const AxisLine(width: 0),
                numberFormat: NumberFormat.compactCurrency(
                  symbol: '₹',
                  decimalDigits: 0,
                ),
              ),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: const Color(0xFF7C3AED),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(fontSize: 10),
                  ),
                  enableTooltip: true,
                  animationDuration: 1000,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                format: 'point.x: ₹point.y',
                color: const Color(0xFF1E293B),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}