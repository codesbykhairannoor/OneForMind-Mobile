import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/tier_provider.dart';
import '../theme/app_theme.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(userTierNotifierProvider).value ?? UserTier.explorer;
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(context, location, tier),
    );
  }

  Widget _buildBottomNav(BuildContext context, String location, UserTier tier) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icons.dashboard_rounded, 'Home', '/', location == '/'),
                _buildNavItem(context, Icons.calendar_today_rounded, 'Planner', '/planner', location == '/planner'),
                _buildCenterButton(context, tier),
                _buildNavItem(context, Icons.account_balance_wallet_rounded, 'Finance', '/finance', location == '/finance'),
                _buildNavItem(context, Icons.grid_view_rounded, 'Nexus', '/nexus', location == '/nexus'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route, bool isActive) {
    return InkWell(
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
            size: 26,
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, UserTier tier) {
    final isAiEnabled = tier == UserTier.quantum || tier == UserTier.legendary;

    return GestureDetector(
      onTap: () {
        if (isAiEnabled) {
          context.go('/coach');
        } else {
          // Quick Add Menu
          _showQuickAdd(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAiEnabled 
                ? [const Color(0xFF4F46E5), const Color(0xFF8B5CF6)]
                : [const Color(0xFF334155), const Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isAiEnabled ? const Color(0xFF4F46E5) : Colors.black).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          isAiEnabled ? Icons.psychology : Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void _showQuickAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Quick Action', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionItem(context, Icons.add_task, 'Task', () {}),
                _buildQuickActionItem(context, Icons.add_card, 'Expense', () {}),
                _buildQuickActionItem(context, Icons.check_circle_outline, 'Habit', () {}),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.slate50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF4F46E5)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
