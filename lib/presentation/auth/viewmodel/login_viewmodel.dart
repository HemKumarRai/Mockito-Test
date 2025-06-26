import 'package:flutter/material.dart';

import '../../../app/app_constants.dart'; // Access hardcoded credentials

class LoginViewModel extends ChangeNotifier {
  // State variables for username, password, and loading status
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage; // To store error messages during login

  // Getters for accessing state from the UI
  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Setters for updating username and password
  void setUsername(String value) {
    _username = value;
    _errorMessage = null; // Clear error message on input change
    notifyListeners(); // Notify listeners to rebuild UI
  }

  void setPassword(String value) {
    _password = value;
    _errorMessage = null; // Clear error message on input change
    notifyListeners(); // Notify listeners to rebuild UI
  }

  void setLoading(bool val){
    _isLoading = val;
  }

  // Login logic
  Future<bool> login() async {
    setLoading(true); // Set loading state to true
    _errorMessage = null; // Clear any previous error messages
    notifyListeners(); // Notify listeners to show loading indicator

    // Simulate a network request delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if entered credentials match the hardcoded valid credentials
    if (_username == AppConstants.validUsername && _password == AppConstants.validPassword) {
      setLoading(false); // Set loading state to false
      notifyListeners(); // Notify listeners to hide loading indicator
      return true; // Login successful
    } else {
      _errorMessage = 'Invalid username or password.'; // Set error message
      setLoading(false); // Set loading state to false
      notifyListeners(); // Notify listeners to hide loading and show error
      return false; // Login failed
    }
  }
}