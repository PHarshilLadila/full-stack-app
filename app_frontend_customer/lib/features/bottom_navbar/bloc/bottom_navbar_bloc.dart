 
import 'package:app_frontend_customer/features/bottom_navbar/bloc/bottom_navbar_event.dart';
import 'package:app_frontend_customer/features/bottom_navbar/bloc/bottom_navbar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationInitial()) {
    on<BottomNavigationItemTapped>((event, emit) {
      emit(BottomNavigationUpdated(event.index));
    });
  }
}