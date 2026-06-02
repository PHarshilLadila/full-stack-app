// lib/features/customer/review/bloc/review_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

// Load Product Reviews
class LoadProductReviews extends ReviewEvent {
  final String productId;
  final int page;
  final int limit;
  final int? rating;

  const LoadProductReviews({
    required this.productId,
    this.page = 1,
    this.limit = 10,
    this.rating,
  });

  @override
  List<Object?> get props => [productId, page, limit, rating];
}

// Load More Reviews (Pagination)
class LoadMoreReviews extends ReviewEvent {
  final String productId;

  const LoadMoreReviews({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Filter Reviews by Rating
class FilterReviewsByRating extends ReviewEvent {
  final int? rating;

  const FilterReviewsByRating({this.rating});

  @override
  List<Object?> get props => [rating];
}

// Add Review
class AddReview extends ReviewEvent {
  final String productId;
  final int rating;
  final String comment;
  final List<File>? images;

  const AddReview({
    required this.productId,
    required this.rating,
    required this.comment,
    this.images,
  });

  @override
  List<Object?> get props => [productId, rating, comment, images];
}

// Delete Review
class DeleteReview extends ReviewEvent {
  final String reviewId;

  const DeleteReview({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

// Update Review
class UpdateReview extends ReviewEvent {
  final String reviewId;
  final int rating;
  final String comment;
  final List<String>? existingImages;
  final List<File>? newImages;

  const UpdateReview({
    required this.reviewId,
    required this.rating,
    required this.comment,
    this.existingImages,
    this.newImages,
  });

  @override
  List<Object?> get props => [reviewId, rating, comment, existingImages, newImages];
}

// Clear Review State
class ClearReviewState extends ReviewEvent {}

// Reset Review Form
class ResetReviewForm extends ReviewEvent {}