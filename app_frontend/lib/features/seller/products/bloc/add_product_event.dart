abstract class AddProductEvent {}

class SubmitProductEvent extends AddProductEvent {
  final Map<String, dynamic> body;

  SubmitProductEvent(this.body);
}