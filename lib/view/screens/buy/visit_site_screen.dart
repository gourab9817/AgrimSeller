import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/models/listing_model.dart';
import 'package:provider/provider.dart';
import '../../../view_model/buy/visit_site_view_model.dart';
import '../../widgets/appbar/navbar.dart';

class VisitSiteScreen extends StatelessWidget {
  final ListingModel listing;
  final String visitDateTime;
  final String contact;
  final String name;
  final String address;
  final String location;
  const VisitSiteScreen({
    Key? key,
    required this.listing,
    required this.visitDateTime,
    required this.contact,
    required this.name,
    required this.address,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitSiteVM = Provider.of<VisitSiteViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Visit Site', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width > 500 ? 400 : width * 0.95,
              minWidth: 280,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          listing.imagePath,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Quantity: ', style: AppTextStyle.medium14.copyWith(color: AppColors.grey)),
                                Text('${listing.quantity} quintals', style: AppTextStyle.medium14.copyWith(color: AppColors.brown)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Agreed Price: ', style: AppTextStyle.medium14.copyWith(color: AppColors.success)),
                                Text('₹${listing.price}/quintal', style: AppTextStyle.medium14.copyWith(color: AppColors.success)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Quality indicator: ', style: AppTextStyle.medium14.copyWith(color: AppColors.grey)),
                                Text(listing.qualityIndicator, style: AppTextStyle.medium14.copyWith(color: AppColors.brown)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Claimed Date: ', style: AppTextStyle.medium14.copyWith(color: AppColors.error)),
                                Text(listing.listingDate, style: AppTextStyle.medium14.copyWith(color: AppColors.error)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      listing.name.toUpperCase(),
                      style: AppTextStyle.bold20.copyWith(color: AppColors.brown),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildLabel('Visit Date & Time :'),
                  _buildReadOnlyField(visitDateTime),
                  const SizedBox(height: 12),
                  _buildLabel('Your Contact :'),
                  _buildReadOnlyField(contact),
                  const SizedBox(height: 12),
                  _buildLabel('Your Name :'),
                  _buildReadOnlyField(name),
                  const SizedBox(height: 12),
                  _buildLabel('Your Address :'),
                  _buildReadOnlyField(address),
                  const SizedBox(height: 12),
                  _buildLabel('Location :'),
                  _buildReadOnlyField(location),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.originalOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: visitSiteVM.isOnSiteLoading ? null : () => visitSiteVM.markOnSite(listing),
                          child: visitSiteVM.isOnSiteLoading
                              ? const CircularProgressIndicator(color: AppColors.brown)
                              : Text('I am on Site', style: AppTextStyle.bold16.copyWith(color: AppColors.brown)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.success, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: visitSiteVM.isCancelLoading ? null : () => visitSiteVM.cancelVisit(listing),
                      child: visitSiteVM.isCancelLoading
                          ? const CircularProgressIndicator(color: AppColors.brown)
                          : Text('Cancel visit', style: AppTextStyle.bold16.copyWith(color: AppColors.success)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(text, style: AppTextStyle.medium14.copyWith(color: AppColors.brown)),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      style: AppTextStyle.regular16.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
