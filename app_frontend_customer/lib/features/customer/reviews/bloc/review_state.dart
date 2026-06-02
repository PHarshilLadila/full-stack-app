// lib/features/customer/review/bloc/review_state.dart
import 'package:equatable/equatable.dart';
import '../model/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

// Initial State
class ReviewInitial extends ReviewState {}

// Loading States
class ReviewsLoading extends ReviewState {}

class AddingReview extends ReviewState {}

class DeletingReview extends ReviewState {}

class UpdatingReview extends ReviewState {}

// Loaded State
class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  final ReviewData reviewData;
  final int currentPage;
  final bool hasMore;

  const ReviewsLoaded({
    required this.reviews,
    required this.reviewData,
    this.currentPage = 1,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [reviews, reviewData, currentPage, hasMore];
}

// Add Review States
class ReviewAdded extends ReviewState {
  final AddReviewResponse response;

  const ReviewAdded(this.response);

  @override
  List<Object?> get props => [response];
}

// Delete Review States
class ReviewDeleted extends ReviewState {
  final String reviewId;

  const ReviewDeleted(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

// Update Review States
class ReviewUpdated extends ReviewState {
  final ReviewModel review;

  const ReviewUpdated(this.review);

  @override
  List<Object?> get props => [review];
}

// Error States
class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}

// Operation Success States
class AddReviewSuccess extends ReviewState {
  final String message;

  const AddReviewSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteReviewSuccess extends ReviewState {
  final String message;

  const DeleteReviewSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateReviewSuccess extends ReviewState {
  final String message;

  const UpdateReviewSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
