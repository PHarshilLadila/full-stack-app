// lib/features/customer/customer_web/customer_web_home/bloc/flash_deals/flash_deals_event.dart
import 'package:equatable/equatable.dart';

abstract class FlashDealsEvent extends Equatable {
  const FlashDealsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFlashDeals extends FlashDealsEvent {
  const LoadFlashDeals();
}