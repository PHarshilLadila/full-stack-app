// lib/features/customer/customer_web/bloc/category/category_state.dart
 
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/bloc/categories/categories_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryData> categories;
  final CategoryData? selectedCategory;
  final String? selectedSubCategory;

  const CategoriesLoaded({
    required this.categories,
    this.selectedCategory,
    this.selectedSubCategory,
  });

  @override
  List<Object?> get props => [categories, selectedCategory, selectedSubCategory];
}

class CategoriesError extends CategoryState {
  final String message;

  const CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductsByCategoryLoading extends CategoryState {}

class ProductsByCategoryLoaded extends CategoryState {
  final List<ProductData> products;

  const ProductsByCategoryLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}