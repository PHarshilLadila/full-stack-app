// lib/features/customer/customer_web/customer_web_home/bloc/featured_products/featured_products_bloc.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/featured_products/featured_products_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/featured_products/featured_products_state.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class FeaturedProductsBloc
    extends Bloc<FeaturedProductsEvent, FeaturedProductsState> {
  final CustomerWebService customerWebService;

  FeaturedProductsBloc({required this.customerWebService})
    : super(FeaturedProductsInitial()) {
    on<LoadFeaturedProducts>(_onLoadFeaturedProducts);
  }

  Future<void> _onLoadFeaturedProducts(
    LoadFeaturedProducts event,
    Emitter<FeaturedProductsState> emit,
  ) async {
    emit(FeaturedProductsLoading());
    try {
      final allProductsResponse = await customerWebService.getAllProducts();
      final allProducts = allProductsResponse.data;

      // Filter ONLY products that have "Featured" tag
      final featuredProducts = allProducts.where((p) => p.isFeatured).toList();

      emit(FeaturedProductsLoaded(products: featuredProducts));
    } catch (e) {
      emit(FeaturedProductsError(message: e.toString()));
    }
  }
}