import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../habits/data/habits_api.dart';
import '../../finance/data/finance_api.dart';
import '../../planner/data/planner_api.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<Map<String, dynamic>> build() async {
    // This will aggregate data from multiple API services
    // For now, let's return mock data that matches the web DashboardService structure
    // so we can build the UI.
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    return {
      'date_formatted': 'Saturday, 25 April 2026',
      'synergy_score': 78,
      'habits': {
        'total': 5,
        'completed': 3,
        'percent': 60,
      },
      'planner': {
        'total': 8,
        'completed': 4,
        'percent': 50,
        'upcoming': [
          {'title': 'Review Mobile UI', 'time': '14:00'},
          {'title': 'Lunch with Team', 'time': '12:30'},
        ],
      },
      'finance': {
        'income': 5000000.0,
        'expense': 1200000.0,
      },
      'ai_insight': 'You are 15% more productive than last week. Focus on your Manifestation Milestone today!',
    };
  }
}
