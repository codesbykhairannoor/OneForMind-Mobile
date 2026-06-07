import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../../core/theme/app_theme.dart';

class BentoDashboardScreen extends ConsumerStatefulWidget {
  const BentoDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BentoDashboardScreen> createState() => _BentoDashboardScreenState();
}

class _BentoDashboardScreenState extends ConsumerState<BentoDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).loadInsight();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
      ),
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dashboardState.error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(dashboardProvider.notifier).loadInsight(),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(dashboardProvider.notifier).loadInsight(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBentoCard(
                          title: 'AI Insight',
                          child: Text(
                            dashboardState.insight?['message'] ?? 'No insights available yet.',
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          color: AppTheme.primaryColor.withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildBentoCard(
                                title: 'Habits',
                                child: const Text('3/5 completed today', style: TextStyle(fontSize: 14)),
                                color: AppTheme.slate100,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildBentoCard(
                                title: 'Finance',
                                child: const Text('Rp 1.500.000 saved', style: TextStyle(fontSize: 14)),
                                color: AppTheme.slate100,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildBentoCard(
                          title: 'Upcoming Tasks',
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TaskItem(title: 'Review project proposal', time: '10:00 AM'),
                              SizedBox(height: 8),
                              _TaskItem(title: 'Team meeting', time: '02:00 PM'),
                            ],
                          ),
                          color: AppTheme.cardColor,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required Widget child,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppTheme.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final String title;
  final String time;

  const _TaskItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
