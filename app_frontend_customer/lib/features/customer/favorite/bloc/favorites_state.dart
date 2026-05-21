// lib/features/customer/favorites/bloc/favorites_state.dart

import 'package:app_frontend_customer/features/customer/favorite/model/favorites_model.dart';
import 'package:equatable/equatable.dart';
 
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> favorites;
  final bool hasReachedMax;
  final int currentPage;
  final int totalItems;

  const FavoritesLoaded({
    required this.favorites,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.totalItems = 0,
  });

  FavoritesLoaded copyWith({
    List<FavoriteItem>? favorites,
    bool? hasReachedMax,
    int? currentPage,
    int? totalItems,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [favorites, hasReachedMax, currentPage, totalItems];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ToggleFavoriteLoading extends FavoritesState {
  final String productId;

  const ToggleFavoriteLoading({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ToggleFavoriteSuccess extends FavoritesState {
  final String productId;
  final bool isFavorite;

  const ToggleFavoriteSuccess({required this.productId, required this.isFavorite});

  @override
  List<Object?> get props => [productId, isFavorite];
}

class ToggleFavoriteError extends FavoritesState {
  final String productId;
  final String message;

  const ToggleFavoriteError({required this.productId, required this.message});

  @override
  List<Object?> get props => [productId, message];
}