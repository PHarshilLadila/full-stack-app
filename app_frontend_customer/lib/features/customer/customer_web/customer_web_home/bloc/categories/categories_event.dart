// lib/features/customer/customer_web/bloc/category/category_event.dart
 

import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/bloc/categories/categories_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class LoadProductsByCategory extends CategoryEvent {
  final String categoryName;

  const LoadProductsByCategory({required this.categoryName});

  @override
  List<Object?> get props => [categoryName];
}

class LoadProductsBySubCategory extends CategoryEvent {
  final String subCategoryName;

  const LoadProductsBySubCategory({required this.subCategoryName});

  @override
  List<Object?> get props => [subCategoryName];
}

class SelectCategory extends CategoryEvent {
  final CategoryData? category;

  const SelectCategory({this.category});

  @override
  List<Object?> get props => [category];
}

class SelectSubCategory extends CategoryEvent {
  final String subCategory;

  const SelectSubCategory({required this.subCategory});

  @override
  List<Object?> get props => [subCategory];
}