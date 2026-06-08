import 'dart:convert';
import 'package:oneformind/models/habit.dart';
import 'package:oneformind/services/api_service.dart';
import 'package:riverpod/riverpod.dart';

class HabitRepository {
  final ApiService _apiService;

  HabitRepository(this._apiService);

  Future<List<Habit>> getHabits() async {
    final response = await _apiService.get('/habits');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Habit.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load habits');
    }
  }

  Future<void> addHabit(Habit habit) async {
    final response = await _apiService.post('/habits', habit.toJson());
    if (response.statusCode != 201) {
      throw Exception('Failed to add habit');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final response = await _apiService.put('/habits/${habit.id}', habit.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update habit');
    }
  }

  Future<void> deleteHabit(String id) async {
    final response = await _apiService.delete('/habits/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete habit');
    }
  }

  Future<void> logHabit(HabitLog habitLog) async {
    final response = await _apiService.post('/habits/log', habitLog.toJson());
    if (response.statusCode != 201) {
      throw Exception('Failed to log habit');
    }
  }

  Future<void> updateHabitLog(HabitLog habitLog) async {
    final response = await _apiService.put('/habits/log/${habitLog.id}', habitLog.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update habit log');
    }
  }

  Future<void> deleteHabitLog(String id) async {
    final response = await _apiService.delete('/habits/log/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete habit log');
    }
  }
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.read(apiServiceProvider));
});
