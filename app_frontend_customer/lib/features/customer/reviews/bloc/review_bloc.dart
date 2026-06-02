// lib/features/customer/review/bloc/review_bloc.dart
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/review_model.dart';
import '../service/review_service.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewService _reviewService;

  ReviewBloc({required ReviewService reviewService})
    : _reviewService = reviewService,
      super(ReviewInitial()) {
    on<LoadProductReviews>(_onLoadProductReviews);
    on<LoadMoreReviews>(_onLoadMoreReviews);
    on<FilterReviewsByRating>(_onFilterReviewsByRating);
    on<AddReview>(_onAddReview);
    on<DeleteReview>(_onDeleteReview);
    on<UpdateReview>(_onUpdateReview);
    on<ClearReviewState>(_onClearReviewState);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviews event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      emit(ReviewsLoading());

      final response = await _reviewService.getProductReviews(
        productId: event.productId,
        page: event.page,
        limit: event.limit,
        rating: event.rating,
      );

      if (response.success && response.data != null) {
        emit(
          ReviewsLoaded(
            reviews: response.data!.reviews,
            reviewData: response.data!,
            currentPage: event.page,
            hasMore: event.page < response.data!.pagination.totalPages,
          ),
        );
      } else if (!response.success) {
        emit(ReviewError(response.message));
      } else {
        emit(ReviewError('No data received'));
      }
    } catch (e) {
      log('Error loading reviews: $e');
      emit(ReviewError('Failed to load reviews: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreReviews(
    LoadMoreReviews event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewsLoaded) return;

    final currentState = state as ReviewsLoaded;
    if (!currentState.hasMore) return;

    final nextPage = currentState.currentPage + 1;

    try {
      final response = await _reviewService.getProductReviews(
        productId: event.productId,
        page: nextPage,
        limit: 10,
      );

      if (response.success && response.data != null) {
        final allReviews = [...currentState.reviews, ...response.data!.reviews];
        emit(
          ReviewsLoaded(
            reviews: allReviews,
            reviewData: ReviewData(
              productId: currentState.reviewData.productId,
              productName: currentState.reviewData.productName,
              averageRating: currentState.reviewData.averageRating,
              totalReviews: currentState.reviewData.totalReviews,
              ratingDistribution: currentState.reviewData.ratingDistribution,
              reviews: allReviews,
              pagination: response.data!.pagination,
            ),
            currentPage: nextPage,
            hasMore: nextPage < response.data!.pagination.totalPages,
          ),
        );
      }
    } catch (e) {
      log('Error loading more reviews: $e');
      emit(ReviewError('Failed to load more reviews: ${e.toString()}'));
    }
  }

  Future<void> _onFilterReviewsByRating(
    FilterReviewsByRating event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewsLoaded) return;

    final currentState = state as ReviewsLoaded;

    try {
      emit(ReviewsLoading());

      final response = await _reviewService.getProductReviews(
        productId: currentState.reviewData.productId,
        page: 1,
        limit: 10,
        rating: event.rating,
      );

      if (response.success && response.data != null) {
        emit(
          ReviewsLoaded(
            reviews: response.data!.reviews,
            reviewData: response.data!,
            currentPage: 1,
            hasMore: 1 < response.data!.pagination.totalPages,
          ),
        );
      } else {
        emit(ReviewError(response.message));
      }
    } catch (e) {
      log('Error filtering reviews: $e');
      emit(ReviewError('Failed to filter reviews: ${e.toString()}'));
    }
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    try {
      emit(AddingReview());

      final token = await _getToken();
      if (token == null) {
        emit(const ReviewError('Please login to add review'));
        return;
      }

      final response = await _reviewService.addReview(
        productId: event.productId,
        rating: event.rating,
        comment: event.comment,
        token: token,
        images: event.images,
      );

      if (response.success) {
        emit(AddReviewSuccess(response.message));
        // Reload reviews after adding
        add(LoadProductReviews(productId: event.productId));
      } else {
        emit(ReviewError(response.message));
      }
    } catch (e) {
      log('Error adding review: $e');
      emit(ReviewError('Failed to add review: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      emit(DeletingReview());

      final token = await _getToken();
      if (token == null) {
        emit(const ReviewError('Please login to delete review'));
        return;
      }

      final response = await _reviewService.deleteReview(
        reviewId: event.reviewId,
        token: token,
      );

      if (response['success'] == true) {
        emit(
          DeleteReviewSuccess(
            response['message'] ?? 'Review deleted successfully',
          ),
        );
        // Reload reviews after deletion if we have a productId
        if (state is ReviewsLoaded) {
          final currentState = state as ReviewsLoaded;
          add(LoadProductReviews(productId: currentState.reviewData.productId));
        }
      } else {
        emit(ReviewError(response['message'] ?? 'Failed to delete review'));
      }
    } catch (e) {
      log('Error deleting review: $e');
      emit(ReviewError('Failed to delete review: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateReview(
    UpdateReview event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      emit(UpdatingReview());

      final token = await _getToken();
      if (token == null) {
        emit(const ReviewError('Please login to update review'));
        return;
      }

      final response = await _reviewService.updateReview(
        reviewId: event.reviewId,
        rating: event.rating,
        comment: event.comment,
        token: token,
        existingImages: event.existingImages,
        newImages: event.newImages,
      );

      if (response['success'] == true) {
        emit(
          UpdateReviewSuccess(
            response['message'] ?? 'Review updated successfully',
          ),
        );
        // Reload reviews after update
        if (state is ReviewsLoaded) {
          final currentState = state as ReviewsLoaded;
          add(LoadProductReviews(productId: currentState.reviewData.productId));
        }
      } else {
        emit(ReviewError(response['message'] ?? 'Failed to update review'));
      }
    } catch (e) {
      log('Error updating review: $e');
      emit(ReviewError('Failed to update review: ${e.toString()}'));
    }
  }

  void _onClearReviewState(ClearReviewState event, Emitter<ReviewState> emit) {
    emit(ReviewInitial());
  }
}
