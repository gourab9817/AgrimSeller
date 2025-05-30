import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view/screens/splash/splash_screen.dart';
import '../view/screens/dashboard/dashboard_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/signup_screen.dart';
import '../view/screens/auth/forgot_password_screen.dart';
import '../view/screens/auth/email_verification_screen.dart';
import '../view/screens/profile/profile_screen.dart';
import '../view_model/profile/profile_view_model.dart';
import '../data/repositories/user_repository.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case dashboard:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ProfileViewModel(
              userRepository: Provider.of<UserRepository>(context, listen: false),
            ),
            child: const DashboardScreen(),
          ),
        );
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case emailVerification:
        return MaterialPageRoute(builder: (_) => const EmailVerificationScreen());
      case profile:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ProfileViewModel(
              userRepository: Provider.of<UserRepository>(context, listen: false),
            ),
            child: const ProfileScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
