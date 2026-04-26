import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          dashboardData.when(
            data: (data) => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSynergyCard(data['synergy_score']),
                  const SizedBox(height: 20),
                  _buildBentoRow([
                    _buildFinanceCard('Income', data['finance']['income'], AppTheme.emerald),
                    _buildFinanceCard('Expense', data['finance']['expense'], AppTheme.rose),
                  ]),
                  const SizedBox(height: 20),
                  _buildHabitBento(data['habits']),
                  const SizedBox(height: 20),
                  _buildPlannerBento(data['planner']),
                  const SizedBox(height: 20),
                  _buildAiInsight(data['ai_insight']),
                  const SizedBox(height: 100), // Spacing for bottom nav
                ]),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF0F172A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Architect',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            Text(
              'Saturday, 25 April',
              style: TextStyle(
                color: AppTheme.slate500,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Color(0xFF0F172A)),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          backgroundColor: Color(0xFFE2E8F0),
          child: Icon(Icons.person, color: AppTheme.slate500),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildSynergyCard(int score) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Synergy Score',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Neural OS is optimized.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  color: Colors.white.withOpacity(0.3),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              const Icon(Icons.bolt, color: Colors.white, size: 32),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoRow(List<Widget> children) {
    return Row(
      children: children
          .map((child) => Expanded(child: Padding(
                padding: EdgeInsets.only(
                  right: children.indexOf(child) == children.length - 1 ? 0 : 10,
                  left: children.indexOf(child) == 0 ? 0 : 10,
                ),
                child: child,
              )))
          .toList(),
    );
  }

  Widget _buildFinanceCard(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(title == 'Income' ? Icons.arrow_downward : Icons.arrow_upward, color: color, size: 20),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppTheme.slate500, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Rp ${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitBento(Map<String, dynamic> habits) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Habits', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              Text('${habits['completed']}/${habits['total']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: habits['percent'] / 100,
            backgroundColor: AppTheme.slate100,
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildPlannerBento(Map<String, dynamic> planner) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Tasks', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 16),
          ...(planner['upcoming'] as List).map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(color: Color(0xFF8B5CF6), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(task['title'], style: const TextStyle(fontWeight: FontWeight.w600))),
                    Text(task['time'], style: const TextStyle(color: AppTheme.slate400, fontSize: 12)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAiInsight(String insight) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Color(0xFF4F46E5), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              insight,
              style: const TextStyle(color: Color(0xFF1E1B4B), fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
