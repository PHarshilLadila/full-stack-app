// lib/features/customer/customer_web/bloc/category/category_bloc.dart
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/bloc/categories/categories_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/bloc/categories/categories_state.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CustomerWebService customerWebService;

  CategoryBloc({required this.customerWebService}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadProductsBySubCategory>(_onLoadProductsBySubCategory);
    on<SelectCategory>(_onSelectCategory);
    on<SelectSubCategory>(_onSelectSubCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      final categoryResponse = await customerWebService.getCategories();
      emit(CategoriesLoaded(categories: categoryResponse.data));
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(ProductsByCategoryLoading());
    try {
      final productResponse = await customerWebService.getProductsByCategory(
        event.categoryName,
      );
      emit(ProductsByCategoryLoaded(products: productResponse.data));
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductsBySubCategory(
    LoadProductsBySubCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(ProductsByCategoryLoading());
    try {
      final productResponse = await customerWebService.getProductsBySubCategory(
        event.subCategoryName,
      );
      emit(ProductsByCategoryLoaded(products: productResponse.data));
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoriesLoaded) {
      final currentState = state as CategoriesLoaded;
      emit(
        CategoriesLoaded(
          categories: currentState.categories,
          selectedCategory: event.category,
          selectedSubCategory: null,
        ),
      );
    }
  }

  void _onSelectSubCategory(
    SelectSubCategory event,
    Emitter<CategoryState> emit,
  ) {
    if (state is CategoriesLoaded) {
      final currentState = state as CategoriesLoaded;
      emit(
        CategoriesLoaded(
          categories: currentState.categories,
          selectedCategory: currentState.selectedCategory,
          selectedSubCategory: event.subCategory,
        ),
      );
    }
  }
}
