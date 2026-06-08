import 'package:riverpod/riverpod.dart';
import 'package:oneformind/models/habit.dart';
import 'package:oneformind/services/habit_service.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(habitService: ref.read(habitServiceProvider));
});

class HabitRepository {
  final HabitService _habitService;

  HabitRepository({required HabitService habitService}) : _habitService = habitService;

  Future<List<Habit>> getHabits() async {
    return await _habitService.getHabits();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitService.addHabit(habit);
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitService.updateHabit(habit);
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitService.deleteHabit(habitId);
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitsNotifier(repository: repository);
});

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final HabitRepository _repository;

  HabitsNotifier({required HabitRepository repository}) : _repository = repository, super([]);

  Future<void> loadHabits() async {
    final habits = await _repository.getHabits();
    state = habits;
  }

  Future<void> addHabit(Habit habit) async {
    await _repository.addHabit(habit);
    state = [...state, habit];
  }

  Future<void> updateHabit(Habit habit) async {
    await _repository.updateHabit(habit);
    state = state.map((h) => h.id == habit.id ? habit : h).toList();
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
    state = state.where((h) => h.id != habitId).toList();
  }
}
