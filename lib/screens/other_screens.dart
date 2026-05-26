import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const _categories = [
    {'label': 'Technology', 'icon': Icons.computer, 'color': Color(0xFF1565C0)},
    {'label': 'Design', 'icon': Icons.palette, 'color': Color(0xFF6A1B9A)},
    {'label': 'Business', 'icon': Icons.business_center, 'color': Color(0xFF2E7D32)},
    {'label': 'Science', 'icon': Icons.science, 'color': Color(0xFFE65100)},
    {'label': 'Health', 'icon': Icons.health_and_safety, 'color': Color(0xFFC62828)},
    {'label': 'Education', 'icon': Icons.school, 'color': Color(0xFF00695C)},
  ];

  @override
  Widget build(BuildContext context) {
    final crossAxis = ResponsiveHelper.gridCrossAxisCount(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.padding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explore',
                  style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, mobile: 22, tablet: 26, desktop: 30),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Discover topics', style: TextStyle(color: Colors.black45)),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxis,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: (cat['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: (cat['color'] as Color).withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 36),
                          const SizedBox(height: 10),
                          Text(cat['label'] as String,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: cat['color'] as Color,
                                  fontSize: ResponsiveHelper.fontSize(context, mobile: 13, tablet: 15, desktop: 16))),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.padding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Favorites',
                  style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, mobile: 22, tablet: 26, desktop: 30),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Your saved items', style: TextStyle(color: Colors.black45)),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.favorite_outline, size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('No favorites yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                    const SizedBox(height: 8),
                    const Text('Items you favorite will appear here',
                        style: TextStyle(fontSize: 13, color: Colors.black38)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.padding(context),
          child: isMobile ? _buildMobileProfile(context) : _buildWideProfile(context),
        ),
      ),
    );
  }

  Widget _buildMobileProfile(BuildContext context) {
    return Column(
      children: [
        _buildAvatar(context),
        const SizedBox(height: 24),
        _buildInfoCards(context),
      ],
    );
  }

  Widget _buildWideProfile(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildAvatar(context)),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildInfoCards(context)),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.deepPurple,
            child: Text('A', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Text('Ankur Tripathi',
              style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, mobile: 18, tablet: 20, desktop: 22),
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Flutter Developer', style: TextStyle(color: Colors.black45)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    final items = [
      {'icon': Icons.email_outlined, 'label': 'Email', 'value': 'ankur@example.com'},
      {'icon': Icons.phone_outlined, 'label': 'Phone', 'value': '+91 9876543210'},
      {'icon': Icons.location_on_outlined, 'label': 'Location', 'value': 'Delhi, India'},
      {'icon': Icons.work_outline, 'label': 'Role', 'value': 'Flutter Developer'},
    ];
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(item['icon'] as IconData, color: Colors.deepPurple, size: 22),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['label'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.black45)),
                  Text(item['value'] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
