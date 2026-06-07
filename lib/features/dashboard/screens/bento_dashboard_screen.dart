import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import '../../ai_coach/screens/ai_coach_screen.dart';

class BentoDashboardScreen extends ConsumerWidget {
  const BentoDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeStatsProvider);
    final habitAsync = ref.watch(habitStatsProvider);
    final plannerAsync = ref.watch(plannerTasksProvider);
    final goalAsync = ref.watch(goalStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.scaffoldBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(financeStatsProvider);
          ref.invalidate(habitStatsProvider);
          ref.invalidate(plannerTasksProvider);
          ref.invalidate(goalStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildBentoCard(
                    title: 'Finance',
                    icon: Icons.account_balance_wallet,
                    color: AppTheme.primaryColor,
                    child: financeAsync.when(
                      data: (data) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Balance', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${(data['balance'] ?? 0).toString()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (err, stack) => const Text('Error', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  _buildBentoCard(
                    title: 'Habits',
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                    child: habitAsync.when(
                      data: (data) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Current Streak', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${data['streak'] ?? 0} Days',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (err, stack) => const Text('Error', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  _buildBentoCard(
                    title: 'Planner',
                    icon: Icons.calendar_today,
                    color: Colors.orange,
                    child: plannerAsync.when(
                      data: (data) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tasks Today', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${data.length} Pending',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (err, stack) => const Text('Error', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  _buildBentoCard(
                    title: 'Goals',
                    icon: Icons.flag,
                    color: Colors.purple,
                    child: goalAsync.when(
                      data: (data) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Completed', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${data['completed'] ?? 0}/${data['total'] ?? 0}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (err, stack) => const Text('Error', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'AI Coach',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiCoachScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppTheme.primaryColor, size: 28),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ask AI Coach', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(
                              'Get personalized insights, habit stacking ideas, and synergy analysis.',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
