import 'package:flutter/material.dart';
import 'package:agrimb/core/theme/app_colors.dart';
import 'package:agrimb/core/constants/app_spacing.dart';
import 'package:agrimb/core/constants/app_text_style.dart';
import 'package:agrimb/core/constants/app_assets.dart';

class WeatherCard extends StatelessWidget {
  final List<Map<String, String>> weatherData;
  
  const WeatherCard({required this.weatherData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 8, right: 16), // Reduced left padding
        itemCount: weatherData.length,
        itemBuilder: (context, index) {
          final day = weatherData[index];
          return Container(
            width: 95, // Reduced width from 120 to 95
            margin: const EdgeInsets.only(right: 6), // Reduced gap from 12 to 6
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8, // Reduced from 12 to 8
                vertical: 12, // Reduced from 16 to 12
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Day name - FIXED: Added overflow protection
                  Text(
                    day['day']!.toUpperCase(),
                    style: AppTextStyle.medium14.copyWith(
                      color: Colors.white,
                      fontSize: 14, // Slightly reduced font size
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  
                  // Weather icon
                  Container(
                    width: 55, // Slightly reduced icon size
                    height: 55,
                    child: Image.asset(
                      AppAssets.weather, // Using weather.png as placeholder
                      width: 55,
                      height: 55,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  
                  // Celsius temperature - FIXED: Added overflow protection
                  Text(
                    day['tempC'] ?? '22°C',
                    style: AppTextStyle.bold20.copyWith(
                      color: Colors.white,
                      fontSize: 18, // Slightly reduced font size
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  
                  // Fahrenheit temperature - FIXED: Added overflow protection
                  Text(
                    day['tempF'] ?? '71.6°F',
                    style: AppTextStyle.medium14.copyWith(
                      color: Colors.white,
                      fontSize: 16, // Slightly reduced font size
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}