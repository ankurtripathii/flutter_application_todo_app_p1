import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _stats = [
    {'label': 'Projects', 'value': '24', 'icon': Icons.folder_outlined, 'color': Colors.blue},
    {'label': 'Tasks', 'value': '128', 'icon': Icons.task_alt, 'color': Colors.green},
    {'label': 'Messages', 'value': '56', 'icon': Icons.chat_bubble_outline, 'color': Colors.orange},
    {'label': 'Reports', 'value': '8', 'icon': Icons.bar_chart, 'color': Colors.purple},
  ];

  static const _items = [
    {'title': 'UI Design System', 'subtitle': 'Updated 2h ago', 'tag': 'Design'},
    {'title': 'Backend API', 'subtitle': 'Updated 5h ago', 'tag': 'Dev'},
    {'title': 'Marketing Plan', 'subtitle': 'Updated 1d ago', 'tag': 'Marketing'},
    {'title': 'Mobile App v2', 'subtitle': 'Updated 2d ago', 'tag': 'Dev'},
    {'title': 'Analytics Dashboard', 'subtitle': 'Updated 3d ago', 'tag': 'Data'},
    {'title': 'User Research', 'subtitle': 'Updated 4d ago', 'tag': 'Design'},
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.padding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildBanner(context),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'Overview'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildStatCards(context),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'Recent Projects'),
          const SizedBox(height: 12),
          ..._buildProjectList(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.padding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildBanner(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Overview'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: _buildStatCards(context),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Recent Projects'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3,
            children: _buildProjectCards(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.padding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanner(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Overview'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _buildStatCards(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Recent Projects'),
                    const SizedBox(height: 12),
                    ..._buildProjectList(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final titleSize = ResponsiveHelper.fontSize(context, mobile: 22, tablet: 26, desktop: 30);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard',
                style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            Text('Welcome back, Ankur 👋',
                style: TextStyle(
                    fontSize: titleSize - 10,
                    color: Colors.black45)),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final isCompact = ResponsiveHelper.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 20 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E35B1), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Screen: ${_getScreenLabel(context)}',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: ResponsiveHelper.fontSize(context, mobile: 12, tablet: 13, desktop: 14))),
          const SizedBox(height: 6),
          Text('Responsive Layout Active',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(context, mobile: 18, tablet: 22, desktop: 26),
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'This layout adapts to mobile, tablet, and desktop screens using MediaQuery & LayoutBuilder.',
            style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.fontSize(context, mobile: 12, tablet: 13, desktop: 14)),
          ),
        ],
      ),
    );
  }

  String _getScreenLabel(BuildContext context) {
    switch (ResponsiveHelper.getScreenType(context)) {
      case ScreenType.mobile:
        return 'Mobile (< 600px)';
      case ScreenType.tablet:
        return 'Tablet (600px–1024px)';
      case ScreenType.desktop:
        return 'Desktop (> 1024px)';
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title,
        style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.bold,
            color: Colors.black87));
  }

  List<Widget> _buildStatCards(BuildContext context) {
    return _stats.map((s) {
      return StatCard(
        label: s['label'] as String,
        value: s['value'] as String,
        icon: s['icon'] as IconData,
        color: s['color'] as Color,
      );
    }).toList();
  }

  List<Widget> _buildProjectList(BuildContext context) {
    return _items.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_outlined, color: Colors.deepPurple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                  Text(item['subtitle'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(item['tag'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.deepPurple, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildProjectCards(BuildContext context) {
    return _items.map((item) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_outlined, color: Colors.deepPurple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(item['subtitle'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(item['tag'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.deepPurple, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    }).toList();
  }
}
