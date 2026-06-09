// lib/features/customer/customer_web/customer_web_home/bloc/flash_deals/flash_deals_bloc.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/flash_deals/flash_deals_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/flash_deals/flash_deals_state.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashDealsBloc extends Bloc<FlashDealsEvent, FlashDealsState> {
  final CustomerWebService customerWebService;

  FlashDealsBloc({required this.customerWebService})
    : super(FlashDealsInitial()) {
    on<LoadFlashDeals>(_onLoadFlashDeals);
  }

  Future<void> _onLoadFlashDeals(
    LoadFlashDeals event,
    Emitter<FlashDealsState> emit,
  ) async {
    emit(FlashDealsLoading());
    try {
      final allProductsResponse = await customerWebService.getAllProducts();
      final allProducts = allProductsResponse.data;

      // Filter ONLY products that have "Sale" tag
      final saleProducts = allProducts.where((p) => p.isSale).toList();

      emit(FlashDealsLoaded(products: saleProducts));
    } catch (e) {
      emit(FlashDealsError(message: e.toString()));
    }
  }
}
