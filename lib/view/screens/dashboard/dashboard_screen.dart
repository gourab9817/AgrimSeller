import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/dashboard/dashboard_appbar.dart';
import '../../widgets/dashboard/weather_card.dart';
import '../../widgets/dashboard/feature_card.dart';
import '../../widgets/dashboard/mandi_bhav_card.dart';
import '../../widgets/dashboard/best_deals_card.dart';
import '../../widgets/dashboard/section_title.dart';
import '../../../core/constants/app_assets.dart';
import '../../widgets/appbar/navbar.dart';
import 'buy_card.dart';
import 'weather_data.dart';
import 'package:provider/provider.dart';
import '../../../view_model/profile/profile_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _buyCropController = PageController(viewportFraction: 0.7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserData();
    });
  }

  @override
  void dispose() {
    _buyCropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final mandiData = [
      {'name': 'Mustard', 'price': '₹71,000/MT', 'change': '+₹12,496 since last month'},
      {'name': 'Wheat', 'price': '₹28,500/MT', 'change': '+₹638 since last month'},
    ];

    return Scaffold(
      appBar: const DashboardAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: WeatherCard(weatherData: weatherDataList),
              ),
              const SectionTitle(title: 'Buy Crop'),
              SizedBox(
                height: 200,
                child: PageView(
                  controller: _buyCropController,
                  children: buyCropImages.map((img) => FeatureCard(image: img)).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SmoothPageIndicator(
                  controller: _buyCropController,
                  count: buyCropImages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: Colors.orange,
                    dotColor: Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MandiBhavCard(mandiData: mandiData),
              const SectionTitle(title: 'Best Deals'),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: bestDealsList.map((deal) => BestDealsCard(
                    image: deal['image']!,
                    title: deal['title']!,
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
} 