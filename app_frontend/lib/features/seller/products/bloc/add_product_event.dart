import 'dart:io';

abstract class AddProductEvent {}

class SubmitProductEvent extends AddProductEvent {
  final Map<String, dynamic> body;
  SubmitProductEvent(this.body);
}

class SubmitProductWithImagesEvent extends AddProductEvent {
  final Map<String, dynamic> body;
  final File mainBannerImage;
  final List<File> multipleImages;

  SubmitProductWithImagesEvent({
    required this.body,
    required this.mainBannerImage,
    required this.multipleImages,
  });
}