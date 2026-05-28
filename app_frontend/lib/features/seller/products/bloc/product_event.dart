// lib/features/seller/products/bloc/product_event.dart

abstract class ProductEvent {}

class FetchSellerProductsEvent extends ProductEvent {
  final int page;
  final int limit;

  FetchSellerProductsEvent({this.page = 1, this.limit = 10});
}

class ChangePageEvent extends ProductEvent {
  final int page;
  final int limit;

  ChangePageEvent({required this.page, required this.limit});
}