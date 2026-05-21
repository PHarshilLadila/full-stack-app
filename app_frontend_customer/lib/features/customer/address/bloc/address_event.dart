// lib/features/customer/address/bloc/address_event.dart
part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {
  final String token;
  
  const LoadAddresses({required this.token});
  
  @override
  List<Object?> get props => [token];
}

class AddAddress extends AddressEvent {
  final String token;
  final AddressModel address;
  
  const AddAddress({required this.token, required this.address});
  
  @override
  List<Object?> get props => [token, address];
}

class UpdateAddress extends AddressEvent {
  final String token;
  final AddressModel address;
  
  const UpdateAddress({required this.token, required this.address});
  
  @override
  List<Object?> get props => [token, address];
}

class DeleteAddress extends AddressEvent {
  final String token;
  final String addressId;
  
  const DeleteAddress({required this.token, required this.addressId});
  
  @override
  List<Object?> get props => [token, addressId];
}

class SetDefaultAddress extends AddressEvent {
  final String token;
  final AddressModel address;
  
  const SetDefaultAddress({required this.token, required this.address});
  
  @override
  List<Object?> get props => [token, address];
}