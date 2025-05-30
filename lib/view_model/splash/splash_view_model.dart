import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

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

      // Navigate to the DashboardScreen
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
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