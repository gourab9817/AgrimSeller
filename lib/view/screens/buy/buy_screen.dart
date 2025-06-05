import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buy/listing_card.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../routes/app_routes.dart';
import '../../../view/widgets/appbar/navbar.dart';
import '../../../view_model/buy/buy_view_model.dart';
import '../../../data/models/listing_model.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuyViewModel(userRepository: Provider.of(context, listen: false))..fetchListings(),
      child: const _BuyScreenBody(),
    );
  }
}

class _BuyScreenBody extends StatelessWidget {
  const _BuyScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BuyViewModel>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.brown),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Buy', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: AppColors.orange,
            unselectedLabelColor: AppColors.brown,
            indicatorColor: AppColors.orange,
            tabs: [
              Tab(text: 'Listed Crops'),
              Tab(text: 'Claimed Crops'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search crops...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.brown),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.brown),
                            onPressed: () => viewModel.setSearchQuery(''),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Filter chips
              Row(
                children: [
                  _FilterChip(
                    label: 'Types',
                    selected: viewModel.selectedType.isNotEmpty,
                    onTap: () => _showFilterDialog(
                      context,
                      'Select Type',
                      viewModel.uniqueTypes,
                      viewModel.selectedType,
                      (type) => viewModel.setTypeFilter(type),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Location',
                    selected: viewModel.selectedLocation.isNotEmpty,
                    onTap: () => _showFilterDialog(
                      context,
                      'Select Location',
                      viewModel.uniqueLocations,
                      viewModel.selectedLocation,
                      (location) => viewModel.setLocationFilter(location),
                    ),
                  ),
                  if (viewModel.selectedType.isNotEmpty || viewModel.selectedLocation.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: 'Clear',
                        selected: false,
                        onTap: viewModel.clearFilters,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Listings
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.orange));
                    } else if (viewModel.filteredListings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/agritech-fbd5e.appspot.com/o/crops%2Fno_data_found.png?alt=media',
                              width: 120,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            const Text('No listings found', style: TextStyle(color: AppColors.brown)),
                          ],
                        ),
                      );
                    } else {
                      final openListings = viewModel.filteredListings.where((crop) => crop['claimed'] != true).toList();
                      final claimedListings = viewModel.filteredListings.where((crop) => crop['claimed'] == true).toList();
                      return TabBarView(
                        children: [
                          // Tab 1: Listed Crops
                          RefreshIndicator(
                            onRefresh: () async {
                              await viewModel.fetchListings();
                            },
                            child: ListView.builder(
                              itemCount: openListings.length,
                              itemBuilder: (context, index) {
                                final crop = openListings[index];
                                final listing = ListingModel.fromMap(crop);
                                return ListingCard(
                                  imageUrl: crop['imagePath'] ?? '',
                                  cropName: crop['name'] ?? '-',
                                  location: crop['location'] ?? '-',
                                  quantity: (crop['quantity']?.toString() ?? '-') + ' Kg',
                                  listingDate: crop['listedDate']?.toString().split(' ').first ?? '-',
                                  onClaim: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.claimListing,
                                      arguments: listing,
                                    );
                                  },
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.claimListing,
                                      arguments: listing,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          // Tab 2: Claimed Crops
                          RefreshIndicator(
                            onRefresh: () async {
                              await viewModel.fetchListings();
                            },
                            child: ListView.builder(
                              itemCount: claimedListings.length,
                              itemBuilder: (context, index) {
                                final crop = claimedListings[index];
                                final listing = ListingModel.fromMap(crop);
                                return ListingCard(
                                  imageUrl: crop['imagePath'] ?? '',
                                  cropName: crop['name'] ?? '-',
                                  location: crop['location'] ?? '-',
                                  quantity: (crop['quantity']?.toString() ?? '-') + ' Kg',
                                  listingDate: crop['listedDate']?.toString().split(' ').first ?? '-',
                                  onClaim: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.visitSite,
                                      arguments: {
                                        'listing': listing,
                                        'visitDateTime': crop['visitDateTime']?.toString() ?? '3/3/2025, 10 am',
                                        'contact': crop['contact']?.toString() ?? '+91 9988776655',
                                        'name': crop['name']?.toString() ?? 'Rakesh Kumar',
                                        'address': crop['address']?.toString() ?? 'Jaipur, Rajasthan, India',
                                        'location': crop['location']?.toString() ?? 'Rampura, Jaipur, Rajasthan 302012, India',
                                      },
                                    );
                                  },
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.visitSite,
                                      arguments: {
                                        'listing': listing,
                                        'visitDateTime': crop['visitDateTime']?.toString() ?? '3/3/2025, 10 am',
                                        'contact': crop['contact']?.toString() ?? '+91 9988776655',
                                        'name': crop['name']?.toString() ?? 'Rakesh Kumar',
                                        'address': crop['address']?.toString() ?? 'Jaipur, Rajasthan, India',
                                        'location': crop['location']?.toString() ?? 'Rampura, Jaipur, Rajasthan 302012, India',
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }

  void _showFilterDialog(
    BuildContext context,
    String title,
    List<String> options,
    String selectedOption,
    Function(String) onSelect,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...options.map(
                (option) => ListTile(
                  title: Text(option),
                  trailing: option == selectedOption
                      ? const Icon(Icons.check, color: AppColors.orange)
                      : null,
                  onTap: () {
                    onSelect(option);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.selected, required this.onTap, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.brown : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              decoration: selected ? TextDecoration.underline : TextDecoration.none,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.orange : AppColors.brown,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: selected ? AppColors.orange : AppColors.brown,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
} 