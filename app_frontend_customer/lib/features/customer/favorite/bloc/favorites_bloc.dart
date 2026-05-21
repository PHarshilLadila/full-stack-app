// lib/features/customer/favorites/bloc/favorites_bloc.dart

import 'dart:developer';
import 'package:app_frontend_customer/features/customer/favorite/bloc/favorites_event.dart';
import 'package:app_frontend_customer/features/customer/favorite/bloc/favorites_state.dart';
import 'package:app_frontend_customer/features/customer/favorite/model/favorites_model.dart';
import 'package:app_frontend_customer/features/customer/favorite/service/favorites_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesService favoritesService;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<FavoriteItem> _allFavorites = [];

  FavoritesBloc({required this.favoritesService}) : super(FavoritesInitial()) {
    on<FetchFavorites>(_onFetchFavorites);
    on<LoadMoreFavorites>(_onLoadMoreFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshFavorites>(_onRefreshFavorites);
    on<ClearFavorites>(_onClearFavorites);
  }

  Future<void> _onFetchFavorites(
    FetchFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());
      log('Fetching favorites - Page: ${event.page}, Limit: ${event.limit}');

      final response = await favoritesService.getFavorites(
        page: event.page,
        limit: event.limit,
      );

      _currentPage = response.pagination?.currentPage ?? 1;
      _hasReachedMax = _currentPage >= (response.pagination?.totalPages ?? 1);
      _allFavorites = response.data;

      emit(
        FavoritesLoaded(
          favorites: response.data,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
          totalItems: response.pagination?.totalItems ?? 0,
        ),
      );

      log('Favorites loaded: ${response.data.length} items');
    } catch (e) {
      log('Fetch favorites error: $e');
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreFavorites(
    LoadMoreFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    if (_hasReachedMax) return;

    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    try {
      final nextPage = _currentPage + 1;
      log('Loading more favorites - Page: $nextPage');

      final response = await favoritesService.getFavorites(
        page: nextPage,
        limit: 20,
      );

      _currentPage = response.pagination?.currentPage ?? _currentPage;
      _hasReachedMax = _currentPage >= (response.pagination?.totalPages ?? 1);
      _allFavorites = [..._allFavorites, ...response.data];

      emit(
        FavoritesLoaded(
          favorites: _allFavorites,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
          totalItems:
              response.pagination?.totalItems ?? currentState.totalItems,
        ),
      );
    } catch (e) {
      log('Load more favorites error: $e');
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(ToggleFavoriteLoading(productId: event.productId));
      log('Adding to favorites: ${event.productId}');

      final response = await favoritesService.addToFavorites(event.productId);

      if (response.success) {
        await _refreshFavorites(emit);
        emit(
          ToggleFavoriteSuccess(productId: event.productId, isFavorite: true),
        );
      } else {
        emit(
          ToggleFavoriteError(
            productId: event.productId,
            message: response.message,
          ),
        );
      }
    } catch (e) {
      log('Add to favorites error: $e');
      emit(
        ToggleFavoriteError(productId: event.productId, message: e.toString()),
      );
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(ToggleFavoriteLoading(productId: event.productId));
      log('Removing from favorites: ${event.productId}');

      final response = await favoritesService.removeFromFavorites(
        event.productId,
      );

      if (response.success) {
        _allFavorites =
            _allFavorites
                .where((item) => item.productId != event.productId)
                .toList();

        if (_allFavorites.isEmpty) {
          emit(
            FavoritesLoaded(
              favorites: [],
              hasReachedMax: true,
              currentPage: 1,
              totalItems: 0,
            ),
          );
        } else {
          emit(
            FavoritesLoaded(
              favorites: _allFavorites,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              totalItems: _allFavorites.length,
            ),
          );
        }

        emit(
          ToggleFavoriteSuccess(productId: event.productId, isFavorite: false),
        );
      } else {
        emit(
          ToggleFavoriteError(
            productId: event.productId,
            message: response.message,
          ),
        );
      }
    } catch (e) {
      log('Remove from favorites error: $e');
      emit(
        ToggleFavoriteError(productId: event.productId, message: e.toString()),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    if (event.isFavorite) {
      add(RemoveFromFavorites(productId: event.productId));
    } else {
      add(AddToFavorites(productId: event.productId));
    }
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;
    add(const FetchFavorites(page: 1));
  }

  void _onClearFavorites(ClearFavorites event, Emitter<FavoritesState> emit) {
    _currentPage = 1;
    _hasReachedMax = false;
    _allFavorites = [];
    emit(FavoritesInitial());
  }

  Future<void> _refreshFavorites(Emitter<FavoritesState> emit) async {
    _currentPage = 1;
    _hasReachedMax = false;

    final response = await favoritesService.getFavorites(page: 1, limit: 20);

    _currentPage = response.pagination?.currentPage ?? 1;
    _hasReachedMax = _currentPage >= (response.pagination?.totalPages ?? 1);
    _allFavorites = response.data;

    emit(
      FavoritesLoaded(
        favorites: _allFavorites,
        hasReachedMax: _hasReachedMax,
        currentPage: _currentPage,
        totalItems: response.pagination?.totalItems ?? 0,
      ),
    );
  }
}
