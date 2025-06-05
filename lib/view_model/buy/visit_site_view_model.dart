import 'package:flutter/material.dart';
import '../../data/models/listing_model.dart';

class VisitSiteViewModel extends ChangeNotifier {
  bool isOnSiteLoading = false;
  bool isCancelLoading = false;

  Future<void> markOnSite(ListingModel listing) async {
    isOnSiteLoading = true;
    notifyListeners();
    // TODO: Add Firestore/repo logic to mark as on site
    await Future.delayed(const Duration(seconds: 1));
    isOnSiteLoading = false;
    notifyListeners();
    // TODO: Show confirmation/snackbar
  }

  Future<void> cancelVisit(ListingModel listing) async {
    isCancelLoading = true;
    notifyListeners();
    // TODO: Add Firestore/repo logic to cancel the visit
    await Future.delayed(const Duration(seconds: 1));
    isCancelLoading = false;
    notifyListeners();
    // TODO: Show confirmation/snackbar
  }
}
