// lib/features/customer/customer_web/navigation/navigation_manager.dart
import 'package:flutter/material.dart';

enum AppPage {
  home,
  productDetails,
  categoryProducts,
  allCategories,
  wishlist,
  cart,
  account,
}

class NavigationManager extends ChangeNotifier {
  AppPage _currentPage = AppPage.home;
  Map<String, dynamic>? _pageArguments;
  
  // Navigation stack for back button support
  final List<MapEntry<AppPage, Map<String, dynamic>?>> _navigationStack = [];

  AppPage get currentPage => _currentPage;
  Map<String, dynamic>? get pageArguments => _pageArguments;

  void navigateTo(AppPage page, {Map<String, dynamic>? arguments}) {
    // Push to stack for back navigation
    _navigationStack.add(MapEntry(_currentPage, _pageArguments));
    
    _currentPage = page;
    _pageArguments = arguments;
    notifyListeners();
  }

  void goBack() {
    if (_navigationStack.isNotEmpty) {
      final previous = _navigationStack.removeLast();
      _currentPage = previous.key;
      _pageArguments = previous.value;
      notifyListeners();
    }
  }

  bool get canGoBack => _navigationStack.isNotEmpty;

  void clearStack() {
    _navigationStack.clear();
  }

  void resetToHome() {
    _navigationStack.clear();
    _currentPage = AppPage.home;
    _pageArguments = null;
    notifyListeners();
  }
}