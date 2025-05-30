import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, dd MMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Namaste Jonny',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF8B5C2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
          ),
          Row(
            children: [
              Text(
                getFormattedDate(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      fontSize: 18,
                    ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Color(0xFFFFA726), size: 24),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, right: 8.0),
          child: Row(
            children: [
              // Language selector
              Image.asset(
                'assets/images/languagechange.png',
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 12),
              // Search icon
              Material(
                color: Colors.orange,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.search, color: Colors.white, size: 28),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Notification icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications, color: Colors.black, size: 36),
                  Positioned(
                    right: -2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 22,
                        minHeight: 22,
                      ),
                      child: const Center(
                        child: Text(
                          '10',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
} 