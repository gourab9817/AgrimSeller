import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';

class VisitSiteViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  bool isLoading = false;
  Map<String, dynamic>? visitSiteData;
  String? errorMessage;
  bool isCancelLoading = false;
  String? cancelError;

  VisitSiteViewModel({required this.userRepository});

  Future<void> fetchVisitSiteData(String claimedId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      visitSiteData = await userRepository.fetchVisitSiteData(claimedId);
      if (visitSiteData == null) {
        errorMessage = 'No data found for this visit.';
      }
    } catch (e) {
      errorMessage = 'Failed to fetch visit data.';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelVisit(String claimedId) async {
    isCancelLoading = true;
    cancelError = null;
    notifyListeners();
    try {
      await userRepository.cancelVisitAndClaim(claimedId);
      isCancelLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      cancelError = 'Failed to cancel visit: $e';
      isCancelLoading = false;
      notifyListeners();
      return false;
    }
  }
} 