import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../data/services/local_storage_service.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> initializeApp(BuildContext context) async {
    try {
      // Add your initialization logic here
      // For example:
      // - Check user authentication
      // - Load necessary data
      // - Initialize services
      
      // Simulate some loading time
      await Future.delayed(const Duration(seconds: 2));
      
      _isInitialized = true;
      notifyListeners();

      // Check if user is logged in
      final user = await _localStorageService.getUserData();
      if (context.mounted) {
        if (user != null) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      debugPrint('Error initializing app: $e');
      // Handle initialization error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize app. Please try again.'),
          ),
        );
      }
    }
  }
} 