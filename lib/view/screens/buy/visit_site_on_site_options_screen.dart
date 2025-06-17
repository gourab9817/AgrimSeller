import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/app_assets.dart';
import '../../../view/widgets/Button/app_button.dart';
import '../../../view/widgets/popup/custom_notification.dart';
import '../../../routes/app_routes.dart';

class VisitSiteOnSiteOptionsScreen extends StatelessWidget {
  final String claimedId;
  const VisitSiteOnSiteOptionsScreen({Key? key, required this.claimedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('On Site Actions', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightOrange, AppColors.background],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? 700 : width * 0.98,
                minWidth: 280,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'What would you like to do on site?',
                    style: AppTextStyle.bold24.copyWith(color: AppColors.brown),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardSize = isWide ? 200.0 : (constraints.maxWidth - 32) / 2;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ResponsiveOptionCard(
                                imagePath: AppAssets.Feature_pred,
                                label: "Crop Analysis",
                                color: AppColors.orange,
                                cardSize: cardSize,
                                onTap: () {
                                  // TODO: Navigate to Crop Analysis
                                },
                              ),
                              const SizedBox(width: 24),
                              _ResponsiveOptionCard(
                                imagePath: AppAssets.Price,
                                label: "Price Prediction",
                                color: AppColors.success,
                                cardSize: cardSize,
                                onTap: () {
                                  CustomNotification.showComingSoon(
                                    context: context,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          Center(
                            child: Text(
                              'Lets proceed with the Deal finalization',
                              style: AppTextStyle.bold18.copyWith(color: AppColors.brown),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: SizedBox(
                              width: isWide ? 340 : double.infinity,
                              child: BasicAppButton(
                                title: 'Finalize deal',
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.finalDeal,
                                    arguments: claimedId,
                                  );
                                },
                                height: 56,
                                backgroundColor: AppColors.orange,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponsiveOptionCard extends StatefulWidget {
  final String? imagePath;
  final IconData? icon;
  final String label;
  final Color color;
  final double cardSize;
  final VoidCallback onTap;
  const _ResponsiveOptionCard({this.imagePath, this.icon, required this.label, required this.color, required this.cardSize, required this.onTap, Key? key}) : super(key: key);

  @override
  State<_ResponsiveOptionCard> createState() => _ResponsiveOptionCardState();
}

class _ResponsiveOptionCardState extends State<_ResponsiveOptionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: widget.cardSize,
        height: widget.cardSize + 18,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: _hovered ? widget.color.withOpacity(0.18) : widget.color.withOpacity(0.11),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_hovered ? 0.22 : 0.13),
              blurRadius: _hovered ? 18 : 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: widget.color, width: _hovered ? 2.2 : 1.2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: widget.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imagePath != null)
                Container(
                  width: widget.cardSize * 0.45,
                  height: widget.cardSize * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: AssetImage(widget.imagePath!),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                )
              else if (widget.icon != null)
                Container(
                  width: widget.cardSize * 0.45,
                  height: widget.cardSize * 0.45,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: widget.cardSize * 0.28),
                ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.label,
                  style: AppTextStyle.bold18.copyWith(color: widget.color, letterSpacing: 0.2),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
