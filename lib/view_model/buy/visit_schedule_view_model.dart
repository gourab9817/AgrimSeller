import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/claimed_listing_model.dart';

class VisitScheduleViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  bool isLoading = false;
  String? errorMessage;
  bool success = false;
  Map<String, dynamic>? _farmerData;
  Map<String, dynamic>? get farmerData => _farmerData;

  VisitScheduleViewModel({required this.userRepository});

  Future<void> scheduleVisit({
    required String farmerId,
    required String buyerId,
    required DateTime claimedDateTime,
    required String listingId,
  }) async {
    isLoading = true;
    errorMessage = null;
    success = false;
    notifyListeners();
    try {
      await userRepository.createClaimedListing(
        farmerId: farmerId,
        buyerId: buyerId,
        claimedDateTime: claimedDateTime,
        listingId: listingId,
      );
      await userRepository.updateCropClaimedStatus(
        listingId: listingId,
        claimed: true,
      );
      _farmerData = await userRepository.fetchFarmerDataById(farmerId);
      success = true;
    } catch (e) {
      errorMessage = e.toString();
      success = false;
    }
    isLoading = false;
    notifyListeners();
  }
}
