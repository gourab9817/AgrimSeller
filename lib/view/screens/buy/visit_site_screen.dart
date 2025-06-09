import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../view/widgets/appbar/navbar.dart';
import '../../../view_model/buy/visit_site_view_model.dart';
import 'visit_site_reschedule_screen.dart';
import '../../../view/widgets/popup/universal_confirmation_dialog.dart';
import '../../../core/constants/app_assets.dart';

class VisitSiteScreen extends StatelessWidget {
  final String claimedId;
  const VisitSiteScreen({Key? key, required this.claimedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VisitSiteViewModel(userRepository: Provider.of(context, listen: false))..fetchVisitSiteData(claimedId),
      child: _VisitSiteBody(claimedId: claimedId),
    );
  }
}

class _VisitSiteBody extends StatelessWidget {
  final String claimedId;
  const _VisitSiteBody({Key? key, required this.claimedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VisitSiteViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    final data = viewModel.visitSiteData;
    final isLoading = viewModel.isLoading;
    final error = viewModel.errorMessage;

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
        child: isLoading
            ? const CircularProgressIndicator(color: AppColors.orange)
            : error != null
                ? Text(error, style: AppTextStyle.bold16.copyWith(color: AppColors.error))
                : data == null
                    ? const SizedBox.shrink()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await viewModel.fetchVisitSiteData(claimedId);
                        },
        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                              child: _VisitSiteDetails(data: data),
                            ),
                          ),
                        ),
                      ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}

class _VisitSiteDetails extends StatelessWidget {
  final Map<String, dynamic> data;
  const _VisitSiteDetails({required this.data});

  @override
  Widget build(BuildContext context) {
    final crop = data['crop'] ?? {};
    final farmer = data['farmer'] ?? {};
    final claimed = data['claimed'] ?? {};
    final viewModel = Provider.of<VisitSiteViewModel>(context);
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                crop['imagePath'] ?? '',
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
                      Text('${crop['quantity'] ?? '-'} quintals', style: AppTextStyle.medium14.copyWith(color: AppColors.brown)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Agreed Price: ', style: AppTextStyle.medium14.copyWith(color: AppColors.success)),
                      Text('₹${crop['price'] ?? '-'} /quintal', style: AppTextStyle.medium14.copyWith(color: AppColors.success)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Quality indicator: ', style: AppTextStyle.medium14.copyWith(color: AppColors.grey)),
                      Text(crop['qualityIndicator'] ?? '-', style: AppTextStyle.medium14.copyWith(color: AppColors.brown)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Claimed Date: ', style: AppTextStyle.medium14.copyWith(color: AppColors.error)),
                      Text((claimed['claimedDateTime'] ?? '').toString().split('T').first, style: AppTextStyle.medium14.copyWith(color: AppColors.error)),
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
            (crop['name'] ?? '-').toString().toUpperCase(),
                      style: AppTextStyle.bold20.copyWith(color: AppColors.brown),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildLabel('Visit Date & Time :'),
        _buildReadOnlyField(claimed['visitDateTime'] ?? '-'),
                  const SizedBox(height: 12),
        _buildLabel("Farmer's Contact :"),
        _buildReadOnlyField(farmer['phoneNumber'] ?? '-'),
                  const SizedBox(height: 12),
        _buildLabel("Farmer's Name :"),
        _buildReadOnlyField(farmer['name'] ?? '-'),
                  const SizedBox(height: 12),
        _buildLabel("Farmer's Address :"),
        _buildReadOnlyField(farmer['address'] ?? '-'),
                  const SizedBox(height: 12),
        _buildLabel('Meeting Location :'),
        _buildReadOnlyField(claimed['location'] ?? '-'),
                  const SizedBox(height: 24),
                  Row(
          mainAxisAlignment: MainAxisAlignment.center,
                    children: [
            SizedBox(
              width: 180,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.lightOrange,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => UniversalConfirmationDialog(
                      animationAsset: AppAssets.exclamation,
                      message: 'Are you sure to reschedule the visit?',
                      yesText: 'Yes',
                      noText: 'No',
                      onYes: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VisitSiteRescheduleScreen(claimedId: data['claimed']['id']),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Text('Visit Reschedule', style: AppTextStyle.bold18.copyWith(color: AppColors.orange)),
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                onPressed: () {
                  // TODO: Implement 'I am on Site' logic
                },
                child: Text('I am on Site', style: AppTextStyle.bold18.copyWith(color: AppColors.white)),
                        ),
                      ),
                    ],
                  ),
        const SizedBox(height: 40),
                  Center(
          child: SizedBox(
            width: 260,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error, width: 1.2),
                        shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: viewModel.isCancelLoading
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (ctx) => UniversalConfirmationDialog(
                          animationAsset: AppAssets.exclamation,
                          message: 'Are you really want to cancel your claim and visit?',
                          yesText: 'Yes',
                          noText: 'No',
                          onYes: () async {
                            final claimedId = data['claimed']['id'];
                            final success = await viewModel.cancelVisit(claimedId);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Visit and claim cancelled.'), backgroundColor: AppColors.success),
                              );
                              Navigator.of(context).pop();
                            } else if (viewModel.cancelError != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(viewModel.cancelError!), backgroundColor: AppColors.error),
                              );
                            }
                          },
                        ),
                      );
                    },
              child: Text('Cancel visit', style: AppTextStyle.bold18.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ],
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