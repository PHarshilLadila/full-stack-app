import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<FetchSellerProductsEvent>(_fetchProducts);
  }

  Future<void> _fetchProducts(
    FetchSellerProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final products = await productService.fetchSellerProducts();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}