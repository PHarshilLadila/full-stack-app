// lib/features/customer/address/bloc/address_bloc.dart
import 'dart:async';
import 'package:app_frontend_customer/features/customer/address/model/address_model.dart';
import 'package:app_frontend_customer/features/customer/address/service/address_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart'; 

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressService addressService;

  AddressBloc({required this.addressService}) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await addressService.getAddresses(event.token);
      emit(AddressesLoaded(addresses: addresses));
    } catch (e) {
      emit(AddressError(error: e.toString()));
    }
  }

  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final response = await addressService.addAddress(
        event.token,
        event.address,
      );
      emit(AddressAdded(message: response['message'] ?? 'Address added successfully'));
      // Reload addresses after add
      add(LoadAddresses(token: event.token));
    } catch (e) {
      emit(AddressError(error: e.toString()));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final response = await addressService.updateAddress(
        event.token,
        event.address,
      );
      emit(AddressUpdated(message: response['message'] ?? 'Address updated successfully'));
      // Reload addresses after update
      add(LoadAddresses(token: event.token));
    } catch (e) {
      emit(AddressError(error: e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final response = await addressService.deleteAddress(
        event.token,
        event.addressId,
      );
      emit(AddressDeleted(message: response['message'] ?? 'Address deleted successfully'));
      // Reload addresses after delete
      add(LoadAddresses(token: event.token));
    } catch (e) {
      emit(AddressError(error: e.toString()));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final updatedAddress = event.address.copyWith(isDefault: true);
      final response = await addressService.updateAddress(
        event.token,
        updatedAddress,
      );
      emit(AddressUpdated(message: response['message'] ?? 'Default address updated'));
      // Reload addresses after update
      add(LoadAddresses(token: event.token));
    } catch (e) {
      emit(AddressError(error: e.toString()));
    }
  }
}