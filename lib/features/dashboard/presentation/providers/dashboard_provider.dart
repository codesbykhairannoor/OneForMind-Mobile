import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardState {
  final Map<String, dynamic>? insight;
  final bool isLoading;
  final String? error;

  DashboardState({
    this.insight,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    Map<String, dynamic>? insight,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      insight: insight ?? this.insight,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final http.Client client;
  final String baseUrl;
  final String? token;

  DashboardNotifier({
    required this.client, 
    required this.baseUrl, 
    this.token,
  }) : super(DashboardState());

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<void> loadInsight() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/dashboard/insight'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(insight: data, isLoading: false);
      } else {
        state = state.copyWith(error: 'Failed to load insight: ${response.statusCode}', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    client: http.Client(),
    baseUrl: 'https://api.oneformind.com', 
    token: null, 
  );
});
