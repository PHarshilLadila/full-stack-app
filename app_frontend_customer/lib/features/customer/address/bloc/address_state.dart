// lib/features/customer/address/bloc/address_state.dart
part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();
  
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressesLoaded extends AddressState {
  final List<AddressModel> addresses;
  
  const AddressesLoaded({required this.addresses});
  
  @override
  List<Object?> get props => [addresses];
}

class AddressAdded extends AddressState {
  final String message;
  
  const AddressAdded({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class AddressUpdated extends AddressState {
  final String message;
  
  const AddressUpdated({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class AddressDeleted extends AddressState {
  final String message;
  
  const AddressDeleted({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class AddressError extends AddressState {
  final String error;
  
  const AddressError({required this.error});
  
  @override
  List<Object?> get props => [error];
}