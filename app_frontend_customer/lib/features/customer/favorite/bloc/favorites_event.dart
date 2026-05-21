// lib/features/customer/favorites/bloc/favorites_event.dart

import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FetchFavorites extends FavoritesEvent {
  final int page;
  final int limit;

  const FetchFavorites({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class LoadMoreFavorites extends FavoritesEvent {
  const LoadMoreFavorites();
}

class AddToFavorites extends FavoritesEvent {
  final String productId;

  const AddToFavorites({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String productId;

  const RemoveFromFavorites({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ToggleFavorite extends FavoritesEvent {
  final String productId;
  final bool isFavorite;

  const ToggleFavorite({required this.productId, required this.isFavorite});

  @override
  List<Object?> get props => [productId, isFavorite];
}

class RefreshFavorites extends FavoritesEvent {
  const RefreshFavorites();
}

class ClearFavorites extends FavoritesEvent {
  const ClearFavorites();
}