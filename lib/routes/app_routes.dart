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
import '../view/screens/buy/buy_screen.dart';
import '../view/screens/buy/claim_listing_screen.dart';
import '../data/models/listing_model.dart';
import '../view/screens/buy/visit_schedule_screen.dart';
import '../view/screens/buy/visit_site_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String profile = '/profile';
  static const String buy = '/buy';
  static const String claimListing = '/claim-listing';
  static const String visitSchedule = '/visit-schedule';
  static const String visitSite = '/visit-site';

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
      case buy:
        return MaterialPageRoute(
          builder: (context) => const BuyScreen(),
        );
      case claimListing:
        final args = settings.arguments as ListingModel;
        return MaterialPageRoute(
          builder: (_) => ClaimListingScreen(listing: args),
        );
      case visitSchedule:
        final args = settings.arguments as ListingModel;
        return MaterialPageRoute(
          builder: (_) => VisitScheduleScreen(listing: args),
        );
      case visitSite:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VisitSiteScreen(claimedId: args),
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
