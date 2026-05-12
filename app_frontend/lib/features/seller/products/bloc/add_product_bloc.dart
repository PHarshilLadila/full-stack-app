import 'dart:io';
import 'package:app_frontend/features/seller/products/bloc/add_product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/add_product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductService productService;

  AddProductBloc(this.productService) : super(AddProductInitial()) {
    on<SubmitProductEvent>(_submitProduct);
    on<SubmitProductWithImagesEvent>(_submitProductWithImages);
  }

  Future<void> _submitProduct(
    SubmitProductEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(AddProductLoading());

    try {
      final message = await productService.addProduct(body: event.body);
      emit(AddProductSuccess(message));
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }

  Future<void> _submitProductWithImages(
    SubmitProductWithImagesEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(AddProductLoading());

    try {
      final message = await productService.addProductWithImages(
        body: event.body,
        mainBannerImage: event.mainBannerImage,
        multipleImages: event.multipleImages,
      );
      emit(AddProductSuccess(message));
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }
}
