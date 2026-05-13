// lib/features/product/bloc/product_event.dart
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final int page;
  final int limit;
  final String? category;
  final String? searchQuery;

  const FetchProducts({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, limit, category, searchQuery];
}

class FetchProductsByCategory extends ProductEvent {
  final String category;
  final int page;
  final int limit;

  const FetchProductsByCategory({
    required this.category,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [category, page, limit];
}

class SearchProducts extends ProductEvent {
  final String query;
  final int page;
  final int limit;

  const SearchProducts({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, page, limit];
}

class LoadMoreProducts extends ProductEvent {
  final int page;

  const LoadMoreProducts({required this.page});

  @override
  List<Object?> get props => [page];
}

class RefreshProducts extends ProductEvent {}