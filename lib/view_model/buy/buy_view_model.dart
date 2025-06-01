import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';

class BuyViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  List<Map<String, dynamic>> listings = [];
  List<Map<String, dynamic>> filteredListings = [];
  bool isLoading = false;
  int selectedTab = 0;
  String searchQuery = '';
  String selectedType = '';
  String selectedLocation = '';

  BuyViewModel({required this.userRepository});

  Future<void> fetchListings() async {
    isLoading = true;
    notifyListeners();
    try {
      listings = await userRepository.fetchListedCrops();
      applyFilters();
    } catch (e) {
      listings = [];
      filteredListings = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void setTab(int tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query.toLowerCase();
    applyFilters();
  }

  void setTypeFilter(String type) {
    selectedType = type;
    applyFilters();
  }

  void setLocationFilter(String location) {
    selectedLocation = location;
    applyFilters();
  }

  void clearFilters() {
    searchQuery = '';
    selectedType = '';
    selectedLocation = '';
    applyFilters();
  }

  void applyFilters() {
    filteredListings = listings.where((listing) {
      final name = (listing['name'] ?? '').toString().toLowerCase();
      final type = (listing['type'] ?? '').toString().toLowerCase();
      final location = (listing['location'] ?? '').toString().toLowerCase();

      bool matchesSearch = searchQuery.isEmpty || 
          name.contains(searchQuery) ||
          type.contains(searchQuery) ||
          location.contains(searchQuery);

      bool matchesType = selectedType.isEmpty || type == selectedType.toLowerCase();
      bool matchesLocation = selectedLocation.isEmpty || location == selectedLocation.toLowerCase();

      return matchesSearch && matchesType && matchesLocation;
    }).toList();
    
    notifyListeners();
  }

  List<String> get uniqueTypes {
    return listings
        .map((listing) => (listing['type'] ?? '').toString())
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
  }

  List<String> get uniqueLocations {
    return listings
        .map((listing) => (listing['location'] ?? '').toString())
        .where((location) => location.isNotEmpty)
        .toSet()
        .toList();
  }
} 