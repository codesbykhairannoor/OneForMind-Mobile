import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/models/habit.dart';

class HabitRepository {
  // Simulate fetching habits from a backend
  Future<List<Habit>> fetchHabits() async {
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 1));
    return [
      Habit(id: 1, name: 'Drink Water', period: 'daily', monthlyTarget: 30, position: 1, color: '#4CAF50', icon: 'water_drop'),
      Habit(id: 2, name: 'Meditate', period: 'daily', monthlyTarget: 30, position: 2, color: '#FFC107', icon: 'meditation'),
      Habit(id: 3, name: 'Exercise', period: 'weekly', monthlyTarget: 4, position: 3, color: '#F44336', icon: 'directions_run'),
    ];
  }

  // Simulate adding a new habit
  Future<void> addHabit(Habit habit) async {
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 1));
  }

  // Simulate updating an existing habit
  Future<void> updateHabit(Habit habit) async {
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 1));
  }

  // Simulate deleting a habit
  Future<void> deleteHabit(int id) async {
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 1));
  }
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository();
});

final habitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  return await repository.fetchHabits();
});

final addHabitProvider = FutureProvider.family<void, Habit>((ref, Habit habit) async {
  final repository = ref.watch(habitRepositoryProvider);
  await repository.addHabit(habit);
});

final updateHabitProvider = FutureProvider.family<void, Habit>((ref, Habit habit) async {
  final repository = ref.watch(habitRepositoryProvider);
  await repository.updateHabit(habit);
});

final deleteHabitProvider = FutureProvider.family<void, int>((ref, int id) async {
  final repository = ref.watch(habitRepositoryProvider);
  await repository.deleteHabit(id);
});
