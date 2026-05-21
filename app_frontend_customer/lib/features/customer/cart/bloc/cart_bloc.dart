import 'dart:async';
import 'package:app_frontend_customer/features/customer/favorite/service/favorites_service.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_frontend_customer/features/customer/cart/bloc/cart_event.dart';
import 'package:app_frontend_customer/features/customer/cart/bloc/cart_state.dart';
import 'package:app_frontend_customer/features/customer/cart/service/cart_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;
  StreamSubscription? _cartUpdateSubscription;

  CartBloc({required CartService cartService})
    : _cartService = cartService,
      super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<RefreshCart>(_onRefreshCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  // Helper method to get token
  Future<String?> _getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("auth_token");
    return token;
  }

  // Load cart
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartError(message: 'Please login to view cart'));
        return;
      }

      final cartSummary = await _cartService.getCart(token: token);
      emit(CartLoaded(cartSummary: cartSummary));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Refresh cart
  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartError(message: 'Please login to view cart'));
        return;
      }

      final cartSummary = await _cartService.getCart(token: token);
      emit(CartLoaded(cartSummary: cartSummary));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Add to cart
  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartAdding(productId: event.productId));

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartError(message: 'Please login to add to cart'));
        return;
      }

      final response = await _cartService.addToCart(
        productId: event.productId,
        quantity: event.quantity,
        token: token,
      );

      if (response.success) {
        // Refresh cart after adding
        final updatedCart = await _cartService.getCart(token: token);
        emit(CartLoaded(cartSummary: updatedCart));
        emit(
          CartAddSuccess(
            message: response.message,
            itemCount: updatedCart.itemCount,
          ),
        );
      } else {
        emit(CartError(message: response.message));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Update cart item
  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartUpdating(productId: event.productId));

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartError(message: 'Please login to update cart'));
        return;
      }

      final response = await _cartService.updateCartItem(
        productId: event.productId,
        quantity: event.quantity,
        token: token,
      );

      if (response['success']) {
        // Refresh cart after update
        final updatedCart = await _cartService.getCart(token: token);
        emit(CartLoaded(cartSummary: updatedCart));
        // Emit success state after cart is loaded
        emit(CartUpdateSuccess(message: response['message']));
      } else {
        emit(CartError(message: response['message']));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Remove from cart
  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartRemoving(productId: event.productId));

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CartError(message: 'Please login to remove from cart'));
        return;
      }

      final response = await _cartService.removeFromCart(
        productId: event.productId,
        token: token,
      );

      if (response['success']) {
        // Refresh cart after removal
        final updatedCart = await _cartService.getCart(token: token);
        emit(CartLoaded(cartSummary: updatedCart));
        // Emit success state after cart is loaded
        emit(CartRemoveSuccess(message: response['message']));
      } else {
        emit(CartError(message: response['message']));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Clear cart
  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) return;

      final currentState = state;
      if (currentState is CartLoaded) {
        // Show clearing state
        emit(CartLoading());

        // Remove all items one by one
        for (final item in currentState.cartSummary.items) {
          await _cartService.removeFromCart(
            productId: item.productId,
            token: token,
          );
        }

        // Refresh cart
        final updatedCart = await _cartService.getCart(token: token);
        emit(CartLoaded(cartSummary: updatedCart));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _cartUpdateSubscription?.cancel();
    return super.close();
  }
}
