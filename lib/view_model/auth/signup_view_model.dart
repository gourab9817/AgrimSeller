import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/auth_exception.dart';

class SignupViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  SignupViewModel({required this.userRepository});

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String address,
    required String idNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await userRepository.signUp(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        idNumber: idNumber,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }
}