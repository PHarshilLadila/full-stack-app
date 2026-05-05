import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      emit(SplashLoading());
      
      // First, check API connection
      await _checkApiConnection(emit);
      
      // Then check authentication status
      await _checkAuthStatus(emit);
    });
  }
  
  Future<void> _checkApiConnection(Emitter<SplashState> emit) async {
    try {
      final response = await http.get(
        Uri.parse("https://full-stack-app-4vxu.onrender.com/"),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(SplashApiSuccess(data['message'] ?? 'API Working'));
      } else {
        emit(SplashApiError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      log("API Connection Error: $e");
      emit(SplashApiError('Unable to connect to server'));
    }
    
    // Wait for 2 seconds so user can see the splash
    await Future.delayed(const Duration(milliseconds: 1500));
  }
  
  Future<void> _checkAuthStatus(Emitter<SplashState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}