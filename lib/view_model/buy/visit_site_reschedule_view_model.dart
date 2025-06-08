import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';

class VisitSiteRescheduleViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  String? errorMessage;
  String? claimedId;
  final UserRepository userRepository;

  VisitSiteRescheduleViewModel({required this.userRepository});

  void init(String claimedId) {
    this.claimedId = claimedId;
  }

  Future<void> rescheduleVisit(DateTime newDateTime, String newLocation) async {
    if (claimedId == null) return;
    isLoading = true;
    errorMessage = null;
    success = false;
    notifyListeners();
    try {
      await userRepository.updateClaimedVisitStatusAndRescheduleCount(
        claimedId: claimedId!,
        visitStatus: 'Rescheduled and Pending',
        incrementReschedule: true,
        newVisitDateTime: newDateTime.toIso8601String(),
        newLocation: newLocation,
      );
      success = true;
    } catch (e) {
      errorMessage = 'Failed to update visit: $e';
      success = false;
    }
    isLoading = false;
    notifyListeners();
  }
} 