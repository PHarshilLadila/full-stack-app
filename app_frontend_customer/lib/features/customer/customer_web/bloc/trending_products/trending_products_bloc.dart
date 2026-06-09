// lib/features/customer/customer_web/customer_web_home/bloc/trending_products/trending_products_bloc.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/trending_products/trending_products_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/trending_products/trending_products_state.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingProductsBloc
    extends Bloc<TrendingProductsEvent, TrendingProductsState> {
  final CustomerWebService customerWebService;

  TrendingProductsBloc({required this.customerWebService})
    : super(TrendingProductsInitial()) {
    on<LoadTrendingProducts>(_onLoadTrendingProducts);
  }

  Future<void> _onLoadTrendingProducts(
    LoadTrendingProducts event,
    Emitter<TrendingProductsState> emit,
  ) async {
    emit(TrendingProductsLoading());
    try {
      final allProductsResponse = await customerWebService.getAllProducts();
      final allProducts = allProductsResponse.data;

      // Filter ONLY products that have "Trending" tag
      final trendingProducts = allProducts.where((p) => p.isTrending).toList();

      emit(TrendingProductsLoaded(products: trendingProducts));
    } catch (e) {
      emit(TrendingProductsError(message: e.toString()));
    }
  }
}
